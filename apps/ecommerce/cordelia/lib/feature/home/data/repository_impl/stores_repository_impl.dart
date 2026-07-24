import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/store_entity.dart';
import '../../domain/repository/stores_repository.dart';
import '../data_source/stores_remote_data_source.dart';

class StoresRepositoryImpl with BaseRepository implements StoresRepository {
  final StoresRemoteDataSource _dataSource;

  const StoresRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<StoreEntity>>> getStores({String? query}) =>
      handleRequest(() async {
        final models = await _dataSource.getStores(query: query);
        return right(models.map((m) => m.toEntity()).toList());
      });
}
