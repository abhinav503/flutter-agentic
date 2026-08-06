import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Crash and non-fatal error reporting, via Firebase Crashlytics.
///
/// Infrastructure with a shared resource, so it follows the static-singleton
/// pattern the other services here use — private constructor,
/// `static final instance`, never registered in GetIt.
///
/// **Every method is a no-op on web and in debug.** `firebase_crashlytics` has
/// no web implementation, and the app is previewed as Flutter Web, so an
/// unguarded call would throw in the console preview. Debug is excluded
/// separately: a developer's own hot-reload exceptions are noise that would
/// bury the reports from real devices, and Crashlytics cannot un-send them.
class CrashReporterService {
  CrashReporterService._();

  static final CrashReporterService instance = CrashReporterService._();

  /// False on web and in debug — the one place the guard is expressed, so a
  /// new method can't forget it.
  bool get _enabled => !kIsWeb && !kDebugMode;

  /// Routes Flutter's own error channels into Crashlytics. Call once, before
  /// `runApp`.
  ///
  /// Two channels, because they catch different things: `FlutterError.onError`
  /// is for errors raised inside the framework (a failed build, a layout
  /// overflow that throws), while `PlatformDispatcher.onError` catches
  /// everything that escapes the Dart zone — an unawaited Future that rejects,
  /// for instance, which the framework handler never sees.
  void register() {
    if (!_enabled) return;

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // true = handled, so the platform doesn't also kill the isolate on an
      // error we have already recorded and can survive.
      return true;
    };
  }

  /// Reports something that was caught and handled — a failed request, a parse
  /// that fell back to a default. Non-fatal, so it lands in Crashlytics without
  /// counting against the crash-free-users rate.
  ///
  /// [reason] is what shows in the issue title, so make it specific enough to
  /// tell two call sites apart.
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
  }) async {
    if (!_enabled) return;
    await FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: reason,
      fatal: false,
    );
  }

  /// Breadcrumb attached to whatever crash comes next. Cheap, kept in a ring
  /// buffer, and only uploaded when a report is actually sent — so log the
  /// steps that would let you reconstruct a crash, never anything personal.
  Future<void> log(String message) async {
    if (!_enabled) return;
    await FirebaseCrashlytics.instance.log(message);
  }
}
