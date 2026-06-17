# jokes — Dad Jokes demo

The template's **demo app** and simplest **request/response** reference: a two-tab
dad-jokes browser. Built on `core`; see the [root README](../../README.md) and
[architecture reference](../../docs/reference/architecture.md).

## Features

- **For You** — fetch a random dad joke; tap for the next one.
- **Search** — search jokes by term with **paginated "load more"** results.
- **Keep** — save favourite jokes; a live count badge shows in the app bar
  (shared in-memory state via a `Cubit`).
- **Bottom navigation** between For You and Search.

## What it demonstrates in the template

- The full **request/response** flow: `HttpService.get` → `BaseRepository.handleRequest`
  → `UseCase` (`GetRandomJokeUseCase`, `SearchJokesUseCase`) → BLoC → screen.
- **Freezed sealed states** rendered with an exhaustive `switch` (no `is` checks).
- **Error states that carry retry context** (search term + page) so retry never
  inspects a previous state.
- **`Cubit` for shared in-memory list state** (`KeptJokesCubit`) provided in
  `buildBlocProviders` (read by the app bar), with each screen's BLoC scoped in
  `buildBody`.
- **`BasePage` getter-based bottom nav.**

## Run

```bash
make run-jokes        # or: cd apps/jokes && flutter run
make web-jokes        # Chrome
```

No configuration or API key needed — it uses a public jokes API.

## Key packages

`flutter_bloc` · `go_router` · `fpdart` (`Either<Failure, T>`) · `freezed`
