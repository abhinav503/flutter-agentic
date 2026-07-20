# Gravia: Shell, Tab, and Auth Flow

How `ShellPage` and its tabs load/refresh data, and how the Firebase auth
flow works end to end. Reference: `apps/ecommerce/gravia`.

> Architecture: `docs/reference/architecture.md` (nav shell pattern)
> Design: `docs/ai-rules/design.md` (loading states)
> Auth setup: `docs/how-to/add-firebase-auth.md`

---

## Shell page flow

`ShellPage` hosts what's shared across every tab; each tab owns nothing
above itself. Two jobs:

**1. Session resume + the verify-email gate**, in `buildBlocProviders` —
`AuthBloc` is created once, above the tab switch, and stays alive the whole
session:

```dart
Widget buildBlocProviders(Widget child) => BlocProvider(
  create: (_) => AuthBloc(...)..add(const AuthEvent.started()),
  child: Builder(
    builder: (context) => BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAwaitingVerification) _openVerifySheet(state.email);
        if (state is AuthAuthenticated) _closeVerifySheet();
      },
      child: child,
    ),
  ),
);
```

Why here and not in a tab: an unverified session must gate *every* tab, not
just Home — a shared `BlocListener` above the switch is the only place that's
true from.

**2. Per-tab `BlocProvider`s**, in `buildBody` — a fresh BLoC per tab switch:

```dart
switch (_currentTab) {
  ShellPage.homeTabIndex => BlocProvider(
    create: (_) => HomeBloc(getHomeUseCase: sl())..add(const HomeEvent.started()),
    child: const HomeScreen(),
  ),
  // ...categories, orders, profile — same shape
}
```

This is why each tab's BLoC needs its own warm-start cache (below) — the
`BlocProvider` (and the BLoC inside it) is destroyed and rebuilt every time
`_currentTab` changes, so nothing survives a tab switch by default.

---

## Home tab — shimmer + real API call + warm-start cache

Home fetches from **two** endpoints in parallel and combines them client-side
(no single `/home` route matches its shape):

```dart
Future<HomeModel> getHome() async {
  final results = await Future.wait([
    HttpService.instance.get(ApiConstants.categoriesPath),
    HttpService.instance.get(ApiConstants.popularProductsPath),
  ]);
  return HomeModel(
    categories: CategoriesModel.fromJson(results[0].data!).groups
        .expand((g) => g.categories).toList(),
    popularProducts: (results[1].data!['popular_products'] as List)
        .map((j) => ProductModel.fromJson(j)).toList(),
  );
}
```

Cold load shows `HomeSkeletonBody` (a `ShimmerBox` layout matching the real
grid), not a spinner. Warm load (tab revisited) skips the shimmer entirely —
see the caching pattern below, shared by all three tabs.

---

## Categories tab — the plain case of the same pattern

Simplest version: one endpoint, one cached entity, one event.

```dart
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  static CategoriesEntity? _cachedCategories;

  CategoriesBloc({required GetCategoriesUseCase getCategoriesUseCase})
    : super(_cachedCategories != null
          ? CategoriesState.loaded(categories: _cachedCategories!)
          : const CategoriesState.loading()) {
    on<CategoriesStarted>(_onStarted);
  }

  Future<void> _onStarted(CategoriesStarted e, Emitter<CategoriesState> emit) async {
    final result = await _getCategories(const NoParams());
    result.fold(
      (failure) => switch (state) {
        CategoriesLoaded(:final categories) =>
          emit(CategoriesState.loaded(categories: categories, refreshFailed: true)),
        _ => emit(CategoriesState.error(message: failure.message)),
      },
      (categories) => _emitLoaded(categories, emit), // caches + emits
    );
  }
}
```

**Why static, not an instance field:** the instance dies with the old BLoC on
every tab switch (see Shell flow above); `static` is the only thing that
survives to the next `CategoriesBloc()` call, for the app process's life.

**Why `refreshFailed`, not `error`:** a warm tab already has good content on
screen — a failed background refetch shouldn't blank it out. It sets a flag
the screen turns into a snackbar instead of an `ErrorView`.

---

## Orders tab — same pattern + filters

Orders adds view-local state (`selectedTab`, `filter`) on top of the same
cache. Only the **fetched list** is cached — the tab/filter selection resets
to its default on every warm start, same as a cold one:

```dart
static List<OrderEntity>? _cachedOrders;

super(_cachedOrders != null
    ? OrdersState.loaded(orders: _cachedOrders!, selectedTab: OrdersTab.past)
    : const OrdersState.loading())
```

Local optimistic edits (cancelling an order) route through the same
cache-updating helper as a real fetch, so leaving and returning before the
next background refresh still shows the edit:

```dart
void _onCancelled(OrdersCancelled e, Emitter<OrdersState> emit) {
  switch (state) {
    case final OrdersLoaded loaded:
      final updated = [/* flip event.orderId to cancelled */];
      _emitLoaded(updated, loaded.selectedTab, emit, filter: loaded.filter); // not a raw emit()
    case OrdersLoading(): case OrdersError(): break;
  }
}
```

---

## Auth flow (Login → Verify → Resume → Forgot Password)

`FirebaseAuthService` is gravia's own static singleton (`lib/services/`, not
`core` — auth is a per-app dependency). `AuthBloc` states:
`initial → loading → awaitingVerification → authenticated | unauthenticated
| passwordResetEmailSent | error`.

**Sign up / log in → the persistent verify sheet.** Both screens dispatch
their event; on success `AuthBloc` enters `awaitingVerification`, which the
shell's `BlocListener` (above) turns into a non-dismissible bottom sheet
(`isDismissible: false`, `enableDrag: false`, `PopScope(canPop: false)`) — a
shopper cannot swipe, tap-outside, or back-button their way past an
unverified account.

**The poll lives in the BLoC, not the sheet widget** — the sheet is a dumb
countdown/resend UI; `AuthBloc` owns the `Timer`:

```dart
Future<void> _enterAwaitingVerification(Emitter<AuthState> emit, String email) async {
  await SharedPreferenceService.instance.setBool(kPendingEmailVerificationPrefKey, true);
  emit(AuthState.awaitingVerification(email: email));
  _verificationTimer?.cancel(); // guard against a second timer if this re-enters
  _verificationTimer = Timer.periodic(const Duration(seconds: 3),
      (_) => add(const AuthEvent.verificationTicked()));
}

Future<void> _onVerificationTicked(AuthVerificationTicked e, Emitter<AuthState> emit) async {
  final result = await _checkEmailVerified(const NoParams());
  await result.fold(
    (failure) async {}, // transient poll failure — stay put, retry next tick
    (user) async {
      if (user == null) return;
      _verificationTimer?.cancel();
      await SharedPreferenceService.instance.setBool(kPendingEmailVerificationPrefKey, false);
      emit(AuthState.authenticated(user: user));
    },
  );
}
```

**Resume on relaunch.** A killed-and-reopened app must land back on the
verify sheet, not silently grant access — `AuthStarted` checks both the live
Firebase user *and* the persisted pending flag:

```dart
Future<void> _onStarted(AuthStarted e, Emitter<AuthState> emit) async {
  final user = FirebaseAuthService.instance.currentUser;
  final pending = SharedPreferenceService.instance.getBool(kPendingEmailVerificationPrefKey) ?? false;
  if (user != null && pending) {
    await _enterAwaitingVerification(emit, user.email ?? '');
  } else {
    emit(const AuthState.unauthenticated());
  }
}
```

**Forgot password.** No separate screen — Login reuses whatever the shopper
already typed into the Email field, validates it inline, and dispatches
`forgotPasswordRequested`; Firebase owns the rest (reset email, reset page).

**Profile cache is a different thing from the tab caches above** —
`UserProfileCacheService` (`lib/services/`) persists the profile to
`SharedPreferences` (survives app restart), written right after
signup/login/verification, read first by `ProfileRepositoryImpl` to avoid a
loader flash. The Home/Categories/Orders caches above are in-memory
`static` fields only — gone on app restart, which is fine, since their whole
point is surviving a *tab switch*, not a relaunch.

---

## Summary

| Flow | Mechanism | Why |
|---|---|---|
| Shell | `AuthBloc` in `buildBlocProviders`, above the tab switch | Verify-gate and session state must outlive every individual tab |
| Any tab | `static` cache + seed-from-cache constructor | Survives the BLoC being rebuilt on every tab switch |
| Any tab | `refreshFailed` flag, not `error`, on a warm refetch failure | Don't blank out content the user can already see |
| Orders | Cache the fetched list only, not `selectedTab`/`filter` | Those are view state, not server data — reset like a cold load |
| Optimistic local edits | Route through the same cache-updating helper | Keeps the cache correct if the tab is revisited before the next refetch |
| Auth verify | 3s `Timer.periodic` inside `AuthBloc`, sheet is presentation-only | One poll owner; sheet stays dumb/reusable |
| Auth resume | Live Firebase user **and** a persisted pending flag | A killed app must not silently skip the verify gate |
| Profile cache | Disk-persisted (`SharedPreferences`), separate from tab caches | Needs to survive app restart; tab caches don't |

Testing: reset every `static` cache in the test file's top-level `setUp`
(`HomeBloc.resetCache()` etc.) — see `test/unit/feature/{home,categories,
orders}/presentation/*_bloc_test.dart` for the cold/warm/refresh-failure
cases each BLoC covers.
