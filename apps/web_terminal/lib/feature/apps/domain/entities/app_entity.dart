enum AppRunStatus { stopped, starting, running }

/// A Flutter app under `apps/` the terminal can preview. [previewPort] is the
/// deterministic port the bridge runs it on.
class AppEntity {
  final String name;
  final String path;
  final int previewPort;
  final AppRunStatus status;

  const AppEntity({
    required this.name,
    required this.path,
    required this.previewPort,
    this.status = AppRunStatus.stopped,
  });

  bool get isRunning => status == AppRunStatus.running;
  bool get isStarting => status == AppRunStatus.starting;

  String get previewUrl => 'http://localhost:$previewPort';

  // Equality by name only (status excluded) so re-fetches don't churn the
  // preview dropdown's selected identity.
  @override
  bool operator ==(Object other) => other is AppEntity && other.name == name;

  @override
  int get hashCode => name.hashCode;
}
