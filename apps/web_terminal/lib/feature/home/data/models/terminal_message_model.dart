import '../../domain/entities/terminal_output_entity.dart';

/// Inbound bridge frame: `{ "type": "output"|"exit", "data": string, "code":
/// int }`. Hand-parsed (not freezed) — too small to justify codegen.
class TerminalMessageModel {
  final String type;
  final String data;
  final int? code;

  const TerminalMessageModel({
    required this.type,
    this.data = '',
    this.code,
  });

  factory TerminalMessageModel.fromJson(Map<String, dynamic> json) =>
      TerminalMessageModel(
        type: json['type'] as String? ?? 'output',
        data: json['data'] as String? ?? '',
        code: json['code'] as int?,
      );

  bool get isExit => type == 'exit';

  TerminalOutputEntity toEntity() => isExit
      ? TerminalOutputEntity.exit(code)
      : TerminalOutputEntity.output(data);
}
