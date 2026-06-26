import '../../domain/entities/setup_item_entity.dart';

/// Bridge DTO for one install step. Hand-parsed (not freezed) — too small to
/// justify codegen, matching the apps feature's `AppModel`.
class SetupStepModel {
  final String label;
  final String? command;
  final String? note;
  final bool manual;

  const SetupStepModel({
    required this.label,
    this.command,
    this.note,
    this.manual = false,
  });

  factory SetupStepModel.fromJson(Map<String, dynamic> json) => SetupStepModel(
        label: json['label'] as String,
        command: json['command'] as String?,
        note: json['note'] as String?,
        manual: json['manual'] as bool? ?? false,
      );

  SetupStep toEntity() =>
      SetupStep(label: label, command: command, note: note, manual: manual);
}

/// Bridge DTO: `{ id, name, description, installed, detail, steps }`.
class SetupItemModel {
  final String id;
  final String name;
  final String description;
  final bool installed;
  final String detail;
  final List<SetupStepModel> steps;

  const SetupItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.installed,
    this.detail = '',
    this.steps = const [],
  });

  factory SetupItemModel.fromJson(Map<String, dynamic> json) => SetupItemModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        installed: json['installed'] as bool? ?? false,
        detail: json['detail'] as String? ?? '',
        steps: (json['steps'] as List? ?? [])
            .cast<Map<String, dynamic>>()
            .map(SetupStepModel.fromJson)
            .toList(),
      );

  SetupItemEntity toEntity() => SetupItemEntity(
        id: id,
        name: name,
        description: description,
        installed: installed,
        detail: detail,
        steps: steps.map((s) => s.toEntity()).toList(),
      );
}
