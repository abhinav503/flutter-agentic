import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/recent_search_entity.dart';
import '../repository/search_repository.dart';

class AddRecentSearchUseCase
    extends
        UseCase<
          Either<Failure, List<RecentSearchEntity>>,
          RecentSearchEntity
        > {
  final SearchRepository _repository;

  const AddRecentSearchUseCase(this._repository);

  @override
  Future<Either<Failure, List<RecentSearchEntity>>> call(
    RecentSearchEntity params,
  ) => _repository.addRecentSearch(params);
}
