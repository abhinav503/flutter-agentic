part of 'for_you_bloc.dart';

@freezed
sealed class ForYouState with _$ForYouState {
  const factory ForYouState.loading() = ForYouLoading;
  const factory ForYouState.loaded({
    required JokeEntity joke,
    @Default(false) bool isFetchingNext,
  }) = ForYouLoaded;
  const factory ForYouState.nextFetchFailed({
    required JokeEntity currentJoke,
    required String message,
  }) = ForYouNextFetchFailed;
  const factory ForYouState.error({required String message}) = ForYouError;
}
