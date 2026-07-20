part of 'search_bloc.dart';

@freezed
sealed class SearchEvent with _$SearchEvent {
  const factory SearchEvent.started() = SearchStarted;
  const factory SearchEvent.queryChanged({required String query}) =
      SearchQueryChanged;

  /// A search result (or an existing recent) was tapped — records it as the
  /// newest recent search. Navigation itself is the screen's side effect.
  const factory SearchEvent.resultSelected({
    required RecentSearchEntity item,
  }) = SearchResultSelected;
  const factory SearchEvent.recentSearchRemoved({
    required RecentSearchEntity item,
  }) = SearchRecentSearchRemoved;
}
