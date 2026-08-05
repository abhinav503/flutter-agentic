import 'package:flutter/material.dart';

import 'active_locale_controller.dart';

/// Exposes [ActiveLocaleController] to descendants (e.g. `StorefrontPage`,
/// the Profile language row) without a service locator — mirrors
/// `ActiveThemeScope`.
class ActiveLocaleScope extends InheritedWidget {
  final ActiveLocaleController controller;

  const ActiveLocaleScope({
    super.key,
    required this.controller,
    required super.child,
  });

  static ActiveLocaleController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ActiveLocaleScope>();
    assert(scope != null, 'No ActiveLocaleScope found in context');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(ActiveLocaleScope oldWidget) =>
      controller != oldWidget.controller;
}
