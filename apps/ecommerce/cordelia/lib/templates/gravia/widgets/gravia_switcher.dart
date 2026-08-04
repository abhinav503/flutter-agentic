import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/app_switcher.dart';

/// The pack's content swap — core's [AppSwitcher] at gravia's own tier, so a
/// skeleton → loaded → empty → error transition can't drift per screen.
///
/// Gravia takes the atom's defaults; the wrapper exists so that stays true of
/// every screen at once, the same role [GrofastSwitcher] plays for its pack.
class GraviaSwitcher extends StatelessWidget {
  final Widget child;

  /// Passthrough: the atom centres its child in the available height, which
  /// floats a short body (a few search suggestions) mid-sheet. Layout, not
  /// timing — so it stays a per-screen call, unlike the duration the wrapper
  /// pins.
  final bool topAligned;

  const GraviaSwitcher({
    super.key,
    required this.child,
    this.topAligned = false,
  });

  @override
  Widget build(BuildContext context) =>
      AppSwitcher(topAligned: topAligned, child: child);
}
