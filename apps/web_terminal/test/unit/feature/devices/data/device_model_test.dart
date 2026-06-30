import 'package:flutter_test/flutter_test.dart';
import 'package:web_terminal/enums/device_platform.dart';
import 'package:web_terminal/feature/devices/data/models/device_model.dart';

void main() {
  group('DeviceModel', () {
    test('parses a connected native device and maps the platform', () {
      final entity = DeviceModel.fromJson({
        'id': '1234-ABCD',
        'name': 'iPhone 15',
        'platform': 'ios',
        'kind': 'device',
        'isEmulator': true,
      }).toEntity();

      expect(entity.id, '1234-ABCD');
      expect(entity.name, 'iPhone 15');
      expect(entity.platform, DevicePlatform.ios);
      expect(entity.kind, DeviceKind.device);
      expect(entity.isNative, isTrue);
      expect(entity.isOfflineEmulator, isFalse);
    });

    test('parses an offline emulator target', () {
      final entity = DeviceModel.fromJson({
        'id': 'Pixel_7_Pro_API_35',
        'name': 'Pixel 7 Pro API 35',
        'platform': 'android',
        'kind': 'emulator',
        'isEmulator': true,
      }).toEntity();

      expect(entity.kind, DeviceKind.emulator);
      expect(entity.isOfflineEmulator, isTrue);
      expect(entity.isNative, isTrue);
    });

    test('maps the synthetic web preview to a web platform', () {
      final entity = DeviceModel.fromJson({
        'id': 'web-server',
        'name': 'Web preview',
        'platform': 'web',
      }).toEntity();

      expect(entity.isWeb, isTrue);
      expect(entity.isEmulator, isFalse);
    });

    test('falls back to other for an unknown platform', () {
      final entity = DeviceModel.fromJson({
        'id': 'x',
        'name': 'x',
        'platform': 'fuchsia',
      }).toEntity();

      expect(entity.platform, DevicePlatform.other);
      expect(entity.isNative, isFalse);
    });
  });
}
