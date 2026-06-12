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
- `docs/how-to/release.md` — when asked to do a release; invoke with `$release` or follow the steps in that file directly

---

## Build & Run

After cloning, run `make setup` once to install git hooks and fetch packages.

```bash
make setup    # first-time setup: git hooks + flutter pub get
make run      # flutter run (connected device)
make web      # flutter run -d chrome
make test     # flutter test
make analyze  # flutter analyze
make gen      # dart run build_runner build --delete-conflicting-outputs
```

The pre-commit hook formats staged Dart files and runs `flutter analyze` — commits are blocked if analysis fails.

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
- Inline `CircularProgressIndicator` in screens — use `LoadingIndicator` from `core/ui/atoms/`
- Error states that omit the data needed to retry — every `*Error` state must carry enough context (e.g. `searchTerm`, `page`) for the BLoC to re-dispatch without reading prior state; screens must never inspect preceding states for retry inputs
- Creating a new entity that is structurally identical to an existing one — reuse the existing entity
- Adding constructor parameters to data source impls for infrastructure — data sources are `const` no-arg; they reach infrastructure through static singleton `.instance` calls
- Duplicating UI concerns (safe-area padding, snackbars, bottom sheet or dialog presentation) across screens — these belong in `BaseScreenState`, `AppBottomSheet`, or `AppDialog`; if something appears in more than one screen, move it to the appropriate base class
- Creating a `*Model` without a corresponding `*Entity`, or a `*Entity` without a corresponding `*Model` — every DTO in `data/` must map to an entity in `domain/` and vice versa; they are always a pair
- Registering a static-singleton service (`HttpService`, `SharedPreferenceService`, `ImagePickerService`, or any class with a `static final instance`) in GetIt, or calling `sl<T>()` for it — these are never in the GetIt graph; always access them via `ServiceName.instance`
- Writing field-by-field `Model(field: entity.field, ...)` construction inside a repository — use `Model.fromEntity(entity)` and `model.toEntity()` instead; every `*Model` must expose both

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
| `LoadingIndicator` | `CircularProgressIndicator` inline |

---

## Project Setup

When the user asks about running the project locally, follow the checklist in `docs/ai-rules/setup-project.md`.
