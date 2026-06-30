/// One install step for a prerequisite. A runnable step carries a [command]
/// the user can run in the terminal; a [manual] step (App Store, IDE wizard)
/// carries a [note] instead because it can't be a shell command.
class SetupStep {
  final String label;
  final String? command;
  final String? note;
  final bool manual;

  const SetupStep({
    required this.label,
    this.command,
    this.note,
    this.manual = false,
  });
}

/// A local dev prerequisite (Flutter, Xcode, Node…), whether it's installed,
/// and the ordered steps to install it.
class SetupItemEntity {
  final String id;
  final String name;
  final String description;
  final bool installed;

  /// Probe output when installed (e.g. a version line); empty when not.
  final String detail;
  final List<SetupStep> steps;

  const SetupItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.installed,
    this.detail = '',
    this.steps = const [],
  });
}
