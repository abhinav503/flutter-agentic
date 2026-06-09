import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/joke_entity.dart';
import '../../domain/usecase/get_random_joke_usecase.dart';

part 'for_you_bloc.freezed.dart';
part 'for_you_event.dart';
part 'for_you_state.dart';

class ForYouBloc extends Bloc<ForYouEvent, ForYouState> {
  final GetRandomJokeUseCase _getRandomJoke;

  ForYouBloc({required GetRandomJokeUseCase getRandomJokeUseCase})
      : _getRandomJoke = getRandomJokeUseCase,
        super(const ForYouState.loading()) {
    on<ForYouStarted>(_onStarted);
    on<ForYouNextRequested>(_onNextRequested);
  }

  Future<void> _onStarted(
    ForYouStarted event,
    Emitter<ForYouState> emit,
  ) async {
    final result = await _getRandomJoke(const NoParams());
    result.fold(
      (failure) => emit(ForYouState.error(message: failure.message)),
      (joke) => emit(ForYouState.loaded(joke: joke)),
    );
  }

  Future<void> _onNextRequested(
    ForYouNextRequested event,
    Emitter<ForYouState> emit,
  ) async {
    final currentJoke = switch (state) {
      ForYouLoaded(:final joke) => joke,
      ForYouNextFetchFailed(:final currentJoke) => currentJoke,
      _ => null,
    };
    if (currentJoke == null) return;

    emit(ForYouState.loaded(joke: currentJoke, isFetchingNext: true));
    final result = await _getRandomJoke(const NoParams());
    result.fold(
      (failure) => emit(ForYouState.nextFetchFailed(
        currentJoke: currentJoke,
        message: failure.message,
      )),
      (joke) => emit(ForYouState.loaded(joke: joke)),
    );
  }
}
