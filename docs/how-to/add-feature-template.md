# How to Scaffold a New Feature

> **Diataxis type:** How-to guide — goal-oriented, step-by-step.
> This guide creates the wiring skeleton only. Entities, models, and use cases are
> added separately once the data source shape is known.
> For architecture rationale see `docs/reference/architecture.md`.
> For layer rules and forbidden patterns see `docs/ai-rules/conventions.md`.

---

## Before you begin

- `make setup` has been run at least once
- You know the feature name in two forms — used throughout every step:
  - `{Feature}` — PascalCase class prefix, e.g. `Products`
  - `{feature}` — snake\_case file/folder prefix, e.g. `products`

---

## What you will end up with

```
lib/feature/{feature}/
├── data/
│   ├── data_source/
│   │   ├── {feature}_remote_data_source.dart        empty abstract interface
│   │   └── {feature}_remote_data_source_impl.dart   empty @RestApi() stub
│   ├── models/                                       empty — populate when API shape is known
│   └── repository_impl/
│       └── {feature}_repository_impl.dart           empty, wired to BaseRepository
├── domain/
│   ├── entities/                                     empty — add after models are defined
│   ├── repository/
│   │   └── {feature}_repository.dart                empty abstract interface
│   └── usecase/                                      empty — add after entities are defined
└── presentation/
    ├── bloc/
    │   ├── {feature}_bloc.dart
    │   ├── {feature}_event.dart
    │   └── {feature}_state.dart
    ├── view/
    │   ├── {feature}_page.dart
    │   └── {feature}_screen.dart
    └── widgets/
```

---

## Steps

### 1. Create the folder tree

```bash
mkdir -p lib/feature/{feature}/data/data_source
mkdir -p lib/feature/{feature}/data/models
mkdir -p lib/feature/{feature}/data/repository_impl
mkdir -p lib/feature/{feature}/domain/entities
mkdir -p lib/feature/{feature}/domain/repository
mkdir -p lib/feature/{feature}/domain/usecase
mkdir -p lib/feature/{feature}/presentation/bloc
mkdir -p lib/feature/{feature}/presentation/view
mkdir -p lib/feature/{feature}/presentation/widgets
```

---

### 2. Domain — repository interface

`lib/feature/{feature}/domain/repository/{feature}_repository.dart`

```dart
abstract interface class {Feature}Repository {}
```

Rules:
- `abstract interface class` — not `abstract class`.
- No `dio`, `retrofit`, or Flutter imports here.
- Methods are added here once entities exist. Return type is always `Either<Failure, T>` — never `throw` across layer boundaries.

---

### 3. Data — remote data source

**Interface** — `lib/feature/{feature}/data/data_source/{feature}_remote_data_source.dart`

```dart
abstract interface class {Feature}RemoteDataSource {}
```

**Retrofit implementation** — `lib/feature/{feature}/data/data_source/{feature}_remote_data_source_impl.dart`

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '{feature}_remote_data_source.dart';

part '{feature}_remote_data_source_impl.g.dart';

@RestApi()
abstract class {Feature}RemoteDataSourceImpl implements {Feature}RemoteDataSource {
  factory {Feature}RemoteDataSourceImpl(Dio dio, {String? baseUrl}) =
      _{Feature}RemoteDataSourceImpl;
}
```

Run `make gen` after saving.

---

### 4. Data — repository implementation

`lib/feature/{feature}/data/repository_impl/{feature}_repository_impl.dart`

```dart
import '../../../../core/base/base_repository.dart';
import '../../domain/repository/{feature}_repository.dart';
import '../data_source/{feature}_remote_data_source.dart';

class {Feature}RepositoryImpl with BaseRepository implements {Feature}Repository {
  final {Feature}RemoteDataSource _dataSource;

  const {Feature}RepositoryImpl(this._dataSource);
}
```

Rules:
- Always use `handleRequest()` from `BaseRepository` when adding methods — never write `try/catch` manually.
- Map model fields to entity fields inside `handleRequest`. Never leak `*Model` outside this class.

---

### 5. Presentation — BLoC

Three files. The event and state files are `part of` the bloc file.

**`lib/feature/{feature}/presentation/bloc/{feature}_event.dart`**

```dart
part of '{feature}_bloc.dart';

@freezed
sealed class {Feature}Event with _${Feature}Event {
  const factory {Feature}Event.fetched() = {Feature}Fetched;
}
```

**`lib/feature/{feature}/presentation/bloc/{feature}_state.dart`**

```dart
part of '{feature}_bloc.dart';

@freezed
sealed class {Feature}State with _${Feature}State {
  const factory {Feature}State.initial()                         = {Feature}Initial;
  const factory {Feature}State.loading()                        = {Feature}Loading;
  const factory {Feature}State.loaded()                         = {Feature}Loaded;
  const factory {Feature}State.error({required String message}) = {Feature}Error;
}
```

> Add data fields to `loaded` once the entity is defined, e.g.
> `const factory {Feature}State.loaded({required {Feature}Entity item}) = {Feature}Loaded;`

**`lib/feature/{feature}/presentation/bloc/{feature}_bloc.dart`**

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{feature}_bloc.freezed.dart';
part '{feature}_event.dart';
part '{feature}_state.dart';

class {Feature}Bloc extends Bloc<{Feature}Event, {Feature}State> {
  {Feature}Bloc() : super(const {Feature}State.initial()) {
    on<{Feature}Fetched>(_onFetched);
  }

  Future<void> _onFetched({Feature}Fetched event, Emitter<{Feature}State> emit) async {
    emit(const {Feature}State.loading());
    // TODO: inject use case, call it here, fold the Either result
    emit(const {Feature}State.loaded());
  }
}
```

Run `make gen` after saving.

Rules:
- `sealed class` + `@freezed` on both event and state — compiler enforces exhaustive `switch`.
- One BLoC per feature. Never mix two features in one BLoC.
- Never use `if (state is XState)` — always `switch`.

---

### 6. Presentation — page

`lib/feature/{feature}/presentation/view/{feature}_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_page.dart';
import '../../../../core/constants/value_const.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/ui/atoms/top_bar.dart';
import '../bloc/{feature}_bloc.dart';
import '{feature}_screen.dart';

class {Feature}Page extends BasePage {
  const {Feature}Page({super.key});

  @override
  State<{Feature}Page> createState() => _{Feature}PageState();
}

class _{Feature}PageState extends BasePageState<{Feature}Page> {
  @override
  Widget buildBlocProviders(Widget child) => BlocProvider(
        create: (_) => sl<{Feature}Bloc>(),
        child: child,
      );

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) =>
      AppTopBar.primary(title: ValueConst.{feature}AppBarTitle);

  @override
  Widget buildBody(BuildContext context) => const {Feature}Screen();
}
```

Rules:
- Page is DI + Scaffold only — no business logic, no `BlocBuilder`.
- Extend `BasePage` / `BasePageState`, never `StatefulWidget` / `State` directly.
- Add the app bar title constant to `lib/core/constants/value_const.dart` before referencing it.

For multiple BLoCs on one page use `MultiBlocProvider`:

```dart
@override
Widget buildBlocProviders(Widget child) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<{Feature}Bloc>()),
        BlocProvider(create: (_) => sl<{Feature}SearchBloc>()),
      ],
      child: child,
    );
```

---

### 7. Presentation — screen

`lib/feature/{feature}/presentation/view/{feature}_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_screen.dart';
import '../../../../core/base/bloc/master_bloc.dart';
import '../../../../core/ui/molecules/error_view.dart';
import '../bloc/{feature}_bloc.dart';

class {Feature}Screen extends BaseScreen {
  const {Feature}Screen({super.key});

  @override
  State<{Feature}Screen> createState() => _{Feature}ScreenState();
}

class _{Feature}ScreenState extends BaseScreenState<{Feature}Screen> {
  @override
  Widget body(BuildContext context) {
    return BlocConsumer<{Feature}Bloc, {Feature}State>(
      listener: (context, state) {
        final master = context.read<MasterBloc>();
        switch (state) {
          case {Feature}Loading():
            master.add(ShowLoader());
          case {Feature}Loaded() || {Feature}Error():
            master.add(HideLoader());
          default:
            break;
        }
      },
      builder: (context, state) => switch (state) {
        {Feature}Initial()             => const SizedBox.shrink(),
        {Feature}Loading()             => const SizedBox.shrink(),
        {Feature}Loaded()              => const SizedBox.shrink(), // replace with content widget
        {Feature}Error(:final message) => ErrorView(message: message),
      },
    );
  }
}
```

Rules:
- Screen is UI-only — no DI calls, no `sl<T>()`.
- Extend `BaseScreen` / `BaseScreenState`, never `StatefulWidget` directly.
- Use `showAppBottomSheet()` (inherited from `BaseScreenState`) — never call `AppBottomSheet.show()` directly.
- Use `MasterBloc` overlay for page-blocking operations (auth, form submit). Use inline `LoadingIndicator` for content-area loading.

---

### 8. Wire up DI

Add registrations to `lib/core/di/injection_container.dart` in this exact order:

```dart
// Network — add only if this feature uses a different base URL
sl.registerLazySingleton(
  () => createDioClient(baseUrl: ApiConstants.{feature}BaseUrl),
  instanceName: '{feature}',
);

// Data sources
sl.registerLazySingleton<{Feature}RemoteDataSource>(
  () => {Feature}RemoteDataSourceImpl(sl()),
);

// Repositories
sl.registerLazySingleton<{Feature}Repository>(
  () => {Feature}RepositoryImpl(sl()),
);

// BLoCs — factory gives a fresh instance per page
sl.registerFactory(() => {Feature}Bloc());
```

If the feature shares the existing Dio client, omit the network registration and pass `sl()` directly.
Add use case registrations (`sl.registerLazySingleton(() => Get{Feature}UseCase(sl()))`) and update the BLoC factory once use cases exist.

---

### 9. Add the app bar string constant

`lib/core/constants/value_const.dart` — add one line:

```dart
static const String {feature}AppBarTitle = '{Human readable title}';
```

Never use an inline string literal in the page file.

---

### 10. Run code generation

```bash
make gen
```

This regenerates all `.freezed.dart` and `.g.dart` files. Never edit those files manually.

---

### 11. Verify

```bash
make analyze   # must produce zero issues
make test      # all existing tests must still pass
```

Checklist:
- [ ] `flutter analyze` returns zero issues
- [ ] No `import 'package:dio/...'` or `import 'package:retrofit/...'` in any `domain/` file
- [ ] All `switch` on BLoC state are exhaustive (no `if (state is X)`)
- [ ] Data source, repository, and BLoC registered in `injection_container.dart`
- [ ] App bar title string added to `ValueConst`
- [ ] No hardcoded colours, spacing, or radii in widget files

---

## AI-context notes

> This section is for AI coding agents. Skip if you are a human reader.

**Naming substitution table** — apply consistently across every file and import in this feature:

| Placeholder | Form | Example |
|---|---|---|
| `{Feature}` | PascalCase | `Products` |
| `{feature}` | snake\_case | `products` |
| `{action}` | snake\_case verb | `get_product`, `search_products` |
| `{Action}` | PascalCase verb | `GetProduct`, `SearchProducts` |

**Scaffold scope** — this guide produces only the wiring skeleton. Do NOT create entity files, model files, or use cases during scaffolding. Those are added in a separate step after the API response shape is confirmed.

**Part/part-of relationship** — the three BLoC files share one Freezed compilation unit:
- `{feature}_bloc.dart` declares `part '{feature}_event.dart'` and `part '{feature}_state.dart'`
- `{feature}_event.dart` and `{feature}_state.dart` each begin with `part of '{feature}_bloc.dart'`
- `make gen` generates a single `{feature}_bloc.freezed.dart` covering all three

**Import depth** — all imports use relative paths (`../../../../`), never package-absolute paths like `package:cordelia_base/feature/...`.

**Forbidden patterns to check before finishing:**

```
❌  if (state is {Feature}Loading)          →  use switch
❌  Colors.red / Color(0xFF...)             →  use Theme.of(context).colorScheme.*
❌  EdgeInsets.all(16)                      →  use AppSpacing.*
❌  BorderRadius.circular(8)               →  use AppRadius.*
❌  'Some string'  in a widget file        →  add to ValueConst
❌  throw SomeException()  in repository   →  return left(Failure.*)
❌  DioException  reaching a BLoC          →  caught by BaseRepository.handleRequest
❌  sl<T>()  inside a screen file          →  DI belongs in the page only
❌  manually editing .freezed.dart/.g.dart →  run make gen
```
