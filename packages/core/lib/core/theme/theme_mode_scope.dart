import 'package:flutter/material.dart';

import 'theme_mode_controller.dart';

/// Exposes the app's [ThemeModeController] to descendants (e.g. an AppBar
/// toggle) without a service locator. `App` wraps `MaterialApp` with this, so a
/// page can reach the controller via [maybeOf] and advance it.
///
/// [maybeOf] returns null when no scope is present (e.g. a widget test that
/// pumps a screen directly), so callers can omit the toggle gracefully.
class ThemeModeScope extends InheritedWidget {
  final ThemeModeController controller;

  const ThemeModeScope({
    super.key,
    required this.controller,
    required super.child,
  });

  static ThemeModeController? maybeOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<ThemeModeScope>()
          ?.controller;

  static ThemeModeController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(controller != null, 'No ThemeModeScope found in context');
    return controller!;
  }

  @override
  bool updateShouldNotify(ThemeModeScope oldWidget) =>
      controller != oldWidget.controller;
}
