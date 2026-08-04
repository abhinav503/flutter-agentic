part of 'search_bloc.dart';

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState.loading() = SearchLoading;

  /// Single loaded state for both modes of the screen — browse (empty
  /// [query]: recents + popular) and results ([query] non-empty). One state
  /// instead of separate results-states so clearing the field can restore
  /// the browse content without re-fetching, and [query] doubles as the
  /// retry context for [resultsError].
  const factory SearchState.loaded({
    required SearchEntity search,
    @Default('') String query,
    @Default(false) bool searching,
    SearchResultsEntity? results,
    String? resultsError,

    /// True for one emission when a silent background refresh (a warm start
    /// seeded from SearchBloc's cached data) fails — the already-visible
    /// cached content stays on screen; the listener surfaces this via a
    /// snackbar instead of replacing it with the error view. Every later
    /// emission clears it through `SearchBloc._emitView`.
    @Default(false) bool refreshFailed,
  }) = SearchLoaded;
  const factory SearchState.error({required String message}) = SearchError;
}
