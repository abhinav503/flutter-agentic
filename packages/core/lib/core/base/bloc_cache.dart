/// Warm-start cache for a BLoC — the value survives across bloc instances
/// so a revisited screen seeds straight into its loaded state instead of
/// re-running the loading skeleton (see docs/how-to/design-tab-flow.md).
///
/// Use it for any **frequently-revisited screen**, not just bottom-nav
/// tabs: a nav shell rebuilds each tab's `BlocProvider` on every switch,
/// and pushed screens the user keeps reopening (search, select-address)
/// rebuild theirs on every push — either way the bloc dies with the visit,
/// so a plain instance field can't carry the data across.
///
/// Hold one per bloc in a `static final` field. Statics also outlive
/// `bloc_test` cases — expose a
/// `@visibleForTesting static void resetCache() => _cache.reset();` beside it.
///
/// ```dart
/// static final _cache = BlocCache<HomeEntity>();
///
/// HomeBloc(...)
///   : super(_cache.seed(
///       warm: (home) => HomeState.loaded(home: home),
///       cold: HomeState.loading,
///     ));
/// ```
///
/// Cache only fetched data, never transient view selections (active tab,
/// filters, query text) — a warm start should reopen with default view
/// state, same as a cold load.
class BlocCache<T> {
  T? _value;

  T? get value => _value;

  /// Call from the bloc's single loaded-emit helper so every path that emits
  /// loaded data refreshes the cache.
  void save(T value) => _value = value;

  void reset() => _value = null;

  /// Builds the bloc's initial state: [warm] with the cached value when one
  /// exists, [cold] otherwise.
  R seed<R>({required R Function(T value) warm, required R Function() cold}) {
    final value = _value;
    return value != null ? warm(value) : cold();
  }
}

/// A [BlocCache] keyed to a scope (a store id, a user id): when the scope
/// changes, the cached value is dropped instead of flashing the previous
/// scope's data on the new scope's screen.
///
/// This replaces the hand-rolled `static String? _cachedStoreId` guard each
/// scoped bloc was carrying beside its cache:
/// ```dart
/// static final _cache = ScopedBlocCache<HomeEntity>();
/// @visibleForTesting
/// static void resetCache() => _cache.reset();
///
/// HomeBloc({required String storeId, ...})
///   : super(_cache.seed(
///       scope: storeId,
///       warm: (home) => HomeState.loaded(home: home),
///       cold: HomeState.loading,
///     ));
///
/// // in the loaded-emit helper:
/// _cache.save(storeId, home);
/// ```
class ScopedBlocCache<T> {
  final BlocCache<T> _cache = BlocCache<T>();
  Object? _scope;

  T? valueFor(Object scope) => scope == _scope ? _cache.value : null;

  /// Saves [value] for [scope]; a different scope simply takes over the slot.
  void save(Object scope, T value) {
    _scope = scope;
    _cache.save(value);
  }

  void reset() {
    _cache.reset();
    _scope = null;
  }

  /// Builds the bloc's initial state: [warm] with the cached value when one
  /// exists **for this scope**, [cold] otherwise. A scope mismatch drops the
  /// stale value so the next visit to the old scope also starts cold.
  R seed<R>({
    required Object scope,
    required R Function(T value) warm,
    required R Function() cold,
  }) {
    if (scope != _scope) reset();
    _scope = scope;
    return _cache.seed(warm: warm, cold: cold);
  }
}
