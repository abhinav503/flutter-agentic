import 'package:web_terminal/enums/device_platform.dart';
import '../../domain/entities/device_entity.dart';

/// Bridge DTO: `{ id, name, platform, isEmulator }`. Hand-parsed (not freezed) —
/// too small to justify codegen, matching AppModel.
class DeviceModel {
  final String id;
  final String name;
  final String platform; // 'web' | 'ios' | 'android' | 'other'
  final String kind; // 'web' | 'device' | 'emulator'
  final bool isEmulator;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.platform,
    required this.kind,
    this.isEmulator = false,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        id: json['id'] as String,
        name: json['name'] as String? ?? json['id'] as String,
        platform: json['platform'] as String? ?? 'other',
        kind: json['kind'] as String? ?? 'device',
        isEmulator: json['isEmulator'] as bool? ?? false,
      );

  DeviceEntity toEntity() => DeviceEntity(
        id: id,
        name: name,
        platform: platform.toDevicePlatform(),
        kind: kind.toDeviceKind(),
        isEmulator: isEmulator,
      );
}
