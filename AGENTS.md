# FlutterAgentic — Agent Rules (Android Studio · Codex CLI)

> Full reference → `docs/` folder · Setup → `$setup-project` · Release → `$release`

## Documentation Index

Read before writing or modifying any code:
- `docs/reference/architecture.md` — core folder map, layer patterns, naming, DI, error flow, design system, testing
- `docs/explanation/end-goal.md` — project vision and guiding principles

Read on demand:
- `docs/ai-rules/design.md` — read before writing any screen, scaffolding an app's UI, or restyling; decides the style pack/theme preset and screen design rules, and which blocks (`core/ui/blocks/`) to compose from
- `docs/how-to/contributing.md` — contributor workflow and git hooks
- `docs/how-to/add-feature-template.md` — full folder tree, empty class skeletons, DI wiring, and forbidden-pattern checklist for scaffolding a new feature
- `docs/how-to/add-usecase.md` — create a use case class and register it in `injection_container.dart`
- `docs/how-to/design-screen-state.md` — business-logic naming for events and states, retry context rules, screen rendering pattern; use the jokes feature as the reference
- `docs/how-to/review-code.md` — when asked to review, audit, or check generated code; run through the full checklist and report ✅/❌ per section
- `docs/how-to/change-app-id.md` — when asked to change the application ID or bundle identifier; covers Android (`build.gradle.kts` + `MainActivity.kt` package path) and iOS (`project.pbxproj`), with Xcode manual steps and provisioning notes
- `docs/how-to/rename-app.md` — when asked to rename the app; covers display name, package name, and all files that reference the old name
- `docs/how-to/connect-firebase.md` (or run `$connect-firebase`) — when connecting an app to Firebase; covers checking/installing the Firebase + FlutterFire CLIs, running `flutterfire configure`, per-app `firebase_core`, `main.dart` init, Android Gradle plugin, iOS deployment target (15.0+), and the Xcode `GoogleService-Info.plist` registration check
- `docs/how-to/add-firebase-auth.md` (or run `$add-firebase-auth`) — when adding email/password login/signup to an app; covers `FirebaseAuthService`, a Clean-Architecture `feature/auth/` (thin repository, fat data source), the persistent non-dismissible email-verification bottom sheet with a 3-second poll that resumes correctly across app relaunches, an optional backend dual-write (Firebase Auth + a Firestore profile synced via a token-verifying server API), and a local profile cache to avoid loader flashes; builds on `$connect-firebase`. Proven end-to-end in `apps/ecommerce/gravia`
- `docs/explanation/ai-agents.md` — per-agent install and usage
- `docs/tutorials/solid-principles.md` — how SOLID principles are applied across all layers; useful when designing new classes or reviewing layer boundaries
- `docs/tutorials/design-patterns-and-concepts.md` — design patterns used in this codebase (Singleton, Repository, DTO, Either, Sealed Classes, Strategy, and more)
- **Release workflow** (`$release`) — when asked to do a release, follow these steps interactively; ask for confirmation at each step before proceeding:
  1. Load `GH_TOKEN` from the git-ignored root `.env` (`set -a && . ./.env && set +a`) — release auth is explicit because the repo uses multiple GitHub accounts — then check `gh auth status` reports `(GH_TOKEN)`. Source `.env` in every shell that runs `gh`. If `.env` lacks a token, create a fine-grained PAT (Contents: Read and write) at https://github.com/settings/personal-access-tokens/new and add `GH_TOKEN=…`. Stop if not ready. If `gh auth status` reports the token as invalid, confirm the shell has network access before replacing it — in a sandboxed agent environment, blocked network access can surface as an auth failure; re-run with network permission and `.env` sourced first.
  2. Get current branch (`git branch --show-current`). Confirm release branch with user.
  3. Compare to main: `git log main..{BRANCH} --oneline` + `git diff main..{BRANCH} --stat`. Show commits.
  4. Read version (`grep "^version:" pubspec.yaml`). Propose bump: Major = breaking; Minor = feat: or new component/skill; Patch = fix/chore/docs. Wait for confirmation.
  5. Edit `pubspec.yaml` with confirmed version.
  6. Create `docs/releases/v{VERSION}.md` from `docs/releases/_template.md`. Two sections: **Features** (what developers gain) and **Agent Context Improvements** (what agents gain). Plain language, one sentence per bullet, no duplicates. Show draft and wait for confirmation.
  7. Commit: `git add pubspec.yaml docs/releases/v{VERSION}.md && git commit -m "chore: release v{VERSION}" && git push`
  8. Merge: `git checkout main && git pull origin main && git merge --no-ff {BRANCH} -m "chore: merge {BRANCH} into main for v{VERSION}" && git push origin main`
  9. Tag and release: `git tag v{VERSION} && git push origin v{VERSION}` then `gh release create v{VERSION} --title "v{VERSION} — {TITLE}" --notes-file docs/releases/v{VERSION}.md --target main`. Report URL.
  10. Ask to delete release branch. If yes: `git branch -d {BRANCH} && git push origin --delete {BRANCH}`

---

## Monorepo Layout

Dart pub-workspace monorepo: one shared `core` package consumed by multiple Flutter apps.

```
packages/core/   shared toolbelt → import 'package:core/core/…'   (no app-specific code)
apps/jokes/      demo app          apps/doc_scanner/  request/response app
apps/ai_chat/    streaming app
```

- One `flutter pub get` at the repo root resolves all packages; editing `core` is live in any running app.
- Each app owns its `main.dart`, `app.dart`, `di/injection_container.dart`, `constants/` (`ValueConst`/`ApiConstants`), and `feature/home/`. `core` holds only `CoreConst`.
- Run `make` targets from the repo root; run an app from its folder (`apps/<app>`).

## Build & Run

After cloning, run `make setup` once to install git hooks and fetch packages.

```bash
make setup            # first-time setup: git hooks + root flutter pub get
make run-jokes        # run the jokes app (cd apps/jokes && flutter run)
make run-doc-scanner  # run the doc_scanner app
make run-ai-chat      # run the ai_chat app
make web-jokes        # run jokes on Chrome
make test             # flutter test in each app
make analyze          # flutter analyze — whole workspace
make gen              # build_runner in core + each app
make clean            # flutter clean per package, then root pub get
```

The pre-commit hook formats staged Dart files and runs `flutter analyze` at the root — commits are blocked if analysis fails.

---

## Forbidden Patterns

- Hardcoded colours, strings, spacing, or radii in widget files
- Business logic in `build()` or widget classes
- `import 'package:dio/...'` from `domain/`
- `if (state is XState)` — always use exhaustive `switch`
- Giving an enum methods/fields in its own body (enhanced enum) when an `extension on` it would do — keep enums as bare case lists; put helpers, `switch` mappings, and string ↔ enum conversion in an extension beside the enum. Likewise, put repeated `String`/`num`/`DateTime` logic in an `extension on` that type, not a `*Utils` helper class or inline. Don't add a conversion extension for an enum that never crosses a string boundary; parse wire strings in the `*Model` (data layer), not the UI
- Comments that restate what the code or name already says — with business-logic naming most doc comments are redundant. Write **why** (non-obvious decisions, gotchas, constraints), not **what**. Don't repeat the same note in two places, and reserve longer comments for genuinely complex logic. Examples:
  - ❌ `/// Stops the app.` above `Future<…> stopApp(String name)` — the name says it
  - ❌ `/// Param is the app name.` above `RunAppUseCase` — the signature says it
  - ✅ `// Not const — owns the live WebSocket the other methods act on`
  - ✅ `// Returning a state equal to the current one is a no-op, so per-chunk updates don't rebuild`
- `context.read<T>()` after an `await` without a `mounted` check
- More than one feature's logic in a single BLoC
- Exposing `*Model` classes outside the `data/` layer
- Calling `AppBottomSheet.show()` directly in a screen — use `showAppBottomSheet()` from `BaseScreenState`
- Extending `StatelessWidget`/`StatefulWidget` directly for full pages or screens
- Manually editing `.freezed.dart` or `.g.dart` files
- Using `setState` in a screen to store values that come from BLoC events — put them in BLoC state instead
- Putting a screen-specific BLoC in `buildBlocProviders` when it is not needed above the body — provide it in `buildBody` wrapping the screen instead. A nav shell doesn't get its own BLoC by default (tab index is `setState`); add a `Cubit` there only once real info needs sharing across tabs/pages, named for that concern (e.g. `CartBadgeCubit`), never a catch-all
- Calling `add()` from inside a BLoC event handler — factor shared logic into a private method instead
- Using Flutter's built-in button widgets (`ElevatedButton`, `TextButton`, `OutlinedButton`, `FilledButton`) in screens or molecules — use `AppButton` with the appropriate `AppButtonVariant`
- Using a raw `PopupMenuButton` / `DropdownButton` for a menu/select — use `AppDropdownMenu` (themed, with `AppDropdownItem`)
- Inline `CircularProgressIndicator` in screens — use `LoadingIndicator` (spinner) or `LoadingDots` (inline "working…") from `package:core/core/ui/atoms/`
- A hand-rolled empty/placeholder view — use the `EmptyState` molecule
- Error states that omit the data needed to retry — every `*Error` state must carry enough context (e.g. `searchTerm`, `page`) for the BLoC to re-dispatch without reading prior state; screens must never inspect preceding states for retry inputs
- Creating a new entity that is structurally identical to an existing one — reuse the existing entity
- Adding constructor parameters to data source impls for infrastructure — data sources are `const` no-arg; they reach infrastructure through static singleton `.instance` calls
- Duplicating UI concerns (safe-area padding, snackbars, bottom sheet or dialog presentation) across screens — these belong in `BaseScreenState`, `AppBottomSheet`, or `AppDialog`; if something appears in more than one screen, move it to the appropriate base class
- Creating a `*Model` without a corresponding `*Entity`, or a `*Entity` without a corresponding `*Model` — every DTO in `data/` must map to an entity in `domain/` and vice versa; they are always a pair
- Registering a static-singleton service (`HttpService`, `SharedPreferenceService`, `ImagePickerService`, or any class with a `static final instance`) in GetIt, or calling `sl<T>()` for it — these are never in the GetIt graph; always access them via `ServiceName.instance`
- Writing field-by-field `Model(field: entity.field, ...)` construction inside a repository — use `Model.fromEntity(entity)` and `model.toEntity()` instead; every `*Model` must expose both
- Putting app-specific copy, feature logic, or product API URLs in `core` — `core` is the generic shared toolbelt; product strings/URLs go in each app's `lib/constants/` (`ValueConst`/`ApiConstants`), `core` keeps only `CoreConst`
- Listing a package in an app's `pubspec.yaml` the app doesn't import directly — declare only direct deps; keep `core` dependency-lean
- Naming the primary feature after the product — it's always `feature/home/` with `HomePage`/`HomeScreen`. Exception: a bottom-nav tabbed app can split the entry point into a `feature/shell/` nav host (`ShellPage`/`ShellScreen`, no domain/data of its own) from `feature/home/` (the real first-tab feature) — this is a case to recognize and confirm with the user when a spec implies tabs, not a rule to auto-apply
- Unguarded native-only init or actions — apps are **previewed as Flutter Web**, so the boot path and tap handlers must never crash on web. Guard native/platform code behind `kIsWeb`: wrap web-throwing init (`Firebase.initializeApp`, FCM, `flutter_local_notifications`) in `if (!kIsWeb) { … }`; make native-only user actions (camera/gallery, native share) no-op **with a snackbar** (e.g. `'… only available on mobile'`) — never a silent dead button or a thrown exception. Prefer plugins with a web implementation. **If a package won't *compile* for web** (pulls in `dart:io`/`dart:ffi`), a runtime `kIsWeb` isn't enough — isolate it behind a **conditional import** with a web stub (`export 'x_stub.dart' if (dart.library.io) 'x_io.dart' if (dart.library.js_interop) 'x_web.dart';`), not Dart deferred loading. Rule: *compiles but throws* → `kIsWeb`; *won't compile* → conditional import

---

## Code Generation

Run after changing any `@freezed` or `@JsonSerializable` file:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Git

```
<type>: <summary under 72 chars>

What changed:
- bullet

Why:
- bullet
```

Types: `feat` `fix` `chore` `refactor` `test` `docs` `ci`

---

## UI Molecules

Use these shared components rather than their raw Flutter equivalents:

| Component | Use instead of |
|---|---|
| `AppBottomSheet.show(context, title:, child:)` | `showModalBottomSheet` directly |
| `AppDialog.show(context, title:, child:, actions:)` | `showDialog` + `AlertDialog` directly |
| `AppButton` with `AppButtonVariant` | `ElevatedButton`, `TextButton`, `FilledButton`, etc. |
| `AppDropdownMenu` with `AppDropdownItem` | raw `PopupMenuButton` / `DropdownButton` |
| `LoadingIndicator` / `LoadingDots` | `CircularProgressIndicator` inline |
| `EmptyState` | hand-rolled empty/placeholder view |

---

## Theme

Config-driven: each app's `assets/theme/theme_config.json` → `AppTheme.fromConfig` → `ThemeData`. A new look is a new config, never per-app theme Dart.

- **Colours:** `activeTheme` picks a preset (`dadJokes`, `oceanBreeze`, `forestWalk`, `rocketWarm`); a seed generates all M3 roles, any role overridable by key. Extra success/warning roles → `AppColorsExtension`.
- **Shape:** optional `"shape": { button, chip, card, input, sheet }` (+ `"density"`) sets brand corner radii. These populate `ThemeData`'s component themes (`elevatedButtonTheme`, `chipTheme`, `cardTheme`, …) **and** the `AppShapes` extension the atoms read — so a raw `ElevatedButton` and `AppButton` match and re-skin together. Read radius from `Theme.of(context).extension<AppShapes>()!`, never hardcode it.
- **Dark/light:** `ThemeMode.system` by default. Manual toggle = `ThemeModeController` (persisted `ValueNotifier<ThemeMode>` in core — not a Cubit, keeps core free of `flutter_bloc`) + `ThemeModeScope` + the `ThemeModeToggle` atom (System→Light→Dark) in the AppBar.
- Full detail: `docs/reference/architecture.md` → Theme configuration.

---

## Project Setup

When the user asks about running the project locally, follow the checklist in `docs/ai-rules/setup-project.md`.

---

## Maintaining agent instructions

This repo serves **7 AI agents** across **6 instruction surfaces** (Codex CLI + Android Studio share `AGENTS.md`). The canonical rule docs are `docs/ai-rules/conventions.md` and `docs/reference/architecture.md`.

When you change a shared rule, update **every** surface in the same commit:

| Surface | Agent(s) | Picks up canonical-doc edits |
|---|---|---|
| `CLAUDE.md` | Claude Code | ✅ auto (`@docs/…` import) |
| `GEMINI.md` | Gemini CLI | ✅ auto (`@docs/…` import) |
| `.amazonq/rules/` | Amazon Q | ⚠️ hybrid — plain rule docs are **symlinks** into `docs/` (auto-sync); per-skill files are **self-contained copies** (hand-sync, drift). Amazon Q reads symlink targets but cannot follow `@docs/…` prose references |
| `.cursor/rules/conventions.mdc` | Cursor | ⚠️ hand-sync — self-contained copy |
| `.github/copilot-instructions.md` | GitHub Copilot | ⚠️ hand-sync — self-contained copy |
| `AGENTS.md` | Codex CLI, Android Studio | ⚠️ hand-sync — self-contained copy |

The three ⚠️ files only **name** the doc path as prose; they carry their own condensed copy that drifts unless edited directly. Full per-agent detail: `docs/explanation/ai-agents.md`.

**Skills live in two parallel trees — keep them in sync.** Both Claude Code (`.claude/skills/`) and Codex CLI (`.codex/skills/`) read per-skill `SKILL.md` folders, but in different formats: Claude skills are thin (body + `@docs/…` import), Codex skills are **self-contained inline** (full content with YAML frontmatter, since Codex can't follow `@docs/…`). When you add, remove, or rename a skill, update **both** trees in the same commit — `.codex/skills/` does not inherit `.claude/skills/` edits — and add the matching self-contained `.amazonq/rules/<skill>.md`. A skill that exists in only one tree is the most common drift; verify with `ls .claude/skills .codex/skills`.
