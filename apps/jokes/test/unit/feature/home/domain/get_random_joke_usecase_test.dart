import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:jokes/feature/home/domain/entities/joke_entity.dart';
import 'package:jokes/feature/home/domain/usecase/get_random_joke_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../helpers/fake_jokes_repository.dart';

void main() {
  late FakeJokesRepository repository;
  late GetRandomJokeUseCase useCase;

  setUp(() {
    repository = FakeJokesRepository();
    useCase = GetRandomJokeUseCase(repository);
  });

  group('GetRandomJokeUseCase', () {
    test('returns Joke on repository success', () async {
      const joke = JokeEntity(id: '1', content: 'Why did the dev quit? No exceptions.');
      repository.result = right(joke);

      final result = await useCase(const NoParams());

      expect(result, right(joke));
    });

    test('returns Failure on repository failure', () async {
      const failure = Failure.network(message: 'No internet');
      repository.result = left(failure);

      final result = await useCase(const NoParams());

      expect(result, left(failure));
    });
  });
}
