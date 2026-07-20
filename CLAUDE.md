# FlutterAgentic — AI Rules

> **Claude Code** (this file) · **Cursor** → `.cursor/rules/` · **GitHub Copilot** → `.github/copilot-instructions.md` · **Gemini** → `GEMINI.md` · **Codex/Android Studio** → `AGENTS.md` · **Amazon Q** → `.amazonq/rules/`

## Monorepo layout

This is a **Dart pub-workspace monorepo**: one shared `core` package consumed by multiple Flutter apps.

```
packages/core/   shared toolbelt → import 'package:core/core/…'   (no app-specific code)
apps/jokes/      demo app          apps/doc_scanner/  request/response app
apps/ai_chat/    streaming app
apps/ecommerce/gravia/  style-pack exemplar (`gravia` theme, ecommerce blocks, free-pack
                         screens: splash, onboarding, app logo)
```

- One `flutter pub get` at the repo root resolves all packages; editing `core` is live in any running app.
- Run `make` targets from the repo root; run an app from its folder (`apps/<app>`). See `docs/ai-rules/conventions.md` for commands.
- Each app: its own `main.dart`, `app.dart`, `di/injection_container.dart`, `constants/` (`ValueConst`/`ApiConstants`), and `feature/home/`. `core` holds only generic constants (`CoreConst`). Keep `core` dependency-lean; each app lists only the deps it imports directly.

@docs/ai-rules/conventions.md
@docs/reference/architecture.md
@docs/explanation/end-goal.md

Read `docs/ai-rules/design.md` BEFORE writing any screen, scaffolding an app's UI, or restyling — it decides which style pack / theme preset an app uses (e.g. `gravia` for ecommerce) and sets the screen design rules and the blocks (`core/ui/blocks/`) to compose from.
Read `docs/how-to/contributing.md` for contributor workflow and git hooks.
Run `/release` to guide a full release — branch comparison, version bump, release notes, and GitHub Release creation.
Read `docs/how-to/add-feature-template.md` when scaffolding a new feature — it has the full folder tree, empty class skeletons, DI registration order, and a forbidden-pattern checklist.
Read `docs/how-to/add-usecase.md` when adding a use case — create the class and register it in `injection_container.dart`.
Read `docs/how-to/stream-usecase.md` when an operation emits many values over time (SSE, sockets, LLM token streams) — covers the `StreamUseCase` base, `BaseRepository.handleStream`, consuming a stream in a BLoC with `emit.forEach` + cancellation, and single-state design, with examples from the `ai_chat` app.
Read `docs/how-to/design-screen-state.md` when designing BLoC events and states — covers business-logic naming, state design, retry context, and screen rendering rules with examples from the jokes feature.
Read `docs/how-to/design-tab-flow.md` when building a bottom-nav shell or wiring a tab's BLoC — covers `ShellPage`'s shared `AuthBloc` + per-tab `BlocProvider`s, the warm-start caching pattern each tab BLoC uses to skip the loading shimmer on revisit, and gravia's full Firebase auth flow (signup/login, the persistent email-verification sheet + 3s poll, resume-on-relaunch, forgot password).
Read `docs/how-to/review-code.md` when asked to review, audit, or check generated code — run through the full checklist and report ✅/❌ per section.
Read `docs/how-to/change-app-id.md` when the user asks to change the application ID or bundle identifier — covers Android (`build.gradle.kts` + `MainActivity.kt` package path) and iOS (`project.pbxproj`), with Xcode manual steps and provisioning notes.
Read `docs/how-to/rename-app.md` when the user asks to rename the app — covers display name, package name, and all files that reference the old name.
Read `docs/how-to/connect-firebase.md` (or run `/connect-firebase`) when connecting an app to Firebase — covers the FlutterFire CLI flow, per-app `firebase_core`, `main.dart` init, Android Gradle plugin, and the manual Xcode `GoogleService-Info.plist` step; it asks which app under `apps/` to connect.
Read `docs/how-to/add-firebase-auth.md` (or run `/add-firebase-auth`) when adding email/password login/signup to an app — covers `FirebaseAuthService`, a Clean-Architecture `feature/auth/` (thin repository, fat data source), the persistent non-dismissible email-verification bottom sheet with a 3-second poll that resumes correctly across app relaunches, an optional backend dual-write (Firebase Auth + a Firestore profile synced via a token-verifying server API), and a local profile cache to avoid loader flashes; builds on `/connect-firebase`. Proven end-to-end in `apps/ecommerce/gravia`.
Read `docs/how-to/add-app-logo.md` (or run `/add-app-logo`) when setting or changing an app's launcher icon — one brand image (asks the user for it) → every Android/iOS/web size via `flutter_launcher_icons`, with adaptive-icon safe-zone rules and a per-platform verification checklist.
Read `docs/how-to/add-splash-screen.md` (or run `/add-splash-screen`) when adding a native boot splash to an app — `flutter_native_splash` with theme-derived light/dark colours and a centered logo (4x-density and Android-12 asset rules), plus a verification checklist; pairs with an optional Flutter splash route.
Read `docs/how-to/add-notification-feature.md` (or run `/add-notification-feature`) when adding Firebase Cloud Messaging push notifications to an app — covers per-app `firebase_messaging` + `flutter_local_notifications`, foreground/background/terminated handling, tap-to-open-a-page routing, and image (rich) notifications, split into shared Flutter code + separate iOS / Android tracks; builds on `/connect-firebase`. Recommend testing FCM on a real Android device (emulator Play services is flaky).
Read `docs/explanation/ai-agents.md` for per-agent install and usage.
Read `docs/tutorials/solid-principles.md` to understand how SOLID principles are applied across all layers — useful context when designing new classes or reviewing layer boundaries.
Read `docs/tutorials/design-patterns-and-concepts.md` for design patterns used in this codebase (Singleton, Repository, DTO, Either, Sealed Classes, Strategy, and more) — explains the why behind structural decisions.
