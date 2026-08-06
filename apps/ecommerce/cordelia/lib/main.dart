import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core/core/theme/app_theme_config.dart';

import 'app.dart';
import 'di/injection_container.dart';
import 'firebase_options.dart';
import 'services/crash_reporter_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Auth is only configured for Android/iOS (firebase_options.dart
  // throws on web) — guard so the web preview still boots; on device this
  // runs exactly as before.
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // After Firebase.initializeApp (Crashlytics needs the app) and before
  // runApp, so a failure during startup is still reported rather than lost.
  // No-ops on web and in debug — see CrashReporterService.
  CrashReporterService.instance.register();

  final config = await _loadThemeConfig();
  await initDependencies();

  runApp(App(themeConfig: config));
}

Future<AppThemeConfig> _loadThemeConfig() async {
  try {
    final raw = await rootBundle.loadString('assets/theme/theme_config.json');
    return AppThemeConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {
    return AppThemeConfig.defaults;
  }
}
