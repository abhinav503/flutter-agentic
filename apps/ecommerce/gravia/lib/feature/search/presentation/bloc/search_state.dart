part of 'search_bloc.dart';

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState.loading() = SearchLoading;
  const factory SearchState.loaded({required SearchEntity search}) =
      SearchLoaded;
  const factory SearchState.error({required String message}) = SearchError;
}
