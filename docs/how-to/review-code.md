# How to Review Generated Code

Run this skill after any AI-generated code to catch rule violations before they are committed.

The skill does not run tests or static analysis — it reads the project's own rules and checks the code against them. Use `flutter analyze` and `flutter test` for mechanical correctness; use this skill for architectural and convention correctness.

---

## Before you report anything: verify

A finding is a **hypothesis** until you have followed the code path it claims
is broken. In a fifty-item review of a mature app, several of the most
convincing findings were wrong:

- three error states flagged for "missing retry context" each retried
  correctly, through a parameterless event, because the BLoC held the inputs
  as fields — the rule exists to stop screens reading *previous states*, and
  none of them did;
- two entity/model pairs flagged as "structurally identical" were distinct
  concepts that happened to share three fields, and merging them would have
  made the surviving type mean "either of two things";
- four strings flagged as duplicated were identical **in English only** —
  elsewhere one was a width-budgeted short form, and the merge overflowed its
  slot in four languages.

Each was derived from the letter of a rule without reading what the rule
protects. So:

- Read the retry path before reporting a missing retry field.
- Read every locale before reporting duplicated copy.
- Read the *reason* a fork exists before proposing to remove it — if the file
  documents the decision, argue with the documented reason or leave it.
- When the claim is behavioural ("this navigation doesn't work"), reproduce
  it. One such bug here was settled only by a runnable repro, and the leading
  theory turned out to be wrong.

Report what survives that, and say plainly when a finding did not.

## What to check

Work through each section below. For every item, read the relevant source files and report: ✅ pass, ❌ violation (with file path and line), or ⚠️ warning (worth a second look).

---

### 1. Layer boundaries

Read `docs/reference/architecture.md` — Dependency Rule section.

- `domain/` files must not import `flutter`, `flutter_bloc`, `dio`, or any `data/` or `presentation/` file
- `data/` files must not import `flutter_bloc` or any UI package
- `presentation/` files must not import `dio`

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
- Unguarded native-only init/actions that crash Flutter Web (`Firebase.initializeApp`, FCM, `flutter_local_notifications`, camera/gallery) — see section 8

---

### 3. Reuse & promotion to core

Before accepting new widgets, utilities, or services, check whether the capability already exists or should be shared. This is the easiest thing for generated code to get wrong — it tends to reinvent rather than reuse.

**Reuse what core already provides.** Skim `packages/core/lib/core/ui/`, `base/`, `network/`, and `usecase/` before judging new code. Flag ❌ when the change reimplements something core already has:
- molecules: `EmptyState`, `ErrorView`, `AppBottomSheet`, `AppDialog`, `AppMenuTile`, `AppRadioGroup`, `IconInfoRow` (takes `subtitle`/`trailing`/`onTap` — flag private forks of its row silhouette), `ShimmerListRow` / `ShimmerSectionHeader` / `ShimmerCircleTile`
- atoms: `AppButton`, `AppTextField`, `AppBadge`, `AppChip`, `AppTopBar`, `AppCheckbox`, `AppIconButton`, `AppIconCircle`, `AppSwitcher` (flag raw `AnimatedSwitcher` content swaps), `LoadingIndicator`, `LoadingDots`, `AppDropdownMenu`
- blocks: `SectionRail` (flag hand-rolled header + horizontal rail compositions), `PriceBreakdown` (`blocks/ecommerce/` — flag hand-rolled totals panels), plus the rest of the `design.md` §2 index
- extensions: `context.appColors` (flag hand-typed `Theme.of(context).extension<AppColorsExtension>()!`), `num`/`int` formatting (`asPrice`, `asPercent`, `plural` — flag inline `toStringAsFixed` price/percent recipes)
- logic: `BaseRepository` (`handleRequest` / `handleStream`), `UseCase` / `StreamUseCase`, `HttpService` (`get` / `post` / `put` / `delete` / `postStream`)

**No raw Material widgets where a design-system equivalent exists.** Flag direct use of `PopupMenuButton` / `DropdownButton` (→ `AppDropdownMenu`), `TextField` (→ `AppTextField`), `ElevatedButton` / `TextButton` / `OutlinedButton` / `FilledButton` (→ `AppButton`), `CircularProgressIndicator` (→ `LoadingIndicator`), or a hand-rolled empty/error view (→ `EmptyState` / `ErrorView`). If no atom fits, the fix is to add one to core (next point) — not to inline raw Material.

**Flag any `core/ui/` widget with no callers (❌).** Extraction and adoption
are one task. A shared widget that nothing uses means the hand-rolled
predecessors are still shipping, and there are now two things to maintain
instead of one. `grep -r <WidgetName> --include='*.dart'` over the workspace
settles it in seconds, and it is the single highest-yield check in this
section.

**Before proposing a merge, apply the three-parameter test (⚠️).** Nearly
every justified extraction is a shared widget missing *one* parameter. If
absorbing a variant would need **three or more** new config params — a
different disabled treatment, a fixed-width slot, its own semantics — the fork
is correct; say so instead of filing it. Check whether the file already
explains the decision before re-opening it.

**Promote genuinely generic code to core (⚠️).** Flag app-local code that is dependency-free, app-agnostic, and reusable, and recommend moving it down:
- generic widgets → `core/ui/atoms` or `core/ui/molecules`
- generic mechanism (networking, base classes, stream/error handling) → the matching `core/` folder
- Keep **provider/product specifics** (API URLs, prompts, model ids, feature logic) in the app. Never promote anything that would add a new dependency to `core` — core stays dependency-lean.

**Don't duplicate across screens.** Safe-area padding, snackbars, and sheet/dialog presentation belong in `BaseScreenState` / `AppBottomSheet` / `AppDialog`; if the same concern appears in two screens, it should move down.

---

### 4. Naming conventions

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

### 5. DI registration order

Read the **Dependency Injection** section in `docs/reference/architecture.md`.

- Check the app's `apps/{app}/lib/di/injection_container.dart` for the new registration
- Order must be: Network → Data sources → Repositories → Use cases
- BLoCs must NOT be registered in GetIt — they must be instantiated inside `BlocProvider` in `buildBody`

---

### 6. Error state retry context

Every `*Error` state must carry enough fields for the BLoC to re-dispatch without reading prior state. Check that:
- The error state includes the inputs that triggered the operation (e.g. `searchTerm`, `page`)
- The screen's retry callback uses only those fields — no `if (state is PreviousState)` lookups

---

### 6b. Failures the user reads

- Does any failure path show text a machine wrote — an HTTP client's message,
  an SDK exception, `e.toString()`? Those are developer copy in one language.
- Does a bottom sheet report its own validation through the host screen's
  `showSnackBar`? That renders behind the modal barrier.
- Does a submit close its surface before the write resolves, throwing away
  what the user typed?
- Does every subscription have an error path, and do empty and failed render
  differently?

### 7. Test coverage

Check that new code has a corresponding test file:
- Use case → `apps/{app}/test/unit/feature/{name}/domain/`
- BLoC → `apps/{app}/test/unit/feature/{name}/presentation/`
- Screen → `apps/{app}/test/widget/feature/{name}/`
- Fakes → `apps/{app}/test/helpers/` (shared, no duplicates)

Tests must use manual fakes only — no `mockito` or `mocktail` imports.

Two failures worth grepping for explicitly:
- **A test that reaches the network.** Look for tests calling the app's real
  `initDependencies()` without overriding the data sources — those pass only
  while some deployment answers, and fail the day it stops.
- **A test seam in production code** (`@visibleForTesting` static overrides,
  `debug*` flags). That is a missing dependency boundary; the fix is to inject
  the dependency, not to keep the seam.

---

### 8. Web-safe native guards

Generated apps are previewed as **Flutter Web**, so the boot path and every tap handler must be safe on web. Read the native-only entry in the **Forbidden Patterns** list of `docs/ai-rules/conventions.md`, then check:

- **Startup boots on web.** Native init that throws on web — `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`, `FirebaseMessaging.onBackgroundMessage`, `flutter_local_notifications`, and any native-only plugin init — is inside `if (!kIsWeb) { … }` (or a `try/catch` that continues).
- **Native-only actions degrade gracefully.** Camera/gallery capture, native share/save, etc. `kIsWeb`-guard the handler to no-op **with user feedback** (a snackbar), never a silent dead button and never a thrown exception.
- **Web-incompatible packages use conditional imports, not just `kIsWeb`.** If a changed file or a new dependency pulls in a package that can't compile for web (`dart:io` / `dart:ffi` / `dart:mirrors`-based), a runtime `kIsWeb` guard won't help — the import fails to compile. Flag ❌ unless the platform code is isolated behind a conditional import (`export '…_stub.dart' if (dart.library.io) '…_io.dart' if (dart.library.js_interop) '…_web.dart';`) with a web stub. (`compiles but throws` → `kIsWeb`; `won't compile` → conditional import. Dart deferred loading is not a fix.)
- Flag ❌ any native init or action reachable on web without a guard.

---

## Output format

Report a checklist:

```
## Code Review — {feature name}

### Layer boundaries        ✅ / ❌
### Forbidden patterns      ✅ / ❌ (list each violation)
### Reuse & promotion       ✅ / ⚠️ / ❌
### Naming conventions      ✅ / ❌
### DI registration         ✅ / ❌
### Error state retry ctx   ✅ / ❌
### Failures the user reads ✅ / ❌
### Test coverage           ✅ / ⚠️ / ❌
### Web-safe native guards  ✅ / ❌

## What to fix
- [file:line] description of violation
```

Keep the report concise. Only list items that need action — passing items need no explanation.
After reporting, offer to fix each violation if the user confirms.
