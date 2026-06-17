# FlutterAgentic — Amazon Q Rules

> **Monorepo:** Dart pub-workspace — shared `core` package (`packages/core`, import `package:core/core/…`) consumed by Flutter apps (`apps/jokes`, `apps/doc_scanner`). One `flutter pub get` at the repo root resolves all; run an app from its folder. Each app owns its `di/`, `constants/` (`ValueConst`/`ApiConstants`), and `feature/home/`; `core` holds only `CoreConst`. Keep `core` free of app-specific copy and lean on dependencies.

Read before writing or modifying any code:
- `docs/ai-rules/conventions.md` — forbidden patterns, build commands, git format
- `docs/reference/architecture.md` — core folder map, layer patterns, naming, DI, error flow, design system, testing
- `docs/explanation/end-goal.md` — project vision and guiding principles

Read on demand:
- `docs/how-to/contributing.md` — contributor workflow and git hooks
- `docs/how-to/add-feature-template.md` — full folder tree, empty class skeletons, DI wiring, and forbidden-pattern checklist for scaffolding a new feature
- `docs/how-to/add-usecase.md` — create a use case class and register it in `injection_container.dart`
- `docs/how-to/design-screen-state.md` — business-logic naming for events and states, retry context rules, screen rendering pattern
- `docs/how-to/review-code.md` — when asked to review, audit, or check generated code; run through the full checklist and report ✅/❌ per section
- `docs/how-to/change-app-id.md` — when asked to change the application ID or bundle identifier
- `docs/how-to/rename-app.md` — when asked to rename the app; covers display name, package name, and all files that reference the old name
- `docs/tutorials/solid-principles.md` — how SOLID principles are applied across all layers
- `docs/tutorials/design-patterns-and-concepts.md` — design patterns used in this codebase (Singleton, Repository, DTO, Either, Sealed Classes, Strategy, and more)
- `docs/explanation/ai-agents.md` — per-agent install and usage
- `release.md` (in this rules folder) — full release workflow; automatically loaded by Amazon Q
