part of 'joke_bloc.dart';

@freezed
sealed class JokeEvent with _$JokeEvent {
  const factory JokeEvent.fetched() = JokeFetched;
}
