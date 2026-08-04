import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/app_switcher.dart';

/// The pack's content-swap transition (spec sheet §7, content tier): core's
/// [AppSwitcher] fade with an ease curve and **top-aligned** in-flight
/// children — the default layout centres a shorter child against a taller
/// one mid-swap, which floats a few-row body mid-screen. Used wherever a
/// screen swaps whole bodies (Search's loading/loaded/error, Product
/// Details' Descriptions/Reviews tabs).
class DailyMartTopSwitcher extends StatelessWidget {
  final Widget child;

  const DailyMartTopSwitcher({super.key, required this.child});

  @override
  Widget build(BuildContext context) =>
      AppSwitcher(curve: Curves.easeInOut, topAligned: true, child: child);
}
