import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/joke_entity.dart';
import '../../domain/usecase/get_random_joke_usecase.dart';

part 'joke_bloc.freezed.dart';
part 'joke_event.dart';
part 'joke_state.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final GetRandomJokeUseCase _getRandomJoke;

  JokeBloc({required GetRandomJokeUseCase getRandomJokeUseCase})
      : _getRandomJoke = getRandomJokeUseCase,
        super(const JokeState.initial()) {
    on<JokeFetched>(_onFetched);
  }

  Future<void> _onFetched(JokeFetched event, Emitter<JokeState> emit) async {
    emit(const JokeState.loading());
    final result = await _getRandomJoke(const NoParams());
    result.fold(
      (failure) => emit(JokeState.error(message: failure.message)),
      (joke) => emit(JokeState.loaded(joke: joke)),
    );
  }
}
