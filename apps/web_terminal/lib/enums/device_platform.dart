/// The coarse run-target category the UI branches on: a web target is embedded
/// in an iframe; a native target launches on the real device beside the
/// terminal. `other` covers desktop/unknown targets we don't special-case.
enum DevicePlatform { web, android, ios, other }

extension DevicePlatformX on DevicePlatform {
  bool get isWeb => this == DevicePlatform.web;
  bool get isNative =>
      this == DevicePlatform.android || this == DevicePlatform.ios;
}

// The bridge already categorizes devices, so this is a thin wire → enum map.
extension DevicePlatformParse on String {
  DevicePlatform toDevicePlatform() => switch (this) {
        'web' => DevicePlatform.web,
        'android' => DevicePlatform.android,
        'ios' => DevicePlatform.ios,
        _ => DevicePlatform.other,
      };
}

/// How a target is reached: the embedded web preview, an already-connected
/// device (run directly), or an offline emulator (booted first, then run).
enum DeviceKind { web, device, emulator }

extension DeviceKindParse on String {
  DeviceKind toDeviceKind() => switch (this) {
        'device' => DeviceKind.device,
        'emulator' => DeviceKind.emulator,
        _ => DeviceKind.web,
      };
}
