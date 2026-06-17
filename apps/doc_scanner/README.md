# doc_scanner — Receipt/Bill → PDF scanner

A real, production-grade app and the template's **request/response** reference
(one call → one result): turn photos of receipts/bills into a single PDF, with
optional AI extraction into a running ledger. Built on `core`; see the
[root README](../../README.md) and [architecture reference](../../docs/reference/architecture.md).

## Features

- **Multi-image capture** — add receipts from the camera or gallery (`image_picker`).
- **AI receipt extraction** — pulls merchant, total, date, etc. from each image,
  with **three swappable backends — Groq, Gemini, Claude** — selected behind a
  dispatcher. **Bring your own API key** per model (entered in-app, stored on device).
- **On-device PDF generation** — combine images into one PDF fully **offline**
  (`pdf` package, no backend).
- **Share / save** via the native share sheet (`share_plus` + `path_provider`).
- **Receipt ledger** — persisted list with running totals; **edit** and **delete**
  entries.
- **Model selector** + per-model key management.

## What it demonstrates in the template

- **Strategy / dispatcher** over several remote data sources (Groq / Gemini /
  Claude) behind one interface — each provider's request/response shape isolated
  in the data layer.
- **Local persistence** data source (receipts) alongside the remote AI sources.
- **BYOK key management** — `Get/SaveApiKeyUseCase`, per-model keys in
  `SharedPreferenceService` (a static singleton, never in GetIt).
- **DTO ↔ Entity** mapping (`Model.fromEntity` / `model.toEntity`) and
  `BaseRepository` error handling.

## Run

```bash
make run-doc-scanner   # or: cd apps/doc_scanner && flutter run
```

PDF generation works **offline with no key**. To enable AI extraction, open the
model/key sheet in-app and paste a Groq, Gemini, or Claude API key.

## Key packages

`image_picker` · `pdf` · `share_plus` · `path_provider` · `crypto` ·
`flutter_bloc` · `go_router` · `fpdart` · `freezed`
