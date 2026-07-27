import 'package:flutter/material.dart';

import 'active_theme_controller.dart';

/// Exposes [ActiveThemeController] to descendants (e.g. `StorefrontPage`)
/// without a service locator — mirrors `core`'s `ThemeModeScope` shape.
class ActiveThemeScope extends InheritedWidget {
  final ActiveThemeController controller;

  const ActiveThemeScope({
    super.key,
    required this.controller,
    required super.child,
  });

  static ActiveThemeController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ActiveThemeScope>();
    assert(scope != null, 'No ActiveThemeScope found in context');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(ActiveThemeScope oldWidget) =>
      controller != oldWidget.controller;
}
