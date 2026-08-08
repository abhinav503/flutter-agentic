import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/store_entity.dart';
import '../repository/stores_repository.dart';

/// One store by id, for the callers that hold an id and nothing else.
///
/// Discovery never needs this — it opens a store it already listed. A
/// notification tap does: the push carries only the store's id, and mounting
/// its storefront takes the whole store.
class GetStoreUseCase
    extends UseCase<Either<Failure, StoreEntity>, GetStoreParams> {
  final StoresRepository _repository;

  const GetStoreUseCase(this._repository);

  @override
  Future<Either<Failure, StoreEntity>> call(GetStoreParams params) =>
      _repository.getStore(storeId: params.storeId);
}

class GetStoreParams {
  final String storeId;

  const GetStoreParams({required this.storeId});
}
