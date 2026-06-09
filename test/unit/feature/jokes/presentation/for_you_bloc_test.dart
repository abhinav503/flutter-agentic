import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_agentic/core/error/failure.dart';
import 'package:flutter_agentic/feature/jokes/domain/entities/joke_entity.dart';
import 'package:flutter_agentic/feature/jokes/domain/usecase/get_random_joke_usecase.dart';
import 'package:flutter_agentic/feature/jokes/presentation/bloc/for_you_bloc.dart';
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

  group('ForYouBloc', () {
    const joke = JokeEntity(id: '42', content: 'Funny joke');
    const newJoke = JokeEntity(id: '99', content: 'Even funnier');

    blocTest<ForYouBloc, ForYouState>(
      'emits [loaded] when started and fetch succeeds',
      build: () {
        fakeRepository.result = right(joke);
        return ForYouBloc(getRandomJokeUseCase: useCase);
      },
      act: (bloc) => bloc.add(const ForYouEvent.started()),
      expect: () => [ForYouState.loaded(joke: joke)],
    );

    blocTest<ForYouBloc, ForYouState>(
      'emits [error] when started and fetch fails',
      build: () {
        fakeRepository.result = left(const Failure.network(message: 'No internet'));
        return ForYouBloc(getRandomJokeUseCase: useCase);
      },
      act: (bloc) => bloc.add(const ForYouEvent.started()),
      expect: () => [const ForYouState.error(message: 'No internet')],
    );

    blocTest<ForYouBloc, ForYouState>(
      'emits [loaded(fetching), loaded(newJoke)] when nextRequested and succeeds',
      seed: () => ForYouState.loaded(joke: joke),
      build: () {
        fakeRepository.result = right(newJoke);
        return ForYouBloc(getRandomJokeUseCase: useCase);
      },
      act: (bloc) => bloc.add(const ForYouEvent.nextRequested()),
      expect: () => [
        ForYouState.loaded(joke: joke, isFetchingNext: true),
        ForYouState.loaded(joke: newJoke),
      ],
    );

    blocTest<ForYouBloc, ForYouState>(
      'emits [loaded(fetching), nextFetchFailed] when nextRequested and fails',
      seed: () => ForYouState.loaded(joke: joke),
      build: () {
        fakeRepository.result = left(const Failure.network(message: 'Offline'));
        return ForYouBloc(getRandomJokeUseCase: useCase);
      },
      act: (bloc) => bloc.add(const ForYouEvent.nextRequested()),
      expect: () => [
        ForYouState.loaded(joke: joke, isFetchingNext: true),
        ForYouState.nextFetchFailed(currentJoke: joke, message: 'Offline'),
      ],
    );
  });
}
