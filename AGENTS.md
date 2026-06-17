# FlutterAgentic — Agent Rules (Android Studio · Codex CLI)

> Full reference → `docs/` folder · Setup → `$setup-project` · Release → `$release`

## Documentation Index

Read before writing or modifying any code:
- `docs/reference/architecture.md` — core folder map, layer patterns, naming, DI, error flow, design system, testing
- `docs/explanation/end-goal.md` — project vision and guiding principles

Read on demand:
- `docs/how-to/contributing.md` — contributor workflow and git hooks
- `docs/how-to/add-feature-template.md` — full folder tree, empty class skeletons, DI wiring, and forbidden-pattern checklist for scaffolding a new feature
- `docs/how-to/add-usecase.md` — create a use case class and register it in `injection_container.dart`
- `docs/how-to/design-screen-state.md` — business-logic naming for events and states, retry context rules, screen rendering pattern; use the jokes feature as the reference
- `docs/how-to/review-code.md` — when asked to review, audit, or check generated code; run through the full checklist and report ✅/❌ per section
- `docs/how-to/change-app-id.md` — when asked to change the application ID or bundle identifier; covers Android (`build.gradle.kts` + `MainActivity.kt` package path) and iOS (`project.pbxproj`), with Xcode manual steps and provisioning notes
- `docs/how-to/rename-app.md` — when asked to rename the app; covers display name, package name, and all files that reference the old name
- `docs/explanation/ai-agents.md` — per-agent install and usage
- `docs/tutorials/solid-principles.md` — how SOLID principles are applied across all layers; useful when designing new classes or reviewing layer boundaries
- `docs/tutorials/design-patterns-and-concepts.md` — design patterns used in this codebase (Singleton, Repository, DTO, Either, Sealed Classes, Strategy, and more)
- **Release workflow** (`$release`) — when asked to do a release, follow these steps interactively; ask for confirmation at each step before proceeding:
  1. Check `gh` is installed (`which gh && gh auth status`). Stop if not ready.
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
- `context.read<T>()` after an `await` without a `mounted` check
- More than one feature's logic in a single BLoC
- Exposing `*Model` classes outside the `data/` layer
- Calling `AppBottomSheet.show()` directly in a screen — use `showAppBottomSheet()` from `BaseScreenState`
- Extending `StatelessWidget`/`StatefulWidget` directly for full pages or screens
- Manually editing `.freezed.dart` or `.g.dart` files
- Using `setState` in a screen to store values that come from BLoC events — put them in BLoC state instead
- Putting a screen-specific BLoC in `buildBlocProviders` when it is not needed above the body — provide it in `buildBody` wrapping the screen instead
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
- Naming the primary feature after the product — it's always `feature/home/` with `HomePage`/`HomeScreen`

---

## Code Generation

Run after changing any `@freezed`, `@JsonSerializable`, or `@RestApi()` file:

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

## Project Setup

When the user asks about running the project locally, follow the checklist in `docs/ai-rules/setup-project.md`.
