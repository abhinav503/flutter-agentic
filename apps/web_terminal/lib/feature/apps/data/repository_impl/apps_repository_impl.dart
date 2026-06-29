import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/app_entity.dart';
import '../../domain/repository/apps_repository.dart';
import '../data_source/apps_remote_data_source.dart';

class AppsRepositoryImpl with BaseRepository implements AppsRepository {
  final AppsRemoteDataSource _dataSource;
  const AppsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<AppEntity>>> listApps() =>
      handleRequest(() async {
        final models = await _dataSource.listApps();
        return right(models.map((m) => m.toEntity()).toList());
      });

  @override
  Future<Either<Failure, AppEntity>> runApp(
    String name, {
    required String deviceId,
    required String platform,
    required String kind,
  }) =>
      handleRequest(() async {
        final model = await _dataSource.runApp(
          name,
          deviceId: deviceId,
          platform: platform,
          kind: kind,
        );
        return right(model.toEntity());
      });

  @override
  Future<Either<Failure, AppEntity>> stopApp(String name) =>
      handleRequest(() async {
        final model = await _dataSource.stopApp(name);
        return right(model.toEntity());
      });
}
