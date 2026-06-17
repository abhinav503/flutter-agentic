# ai_chat — Streaming AI chat

The template's **streaming** reference (the counterpart to `doc_scanner`'s
request/response): an AI chat where replies stream in token-by-token. Built on
`core`; see the [root README](../../README.md), the
[architecture reference](../../docs/reference/architecture.md), and the
[StreamUseCase how-to](../../docs/how-to/stream-usecase.md).

## Features

- **Streaming replies** — assistant text arrives **token-by-token** (SSE), or
  **one-shot** (whole reply at once); the user toggles the mode from the app bar.
- **Real Groq backend** (OpenAI-compatible) **+ zero-setup local mock** — the app
  runs and streams with no key; paste a key to switch to a real model.
- **In-app BYOK key** — enter/clear a Groq key (stored on device); a dispatcher
  routes to Groq when a key is set, the mock otherwise.
- **Markdown rendering** of replies — code blocks, lists, bold — tolerant of the
  partial markdown that arrives mid-stream (`gpt_markdown`).
- **Stop** a reply mid-stream and **Retry** after an error.

## What it demonstrates in the template

- The **streaming stack**: `StreamUseCase` + `BaseRepository.handleStream` +
  `HttpService.postStream`, consumed by a BLoC that accumulates deltas and
  supports cancellation.
- A **single Freezed state** with `copyWith` (continuous list + `isResponding`),
  rather than mutually-exclusive sealed phases — per-message status lives on the
  entity.
- **Swap-the-data-layer** design: provider specifics live only in the data layer,
  so plugging in your own API/stream means implementing one `ChatRemoteDataSource`
  and registering it in DI — domain, use case, BLoC, and UI are untouched.

## Run

```bash
make run-ai-chat       # or: cd apps/ai_chat && flutter run
make web-ai-chat       # Chrome
```

Runs immediately on the **local mock** (no key, offline). For a real model, tap
the **key** action in the app bar and paste a Groq key (`gsk_…`). Default model is
`llama-3.3-70b-versatile` (change in `lib/constants/api_constants.dart`).

## Key packages

`gpt_markdown` · `flutter_bloc` · `go_router` · `fpdart` · `freezed`
