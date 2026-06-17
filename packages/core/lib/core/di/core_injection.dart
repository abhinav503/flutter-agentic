import 'package:get_it/get_it.dart';

import '../services/shared_pref_service/shared_preference_service.dart';

/// Global service locator shared by every app in the workspace.
///
/// Each app registers its own feature data sources, repositories, and use
/// cases against this instance from its `di/injection_container.dart`.
final sl = GetIt.instance;

/// Initialises infrastructure shared across all apps.
///
/// Call this first from an app's `initDependencies()`, before registering any
/// feature-specific dependencies.
Future<void> initCoreDependencies() async {
  // Static singletons — accessed via `.instance`, never registered in GetIt.
  await SharedPreferenceService.instance.init();
}
