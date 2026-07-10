import 'package:core/core/di/core_injection.dart';

// Re-export the shared service locator so consumers can import `sl` from the
// app's own DI entrypoint.
export 'package:core/core/di/core_injection.dart' show sl;

/// Wires the Gravia app: shared core services first, then this app's
/// features (data sources → repositories → use cases) as they land.
Future<void> initDependencies() async {
  await initCoreDependencies();
}
