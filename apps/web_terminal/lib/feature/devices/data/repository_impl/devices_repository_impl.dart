import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/device_entity.dart';
import '../../domain/repository/devices_repository.dart';
import '../data_source/devices_remote_data_source.dart';

class DevicesRepositoryImpl with BaseRepository implements DevicesRepository {
  final DevicesRemoteDataSource _dataSource;
  const DevicesRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<DeviceEntity>>> listDevices() =>
      handleRequest(() async {
        final models = await _dataSource.listDevices();
        return right(models.map((m) => m.toEntity()).toList());
      });
}
