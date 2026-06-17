import 'package:ai_chat/enums/chat_mode.dart';
import 'chat_remote_data_source.dart';

/// Default data source: a local mock that simulates both reply modes.
///
/// In [ChatMode.streaming] it emits a canned reply word-by-word with a small
/// delay between tokens; in [ChatMode.oneShot] it waits briefly then emits the
/// whole reply at once. Either way the app demonstrates the full flow with zero
/// setup — no network, no API key, runs offline and on web. Provide a Groq key
/// to swap in [GroqChatRemoteDataSourceImpl] (see docs/how-to/stream-usecase.md).
/// No DTO/model is needed here because nothing is serialized.
class MockChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const MockChatRemoteDataSourceImpl();

  static const _tokenDelay = Duration(milliseconds: 45);
  static const _thinkingDelay = Duration(milliseconds: 600);

  @override
  Stream<String> sendMessage({
    required String prompt,
    required ChatMode mode,
    required String apiKey, // ignored — the mock needs no key
  }) async* {
    final reply = _cannedReplyFor(prompt);
    if (mode == ChatMode.oneShot) {
      await Future<void>.delayed(_thinkingDelay);
      yield reply;
      return;
    }
    // Streaming: split on spaces but keep them, so the rendered text reads
    // naturally as tokens accumulate.
    for (final word in reply.split(' ')) {
      await Future<void>.delayed(_tokenDelay);
      yield '$word ';
    }
  }

  String _cannedReplyFor(String prompt) {
    final p = prompt.toLowerCase();
    if (p.contains('code') || p.contains('dart') || p.contains('example')) {
      return _codeReply;
    }
    if (p.contains('hello') || p.contains('hi') || p.contains('hey')) {
      return _greetingReply;
    }
    if (p.contains('stream') || p.contains('sse')) {
      return _streamingReply;
    }
    return _defaultReply;
  }

  static const _greetingReply =
      'Hello! 👋 I am a **local mock** assistant. I stream my replies token by '
      'token, just like a real LLM over SSE — but with no backend or API key. '
      'Try asking me for a *code example*.';

  static const _codeReply = '''
Sure — here's a tiny Dart snippet that consumes a stream:

```dart
await emit.forEach(
  useCase(params),
  onData: (delta) => state.copyWith(
    text: state.text + delta,
  ),
);
```

The **BLoC** stays alive while `emit.forEach` drains the stream, emitting a new
state per token. That's the whole streaming pattern in one call.''';

  static const _streamingReply =
      'Server-Sent Events (SSE) keep one HTTP connection open and push text '
      'chunks as they are generated. In this template the **data source** owns '
      'the stream, the **repository** maps each chunk to `Either<Failure, T>`, '
      'and the **BLoC** consumes it with `emit.forEach` — appending every delta '
      'to the assistant message until the stream completes.';

  static const _defaultReply =
      'Got it. This reply is streaming in **token by token** from a local mock '
      'data source, which means the entire flow — data → repository → use case '
      '→ BLoC → UI — runs with no network and no API key. Hit **Stop** to '
      'cancel a reply mid-stream, or swap in a real SSE backend to talk to an '
      'actual model.';
}
