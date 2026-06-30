import 'package:bloc_test/bloc_test.dart';
import 'package:core/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:web_terminal/enums/device_platform.dart';
import 'package:web_terminal/feature/devices/domain/entities/device_entity.dart';
import 'package:web_terminal/feature/devices/domain/usecase/list_devices_usecase.dart';
import 'package:web_terminal/feature/devices/presentation/cubit/devices_cubit.dart';

import '../../../../helpers/fake_devices_repository.dart';

void main() {
  late FakeDevicesRepository repository;
  late ListDevicesUseCase listDevices;

  const iphone = DeviceEntity(
    id: 'iphone-1',
    name: 'iPhone 15',
    platform: DevicePlatform.ios,
  );

  setUp(() {
    repository = FakeDevicesRepository();
    listDevices = ListDevicesUseCase(repository);
  });

  DevicesCubit build() => DevicesCubit(listDevicesUseCase: listDevices);

  test('starts on the embedded web preview', () {
    expect(build().state.selected, DevicesCubit.webPreview);
    expect(build().state.devices, [DevicesCubit.webPreview]);
  });

  blocTest<DevicesCubit, DevicesState>(
    'load replaces the list and keeps the web preview selected',
    setUp: () => repository.result = right([DevicesCubit.webPreview, iphone]),
    build: build,
    act: (cubit) => cubit.load(),
    verify: (cubit) {
      expect(cubit.state.devices, [DevicesCubit.webPreview, iphone]);
      expect(cubit.state.selected, DevicesCubit.webPreview);
    },
  );

  blocTest<DevicesCubit, DevicesState>(
    'load keeps the default when the list is empty',
    setUp: () => repository.result = right(const []),
    build: build,
    act: (cubit) => cubit.load(),
    verify: (cubit) => expect(cubit.state.selected, DevicesCubit.webPreview),
  );

  blocTest<DevicesCubit, DevicesState>(
    'load surfaces an error and keeps the web preview default',
    setUp: () =>
        repository.result = left(const Failure.network(message: 'offline')),
    build: build,
    act: (cubit) => cubit.load(),
    verify: (cubit) {
      expect(cubit.state.error, 'offline');
      expect(cubit.state.selected, DevicesCubit.webPreview);
    },
  );

  blocTest<DevicesCubit, DevicesState>(
    'select switches the active target to a native device',
    setUp: () => repository.result = right([DevicesCubit.webPreview, iphone]),
    build: build,
    act: (cubit) async {
      await cubit.load();
      cubit.select(iphone);
    },
    verify: (cubit) {
      expect(cubit.state.selected, iphone);
      expect(cubit.state.selected.isNative, isTrue);
    },
  );
}
