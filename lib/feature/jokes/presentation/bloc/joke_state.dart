part of 'joke_bloc.dart';

@freezed
sealed class JokeState with _$JokeState {
  const factory JokeState.initial() = JokeInitial;
  const factory JokeState.loading() = JokeLoading;
  const factory JokeState.loaded({required JokeEntity joke}) = JokeLoaded;
  const factory JokeState.error({required String message}) = JokeError;
}
