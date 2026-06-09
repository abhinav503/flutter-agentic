# Cordelia Base — Agent Rules (Android Studio · Codex CLI)

> Full reference → `docs/` folder · Setup skill → `$setup-project` or ask about project setup

## Documentation Index

Read before writing or modifying any code:
- `docs/reference/architecture.md` — folder structure, layer patterns, naming, DI, error flow, design system, testing
- `docs/explanation/end-goal.md` — project vision and guiding principles

Read on demand:
- `docs/how-to/contributing.md` — contributor workflow and git hooks
- `docs/how-to/add-feature.md` — full folder tree, empty class skeletons, DI wiring, and forbidden-pattern checklist for scaffolding a new feature
- `docs/explanation/ai-agents.md` — per-agent install and usage

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
- `import 'package:dio/...'` or `import 'package:retrofit/...'` from `domain/`
- `if (state is XState)` — always use exhaustive `switch`
- `context.read<T>()` after an `await` without a `mounted` check
- More than one feature's logic in a single BLoC
- Exposing `*Model` classes outside the `data/` layer
- Calling `AppBottomSheet.show()` directly in a screen — use `showAppBottomSheet()` from `BaseScreenState`
- Extending `StatelessWidget`/`StatefulWidget` directly for full pages or screens
- Manually editing `.freezed.dart` or `.g.dart` files

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

## Project Setup

When the user asks about running the project locally, follow the checklist in `docs/ai-rules/setup-project.md`.
