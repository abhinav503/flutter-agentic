part of 'joke_search_bloc.dart';

@freezed
sealed class JokeSearchEvent with _$JokeSearchEvent {
  const factory JokeSearchEvent.submitted({required String term}) =
      JokeSearchSubmitted;
  const factory JokeSearchEvent.chipSelected({required String term}) =
      JokeSearchChipSelected;
  const factory JokeSearchEvent.loadMore() = JokeSearchLoadMore;
}
