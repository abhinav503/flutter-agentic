import 'package:cordelia_base/core/error/failure.dart';
import 'package:cordelia_base/core/usecase/usecase.dart';
import 'package:cordelia_base/feature/jokes/domain/entities/joke_entity.dart';
import 'package:cordelia_base/feature/jokes/domain/entities/joke_search_result_entity.dart';
import 'package:cordelia_base/feature/jokes/domain/repository/jokes_repository.dart';
import 'package:cordelia_base/feature/jokes/domain/usecase/get_random_joke_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class _FakeJokesRepository implements JokesRepository {
  Either<Failure, JokeEntity>? result;

  @override
  Future<Either<Failure, JokeEntity>> getRandomJoke() async => result!;

  @override
  Future<Either<Failure, JokeSearchPageEntity>> searchJokes({
    required String term,
    required int page,
    int limit = 20,
  }) async =>
      throw UnimplementedError();
}

void main() {
  late _FakeJokesRepository repository;
  late GetRandomJokeUseCase useCase;

  setUp(() {
    repository = _FakeJokesRepository();
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
