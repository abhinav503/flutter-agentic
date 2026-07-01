import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'di/injection_container.dart';
import 'firebase_options.dart';
import 'package:core/core/theme/app_theme_config.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Runs in a separate isolate. Keep it light; no navigation here — tapping the
  // delivered notification routes via onMessageOpenedApp / getInitialMessage.
  debugPrint('FCM background message: '
      'notification=${message.notification?.title} data=${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase/FCM aren't configured for web (firebase_options.dart throws on
  // web), so guard the init to keep the web preview bootable. On device this
  // runs exactly as before.
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

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
