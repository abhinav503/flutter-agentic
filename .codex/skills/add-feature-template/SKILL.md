---
name: add-feature-template
description: >
  Scaffold the wiring skeleton for a new Flutter feature: folder tree, empty
  repository interface, empty data source, empty repository impl, BLoC with
  sealed states, page, screen, and DI registration.
  Invoke with $add-feature-template <feature_name>.
---

If the feature name was not passed as an argument, ask:
"What is the feature name? (e.g. `products`, `auth`, `settings`)"

- `{Feature}` = PascalCase · `{feature}` = snake_case
- `{Action}` = PascalCase verb · `{action}` = snake_case verb (e.g. `GetProducts` / `get_products`)

Scaffold only — do NOT create entity, model, or use case files.
BLoCs are never registered in GetIt.
All imports are relative (`../../../../`), never `package:flutter_agentic/...`.
Run `make gen` and `make analyze` at the end before reporting done.

---

## 1. Folder tree

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

## 2. Domain — repository interface

`lib/feature/{feature}/domain/repository/{feature}_repository.dart`
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

## 6. Presentation — page

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
  PreferredSizeWidget buildAppBar(BuildContext context) =>
      AppTopBar.primary(title: ValueConst.{feature}AppBarTitle);

  // BLoC scoped to the screen subtree; cascade dispatches started immediately
  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => {Feature}Bloc({action}UseCase: sl())..add(const {Feature}Event.started()),
    child: const {Feature}Screen(),
  );
}
```

## 7. Presentation — screen

`lib/feature/{feature}/presentation/view/{feature}_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/base/base_screen.dart';
import '../../../../core/ui/atoms/loading_indicator.dart';
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

## 8. DI

`lib/core/di/injection_container.dart`
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

## 9. App bar constant

`lib/core/constants/value_const.dart`
```dart
static const String {feature}AppBarTitle = '{Title}';
```

## 10. Verify

```bash
make gen && make analyze
```

- [ ] Zero analysis issues
- [ ] No `dio`/`retrofit` imports in `domain/`
- [ ] Data source and repository registered in `injection_container.dart`
- [ ] App bar title in `ValueConst`
- [ ] No hardcoded colours (`Color(...)`), spacing (`EdgeInsets.all(...)`), or radii
- [ ] All BLoC state `switch` are exhaustive — never `if (state is X)`
