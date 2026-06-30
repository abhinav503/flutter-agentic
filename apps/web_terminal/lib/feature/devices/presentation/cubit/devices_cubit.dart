import 'package:core/core/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_terminal/enums/device_platform.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/usecase/list_devices_usecase.dart';

/// The run-target list and the selected target. Read by the device dropdown and
/// by the right pane (web → iframe, native → status panel). Defaults to the
/// embedded "Web preview" so the app works with zero native setup.
class DevicesState {
  final List<DeviceEntity> devices;
  final DeviceEntity selected;
  // One-shot message when the list couldn't be fetched; the screen shows it once.
  final String? error;

  const DevicesState({
    required this.devices,
    required this.selected,
    this.error,
  });

  DevicesState copyWith({List<DeviceEntity>? devices, DeviceEntity? selected}) =>
      DevicesState(
        devices: devices ?? this.devices,
        selected: selected ?? this.selected,
      );
}

class DevicesCubit extends Cubit<DevicesState> {
  final ListDevicesUseCase _listDevices;

  // The always-present embedded-iframe target; mirrors the bridge's WEB_PREVIEW
  // so the dropdown has a sensible default even before the list loads.
  static const webPreview = DeviceEntity(
    id: 'web-server',
    name: 'Web preview',
    platform: DevicePlatform.web,
    kind: DeviceKind.web,
  );

  DevicesCubit({required ListDevicesUseCase listDevicesUseCase})
      : _listDevices = listDevicesUseCase,
        super(const DevicesState(devices: [webPreview], selected: webPreview));

  // On failure keeps the web-preview default — the run target stays embeddable —
  // and surfaces the message once so the screen can show a snackbar.
  Future<void> load() async {
    final result = await _listDevices(const NoParams());
    result.fold(
      (failure) => emit(DevicesState(
        devices: state.devices,
        selected: state.selected,
        error: failure.message,
      )),
      (devices) {
        if (devices.isEmpty) return;
        final keep =
            devices.contains(state.selected) ? state.selected : devices.first;
        emit(DevicesState(devices: devices, selected: keep));
      },
    );
  }

  void select(DeviceEntity device) => emit(state.copyWith(selected: device));
}
