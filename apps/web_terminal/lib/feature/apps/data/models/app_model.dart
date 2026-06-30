import '../../domain/entities/app_entity.dart';

/// Bridge DTO: `{ name, path, previewPort, status }`. Hand-parsed (not freezed)
/// — too small to justify codegen.
class AppModel {
  final String name;
  final String path;
  final int? previewPort; // null for a native run (no embeddable web port)
  final String status; // 'stopped' | 'starting' | 'running' | 'failed'
  final String? message; // set when status is 'failed'

  const AppModel({
    required this.name,
    required this.path,
    required this.previewPort,
    this.status = 'stopped',
    this.message,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) => AppModel(
        name: json['name'] as String,
        path: json['path'] as String? ?? '',
        previewPort: json['previewPort'] as int?,
        status: json['status'] as String? ?? 'stopped',
        message: json['message'] as String?,
      );

  AppEntity toEntity() => AppEntity(
        name: name,
        path: path,
        previewPort: previewPort,
        message: message,
        status: switch (status) {
          'running' => AppRunStatus.running,
          'starting' => AppRunStatus.starting,
          'failed' => AppRunStatus.failed,
          _ => AppRunStatus.stopped,
        },
      );
}
