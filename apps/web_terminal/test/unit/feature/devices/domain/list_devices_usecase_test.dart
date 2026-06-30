import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:web_terminal/enums/device_platform.dart';
import 'package:web_terminal/feature/devices/domain/entities/device_entity.dart';
import 'package:web_terminal/feature/devices/domain/usecase/list_devices_usecase.dart';

import '../../../../helpers/fake_devices_repository.dart';

void main() {
  late FakeDevicesRepository repository;
  late ListDevicesUseCase useCase;

  setUp(() {
    repository = FakeDevicesRepository();
    useCase = ListDevicesUseCase(repository);
  });

  test('returns the repository device list', () async {
    const device = DeviceEntity(
      id: 'iphone-1',
      name: 'iPhone 15',
      platform: DevicePlatform.ios,
    );
    repository.result = right([device]);

    final result = await useCase(const NoParams());

    expect(result.getRight().toNullable(), [device]);
  });

  test('passes a failure through unchanged', () async {
    repository.result = left(const Failure.network(message: 'offline'));

    final result = await useCase(const NoParams());

    expect(result.isLeft(), isTrue);
  });
}
