part of 'search_page_bloc.dart';

@freezed
sealed class SearchPageState with _$SearchPageState {
  const factory SearchPageState.initial() = SearchPageInitial;
  const factory SearchPageState.loading() = SearchPageLoading;
  const factory SearchPageState.loaded({
    required List<JokeSearchResultEntity> results,
    required int totalJokes,
    required int totalPages,
    required int currentPage,
    required String searchTerm,
    @Default(false) bool isLoadingMore,
  }) = SearchPageLoaded;
  const factory SearchPageState.error({required String message}) =
      SearchPageError;
}
