# FlutterAgentic — AI Rules

> **Claude Code** (this file) · **Cursor** → `.cursor/rules/` · **GitHub Copilot** → `.github/copilot-instructions.md` · **Gemini** → `GEMINI.md` · **Codex/Android Studio** → `AGENTS.md` · **Amazon Q** → `.amazonq/rules/`

@docs/ai-rules/conventions.md
@docs/reference/architecture.md
@docs/explanation/end-goal.md

Read `docs/how-to/contributing.md` for contributor workflow and git hooks.
Run `/release` to guide a full release — branch comparison, version bump, release notes, and GitHub Release creation.
Read `docs/how-to/add-feature-template.md` when scaffolding a new feature — it has the full folder tree, empty class skeletons, DI registration order, and a forbidden-pattern checklist.
Read `docs/how-to/add-usecase.md` when adding a use case — create the class and register it in `injection_container.dart`.
Read `docs/how-to/design-screen-state.md` when designing BLoC events and states — covers business-logic naming, state design, retry context, and screen rendering rules with examples from the jokes feature.
Read `docs/how-to/review-code.md` when asked to review, audit, or check generated code — run through the full checklist and report ✅/❌ per section.
Read `docs/how-to/change-app-id.md` when the user asks to change the application ID or bundle identifier — covers Android (`build.gradle.kts` + `MainActivity.kt` package path) and iOS (`project.pbxproj`), with Xcode manual steps and provisioning notes.
Read `docs/how-to/rename-app.md` when the user asks to rename the app — covers display name, package name, and all files that reference the old name.
Read `docs/explanation/ai-agents.md` for per-agent install and usage.
Read `docs/tutorials/solid-principles.md` to understand how SOLID principles are applied across all layers — useful context when designing new classes or reviewing layer boundaries.
Read `docs/tutorials/design-patterns-and-concepts.md` for design patterns used in this codebase (Singleton, Repository, DTO, Either, Sealed Classes, Strategy, and more) — explains the why behind structural decisions.
