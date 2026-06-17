# How to Stream Through Clean Architecture (`StreamUseCase`)

Most operations return a single value: `UseCase<Output, Param>` with
`Future<Output> call(Param)`. Some operations emit **many values over time** —
server-sent events (SSE), web sockets, LLM token streams. For those, use
**`StreamUseCase`** and consume it in the BLoC with `emit.forEach` (or a managed
subscription when you need to cancel).

The `apps/ai_chat` reference app implements this end to end.

---

## When to use which

| Use case shape | Base class | Returns |
|---|---|---|
| One request → one result | `UseCase<Output, Param>` | `Future<Output>` |
| One request → many chunks over time | `StreamUseCase<Output, Param>` | `Stream<Output>` |

Both live in `packages/core/lib/core/usecase/usecase.dart`. The output is
typically `Either<Failure, T>` so success **and** error both flow through the
stream as values — no exception ever crosses a layer boundary.

---

## 1. Domain — the contract

```dart
// repository/chat_repository.dart
abstract interface class ChatRepository {
  Stream<Either<Failure, String>> sendMessage(String prompt); // token deltas
}

// usecase/send_message_usecase.dart
class SendMessageUseCase
    extends StreamUseCase<Either<Failure, String>, SendMessageParams> {
  final ChatRepository _repository;
  const SendMessageUseCase(this._repository);

  @override
  Stream<Either<Failure, String>> call(SendMessageParams params) =>
      _repository.sendMessage(params.prompt);
}
```

## 2. Data — the source and `handleStream`

The data source returns a raw transport `Stream` (here, mocked token deltas; a
real impl would yield each SSE `data:` payload). The repository wraps it with
**`BaseRepository.handleStream`**, the streaming counterpart to `handleRequest`
— it yields each value as `right(value)` and maps any error to a typed
`Failure`:

```dart
class ChatRepositoryImpl with BaseRepository implements ChatRepository {
  final ChatRemoteDataSource _dataSource;
  const ChatRepositoryImpl(this._dataSource);

  @override
  Stream<Either<Failure, String>> sendMessage(String prompt) =>
      handleStream(() => _dataSource.sendMessage(prompt));
}
```

> `ai_chat` ships **two** data sources behind this interface:
> `MockChatRemoteDataSourceImpl` (the default — emits a canned reply with
> delays, so the app runs offline with no key) and `GroqChatRemoteDataSourceImpl`
> (a real model). A `ChatDataSourceDispatcher` routes per call: the user pastes
> a Groq key via the top-bar key action (stored on-device through
> `SharedPreferenceService` and managed with `Get/SaveApiKeyUseCase`), and from
> then on sends go to Groq instead of the mock.

### Real backend: one endpoint, two modes (Groq)

Direct LLM APIs (Groq, OpenAI, Anthropic, Gemini) do **not** use a separate
"send" call + persistent socket. It's a **single** `POST` to the
chat-completions endpoint; with `"stream": true` the *response body of that same
request* is the SSE stream. So a reusing dev needs exactly **one endpoint and
one API key**.

`GroqChatRemoteDataSourceImpl` (OpenAI-compatible) implements both modes the
user can toggle:

- **Streaming** (`ChatMode.streaming`, `"stream": true`) — `HttpService.postStream`
  returns the raw byte stream; the data source parses SSE `data:` frames and
  yields each `choices[0].delta.content`, stopping at `data: [DONE]`.
- **One-shot** (`ChatMode.oneShot`, `"stream": false`) — a normal
  `HttpService.post`; yields the single `choices[0].message.content` once.

Both flow through the *same* `Stream<Either<Failure, String>>` contract, so the
repository, use case, and BLoC are identical regardless of mode or backend —
only the data source differs. (No `eventflux`/SSE package is needed: `eventflux`
is built for persistent server-push connections and would wrongly auto-reconnect
a one-shot completion; `dio`'s `ResponseType.stream` is the right tool.)

## 3. Presentation — consuming the stream in a BLoC

**The simple case — `emit.forEach`.** When you don't need to cancel, this is the
whole pattern: the handler stays alive while the stream drains, emitting a new
state per chunk.

```dart
await emit.forEach(
  _sendMessage(SendMessageParams(prompt: prompt)),
  onData: (either) => either.fold(
    (failure) => _withAssistantError(state),
    (delta)   => _appendDelta(state, delta), // immutable list update
  ),
);
```

**With Stop/cancel.** A chat needs to halt a reply mid-stream, so `ai_chat`
holds the `StreamSubscription` and a `Completer` the handler awaits. A
`StopPressed` event cancels the subscription and completes the completer, so the
send handler finishes cleanly. See `chat_bloc.dart` for the full implementation
(`_streamReply`, `_onStop`). Always cancel the subscription in `close()`.

### State shape: one class, not a sealed union

Chat is a **single, continuously evolving state** — existing messages, the
in-flight reply, and any error all coexist. So `ChatState` is one Freezed data
class with `copyWith`, and per-message lifecycle lives on
`ChatMessageEntity.status` (`streaming` / `done` / `error`):

```dart
@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default(<ChatMessageEntity>[]) List<ChatMessageEntity> messages,
    @Default(false) bool isResponding,
  }) = _ChatState;
}
```

This is a deliberate exception to the "sealed states + exhaustive `switch`"
default, which fits *mutually exclusive phases* (loading / loaded / error). A
stream that mutates a list in place is not phase-based — forcing it into a union
would mean rebuilding the whole list on every token. Retry context comes from
the conversation itself (the last user message), never from inspecting a prior
BLoC state.

---

## Verify

`apps/ai_chat/test/unit/feature/home/presentation/chat_bloc_test.dart` covers
delta accumulation → `done`, error → `error` status, and retry re-streaming.
Run `cd apps/ai_chat && flutter test`, or `make run-ai-chat` to watch a reply
stream in token by token and hit **Stop** mid-stream.
