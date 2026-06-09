# FlutterAgentic

<p>
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-frontend-blue?logo=flutter" />
  <img alt="AI first" src="https://img.shields.io/badge/AI--first-agent--ready-5B5FC7" />
  <img alt="Architecture" src="https://img.shields.io/badge/Clean%20Architecture-BLoC%20%2B%20Freezed-0A7EA4" />
  <img alt="Open source" src="https://img.shields.io/badge/Open%20Source-community--improvable-2E7D32" />
</p>

**An open-source, AI-first Flutter frontend starter.**

FlutterAgentic gives Flutter developers a production-grade Clean Architecture foundation that AI coding agents can actually follow. Fork it, open it in Claude Code, Codex, GitHub Copilot, Cursor, Gemini, Android Studio, or Amazon Q, and the agent gets the same architecture rules, forbidden patterns, naming conventions, test expectations, and feature scaffolding docs that a human teammate would use.

Most Flutter starters give you folders. FlutterAgentic gives you a rulebook plus a runnable app structure, so AI-generated code is less likely to drift into random widgets, leaked DTOs, untestable state, or inconsistent feature layouts.

The documentation is organised with the [Diataxis](https://diataxis.fr/) framework, so both humans and AI agents can quickly separate task guides, exact architecture reference, project reasoning, and operational coding rules.

## AI Agent Support

FlutterAgentic includes repo-native instructions for Claude Code, Codex CLI, Cursor, Gemini, Android Studio, GitHub Copilot, and Amazon Q.

| Agent | Instruction source | Setup / scaffold path |
|---|---|---|
| <img alt="Claude Code" src="https://img.shields.io/badge/Claude_Code-191919?logo=anthropic&logoColor=white" /> | `CLAUDE.md` | `/setup-project`, `/add-feature-template` |
| <img alt="Codex CLI" src="https://img.shields.io/badge/Codex_CLI-111827?logo=openai&logoColor=white" /> | `AGENTS.md` + `.codex/skills/` | `$setup-project`, `$add-feature-template <name>` |
| <img alt="GitHub Copilot" src="https://img.shields.io/badge/GitHub_Copilot-181717?logo=githubcopilot&logoColor=white" /> | `.github/copilot-instructions.md` | Repo-wide instructions; path-specific instructions can live in `.github/instructions/` |
| <img alt="Cursor" src="https://img.shields.io/badge/Cursor-000000?logo=cursor&logoColor=white" /> | `.cursor/rules/` | Ask to set up or scaffold a feature |
| <img alt="Gemini CLI" src="https://img.shields.io/badge/Gemini_CLI-4285F4?logo=googlegemini&logoColor=white" /> | `GEMINI.md` | Ask to set up or scaffold a feature |
| <img alt="Android Studio" src="https://img.shields.io/badge/Android_Studio-3DDC84?logo=androidstudio&logoColor=111827" /> | `AGENTS.md` | Ask to set up or scaffold a feature |
| <img alt="Amazon Q" src="https://img.shields.io/badge/Amazon_Q-232F3E?logo=amazonaws&logoColor=white" /> | `.amazonq/rules/` | Rules are loaded from the repo |

Available skills:

- `setup-project` — checks Flutter/Dart setup, dependencies, generated files, hooks, run targets, and analysis.
- `add-feature-template` — scaffolds a new Clean Architecture feature with folders, class skeletons, BLoC state, screen/page files, and DI wiring.
- `rename-app` — renames the app across all platform files (iOS, Android, Web), Dart source, test imports, VS Code config, and all AI rules docs in one pass.

## Why Fork This?

AI can generate Flutter quickly. The hard part is keeping the codebase consistent after the fifth feature.

FlutterAgentic is built for developers who want:

- A Flutter frontend template that is open-source and community-improvable
- Clean Architecture feature folders from day one
- BLoC + Freezed sealed events/states with exhaustive UI rendering
- `Either<Failure, T>` error handling instead of thrown exceptions across layers
- Dio + Retrofit networking with repository-level failure mapping
- GoRouter navigation and a central DI graph
- Design tokens and reusable UI atoms instead of hardcoded styling
- Agent instructions for Claude, Codex, Copilot, Cursor, Gemini, Android Studio, and Amazon Q
- A repeatable path for adding features without asking the AI to invent structure

The core project is Flutter-first. Backend, React, Node.js, Python, or other folders may become optional community examples later, but the main product is a high-quality Flutter frontend starter.

## At A Glance

| Area | Included |
|---|---|
| App shape | Flutter frontend starter with one complete example feature |
| Architecture | Feature-first Clean Architecture with strict layer boundaries |
| AI support | Repo-native instructions for eight AI coding surfaces |
| State | BLoC events/states generated with Freezed |
| Quality gates | Git hooks, analysis, tests, CI, and generated-code workflow |
| Extension path | Add features through documented scaffolding rules |

## How It Is Different

| Alternative | What it gives you | FlutterAgentic difference |
|---|---|---|
| Regular Flutter boilerplates | App folders, dependencies, sometimes example screens | Adds explicit AI-agent rules, forbidden patterns, docs, scaffold flow, tests, and architecture contracts |
| Paid AI Flutter starters like [Create Flutter App](https://createflutterapp.com/) | AI-optimised Flutter template with backend/product modules | FlutterAgentic is open-source, Flutter-frontend-first, and designed for community improvement |
| Paid kits with AI rules like [ApparenceKit](https://apparencekit.dev/flutter-templates/claude-rules/) | Commercial Flutter templates with `CLAUDE.md` rules for their architecture | FlutterAgentic ships multi-agent rules plus the runnable app, CI, tests, design tokens, and feature structure |
| Standalone skills like [building-flutter-apps](https://www.awesomeskills.dev/en/skill/sgaabdu4-building-flutter-apps) | An installable AI-agent skill for Flutter patterns | FlutterAgentic is repo-native: any new Flutter dev can fork, run, edit, and contribute to the app, rules, docs, examples, and verification commands together |

## Stack

| Concern | Library |
|---|---|
| State management | [flutter_bloc](https://pub.dev/packages/flutter_bloc) |
| Dependency injection | [get_it](https://pub.dev/packages/get_it) — service locator (`sl<T>()`) |
| Navigation | [go_router](https://pub.dev/packages/go_router) |
| Networking | [Dio](https://pub.dev/packages/dio) + [Retrofit](https://pub.dev/packages/retrofit) |
| Models / serialization | [Freezed](https://pub.dev/packages/freezed) + [json_serializable](https://pub.dev/packages/json_serializable) |
| Error handling | [fpdart](https://pub.dev/packages/fpdart) (`Either<Failure, T>`) |

## Documentation System

The docs use the [Diataxis](https://diataxis.fr/) approach: separate docs by the reader's need instead of mixing everything into one long guide. Diataxis defines four documentation modes: tutorials, how-to guides, reference, and explanation.

| Need | Folder | Purpose |
|---|---|---|
| Do a task | [`docs/how-to/`](docs/how-to/) | Step-by-step guides for setup, contribution, features, and use cases |
| Look up exact rules | [`docs/reference/`](docs/reference/) | Architecture, naming, dependency boundaries, DI, error flow, and tests |
| Understand why | [`docs/explanation/`](docs/explanation/) | Product vision, agent setup, and reasoning behind the template |
| Guide AI agents | [`docs/ai-rules/`](docs/ai-rules/) | Operational conventions loaded by agent instruction files |

Tutorial-style docs can be added later when the project has more real app examples.

## Architecture

Each feature lives under `lib/feature/{name}/` with three layers:

```mermaid
flowchart LR
  Presentation["presentation<br/>BLoC, screens, widgets"] --> Domain["domain<br/>entities, repositories, use cases"]
  Data["data<br/>DTOs, API clients, repository impls"] --> Domain

  classDef core fill:#eef6ff,stroke:#0a7ea4,color:#111827;
  class Presentation,Domain,Data core;
```

```text
feature/jokes/
├── data/               # API clients, DTOs, repository implementations
├── domain/             # Entities, repository interfaces, use cases (pure Dart)
└── presentation/       # BLoC + screens + widgets
```

The dependency rule is simple:

```text
presentation  ->  domain  <-  data
```

Domain never imports Flutter, Dio, Retrofit, or presentation code. Data never imports UI or BLoC code. Presentation never imports Dio or Retrofit.

See [`docs/reference/architecture.md`](docs/reference/architecture.md) for folder structure, naming, DI, error flow, design system rules, and testing patterns.

## Using This as a Template

1. Click **Use this template** on GitHub to create your repo.
2. Clone your new repo.
3. Run `make setup` to install git hooks and fetch packages.
4. Run `make gen` to generate Freezed / Retrofit code.
5. Run `make test` to verify the starter.
6. Replace or extend the `jokes` feature with your first real feature.

```bash
make setup   # first-time: git hooks + flutter pub get
make run     # flutter run on a connected device
make web     # flutter run -d chrome
make test    # flutter test
make analyze # flutter analyze
make gen     # dart run build_runner build --delete-conflicting-outputs
```

<details>
<summary>Command reference</summary>

| Command | Purpose |
|---|---|
| `make setup` | First-time setup: git hooks + `flutter pub get` |
| `make run` | Run on a connected device |
| `make web` | Run in Chrome |
| `make test` | Run Flutter tests |
| `make analyze` | Run static analysis |
| `make gen` | Generate Freezed / Retrofit code |

</details>

## Running the Example

```bash
make setup
make gen
make run
```

The example feature fetches dad jokes from [icanhazdadjoke.com](https://icanhazdadjoke.com) and demonstrates the full data -> domain -> presentation stack, including search, saved jokes, BLoC state, repository mapping, and widget tests.

## Project Structure

```text
lib/
├── core/
│   ├── base/            # BasePage, BaseScreen, BaseRepository
│   ├── constants/       # API base URLs, app-wide string constants
│   ├── di/              # injection_container.dart, full dependency graph
│   ├── error/           # Failure sealed class
│   ├── network/         # Dio client factory + interceptors
│   ├── theme/           # AppTheme, AppSpacing, AppRadius, AppColorsExtension
│   └── ui/
│       ├── atoms/       # AppButton, AppTextField, AppBadge, AppChip, AppTopBar
│       └── molecules/   # AppBottomSheet, ErrorView, LoadingIndicator
├── feature/
│   └── jokes/           # Full example feature
├── app.dart             # MaterialApp.router + GoRouter config
└── main.dart            # Entry point

test/
├── helpers/             # Shared fakes
├── unit/feature/jokes/  # Use case + BLoC unit tests
└── widget/feature/jokes/# Screen widget tests

docs/
├── ai-rules/            # Conventions loaded by agent instruction files
├── explanation/         # End goal and AI agent setup
├── how-to/              # Contributing, add-feature, add-usecase guides
└── reference/           # Architecture reference
```

## Roadmap

- App checkbox and radio group atoms
- Snackbar and dialog helpers
- Notifications foundation
- Deep link foundation
- Secure storage foundation
- Pagination helpers for list features
- Responsive web layout helpers
- Second non-jokes example feature
- More community-reviewed agent rules and feature templates

## CI

GitHub Actions runs on every push and pull request:

- `dart run build_runner build --delete-conflicting-outputs`
- `flutter analyze --fatal-infos`
- `flutter test --coverage`

See [`.github/workflows/validate.yml`](.github/workflows/validate.yml).

## Quick Links

| Start here | Reference | Build |
|---|---|---|
| [Use as a template](#using-this-as-a-template) | [Architecture](docs/reference/architecture.md) | [`make setup`](#using-this-as-a-template) |
| [AI agent support](#ai-agent-support) | [AI agents](docs/explanation/ai-agents.md) | [`make test`](#ci) |
| [Feature guide](docs/how-to/add-feature-template.md) | [Docs system](#documentation-system) | [`make analyze`](#ci) |
