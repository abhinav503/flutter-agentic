# Architecture

## Monorepo Layout

This repo is a **Dart pub-workspace monorepo**: one shared `core` package consumed by many Flutter apps. Editing `packages/core` is picked up live by any running app — no republish, one `flutter pub get` at the root resolves everything.

```
flutter_agentic/
├── pubspec.yaml                 workspace root (lists members; no app code)
├── melos.yaml                   optional task runner (see Makefile for the no-melos path)
├── packages/
│   └── core/                    shared package  →  import 'package:core/core/…'
└── apps/
    ├── jokes/                   demo app
    ├── doc_scanner/             real app — request/response reference (image → JSON)
    ├── ai_chat/                 real app — streaming reference (SSE token streaming)
    └── ecommerce/
        └── gravia/              real app — style-pack exemplar (`gravia` theme, ecommerce
                                  blocks, generated free-pack screens: splash, onboarding,
                                  app logo)
```

- **`packages/core`** — the shared mobile toolbelt: base classes, design system, networking, DI seed, generic device services. Zero app-specific copy, feature logic, or product API URLs. Imported everywhere as `package:core/core/…`.
- **`apps/<app>`** — a runnable Flutter app: its own `main.dart`, `app.dart`, `di/`, `constants/`, `feature/`, native folders, and `assets/theme/`. Each app depends on `core` (and only the extra packages its own code imports — see `docs/ai-rules/conventions.md`).
- Every member declares `resolution: workspace`; the root `pubspec.yaml` lists them under `workspace:`.

**Adding a new app:** scaffold native folders (`flutter create`), add `core` as a `path:` dependency with `resolution: workspace`, register it in the root `workspace:` list, and add `run-<app>` to the `Makefile`. The primary feature folder is always `feature/home/` (see Folder Structure).

---

## Stack

| Concern | Choice | Why |
|---|---|---|
| State management | `flutter_bloc` | Explicit event→state transitions; sealed Freezed classes give compiler-enforced exhaustive `switch` |
| Error handling | `fpdart` `Either<Failure, T>` | Compiler rejects callers that ignore `Left`; error paths are visible in every signature |
| Models + BLoC events/states | `freezed` | Immutable value types, `copyWith`, `==`, pattern matching — same package across all layers |
| Networking | `dio` via `HttpService` | Static singleton owns one `Dio` instance; data sources call `HttpService.instance.get/post/put/delete` with full URLs (`postStream` for SSE/token streaming) |
| Navigation | `go_router` | Declarative, deep-link ready, web-URL capable, Flutter-team maintained |
| DI | `get_it` | Shared `sl` lives in `core`; BLoCs as factories, everything else lazy singletons |
| UI baseline | Material 3 | No component library imposed — use the design system atoms in `package:core/core/ui/` |

---

## Dependency Rule

**Outer layers depend on inner. Never the reverse.**

```
presentation  →  domain  ←  data
```

- `domain` — zero imports from `flutter`, `flutter_bloc`, `dio`
- `data` — zero imports from `flutter_bloc` or any UI package
- `presentation` — zero imports from `dio`

Across packages: **`apps/*` depend on `core`; `core` never imports an app.** Shared mechanism goes down into `core`; product copy, feature logic, and product API URLs stay up in the app.

---

## Folder Structure

### Shared package — `packages/core/lib/core/`

```
core/
├── base/
│   ├── base_page.dart           BasePage + BasePageState (Scaffold + getter-based bottom nav)
│   ├── base_repository.dart     BaseRepository mixin (Dio→Failure mapping; handleRequest + handleStream)
│   ├── base_screen.dart         BaseScreen + BaseScreenState (showAppBottomSheet, showSnackBar)
│   └── bloc_cache.dart          BlocCache<T> — warm-start cache a frequently-revisited
│                                 screen's BLoC seeds its initial state from
│                                 (see docs/how-to/design-tab-flow.md)
├── constants/
│   └── core_const.dart          CoreConst — ONLY generic constants core's own code uses
│                                (e.g. retryButton, imagePicker* config). No app copy here.
├── di/
│   └── core_injection.dart      shared `sl` (GetIt) + initCoreDependencies()
├── error/
│   └── failure.dart             sealed Failure class; add variants only here
├── extensions/
│   └── string_extensions.dart   generic String helpers (isSvgUrl) + FieldValidationX
│                                 predicates (isValidEmail, digitCount)
├── mixins/
│   └── textfield_validations.dart  TextfieldValidations — validate* methods returning
│                                 user-facing messages (defaults in CoreConst; override
│                                 a method for custom copy)
├── network/
│   ├── http_service.dart        HttpService static singleton (get/post/put/delete/postStream via single Dio)
│   └── interceptors/            logging and other Dio interceptors
├── services/
│   ├── image_picker/
│   │   └── image_picker_service.dart  ImagePickerService static singleton (shared device util)
│   └── shared_pref_service/
│       └── shared_preference_service.dart  SharedPreferenceService static singleton
├── theme/
│   ├── app_colors_extension.dart  ThemeExtension for success/warning colours,
│   │                               onOverlay, and per-preset theme data
│   │                               (dockedHairline/sheetHairline/tintedPrimaryFill)
│   ├── app_shapes_extension.dart  ThemeExtension for brand radii (button/chip/card/input/sheet)
│   ├── app_radius.dart            border-radius token scale (defaults behind AppShapes)
│   ├── app_spacing.dart           spacing token scale
│   ├── app_theme.dart             AppTheme.fromConfig() → ColorScheme + component themes + extensions
│   ├── app_theme_config.dart      parses theme_config.json (colours + shape + density)
│   ├── app_theme_presets.dart     named palettes (dadJokes, oceanBreeze, forestWalk, rocketWarm)
│   ├── theme_mode_controller.dart ThemeModeController — persisted ValueNotifier<ThemeMode>
│   └── theme_mode_scope.dart      InheritedWidget exposing the controller to the AppBar toggle
├── ui/                          new atom/molecule/block → add a matching
│                                 apps/design_gallery (Widgetbook) showcase entry
│                                 in the same commit, per docs/ai-rules/design.md §1
│   ├── atoms/                   single-responsibility widgets, no BLoC reads
│   │   ├── badge.dart           AppBadge
│   │   ├── button.dart          AppButton
│   │   ├── checkbox.dart        AppCheckbox
│   │   ├── chip.dart            AppChip
│   │   ├── device_frame.dart    DeviceFrame (decorative phone bezel — notch + side
│   │   │                        buttons — for framing a screenshot/image)
│   │   ├── dropdown_menu.dart   AppDropdownMenu (themed PopupMenuButton + AppDropdownItem)
│   │   ├── file_thumbnail.dart  AppFileThumbnail (local image file thumbnail, rounded)
│   │   ├── icon_button.dart     AppIconButton (icon-only circular action; filled / translucent)
│   │   ├── loading_dots.dart    LoadingDots (pulsing "working…" dots)
│   │   ├── loading_indicator.dart
│   │   ├── network_image.dart   AppNetworkImage (built-in loading/error states;
│   │   │                        `.placeholder()` factory for seeded stock photos)
│   │   ├── page_indicator.dart  PageIndicator (dot row for paged flows — onboarding,
│   │   │                        carousels)
│   │   ├── text_field.dart      AppTextField (`dense` for compact rows)
│   │   ├── theme_mode_toggle.dart ThemeModeToggle (System/Light/Dark AppBar action)
│   │   └── top_bar.dart         AppTopBar (primary / secondary named constructors)
│   ├── molecules/               composed atoms
│   │   ├── bottom_sheet.dart    AppBottomSheet (static show())
│   │   ├── dialog.dart          AppDialog (static show())
│   │   ├── empty_state.dart     EmptyState (icon + title + subtitle + actions)
│   │   ├── error_view.dart      ErrorView
│   │   ├── menu_tile.dart       AppMenuTile (settings/profile row: icon circle +
│   │   │                        label + chevron/trailing; danger variant)
│   │   └── radio_group.dart     AppRadioGroup<T> + AppRadioRow (single-select list)
│   └── blocks/                  larger domain compositions (root = cross-domain,
│                                 `blocks/<category>/` = domain-specific data, e.g.
│                                 `ecommerce/`); indexed in `docs/ai-rules/design.md`
│                                 §1, not duplicated here — check that doc, not just
│                                 this tree, before hand-rolling a screen composition
└── usecase/
    └── usecase.dart             UseCase (Future) + StreamUseCase (Stream); NoParams
```

### App — `apps/<app>/lib/`

```
lib/
├── main.dart                    bootstraps theme + initDependencies(), runApp(App())
├── app.dart                     MaterialApp.router + GoRouter (routes to HomePage)
├── constants/
│   ├── api_constants.dart       ApiConstants — this app's base URLs / endpoint paths
│   └── value_const.dart         ValueConst — ALL of this app's strings; no inline literals
├── di/
│   └── injection_container.dart initDependencies(): calls initCoreDependencies(), then
│                                registers this app's data sources / repos / use cases.
│                                Re-exports `sl` from core for convenience.
├── enums/                       app-level shared enums (e.g. extraction_status.dart)
└── feature/
    └── home/                    the app's primary feature (always named `home`)
        ├── data/
        │   ├── data_source/
        │   │   ├── {name}_remote_data_source.dart         abstract interface
        │   │   └── {name}_remote_data_source_impl.dart    concrete impl; calls HttpService.instance
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
            │   ├── home_page.dart      DI + Scaffold (extends BasePage) → HomePage
            │   └── home_screen.dart    UI only (extends BaseScreen) → HomeScreen
            └── widgets/
                └── {name}_*.dart       feature-local reusable widgets
```

**Import rules of thumb:**
- Anything in `core` → `import 'package:core/core/…'`.
- Same-feature files → relative imports (`../domain/…`).
- App-level shared (`di`, `constants`, `enums`) from a feature → `package:<app>/…` import.

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
| Entry page | `home_page.dart` | `HomePage` | the app's primary feature page |
| Entry screen | `home_screen.dart` | `HomeScreen` | the app's primary feature screen |
| Widget | `{feature}_{description}.dart` | `{Feature}{Description}` | `joke_card.dart` → `JokeCard` |

> The feature **folder** and its **entry page/screen** are always `home` / `HomePage` / `HomeScreen`. Domain and data symbols keep their real concept names (`JokeEntity`, `ScannedReceiptEntity`, `JokesRepository`, `DocScannerBloc`) — they are not renamed to "home".

> **Case that can arise — bottom-nav tabbed apps.** For a single-feature app the entry point and the primary feature are the same thing, so `HomePage`/`HomeScreen` covers both. A tabbed app (bottom nav across several tabs) splits them: the route target is a **nav shell** (owns AppBar + BottomNavBar + tab switching, no domain/data layers of its own) and `feature/home/` is just the first tab's real feature. `apps/ecommerce/gravia` hit this and resolved it — per user instruction, not a pre-baked rule — as `feature/shell/` (`ShellPage`/`ShellScreen`) for the nav host, keeping `feature/home/` for the actual home-tab feature. Treat this as a case to recognize and confirm with the user when a spec implies tabs, not as a rule to auto-apply. That structural split is only half of designing a tab — because the nav shell rebuilds each tab's `BlocProvider` fresh on every switch (see its `buildBody`), a tab's own BLoC also needs the warm-start caching pattern in `docs/how-to/design-tab-flow.md` so revisiting an already-loaded tab doesn't re-run the full loading state.

---

## Dart Conventions

### Add behaviour with extensions, not bloated declarations

When a type needs helper methods or computed values, attach them with a Dart `extension` rather than inflating the type's own declaration. This keeps the type a clean data declaration and groups the behaviour where it reads naturally.

**Enums stay as bare value lists; behaviour lives in an extension.** Declare the enum as a plain list of cases, then add any mapping/label/parsing in an `extension on` it. Never grow an enhanced enum with fields and a body just to hold a `switch`.

```dart
// enums/extraction_status.dart — the enum is only the cases
enum ExtractionStatus { pending, processing, completed, failed }

// keep the extension beside the enum (same file)
extension ExtractionStatusX on ExtractionStatus {
  bool get isTerminal =>
      this == ExtractionStatus.completed || this == ExtractionStatus.failed;

  // enum → wire/string (Dart gives `.name` for free; wrap only when the
  // external value differs from the Dart case name)
  String get apiValue => switch (this) {
        ExtractionStatus.pending    => 'PENDING',
        ExtractionStatus.processing => 'IN_PROGRESS',
        ExtractionStatus.completed  => 'DONE',
        ExtractionStatus.failed     => 'ERROR',
      };
}

// string → enum: a static helper on the extension (tolerates unknown values)
extension ExtractionStatusParse on String {
  ExtractionStatus toExtractionStatus() => switch (this) {
        'IN_PROGRESS' => ExtractionStatus.processing,
        'DONE'        => ExtractionStatus.completed,
        'ERROR'       => ExtractionStatus.failed,
        _             => ExtractionStatus.pending, // safe default
      };
}
```

**Reach for `String`/`num`/`DateTime` extensions instead of free-function utils or inline logic.** A repeated `String` transform (formatting, validation, parsing to an enum) belongs in an `extension on String`, not a `StringUtils.foo(s)` helper class and not copy-pasted inline.

**Where the extension lives:**
- An enum's own helpers → **same file as the enum** (`lib/enums/` for app-shared enums, or beside a feature-local enum).
- A generic `String`/`num`/`DateTime` extension used across a package → a `…_extensions.dart` file in that package (`core` if every app needs it, otherwise the app).

**Only add the extension when there's a real caller.** Don't pre-emptively write `toX()`/`fromString()` for an enum that never crosses a string boundary — that's dead API. Enums used purely in-memory (chosen in the UI, matched with an exhaustive `switch`) need **no** conversion extension at all. When a value genuinely arrives as a string from the wire, parse it at the **data layer** (in the `*Model`), not in the UI.

---

## Layer Implementation Patterns

> Imports are omitted for brevity. In real files, `core` types (`HttpService`, `Failure`, `UseCase`, `BasePage`…) come from `package:core/core/…`; `ApiConstants`/`ValueConst` come from the app's own `package:<app>/constants/…`.

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

Every `*Model` must expose two conversion methods:
- `Model.fromEntity(entity)` — factory constructor; data layer imports domain, which is allowed
- `model.toEntity()` — instance method returning the domain entity

Domain entities must **not** import models (dependency rule). Add `const ClassName._()` private constructor to the freezed class to unlock instance methods. Repository impls call these instead of writing field-by-field construction inline. Business-logic transforms (e.g. status normalization on load) stay in the repository, not in the model methods.

```dart
// data/models/joke_model.dart
@freezed
abstract class JokeModel with _$JokeModel {
  const JokeModel._();

  const factory JokeModel({
    required String id,
    required String joke,       // JSON key matches field name
    required int status,
  }) = _JokeModel;

  factory JokeModel.fromJson(Map<String, dynamic> json) => _$JokeModelFromJson(json);
  // Use @JsonKey(name: 'snake_key') for any key that doesn't match camelCase

  factory JokeModel.fromEntity(JokeEntity e) =>
      JokeModel(id: e.id, joke: e.content, status: 200);

  JokeEntity toEntity() => JokeEntity(id: id, content: joke);
}
```

### Data Source
```dart
// abstract interface
abstract interface class JokesRemoteDataSource {
  Future<JokeModel> getRandomJoke();
}

// impl — const no-arg constructor; reaches network via HttpService.instance (from core)
class JokesRemoteDataSourceImpl implements JokesRemoteDataSource {
  const JokesRemoteDataSourceImpl();

  @override
  Future<JokeModel> getRandomJoke() async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      '${ApiConstants.jokesBaseUrl}/',   // ApiConstants from package:<app>/constants/
    );
    return JokeModel.fromJson(response.data!);
  }
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
        return right(model.toEntity()); // ✅ use toEntity(), not field-by-field construction
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
  const factory JokeEvent.started() = JokeStarted; // triggers first fetch
}

// state (part file) — cover every observable state; no "initial" needed when auto-fetching
@freezed
sealed class JokeState with _$JokeState {
  const factory JokeState.loading()                          = JokeLoading;
  const factory JokeState.loaded({required JokeEntity joke}) = JokeLoaded;
  const factory JokeState.error({required String message})   = JokeError;
}

// bloc — starts in loading; dispatches started via cascade on creation
class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final GetRandomJokeUseCase _getRandomJoke;

  JokeBloc({required GetRandomJokeUseCase getRandomJokeUseCase})
      : _getRandomJoke = getRandomJokeUseCase,
        super(const JokeState.loading()) {
    on<JokeStarted>(_onStarted);
  }

  Future<void> _onStarted(JokeStarted event, Emitter<JokeState> emit) async {
    final result = await _getRandomJoke(const NoParams());
    result.fold(
      (failure) => emit(JokeState.error(message: failure.message)),
      (joke)    => emit(JokeState.loaded(joke: joke)),
    );
  }
}
```

**Error states must carry retry context.** Every `*Error` state should include the inputs the BLoC needs to re-run the operation. This avoids the forbidden `if (state is PreviousState)` pattern in screens:

```dart
// ✅ — error carries searchTerm; screen retries cleanly
const factory SearchPageState.error({
  required String message,
  required String searchTerm,  // enough to re-dispatch
}) = SearchPageError;

// in screen:
SearchPageError(:final message, :final searchTerm) => ErrorView(
  message: message,
  onRetry: () => context.read<SearchPageBloc>()
      .add(SearchPageEvent.submitted(term: searchTerm)),
),

// ❌ — screen reads prior state to recover inputs
onRetry: () {
  final s = bloc.state;
  if (s is SearchPageLoaded) ...  // forbidden is-check
},
```

**When multiple events share logic**, factor it into a private `_doWork()` method rather than calling `add()` from within a handler:
```dart
Future<void> _onEventA(EventA event, Emitter<State> emit) async => _doWork(event.term, emit);
Future<void> _onEventB(EventB event, Emitter<State> emit) async => _doWork(event.term, emit);

Future<void> _doWork(String term, Emitter<State> emit) async { ... }
```

**Cubit for shared in-memory state** — no Freezed needed for simple list state:
```dart
class KeptJokesCubit extends Cubit<List<JokeEntity>> {
  KeptJokesCubit() : super([]);
  void keep(JokeEntity joke) {
    if (!state.any((j) => j.id == joke.id)) emit([...state, joke]);
  }
  void remove(String id) => emit(state.where((j) => j.id != id).toList());
}
```

### Page + Screen

**BLoC scoping rule:**
- `buildBlocProviders` — only for state shared across multiple screens or read by the AppBar. Typically a `Cubit`.
- `buildBody` — wrap each screen in its own `BlocProvider`. The BLoC lifetime is tied to that screen's subtree.

> This is also why a nav shell (see the tabbed-apps case above) doesn't get its own BLoC by default — which tab is selected is UI-local state (`setState`), not shared info. Only add a `Cubit` in the shell's `buildBlocProviders` once a real piece of info needs to be shared/read across multiple tabs/pages (e.g. a cart-count badge read by both the AppBar and the Orders tab), and name it for that concern (`CartBadgeCubit`) — never a catch-all shell state container.

```dart
// home_page.dart — shared cubit in buildBlocProviders; screen-specific BLoC in buildBody
class _HomePageState extends BasePageState<HomePage> {
  @override
  Widget buildBlocProviders(Widget child) => BlocProvider(
    create: (_) => KeptJokesCubit(), child: child); // read by AppBar + screen

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) =>
      AppTopBar.primary(title: ValueConst.jokeAppBarTitle); // ValueConst from package:<app>/constants/

  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    // cascade auto-dispatches started so the screen begins loading immediately
    create: (_) => JokeBloc(getRandomJokeUseCase: sl())..add(const JokeEvent.started()),
    child: const HomeScreen(),
  );
}

// home_screen.dart — pure switch(state) builder; no setState for BLoC-derived values
class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  Widget body(BuildContext context) {
    return BlocConsumer<JokeBloc, JokeState>(
      // listener: side effects only (snackbars, navigation)
      listener: (context, state) {
        if (state case JokeError(:final message)) showSnackBar(message);
      },
      builder: (context, state) => switch (state) {
        JokeLoading()             => const LoadingIndicator(),
        JokeLoaded(:final joke)   => JokeCard(joke: joke),
        JokeError(:final message) => ErrorView(message: message),
      },
    );
  }
}
```

> For a single-screen page where the AppBar also needs to read the BLoC, putting it in `buildBlocProviders` is fine. The rule is: scope as tightly as the consumers require.

**Bottom navigation** — override only the getters you need; `BasePage` renders the bar automatically:
```dart
@override bool get showBottomNav => true;
@override List<BottomNavigationBarItem> get bottomNavItems => const [...];
@override int get selectedNavIndex => _currentTab;
@override void onNavItemTapped(int index) => setState(() => _currentTab = index);
```

---

## Infrastructure Services

Infrastructure with async init (`SharedPreferenceService`), a shared resource (`HttpService`), or a shared device capability (`ImagePickerService`) uses the **static singleton** pattern — one class file, private constructor, `static final instance`. They live in `core` and are **never registered in GetIt** — any class with a `static final instance` field follows this rule.

```dart
// HttpService — synchronous; Dio is created at class load time
class HttpService {
  HttpService._();
  static final HttpService instance = HttpService._();
  static final Dio _dio = Dio(BaseOptions(...))..interceptors.add(LoggingInterceptor());

  Future<Response<T>> get<T>(String url, {...}) => _dio.get(...);
  Future<Response<T>> post<T>(String url, {...}) => _dio.post(...);
}

// SharedPreferenceService — async init called once in initCoreDependencies()
class SharedPreferenceService {
  SharedPreferenceService._();
  static final SharedPreferenceService instance = SharedPreferenceService._();
  late SharedPreferences _prefs;

  Future<void> init() async { _prefs = await SharedPreferences.getInstance(); }
  String? getString(String key) => _prefs.getString(key);
  // ...
}
```

---

## Dependency Injection

The shared service locator `sl` and `initCoreDependencies()` live in **`core`** (`package:core/core/di/core_injection.dart`). Each app has its **own** `lib/di/injection_container.dart` that initialises core first, then registers its features.

```dart
// packages/core/lib/core/di/core_injection.dart
final sl = GetIt.instance;

Future<void> initCoreDependencies() async {
  await SharedPreferenceService.instance.init();   // static singletons — not in GetIt
}
```

```dart
// apps/<app>/lib/di/injection_container.dart
import 'package:core/core/di/core_injection.dart';
export 'package:core/core/di/core_injection.dart' show sl;   // so consumers import `sl` from here

Future<void> initDependencies() async {
  await initCoreDependencies();

  // 1. Data sources — const no-arg; infrastructure accessed via static .instance
  sl.registerLazySingleton<JokesRemoteDataSource>(() => const JokesRemoteDataSourceImpl());
  // 2. Repositories
  sl.registerLazySingleton<JokesRepository>(() => JokesRepositoryImpl(sl()));
  // 3. Use cases
  sl.registerLazySingleton(() => GetRandomJokeUseCase(sl()));

  // BLoCs are NOT registered in GetIt — instantiated in BlocProvider inside buildBody:
  // BlocProvider(create: (_) => JokeBloc(getRandomJokeUseCase: sl())..add(const JokeEvent.started()))
  // Cubits for shared state also instantiated in buildBlocProviders (not GetIt).
}
```

`main.dart` calls the app's `initDependencies()` once before `runApp`.

---

## Error Flow

```
data source throws DioException
  ↓ BaseRepository.handleRequest() catches it
  ↓ returns Left(Failure.network(...))  — for connectionError, timeout, or (unknown && response == null)
     Left(Failure.server(statusCode, ...)) — for 4xx/5xx responses

use case returns Either<Failure, T> unchanged

BLoC folds the Either:
  right(entity) → emit(XState.loaded(...))
  left(failure) → emit(XState.error(message: failure.message))
```

Never `throw` across layer boundaries. Never let `DioException` reach a BLoC or widget.

`DioExceptionType.unknown` with `response == null` is a network error (SSL/socket failure) — treat it the same as `connectionError`. Always log `err.error` in the interceptor to surface the underlying cause.

---

## UI Design System

### Atomic hierarchy
- **atoms** — single widget, no BLoC reads: `AppButton`, `AppTextField` (`dense` option), `AppBadge`, `AppChip`, `AppCheckbox`, `AppTopBar`, `AppDropdownMenu`, `LoadingIndicator`, `LoadingDots`, `ThemeModeToggle` (all in `package:core/core/ui/atoms/`)
- **molecules** — composed atoms, may read BLoC via context: `AppBottomSheet` (supports `actions:` row), `AppDialog`, `EmptyState`, `ErrorView`
- **feature/widgets** — feature-local, may read that feature's BLoC

### Never hardcode — use tokens
```dart
// colours ✅
Theme.of(context).colorScheme.primary
Theme.of(context).extension<AppColorsExtension>()!.successContainer
colorScheme.scrim.withValues(alpha: 0.33)
// colours ❌  Color(0xFF186752) / Colors.red / Colors.black54

// text styles ✅
Theme.of(context).textTheme.bodyLarge!.copyWith(color: cs.onSurface)
// text styles ❌  TextStyle(fontSize: 16, fontWeight: FontWeight.w400)

// spacing + radius ✅
AppSpacing.lg          // 16
AppRadius.md           // BorderRadius.all(Radius.circular(8)) — one-off radii
// brand corner radius (buttons/chips/cards/inputs) is theme-driven — read it,
// don't hardcode:  Theme.of(context).extension<AppShapes>()!.buttonRadius
// spacing ❌  EdgeInsets.all(16) / BorderRadius.circular(8)

// strings ✅  app copy → apps/<app>/lib/constants/value_const.dart  (class ValueConst)
ValueConst.jokeAppBarTitle
ValueConst.jokeResultsCount(state.totalJokes)   // dynamic → static method
// generic core-owned strings → CoreConst (package:core/core/constants/core_const.dart)
CoreConst.retryButton
// strings ❌  'Dad Jokes' / 'Load More'
```

> **Constants split:** product copy and API URLs live in each app (`ValueConst` / `ApiConstants` under `apps/<app>/lib/constants/`). `core` only holds the handful of generic constants its own widgets/services need, in `CoreConst` — so a file can use both `CoreConst.x` and `ValueConst.y` without a name clash.

### Theme configuration
Each app owns `assets/theme/theme_config.json`; `AppTheme.fromConfig` (in core) turns it into a full `ThemeData`. **The theme is data through one builder — a new look means a new config, never per-app theme Dart.**

```jsonc
{
  "activeTheme": "rocketWarm",           // pick a preset from app_theme_presets.dart
  "shape": { "button": 999, "chip": 999, "card": 16, "input": 8, "sheet": 24 },
  "density": 0                           // VisualDensity adjustment (compact -2 … 0 … 1)
  // or, instead of activeTheme, inline "fontFamily" + "light"/"dark" role maps
}
```

- **Colours** — `activeTheme` selects a preset (`dadJokes`, `oceanBreeze`, `forestWalk`, `rocketWarm`, `gravia`); a seed drives all 45 M3 roles via `ColorScheme.fromSeed`, and any role can be overridden by key. Custom success/warning roles, plus the cross-pack `dockedHairline`/`sheetHairline`/`tintedPrimaryFill` roles (also overridable per preset — a pack's kit typically specs exact swatches, see the `gravia` preset — with scheme-derived fallbacks when a preset omits them), live in `AppColorsExtension`.
- **Shape** — the optional `shape` block sets brand corner radii. These populate `ThemeData`'s **component themes** (`elevatedButtonTheme`, `filledButtonTheme`, `chipTheme`, `cardTheme`, `dialogTheme`, `bottomSheetTheme`, `fab`, `inputDecorationTheme`) **and** the `AppShapes` extension that atoms read — so a raw `ElevatedButton` and an `AppButton` come out identical, and both re-skin per theme. Omitted → `AppShapes.standard`.
- **One source of truth** — colours come from `ColorScheme` (free for raw Material + atoms); shape comes from `AppShapes`/component themes. Atoms own *structure + behaviour* and read *all* style from the theme, so you never fork an atom per app — you change the config.

### Light / dark toggle
Dark mode follows the OS by default (`themeMode: ThemeMode.system`). For a manual switch, `core` provides `ThemeModeController` (a persisted `ValueNotifier<ThemeMode>`, not a Cubit — keeps `core` free of `flutter_bloc`). Each `App` owns one, drives `MaterialApp.themeMode` via a `ValueListenableBuilder`, and exposes it through `ThemeModeScope`; the `ThemeModeToggle` atom in the AppBar cycles System → Light → Dark and persists the choice via `SharedPreferenceService`.

---

## Testing

Tests live inside each app (`apps/<app>/test/`). `core` has its own `packages/core/test/`.

| Subject | Location | Tool |
|---|---|---|
| Use case | `apps/<app>/test/unit/feature/{name}/domain/` | `flutter_test` |
| BLoC | `apps/<app>/test/unit/feature/{name}/presentation/` | `bloc_test` |
| Screen/page | `apps/<app>/test/widget/feature/{name}/` | `flutter_test` + `MockBloc` |
| Shared fakes | `apps/<app>/test/helpers/` | manual fake implements interface |

Rules:
- Manual fakes only — no `mockito`, no `mocktail`
- Fake exposes a `result` field set per test; always use the shared fake from `test/helpers/`
- Widget tests use `BlocProvider.value(value: mockBloc, child: MaterialApp(home: Screen()))`
- Use `bloc_test` `MockBloc` for widget tests — never wire real BLoCs
- No real-network calls in any test — inject fakes at the data-source boundary
- Run with `make test` (loops both apps) or `cd apps/<app> && flutter test`
