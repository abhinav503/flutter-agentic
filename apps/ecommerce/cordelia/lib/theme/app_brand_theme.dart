import 'package:flutter/material.dart';

import 'package:core/core/theme/app_theme.dart';

import 'active_theme_scope.dart';

/// Pins its subtree to CordeliaApps' own brand theme, whatever store theme
/// the app happens to be wearing.
///
/// The auth screens belong to the app, not to any store — but since a guest
/// can browse, Login is now *pushed over a storefront*, and a storefront has
/// swapped `MaterialApp.theme` for that store's template config. So the same
/// Login drew a neutral grey input outline (`#ADADAD`) when reached from
/// Discovery and a pale green one (`#DCE3E1`) when reached from inside a
/// `grofast` store — one screen, three looks.
///
/// A `Theme` override rather than something at the `MaterialApp` level: the
/// store's theme must survive underneath, because the shopper pops straight
/// back onto that storefront.
class AppBrandTheme extends StatelessWidget {
  final Widget child;

  const AppBrandTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Theme(
    // Follows the device/user light-dark choice; only the palette is pinned.
    data: AppTheme.fromConfig(
      ActiveThemeScope.of(context).appDefault,
      dark: Theme.of(context).brightness == Brightness.dark,
    ),
    child: child,
  );
}
