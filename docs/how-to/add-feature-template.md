# How to Scaffold a New Feature

> Skeleton only — entities, models, and use cases are added separately once the API shape is known.
> Layer rules and forbidden patterns: `docs/ai-rules/conventions.md`.
> Full architecture reference: `docs/reference/architecture.md`.

`{Feature}` = PascalCase &nbsp;·&nbsp; `{feature}` = snake_case &nbsp;·&nbsp; `{Action}` = PascalCase verb &nbsp;·&nbsp; `{action}` = snake_case verb (e.g. `GetProducts` / `get_products`)

> **Monorepo note:** features live inside an app — `apps/{app}/lib/feature/{feature}/`. An app's primary feature is always `feature/home/`; add a differently-named feature folder only for a genuinely separate area. `core` types come from `package:core/core/…`; app-level `di`/`constants` come from `package:{app}/…`; same-feature files use relative imports. Run all `make` commands from the repo root.

---

## 1. Folder tree

```bash
cd apps/{app}
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

## 2. Domain — repository interface

`apps/{app}/lib/feature/{feature}/domain/repository/{feature}_repository.dart`

```dart
abstract interface class {Feature}Repository {}
```

## 3. Data — remote data source

`{feature}_remote_data_source.dart`
```dart
abstract interface class {Feature}RemoteDataSource {}
```

`{feature}_remote_data_source_impl.dart`
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

## 4. Data — repository impl

`apps/{app}/lib/feature/{feature}/data/repository_impl/{feature}_repository_impl.dart`

```dart
import 'package:core/core/base/base_repository.dart';
import '../../domain/repository/{feature}_repository.dart';
import '../data_source/{feature}_remote_data_source.dart';

class {Feature}RepositoryImpl with BaseRepository implements {Feature}Repository {
  final {Feature}RemoteDataSource _dataSource;
  const {Feature}RepositoryImpl(this._dataSource);
}
```

## 5. Presentation — BLoC

`{feature}_event.dart`
```dart
part of '{feature}_bloc.dart';

@freezed
sealed class {Feature}Event with _${Feature}Event {
  const factory {Feature}Event.started() = {Feature}Started; // auto-dispatched on creation
}
```

`{feature}_state.dart`
```dart
part of '{feature}_bloc.dart';

@freezed
sealed class {Feature}State with _${Feature}State {
  const factory {Feature}State.loading()                        = {Feature}Loading;
  const factory {Feature}State.loaded()                         = {Feature}Loaded;
  const factory {Feature}State.error({required String message}) = {Feature}Error;
}
```

`{feature}_bloc.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{feature}_bloc.freezed.dart';
part '{feature}_event.dart';
part '{feature}_state.dart';

class {Feature}Bloc extends Bloc<{Feature}Event, {Feature}State> {
  {Feature}Bloc() : super(const {Feature}State.loading()) {
    on<{Feature}Started>(_onStarted);
  }

  Future<void> _onStarted({Feature}Started event, Emitter<{Feature}State> emit) async {
    // TODO: inject use case, call it, fold the Either
    emit(const {Feature}State.loaded());
  }
}
```

Run `make gen` after saving.

## 6. Presentation — page

`apps/{app}/lib/feature/{feature}/presentation/view/{feature}_page.dart`
(for the primary feature this is `home_page.dart` → `HomePage`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core/base/base_page.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import 'package:{app}/constants/value_const.dart';
import 'package:{app}/di/injection_container.dart';   // provides `sl`
import '../bloc/{feature}_bloc.dart';
import '{feature}_screen.dart';

class {Feature}Page extends BasePage {
  const {Feature}Page({super.key});
  @override
  State<{Feature}Page> createState() => _{Feature}PageState();
}

class _{Feature}PageState extends BasePageState<{Feature}Page> {
  @override
  PreferredSizeWidget buildAppBar(BuildContext context) =>
      AppTopBar.primary(title: ValueConst.{feature}AppBarTitle);

  // BLoC is scoped to the screen subtree; cascade dispatches started immediately
  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => {Feature}Bloc({action}UseCase: sl())..add(const {Feature}Event.started()),
    child: const {Feature}Screen(),
  );
}
```

> If the AppBar also needs to read the same BLoC (e.g., to show a badge), move the `BlocProvider` up into `buildBlocProviders` instead.

## 7. Presentation — screen

`apps/{app}/lib/feature/{feature}/presentation/view/{feature}_screen.dart`
(for the primary feature this is `home_screen.dart` → `HomeScreen`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/molecules/error_view.dart';
import '../bloc/{feature}_bloc.dart';

class {Feature}Screen extends BaseScreen {
  const {Feature}Screen({super.key});
  @override
  State<{Feature}Screen> createState() => _{Feature}ScreenState();
}

class _{Feature}ScreenState extends BaseScreenState<{Feature}Screen> {
  @override
  Widget body(BuildContext context) {
    return BlocBuilder<{Feature}Bloc, {Feature}State>(
      builder: (context, state) => switch (state) {
        {Feature}Loading()             => const LoadingIndicator(),
        {Feature}Loaded()              => const SizedBox.shrink(), // replace with content
        {Feature}Error(:final message) => ErrorView(message: message),
      },
    );
  }
}
```

> Use `BlocConsumer` (adding a `listener:`) only when you need side effects such as a snackbar or navigation on a specific state transition.

## 8. DI — data source and repository

`apps/{app}/lib/di/injection_container.dart` — inside `initDependencies()` (which calls `initCoreDependencies()` first)

```dart
// Network — only if this feature has a new base URL
sl.registerLazySingleton(
  () => createDioClient(baseUrl: ApiConstants.{feature}BaseUrl),
  instanceName: '{feature}',
);

sl.registerLazySingleton<{Feature}RemoteDataSource>(
  () => {Feature}RemoteDataSourceImpl(sl()),
);
sl.registerLazySingleton<{Feature}Repository>(
  () => {Feature}RepositoryImpl(sl()),
);
```

BLoCs are never registered in GetIt. Use cases are added via `docs/how-to/add-usecase.md`.

## 9. App bar constant

`apps/{app}/lib/constants/value_const.dart` (class `ValueConst` — app-specific copy; never put app strings in core)
```dart
static const String {feature}AppBarTitle = '{Title}';
```
> If you also need a new base URL, add it to `apps/{app}/lib/constants/api_constants.dart` (class `ApiConstants`).

## 10. Verify

```bash
make gen && make analyze
```

- [ ] Zero analysis issues
- [ ] No `dio`/`retrofit` imports in `domain/`
- [ ] Data source and repository registered in the app's `di/injection_container.dart`
- [ ] App bar title in the app's `ValueConst` (not in `core`)

---

## Notes

**Scaffold scope:** Do NOT create entity, model, or use case files — those follow separately via `docs/how-to/add-usecase.md`.

**BLoC part files:** `{feature}_event.dart` and `{feature}_state.dart` begin with `part of '{feature}_bloc.dart'`. The bloc declares `part '{feature}_event.dart'` and `part '{feature}_state.dart'`. One `make gen` covers all three.

**Imports:** `core` types → `package:core/core/…`; app-level `di`/`constants`/`enums` → `package:{app}/…`; same-feature files → relative (`../bloc/…`). Never use the old single-app `package:flutter_agentic/...`.
