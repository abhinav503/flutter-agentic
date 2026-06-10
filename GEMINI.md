# FlutterAgentic — Gemini Rules

> Full reference → `docs/` folder

@docs/ai-rules/conventions.md
@docs/reference/architecture.md
@docs/explanation/end-goal.md

Read `docs/how-to/contributing.md` for contributor workflow and git hooks.
Read `docs/how-to/add-feature-template.md` when scaffolding a new feature — it has the full folder tree, empty class skeletons, DI registration order, and a forbidden-pattern checklist.
Read `docs/how-to/add-usecase.md` when adding a use case — create the class and register it in `injection_container.dart`.
Read `docs/how-to/design-screen-state.md` when designing BLoC events and states — covers business-logic naming, state design, retry context, and screen rendering rules with examples from the jokes feature.
Read `docs/how-to/review-code.md` when the user asks to review, audit, or check generated code — run through the full checklist and report ✅/❌ per section.
Read `docs/how-to/change-app-id.md` when the user asks to change the application ID or bundle identifier — covers Android (`build.gradle.kts` + `MainActivity.kt` package path) and iOS (`project.pbxproj`), with Xcode manual steps and provisioning notes.
Read `docs/explanation/ai-agents.md` for per-agent install and usage.

---

## Project Setup

When the user asks about running the project locally, setting up their environment, or troubleshooting missing tools or emulators, follow the instructions in `docs/ai-rules/setup-project.md`.

@docs/ai-rules/setup-project.md
