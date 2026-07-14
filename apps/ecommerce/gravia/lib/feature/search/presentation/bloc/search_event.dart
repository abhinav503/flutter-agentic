part of 'search_bloc.dart';

@freezed
sealed class SearchEvent with _$SearchEvent {
  const factory SearchEvent.started() = SearchStarted;
  const factory SearchEvent.recentSearchRemoved({required String term}) =
      SearchRecentSearchRemoved;
}
