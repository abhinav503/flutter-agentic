import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/store_entity.dart';
import '../repository/stores_repository.dart';

class GetStoresUseCase
    extends UseCase<Either<Failure, List<StoreEntity>>, GetStoresParams> {
  final StoresRepository _repository;

  const GetStoresUseCase(this._repository);

  @override
  Future<Either<Failure, List<StoreEntity>>> call(GetStoresParams params) =>
      _repository.getStores(query: params.query);
}

class GetStoresParams {
  final String? query;

  const GetStoresParams({this.query});
}
