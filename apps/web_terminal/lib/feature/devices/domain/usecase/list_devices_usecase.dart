import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/device_entity.dart';
import '../repository/devices_repository.dart';

class ListDevicesUseCase
    extends UseCase<Either<Failure, List<DeviceEntity>>, NoParams> {
  final DevicesRepository _repository;
  const ListDevicesUseCase(this._repository);

  @override
  Future<Either<Failure, List<DeviceEntity>>> call(NoParams params) =>
      _repository.listDevices();
}
