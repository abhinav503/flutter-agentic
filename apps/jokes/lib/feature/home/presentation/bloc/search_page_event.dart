part of 'search_page_bloc.dart';

@freezed
sealed class SearchPageEvent with _$SearchPageEvent {
  const factory SearchPageEvent.submitted({required String term}) =
      SearchPageSubmitted;
  const factory SearchPageEvent.chipSelected({required String term}) =
      SearchPageChipSelected;
  const factory SearchPageEvent.loadMore() = SearchPageLoadMore;
}
