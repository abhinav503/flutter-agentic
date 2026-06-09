import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/joke_search_page_entity.dart';
import '../repository/jokes_repository.dart';

class SearchJokesParams {
  final String term;
  final int page;
  final int limit;

  const SearchJokesParams({
    required this.term,
    required this.page,
    this.limit = 20,
  });
}

class SearchJokesUseCase
    extends UseCase<Either<Failure, JokeSearchPageEntity>, SearchJokesParams> {
  final JokesRepository _repository;

  const SearchJokesUseCase(this._repository);

  @override
  Future<Either<Failure, JokeSearchPageEntity>> call(SearchJokesParams params) =>
      _repository.searchJokes(
        term: params.term,
        page: params.page,
        limit: params.limit,
      );
}
