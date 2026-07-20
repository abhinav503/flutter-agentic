/// Warm-start cache for a tab's BLoC — the value survives across bloc
/// instances so a revisited tab seeds straight into its loaded state instead
/// of re-running the loading shimmer (see docs/how-to/design-tab-flow.md).
///
/// Hold one per bloc in a `static final` field: a nav shell rebuilds each
/// tab's `BlocProvider` fresh on every switch, so an instance field would die
/// with the old bloc. Statics also outlive `bloc_test` cases — expose a
/// `@visibleForTesting static void resetCache() => _cache.reset();` beside it.
///
/// ```dart
/// static final _cache = TabCache<HomeEntity>();
///
/// HomeBloc(...)
///   : super(_cache.seed(
///       warm: (home) => HomeState.loaded(home: home),
///       cold: HomeState.loading,
///     ));
/// ```
///
/// Cache only fetched data, never transient view selections (active tab,
/// filters) — a warm start should reopen with default view state, same as a
/// cold load.
class TabCache<T> {
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
