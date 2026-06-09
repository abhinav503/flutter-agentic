import 'package:bloc_test/bloc_test.dart';
import 'package:cordelia_base/core/error/failure.dart';
import 'package:cordelia_base/feature/jokes/domain/entities/joke_entity.dart';
import 'package:cordelia_base/feature/jokes/domain/usecase/get_random_joke_usecase.dart';
import 'package:cordelia_base/feature/jokes/presentation/bloc/joke_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../helpers/fake_jokes_repository.dart';

void main() {
  late FakeJokesRepository fakeRepository;
  late GetRandomJokeUseCase useCase;

  setUp(() {
    fakeRepository = FakeJokesRepository();
    useCase = GetRandomJokeUseCase(fakeRepository);
  });

  group('JokeBloc', () {
    const joke = JokeEntity(id: '42', content: 'Funny joke');

    blocTest<JokeBloc, JokeState>(
      'emits [loading, loaded] when fetch succeeds',
      build: () {
        fakeRepository.result = right(joke);
        return JokeBloc(getRandomJokeUseCase: useCase);
      },
      act: (bloc) => bloc.add(const JokeEvent.fetched()),
      expect: () => [
        const JokeState.loading(),
        JokeState.loaded(joke: joke),
      ],
    );

    blocTest<JokeBloc, JokeState>(
      'emits [loading, error] when fetch fails',
      build: () {
        fakeRepository.result = left(const Failure.network(message: 'No internet'));
        return JokeBloc(getRandomJokeUseCase: useCase);
      },
      act: (bloc) => bloc.add(const JokeEvent.fetched()),
      expect: () => [
        const JokeState.loading(),
        const JokeState.error(message: 'No internet'),
      ],
    );
  });
}
