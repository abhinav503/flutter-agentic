import 'package:flutter/material.dart';

import '../services/shared_pref_service/shared_preference_service.dart';

/// App theme-mode holder, persisted across launches.
///
/// Implemented as a [ValueNotifier] rather than a Cubit so it lives in
/// dependency-lean `core` without pulling in `flutter_bloc`. Drive
/// [MaterialApp.themeMode] from it:
/// ```dart
/// final themeMode = ThemeModeController()..load();
/// ValueListenableBuilder<ThemeMode>(
///   valueListenable: themeMode,
///   builder: (_, mode, __) => MaterialApp.router(
///     theme: AppTheme.fromConfig(config),
///     darkTheme: AppTheme.fromConfig(config, dark: true),
///     themeMode: mode,
///     ...
///   ),
/// );
/// ```
/// A toggle then calls [cycle] (System → Light → Dark) or [setMode] directly.
class ThemeModeController extends ValueNotifier<ThemeMode> {
  ThemeModeController([super.initial = ThemeMode.system]);

  static const _key = 'core.themeMode';

  /// Restores the persisted choice (defaults to [ThemeMode.system]). Call once
  /// after `SharedPreferenceService.init()` — i.e. after `initCoreDependencies()`.
  /// Defensive: if prefs isn't initialised yet (e.g. a widget test that pumps
  /// the app without DI), it silently keeps [ThemeMode.system].
  void load() {
    try {
      value = _fromName(SharedPreferenceService.instance.getString(_key));
    } catch (_) {
      value = ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == value) return;
    value = mode; // update in-memory first so the UI reacts even if persist fails
    try {
      await SharedPreferenceService.instance.setString(_key, mode.name);
    } catch (_) {
      // Prefs not ready (e.g. a test) — keep the in-memory value; the choice
      // just won't survive a restart.
    }
  }

  /// System → Light → Dark → System (for a single cycling toggle button).
  Future<void> cycle() => setMode(switch (value) {
        ThemeMode.system => ThemeMode.light,
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
      });

  static ThemeMode _fromName(String? name) => switch (name) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}
