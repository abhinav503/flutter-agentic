import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/device_entity.dart';

abstract interface class DevicesRepository {
  Future<Either<Failure, List<DeviceEntity>>> listDevices();
}
