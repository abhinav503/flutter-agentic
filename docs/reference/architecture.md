# Architecture

## Stack

| Concern | Choice | Why |
|---|---|---|
| State management | `flutter_bloc` | Explicit event→state transitions; sealed Freezed classes give compiler-enforced exhaustive `switch` |
| Error handling | `fpdart` `Either<Failure, T>` | Compiler rejects callers that ignore `Left`; error paths are visible in every signature |
| Models + BLoC events/states | `freezed` | Immutable value types, `copyWith`, `==`, pattern matching — same package across all layers |
| Networking | `dio` + `retrofit` | Retrofit generates type-safe clients from annotated interfaces; fake the interface in tests |
| Navigation | `go_router` | Declarative, deep-link ready, web-URL capable, Flutter-team maintained |
| DI | `get_it` | Service locator (`sl<T>()`); BLoCs as factories, everything else lazy singletons |
| UI baseline | Material 3 | No component library imposed — bring your own or use the design system atoms in `core/ui/` |

---

## Dependency Rule

**Outer layers depend on inner. Never the reverse.**

```
presentation  →  domain  ←  data
```

- `domain` — zero imports from `flutter`, `flutter_bloc`, `dio`, `retrofit`
- `data` — zero imports from `flutter_bloc` or any UI package
- `presentation` — zero imports from `dio` or `retrofit`

---

## Folder Structure

```
lib/
├── core/                            shared infrastructure, no feature logic
│   ├── base/
│   │   ├── base_page.dart           BasePage + BasePageState (Scaffold + MasterBloc overlay)
│   │   ├── base_page_without_bloc.dart
│   │   ├── base_repository.dart     BaseRepository mixin (Dio→Failure mapping)
│   │   ├── base_screen.dart         BaseScreen + BaseScreenState (showAppBottomSheet, showSnackBar)
│   │   └── bloc/
│   │       ├── master_bloc.dart     ShowLoader / HideLoader → page-level overlay
│   │       ├── master_event.dart
│   │       └── master_state.dart
│   ├── constants/
│   │   ├── api_constants.dart       base URLs, endpoint paths
│   │   └── value_const.dart         ALL string/value constants — no inline literals anywhere
│   ├── di/
│   │   └── injection_container.dart full dependency graph; call initDependencies() in main()
│   ├── error/
│   │   └── failure.dart             sealed Failure class; add variants only here
│   ├── network/
│   │   └── api_client.dart          createDioClient() factory
│   ├── theme/
│   │   ├── app_colors_extension.dart  ThemeExtension for success/warning colours
│   │   ├── app_radius.dart            border-radius token scale
│   │   ├── app_spacing.dart           spacing token scale
│   │   ├── app_theme.dart             AppTheme.light() / .dark() / .fromConfig()
│   │   └── app_theme_config.dart      parses assets/theme/theme_config.json
│   ├── ui/
│   │   ├── atoms/                   single-responsibility widgets, no BLoC reads
│   │   │   ├── badge.dart           AppBadge
│   │   │   ├── button.dart          AppButton
│   │   │   ├── chip.dart            AppChip
│   │   │   ├── loading_indicator.dart
│   │   │   ├── text_field.dart      AppTextField
│   │   │   └── top_bar.dart         AppTopBar (primary / secondary named constructors)
│   │   └── molecules/               composed atoms
│   │       ├── bottom_sheet.dart    AppBottomSheet (static show())
│   │       └── error_view.dart      ErrorView
│   └── usecase/
│       └── usecase.dart             UseCase<Output, Param> base; NoParams
└── feature/
    └── {name}/
        ├── data/
        │   ├── data_source/
        │   │   ├── {name}_remote_data_source.dart         abstract interface
        │   │   ├── {name}_remote_data_source_impl.dart    @RestApi() Retrofit impl
        │   │   └── {name}_remote_data_source_impl.g.dart  generated
        │   ├── models/
        │   │   ├── {name}_model.dart          @freezed + @JsonSerializable DTO
        │   │   ├── {name}_model.freezed.dart  generated
        │   │   └── {name}_model.g.dart        generated
        │   └── repository_impl/
        │       └── {name}_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── {name}_entity.dart    plain Dart, no annotations, suffix *Entity
        │   ├── repository/
        │   │   └── {name}_repository.dart  abstract interface
        │   └── usecase/
        │       └── {action}_usecase.dart
        └── presentation/
            ├── bloc/
            │   ├── {name}_bloc.dart    event handlers, part declarations
            │   ├── {name}_event.dart   @freezed sealed class, part of bloc file
            │   └── {name}_state.dart   @freezed sealed class, part of bloc file
            ├── view/
            │   ├── {name}_page.dart    DI + Scaffold (extends BasePage)
            │   └── {name}_screen.dart  UI only (extends BaseScreen)
            └── widgets/
                └── {name}_*.dart       feature-local reusable widgets
```

---

## Naming Conventions

| Artifact | File name | Class name | Example |
|---|---|---|---|
| Entity | `{concept}_entity.dart` | `{Concept}Entity` | `joke_entity.dart` → `JokeEntity` |
| Model (DTO) | `{concept}_model.dart` | `{Concept}Model` | `joke_model.dart` → `JokeModel` |
| Repository interface | `{feature}_repository.dart` | `{Feature}Repository` | `JokesRepository` |
| Repository impl | `{feature}_repository_impl.dart` | `{Feature}RepositoryImpl` | `JokesRepositoryImpl` |
| Data source interface | `{feature}_remote_data_source.dart` | `{Feature}RemoteDataSource` | `JokesRemoteDataSource` |
| Data source impl | `{feature}_remote_data_source_impl.dart` | `{Feature}RemoteDataSourceImpl` | `JokesRemoteDataSourceImpl` |
| Use case | `{action}_usecase.dart` | `{Action}UseCase` | `GetRandomJokeUseCase` |
| Use case params | — (same file) | `{Action}Params` | `SearchJokesParams` |
| BLoC | `{feature}_bloc.dart` | `{Feature}Bloc` | `JokeBloc` |
| Page | `{feature}_page.dart` | `{Feature}Page` | `JokesPage` |
| Screen | `{feature}_screen.dart` | `{Feature}Screen` | `JokesScreen` |
| Widget | `{feature}_{description}.dart` | `{Feature}{Description}` | `joke_card.dart` → `JokeCard` |

---

## Layer Implementation Patterns

### Entity
```dart
// domain/entities/joke_entity.dart
class JokeEntity {
  final String id;
  final String content;
  const JokeEntity({required this.id, required this.content});
}
```

### Model (DTO)
```dart
// data/models/joke_model.dart
@freezed
abstract class JokeModel with _$JokeModel {
  const factory JokeModel({
    required String id,
    required String joke,       // JSON key matches field name
    required int status,
  }) = _JokeModel;
  factory JokeModel.fromJson(Map<String, dynamic> json) => _$JokeModelFromJson(json);
}
// Use @JsonKey(name: 'snake_key') for any key that doesn't match camelCase
```

### Data Source
```dart
// abstract interface
abstract interface class JokesRemoteDataSource {
  Future<JokeModel> getRandomJoke();
}

// Retrofit impl
@RestApi()
abstract class JokesRemoteDataSourceImpl implements JokesRemoteDataSource {
  factory JokesRemoteDataSourceImpl(Dio dio, {String? baseUrl}) = _JokesRemoteDataSourceImpl;

  @override
  @GET('/')
  Future<JokeModel> getRandomJoke();

  @override
  @GET('/search')
  Future<JokeSearchResponseModel> searchJokes({
    @Query('term')  required String term,
    @Query('page')  required int page,
    @Query('limit') int limit = 20,
  });
}
```

### Repository Implementation
```dart
// with BaseRepository — never write try/catch manually
class JokesRepositoryImpl with BaseRepository implements JokesRepository {
  final JokesRemoteDataSource _dataSource;
  const JokesRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, JokeEntity>> getRandomJoke() =>
      handleRequest(() async {
        final model = await _dataSource.getRandomJoke();
        return right(JokeEntity(id: model.id, content: model.joke));
      });
}
```

### Use Case
```dart
class GetRandomJokeUseCase extends UseCase<Either<Failure, JokeEntity>, NoParams> {
  final JokesRepository _repository;
  const GetRandomJokeUseCase(this._repository);

  @override
  Future<Either<Failure, JokeEntity>> call(NoParams params) =>
      _repository.getRandomJoke();
}
```

### BLoC
```dart
// event (part file)
@freezed
sealed class JokeEvent with _$JokeEvent {
  const factory JokeEvent.fetched() = JokeFetched;
}

// state (part file)
@freezed
sealed class JokeState with _$JokeState {
  const factory JokeState.initial()                           = JokeInitial;
  const factory JokeState.loading()                          = JokeLoading;
  const factory JokeState.loaded({required JokeEntity joke}) = JokeLoaded;
  const factory JokeState.error({required String message})   = JokeError;
}

// bloc
class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final GetRandomJokeUseCase _getRandomJoke;

  JokeBloc(this._getRandomJoke) : super(const JokeState.initial()) {
    on<JokeFetched>(_onFetched);
  }

  Future<void> _onFetched(JokeFetched event, Emitter<JokeState> emit) async {
    emit(const JokeState.loading());
    final result = await _getRandomJoke(const NoParams());
    result.fold(
      (failure) => emit(JokeState.error(message: failure.message)),
      (joke)    => emit(JokeState.loaded(joke: joke)),
    );
  }
}
```

### Page + Screen
```dart
// page — DI only
class _JokesPageState extends BasePageState<JokesPage> {
  @override
  Widget buildBlocProviders(Widget child) => BlocProvider(
    create: (_) => sl<JokeBloc>(), child: child);

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) =>
      AppTopBar.primary(title: ValueConst.jokeAppBarTitle);

  @override
  Widget buildBody(BuildContext context) => const JokesScreen();
}

// screen — UI only
class _JokesScreenState extends BaseScreenState<JokesScreen> {
  @override
  Widget body(BuildContext context) {
    return BlocConsumer<JokeBloc, JokeState>(
      listener: (context, state) {
        final master = context.read<MasterBloc>();
        switch (state) {
          case JokeLoading():              master.add(ShowLoader());
          case JokeLoaded() || JokeError(): master.add(HideLoader());
          default: break;
        }
      },
      builder: (context, state) => switch (state) {
        JokeInitial()             => const JokeEmptyState(),
        JokeLoading()             => const SizedBox.shrink(),
        JokeLoaded(:final joke)   => JokeCard(joke: joke),
        JokeError(:final message) => ErrorView(message: message),
      },
    );
  }
}
```

---

## Dependency Injection

Registration order inside `initDependencies()`:

```dart
// 1. Network
sl.registerLazySingleton(() => createDioClient(baseUrl: ApiConstants.jokesBaseUrl));

// 2. Data sources
sl.registerLazySingleton<JokesRemoteDataSource>(() => JokesRemoteDataSourceImpl(sl()));

// 3. Repositories
sl.registerLazySingleton<JokesRepository>(() => JokesRepositoryImpl(sl()));

// 4. Use cases
sl.registerLazySingleton(() => GetRandomJokeUseCase(sl()));

// 5. BLoCs — factory gives a fresh instance per page
sl.registerFactory(() => JokeBloc(sl()));
```

---

## Error Flow

```
data source throws DioException
  ↓ BaseRepository.handleRequest() catches it
  ↓ returns Left(Failure.network(...))  or  Left(Failure.server(statusCode, ...))

use case returns Either<Failure, T> unchanged

BLoC folds the Either:
  right(entity) → emit(XState.loaded(...))
  left(failure) → emit(XState.error(message: failure.message))
```

Never `throw` across layer boundaries. Never let `DioException` reach a BLoC or widget.

---

## UI Design System

### Atomic hierarchy
- **atoms** — single widget, no BLoC reads: `AppButton`, `AppTextField`, `AppBadge`, `AppChip`, `AppTopBar`, `LoadingIndicator`
- **molecules** — composed atoms, may read BLoC via context: `AppBottomSheet`, `ErrorView`
- **feature/widgets** — feature-local, may read that feature's BLoC

### Colours — never hardcode
```dart
// ✅
Theme.of(context).colorScheme.primary
Theme.of(context).extension<AppColorsExtension>()!.successContainer
colorScheme.scrim.withValues(alpha: 0.33)   // overlay / scrim

// ❌
Color(0xFF186752)
Colors.red
Colors.black54
```

### Text styles — never hardcode
```dart
// ✅
Theme.of(context).textTheme.bodyLarge!.copyWith(color: cs.onSurface)

// ❌
TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
```

### Spacing + radius — use tokens
```dart
// ✅
AppSpacing.lg          // 16
AppRadius.md           // BorderRadius.all(Radius.circular(8))
AppRadius.mdValue      // 8 (double)

// ❌
EdgeInsets.all(16)
BorderRadius.circular(8)
```

### Strings — use ValueConst
```dart
// ✅  (lib/core/constants/value_const.dart)
ValueConst.jokeAppBarTitle
ValueConst.jokeResultsCount(state.totalJokes)   // dynamic → static method

// ❌
'Dad Jokes'
'Load More'
```

### MasterBloc — page-level overlay
`BasePage` renders a scrim + spinner over the entire page when `MasterBloc` emits `MasterLoading`.
Use it for operations that lock the whole page (auth, form submit).
Use inline `LoadingIndicator` for list/content loading — not the overlay.

### Theme configuration
Colours and font set in `assets/theme/theme_config.json`.
Change `activeTheme` to switch between `dadJokes`, `oceanBreeze`, `forestWalk` presets.
Individual colour roles can be overridden by key — all others are seed-generated by M3.

---

## Testing

| Subject | Location | Tool |
|---|---|---|
| Use case | `test/unit/feature/{name}/domain/` | `flutter_test` |
| BLoC | `test/unit/feature/{name}/presentation/` | `bloc_test` |
| Screen/page | `test/widget/feature/{name}/` | `flutter_test` + `MockBloc` |
| Shared fakes | `test/helpers/` | manual fake implements interface |

Rules:
- Manual fakes only — no `mockito`, no `mocktail`
- Fake exposes a `result` field set per test
- Widget tests use `BlocProvider.value(value: mockBloc, child: MaterialApp(home: Screen()))`
- Use `bloc_test` `MockBloc` for widget tests — never wire real BLoCs
