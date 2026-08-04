import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/app_switcher.dart';

/// The pack's content swap — core's [AppSwitcher] at dailymart's own tier, so
/// a skeleton → loaded → empty → error transition can't drift per screen.
///
/// [curve] is a passthrough rather than a fixed tier because Notifications
/// eases its swap where the rest of the pack takes the atom's default; the
/// override stays visible at that one call site instead of silently becoming
/// the pack's rule.
class DailyMartSwitcher extends StatelessWidget {
  final Widget child;
  final Curve? curve;

  const DailyMartSwitcher({super.key, required this.child, this.curve});

  @override
  Widget build(BuildContext context) => curve == null
      ? AppSwitcher(child: child)
      : AppSwitcher(curve: curve!, child: child);
}
