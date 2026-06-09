import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/joke_entity.dart';
import '../entities/joke_search_page_entity.dart';

abstract interface class JokesRepository {
  Future<Either<Failure, JokeEntity>> getRandomJoke();

  Future<Either<Failure, JokeSearchPageEntity>> searchJokes({
    required String term,
    required int page,
    int limit = 20,
  });
}
