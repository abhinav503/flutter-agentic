# Cordelia Base

A Flutter Clean Architecture template designed for AI-assisted development. Fork this repo and your AI assistant (Claude Code or any LLM) will generate code that follows the architecture, testing, and style rules baked into `CLAUDE.md`.

## Stack

| Concern | Library |
|---|---|
| State management | [flutter_bloc](https://pub.dev/packages/flutter_bloc) |
| Dependency injection | `RepositoryProvider` / `BlocProvider` (built into flutter_bloc) |
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

See [`docs/reference/architecture.md`](docs/reference/architecture.md) for the full cheat sheet and [`docs/architecture/001-stack-choices.md`](docs/architecture/001-stack-choices.md) for the ADR explaining each decision.

## Using This as a Template

1. Click **"Use this template"** on GitHub to create your repo
2. Clone your new repo
3. Run `flutter pub get`
4. Run `dart run build_runner build --delete-conflicting-outputs`
5. Run `flutter test` — all example tests should pass
6. Activate git hooks: `git config core.hooksPath .githooks`
7. Replace the `jokes` feature with your first real feature

## AI Tooling

The `.claude/skills/` directory contains Claude Code skills:

| Skill | What it does |
|---|---|
| `/write-tests` | Generates unit and widget tests for changed or specified files |
| `/code-review` | Two-stage review — finds issues, you approve, fixes are applied |
| `/release` | Semver bump, changelog, commit + tag + push |

Install [Claude Code](https://claude.ai/code) to use them. The `CLAUDE.md` at the root defines rules the AI follows when generating code.

## Running the Example

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Tap **+** to fetch a random dad joke from [icanhazdadjoke.com](https://icanhazdadjoke.com).

## Project Structure

```
lib/
├── core/
│   ├── constants/       # API base URLs, app-wide constants
│   ├── di/              # AppProviders — wires the full dependency graph
│   ├── error/           # Failure sealed class (network, server, unexpected)
│   ├── mappers/         # Mapper<Model, Entity> abstract interface
│   ├── network/         # Dio client factory + interceptors
│   └── ui/
│       ├── atoms/       # Smallest reusable widgets
│       ├── molecules/   # Composed atoms
│       └── organisms/   # Page-level shared sections
├── feature/
│   └── jokes/           # Full example feature (data → domain → presentation)
├── app.dart             # MaterialApp.router + GoRouter config
└── main.dart            # Entry point — wraps app in AppProviders

test/
├── helpers/             # Shared fakes (FakeJokesRepository, etc.)
├── unit/feature/jokes/  # Use case + BLoC unit tests
└── widget/feature/jokes/# Screen widget tests

docs/
├── architecture/        # Architecture Decision Records (ADRs)
├── how-to/              # Step-by-step task guides
├── reference/           # Quick-reference facts
└── tutorials/           # Learning-oriented guides
```

## Adding a New Feature

1. Create `lib/feature/{name}/{data,domain,presentation}/` directories
2. Start in `domain/` — define entity, repository interface, use case(s)
3. Implement `data/` — data source, Freezed model, repository impl
4. Implement `presentation/` — BLoC (Freezed event/state), page, widgets
5. Wire in `core/di/app_providers.dart`
6. Add route in `lib/app.dart`
7. Run `/write-tests` to generate the test suite

## CI

GitHub Actions runs on every push and PR — `flutter analyze` + `flutter test`.
See `.github/workflows/validate.yml`.
