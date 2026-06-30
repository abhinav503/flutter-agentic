import 'package:web_terminal/enums/device_platform.dart';

/// A run target the terminal can launch an app on. The synthetic "Web preview"
/// ([id] `web-server`) embeds in the iframe; native devices launch on the real
/// simulator/emulator/phone. An [DeviceKind.emulator] target is offline and gets
/// booted before the run.
class DeviceEntity {
  final String id;
  final String name;
  final DevicePlatform platform;
  final DeviceKind kind;
  final bool isEmulator;

  const DeviceEntity({
    required this.id,
    required this.name,
    required this.platform,
    this.kind = DeviceKind.device,
    this.isEmulator = false,
  });

  bool get isWeb => platform.isWeb;
  bool get isNative => platform.isNative;
  bool get isOfflineEmulator => kind == DeviceKind.emulator;

  // Equality by id so device-list re-fetches don't churn the dropdown selection.
  @override
  bool operator ==(Object other) => other is DeviceEntity && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
