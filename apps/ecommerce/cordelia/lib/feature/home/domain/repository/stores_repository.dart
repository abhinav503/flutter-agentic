import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/store_entity.dart';

abstract interface class StoresRepository {
  Future<Either<Failure, List<StoreEntity>>> getStores({String? query});

  Future<Either<Failure, StoreEntity>> getStore({required String storeId});
}
