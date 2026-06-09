part of 'joke_search_bloc.dart';

@freezed
sealed class JokeSearchState with _$JokeSearchState {
  const factory JokeSearchState.initial() = JokeSearchInitial;
  const factory JokeSearchState.loading() = JokeSearchLoading;
  const factory JokeSearchState.loaded({
    required List<JokeSearchResultEntity> results,
    required int totalJokes,
    required int totalPages,
    required int currentPage,
    required String searchTerm,
    @Default(false) bool isLoadingMore,
  }) = JokeSearchLoaded;
  const factory JokeSearchState.error({required String message}) =
      JokeSearchError;
}
