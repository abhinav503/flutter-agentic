import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:web_terminal/feature/devices/domain/entities/device_entity.dart';
import 'package:web_terminal/feature/devices/domain/repository/devices_repository.dart';

/// Manual fake (no mockito/mocktail). Set [result] per test; the cubit reaches
/// it through the real ListDevicesUseCase, injecting at the repository boundary.
class FakeDevicesRepository implements DevicesRepository {
  Either<Failure, List<DeviceEntity>> result = right(const []);

  @override
  Future<Either<Failure, List<DeviceEntity>>> listDevices() async => result;
}
