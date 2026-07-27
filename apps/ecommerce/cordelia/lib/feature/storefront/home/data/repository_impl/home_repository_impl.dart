import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/home_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../data_source/home_remote_data_source.dart';

class HomeRepositoryImpl with BaseRepository implements HomeRepository {
  final HomeRemoteDataSource _dataSource;

  const HomeRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, HomeEntity>> getHome({required String storeId}) =>
      handleRequest(() async {
        final model = await _dataSource.getHome(storeId: storeId);
        return right(model.toEntity());
      });
}
