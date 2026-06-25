import '../../domain/entities/app_entity.dart';

/// Bridge DTO: `{ name, path, previewPort, status }`. Hand-parsed (not freezed)
/// — too small to justify codegen.
class AppModel {
  final String name;
  final String path;
  final int previewPort;
  final String status; // 'stopped' | 'starting' | 'running'

  const AppModel({
    required this.name,
    required this.path,
    required this.previewPort,
    this.status = 'stopped',
  });

  factory AppModel.fromJson(Map<String, dynamic> json) => AppModel(
        name: json['name'] as String,
        path: json['path'] as String? ?? '',
        previewPort: json['previewPort'] as int,
        status: json['status'] as String? ?? 'stopped',
      );

  AppEntity toEntity() => AppEntity(
        name: name,
        path: path,
        previewPort: previewPort,
        status: switch (status) {
          'running' => AppRunStatus.running,
          'starting' => AppRunStatus.starting,
          _ => AppRunStatus.stopped,
        },
      );
}
