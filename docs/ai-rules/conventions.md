## Build & Run

After cloning, run `make setup` once to install git hooks and fetch packages.

```bash
make setup       # first-time setup: git hooks + flutter pub get
make run         # flutter run (connected device)
make web         # flutter run -d chrome
make test        # flutter test
make analyze     # flutter analyze
make gen         # dart run build_runner build --delete-conflicting-outputs
```

The pre-commit hook formats staged Dart files and runs `flutter analyze` — commits are blocked if analysis fails.

> First-time setup and contributor workflow: `docs/how-to/contributing.md`
> For folder structure, naming conventions, layer patterns, DI, and code examples see `docs/reference/architecture.md`.

---

## Forbidden Patterns

- Hardcoded colours, strings, spacing, or radii in widget files
- Business logic in `build()` or widget classes
- `import 'package:dio/...'` or `import 'package:retrofit/...'` from `domain/`
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
- Creating a new entity that is structurally identical to an existing one — reuse the existing entity; a single `JokeEntity` works for both single-result and list-result use cases

---

## Code Generation

Run after changing any `@freezed`, `@JsonSerializable`, or `@RestApi()` file:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Never manually edit `.freezed.dart` or `.g.dart` files.

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
