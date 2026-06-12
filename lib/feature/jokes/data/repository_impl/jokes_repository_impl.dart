import 'package:fpdart/fpdart.dart';

import '../../../../core/base/base_repository.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/joke_entity.dart';
import '../../domain/entities/joke_search_page_entity.dart';
import '../../domain/repository/jokes_repository.dart';
import '../data_source/jokes_remote_data_source.dart';

class JokesRepositoryImpl with BaseRepository implements JokesRepository {
  final JokesRemoteDataSource _dataSource;

  const JokesRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, JokeEntity>> getRandomJoke() => handleRequest(() async {
        final model = await _dataSource.getRandomJoke();
        return right(model.toEntity());
      });

  @override
  Future<Either<Failure, JokeSearchPageEntity>> searchJokes({
    required String term,
    required int page,
    int limit = 20,
  }) =>
      handleRequest(() async {
        final model = await _dataSource.searchJokes(
          term: term,
          page: page,
          limit: limit,
        );
        return right(model.toEntity());
      });
}
