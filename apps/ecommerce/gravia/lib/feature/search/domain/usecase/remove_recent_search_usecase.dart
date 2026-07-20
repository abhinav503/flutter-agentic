import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import 'package:gravia/enums/recent_search_type.dart';

import '../entities/recent_search_entity.dart';
import '../repository/search_repository.dart';

class RemoveRecentSearchUseCase
    extends
        UseCase<
          Either<Failure, List<RecentSearchEntity>>,
          RemoveRecentSearchParams
        > {
  final SearchRepository _repository;

  const RemoveRecentSearchUseCase(this._repository);

  @override
  Future<Either<Failure, List<RecentSearchEntity>>> call(
    RemoveRecentSearchParams params,
  ) => _repository.removeRecentSearch(id: params.id, type: params.type);
}

class RemoveRecentSearchParams {
  final String id;
  final RecentSearchType type;

  const RemoveRecentSearchParams({required this.id, required this.type});
}
