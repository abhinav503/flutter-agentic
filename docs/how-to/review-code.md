# How to Review Generated Code

Run this skill after any AI-generated code to catch rule violations before they are committed.

The skill does not run tests or static analysis — it reads the project's own rules and checks the code against them. Use `flutter analyze` and `flutter test` for mechanical correctness; use this skill for architectural and convention correctness.

---

## What to check

Work through each section below. For every item, read the relevant source files and report: ✅ pass, ❌ violation (with file path and line), or ⚠️ warning (worth a second look).

---

### 1. Layer boundaries

Read `docs/reference/architecture.md` — Dependency Rule section.

- `domain/` files must not import `flutter`, `flutter_bloc`, `dio`, `retrofit`, or any `data/` or `presentation/` file
- `data/` files must not import `flutter_bloc` or any UI package
- `presentation/` files must not import `dio` or `retrofit`

Check every `import` in the changed files. Flag any that cross a boundary.

---

### 2. Forbidden patterns

Read the **Forbidden Patterns** list in `docs/ai-rules/conventions.md`. Check the generated code for every item:

- Hardcoded colours (`Color(...)`, `Colors.*`), strings, spacing (`EdgeInsets.all(16)`), or radii (`BorderRadius.circular(...)`) in widget files
- Business logic in `build()` or widget classes
- `if (state is XState)` — must be exhaustive `switch`
- `context.read<T>()` after an `await` without a `mounted` check
- More than one feature's logic in a single BLoC
- `*Model` classes used outside `data/`
- `AppBottomSheet.show()` called directly in a screen (must use `showAppBottomSheet()`)
- Full pages or screens extending `StatelessWidget` / `StatefulWidget` directly (must use `BasePage` / `BaseScreen`)
- `setState` in a screen for values that come from BLoC events
- Screen-specific BLoC in `buildBlocProviders` when it is not needed above the body
- `add()` called from inside a BLoC event handler
- Flutter built-in buttons (`ElevatedButton`, `TextButton`, etc.) — must use `AppButton`
- Inline `CircularProgressIndicator` — must use `LoadingIndicator`
- `*Error` states that omit the data needed to retry
- New entity that duplicates an existing one

---

### 3. Naming conventions

Read the **Naming Conventions** table in `docs/reference/architecture.md`.

- Entity files: `{concept}_entity.dart`, class `{Concept}Entity`
- Model files: `{concept}_model.dart`, class `{Concept}Model`
- Repository interface: `{feature}_repository.dart`, class `{Feature}Repository`
- Repository impl: `{feature}_repository_impl.dart`, class `{Feature}RepositoryImpl`
- Data source interface / impl: correct suffixes
- Use case: `{action}_usecase.dart`, class `{Action}UseCase`
- BLoC: `{feature}_bloc.dart`, class `{Feature}Bloc`
- Page / Screen: correct suffixes, extend `BasePage` / `BaseScreen`

---

### 4. DI registration order

Read the **Dependency Injection** section in `docs/reference/architecture.md`.

- Check `lib/core/di/injection_container.dart` for the new registration
- Order must be: Network → Data sources → Repositories → Use cases
- BLoCs must NOT be registered in GetIt — they must be instantiated inside `BlocProvider` in `buildBody`

---

### 5. Error state retry context

Every `*Error` state must carry enough fields for the BLoC to re-dispatch without reading prior state. Check that:
- The error state includes the inputs that triggered the operation (e.g. `searchTerm`, `page`)
- The screen's retry callback uses only those fields — no `if (state is PreviousState)` lookups

---

### 6. Test coverage

Check that new code has a corresponding test file:
- Use case → `test/unit/feature/{name}/domain/`
- BLoC → `test/unit/feature/{name}/presentation/`
- Screen → `test/widget/feature/{name}/`
- Fakes → `test/helpers/` (shared, no duplicates)

Tests must use manual fakes only — no `mockito` or `mocktail` imports.

---

## Output format

Report a checklist:

```
## Code Review — {feature name}

### Layer boundaries        ✅ / ❌
### Forbidden patterns      ✅ / ❌ (list each violation)
### Naming conventions      ✅ / ❌
### DI registration         ✅ / ❌
### Error state retry ctx   ✅ / ❌
### Test coverage           ✅ / ⚠️ / ❌

## What to fix
- [file:line] description of violation
```

Keep the report concise. Only list items that need action — passing items need no explanation.
After reporting, offer to fix each violation if the user confirms.
