import 'dart:math';

import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

/// Firebase App Check — proves to Firebase that a request comes from this
/// app on a genuine device, so a script holding the public API key can't
/// drive Auth, Storage or Messaging as though it were the app.
///
/// Same static-singleton shape as [CrashReporterService]: private
/// constructor, `static final instance`, never in GetIt.
///
/// **No-op on web** — the web preview has no Firebase app (see `main.dart`),
/// and the console protects its own surface separately.
///
/// Providers by build, not by platform alone:
/// - Release: **Play Integrity** on Android, **App Attest** on iOS (with
///   DeviceCheck as Apple's fallback on hardware that predates it).
/// - Debug: the **debug provider** with a token this service mints once per
///   install and keeps in preferences, printed through `debugPrint` on
///   every debug boot (the SDK's own print goes to the native logger, which
///   `flutter run` doesn't reliably show, and only when a Firebase call
///   first asks for a token). Register it once in Firebase → App Check →
///   the app → *Manage debug tokens*, or a simulator/emulator (which can't
///   attest) is refused the moment enforcement is on.
///
/// Enforcement is a Firebase console switch, not code: the SDK ships
/// **unenforced** first, so every installed build keeps working while the
/// App Check metrics show what share of traffic is attested; the switch is
/// flipped once builds without this SDK are gone.
class AppCheckService {
  AppCheckService._();
  static final AppCheckService instance = AppCheckService._();

  static const _debugTokenKey = 'app_check_debug_token';

  /// Call once, after `Firebase.initializeApp` and the preferences service
  /// are up, and before anything that talks to Firebase (Auth sign-in,
  /// Storage upload, FCM token).
  Future<void> activate() async {
    if (kIsWeb) return;
    try {
      final debugToken = kDebugMode ? await _debugToken() : null;
      if (debugToken != null) {
        debugPrint(
          'App Check debug token (register in Firebase → App Check → '
          'Manage debug tokens): $debugToken',
        );
      }
      await FirebaseAppCheck.instance.activate(
        providerAndroid: kDebugMode
            ? AndroidDebugProvider(debugToken: debugToken)
            : const AndroidPlayIntegrityProvider(),
        providerApple: kDebugMode
            ? AppleDebugProvider(debugToken: debugToken)
            : const AppleAppAttestWithDeviceCheckFallbackProvider(),
      );
      // Keeps the token fresh in the background, so the first Firebase
      // call after a long idle doesn't pay an attestation round trip.
      await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
    } catch (e, st) {
      // Attestation failing must never stop the app from booting: while
      // unenforced, requests still succeed without a token; once enforced,
      // the Firebase call itself fails with a clear error. Either way, a
      // report is more useful than a crash on the splash screen.
      debugPrint('AppCheck activate failed: $e');
      FlutterError.reportError(
        FlutterErrorDetails(exception: e, stack: st, library: 'app_check'),
      );
    }
  }

  /// One token per install, so it is registered once rather than on every
  /// run. A UUID v4 from the secure generator — the shape Firebase expects.
  Future<String> _debugToken() async {
    final prefs = SharedPreferenceService.instance;
    final existing = prefs.getString(_debugTokenKey);
    if (existing != null) return existing;
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    final token =
        '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
                '${hex.substring(16, 20)}-${hex.substring(20)}'
            .toUpperCase();
    await prefs.setString(_debugTokenKey, token);
    return token;
  }
}
