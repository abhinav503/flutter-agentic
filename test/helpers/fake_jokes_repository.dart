import 'package:cordelia_base/core/error/failure.dart';
import 'package:cordelia_base/feature/jokes/domain/entities/joke_entity.dart';
import 'package:cordelia_base/feature/jokes/domain/entities/joke_search_page_entity.dart';
import 'package:cordelia_base/feature/jokes/domain/repository/jokes_repository.dart';
import 'package:fpdart/fpdart.dart';

class FakeJokesRepository implements JokesRepository {
  Either<Failure, JokeEntity>? result;
  Either<Failure, JokeSearchPageEntity>? searchResult;

  @override
  Future<Either<Failure, JokeEntity>> getRandomJoke() async => result!;

  @override
  Future<Either<Failure, JokeSearchPageEntity>> searchJokes({
    required String term,
    required int page,
    int limit = 20,
  }) async =>
      searchResult!;
}
