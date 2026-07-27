import 'package:flutter/material.dart';

import 'package:core/core/theme/app_theme_config.dart';

/// Holds the [AppThemeConfig] currently driving [MaterialApp.router]'s
/// `theme`/`darkTheme`. Starts at CordeliaApps' own bundled app-level brand
/// config ([appDefault]) and can be swapped at runtime — a storefront
/// applies its store's template config on entry and restores the app
/// default on exit, proving the theme is a runtime decision (once a store
/// is opened), not a per-build one. See
/// docs/explanation/superapp-ecommerce-plan.md.
///
/// A `ValueNotifier`, not a Cubit — mirrors [ThemeModeController]'s reasoning
/// (`core` stays dependency-lean, no `flutter_bloc`), kept app-local here
/// since only `cordelia` needs it today.
class ActiveThemeController extends ValueNotifier<AppThemeConfig> {
  final AppThemeConfig appDefault;

  ActiveThemeController(this.appDefault) : super(appDefault);

  void apply(AppThemeConfig config) => value = config;

  void resetToAppDefault() => value = appDefault;
}
