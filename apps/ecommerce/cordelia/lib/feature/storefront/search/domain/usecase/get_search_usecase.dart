import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/search_entity.dart';
import '../repository/search_repository.dart';

class GetSearchParams {
  final String storeId;

  const GetSearchParams({required this.storeId});
}

class GetSearchUseCase
    extends UseCase<Either<Failure, SearchEntity>, GetSearchParams> {
  final SearchRepository _repository;

  const GetSearchUseCase(this._repository);

  @override
  Future<Either<Failure, SearchEntity>> call(GetSearchParams params) =>
      _repository.getSearch(params.storeId);
}
