import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'di/injection_container.dart';
import 'firebase_options.dart';
import 'package:core/core/theme/app_theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
