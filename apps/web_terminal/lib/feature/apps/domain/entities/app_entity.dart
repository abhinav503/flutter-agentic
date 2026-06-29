enum AppRunStatus { stopped, starting, running, failed }

/// A Flutter app under `apps/` the terminal can preview. [previewPort] is the
/// deterministic port the bridge runs it on. [message] explains a [failed] run.
class AppEntity {
  final String name;
  final String path;
  final int? previewPort; // null for a native run (launched on a device)
  final AppRunStatus status;
  final String? message;

  const AppEntity({
    required this.name,
    required this.path,
    required this.previewPort,
    this.status = AppRunStatus.stopped,
    this.message,
  });

  bool get isRunning => status == AppRunStatus.running;
  bool get isStarting => status == AppRunStatus.starting;

  // Only a web target has an embeddable preview; null for native runs.
  String? get previewUrl =>
      previewPort == null ? null : 'http://localhost:$previewPort';

  // Equality by name only (status excluded) so re-fetches don't churn the
  // preview dropdown's selected identity.
  @override
  bool operator ==(Object other) => other is AppEntity && other.name == name;

  @override
  int get hashCode => name.hashCode;
}
