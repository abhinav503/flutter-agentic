# Cordelia Base

A Flutter Clean Architecture template designed for AI-assisted development. Fork this repo and your AI assistant (Claude Code or any LLM) will generate code that follows the architecture, testing, and style rules baked into `CLAUDE.md`.

## Stack

| Concern | Library |
|---|---|
| State management | [flutter_bloc](https://pub.dev/packages/flutter_bloc) |
| Dependency injection | [get_it](https://pub.dev/packages/get_it) — service locator (`sl<T>()`) |
| Navigation | [go_router](https://pub.dev/packages/go_router) |
| Networking | [Dio](https://pub.dev/packages/dio) + [Retrofit](https://pub.dev/packages/retrofit) |
| Models / serialization | [Freezed](https://pub.dev/packages/freezed) + [json_serializable](https://pub.dev/packages/json_serializable) |
| Error handling | [fpdart](https://pub.dev/packages/fpdart) (`Either<Failure, T>`) |

## Architecture

Each feature lives under `lib/feature/{name}/` with three layers:

```
feature/jokes/
├── data/               # API clients, DTOs, repository implementations
├── domain/             # Entities, repository interfaces, use cases (pure Dart)
└── presentation/       # BLoC + screens + widgets
```

The **dependency rule**: domain knows nothing about data or presentation. Data knows nothing about presentation.

See [`docs/reference/architecture.md`](docs/reference/architecture.md) for the full cheat sheet.

## Using This as a Template

1. Click **"Use this template"** on GitHub to create your repo
2. Clone your new repo
3. Run `make setup` — installs git hooks and fetches packages
4. Run `make gen` — generates Freezed / Retrofit code
5. Run `make test` — all example tests should pass
6. Replace the `jokes` feature with your first real feature

### Make targets

```bash
make setup   # first-time: git hooks + flutter pub get
make run     # flutter run (connected device)
make web     # flutter run -d chrome
make test    # flutter test
make analyze # flutter analyze
make gen     # dart run build_runner build --delete-conflicting-outputs
```

## AI Tooling

Install [Claude Code](https://claude.ai/code) to use the project's slash commands:

| Skill | What it does |
|---|---|
| `/add-feature-template` | Scaffolds a complete new feature (folder tree, class skeletons, DI wiring) |
| `/setup-project` | Runs first-time project setup |

The `CLAUDE.md` at the root defines layer rules, forbidden patterns, and commit format that the AI follows when generating code.

## Running the Example

```bash
make setup
make gen
make run
```

The example feature fetches dad jokes from [icanhazdadjoke.com](https://icanhazdadjoke.com) and demonstrates the full data → domain → presentation stack including search.

## Project Structure

```
lib/
├── core/
│   ├── base/            # BasePage, BaseScreen, BaseRepository, MasterBloc
│   ├── constants/       # API base URLs, app-wide string constants
│   ├── di/              # injection_container.dart — full dependency graph
│   ├── error/           # Failure sealed class (network, server, unexpected)
│   ├── mappers/         # Mapper<Model, Entity> abstract interface
│   ├── network/         # Dio client factory + interceptors
│   ├── theme/           # AppTheme, AppSpacing, AppRadius, AppColorsExtension
│   └── ui/
│       ├── atoms/       # AppButton, AppTextField, AppBadge, AppChip, AppTopBar
│       └── molecules/   # AppBottomSheet, ErrorView, LoadingIndicator
├── feature/
│   └── jokes/           # Full example feature (data → domain → presentation)
├── app.dart             # MaterialApp.router + GoRouter config
└── main.dart            # Entry point — calls initDependencies(), runs app

test/
├── helpers/             # Shared fakes (FakeJokesRepository, etc.)
├── unit/feature/jokes/  # Use case + BLoC unit tests
└── widget/feature/jokes/# Screen widget tests

docs/
├── ai-rules/            # Conventions loaded by CLAUDE.md
├── explanation/         # End-goal, AI agent setup
├── how-to/              # Contributing, add-feature, add-usecase guides
└── reference/           # Architecture cheat sheet
```

## Adding a New Feature

1. Run `/add-feature-template` — it scaffolds the full folder tree and empty skeletons
2. Or do it manually:
   1. Create `lib/feature/{name}/{data,domain,presentation}/` directories
   2. Start in `domain/` — define entity, repository interface, use case(s)
   3. Implement `data/` — data source, Freezed model, repository impl
   4. Implement `presentation/` — BLoC (Freezed event/state), page, screen, widgets
   5. Wire DI in `lib/core/di/injection_container.dart`
   6. Add route in `lib/app.dart`
   7. Run `make gen` to generate Freezed / Retrofit code

See [`docs/how-to/add-feature-template.md`](docs/how-to/add-feature-template.md) for the full walkthrough.

## CI

GitHub Actions runs on every push and PR — `flutter analyze` + `flutter test`.
See `.github/workflows/validate.yml`.
