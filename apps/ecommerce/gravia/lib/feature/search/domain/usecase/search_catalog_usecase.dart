import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/search_results_entity.dart';
import '../repository/search_repository.dart';

class SearchCatalogUseCase
    extends UseCase<Either<Failure, SearchResultsEntity>, SearchCatalogParams> {
  final SearchRepository _repository;

  const SearchCatalogUseCase(this._repository);

  @override
  Future<Either<Failure, SearchResultsEntity>> call(
    SearchCatalogParams params,
  ) => _repository.searchCatalog(params.query);
}

class SearchCatalogParams {
  final String query;

  const SearchCatalogParams({required this.query});
}
