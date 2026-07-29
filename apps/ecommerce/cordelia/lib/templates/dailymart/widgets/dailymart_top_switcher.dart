import 'package:flutter/material.dart';

/// The pack's content-swap transition (spec sheet §7, content tier): a 300ms
/// ease fade whose in-flight children stay **top-aligned** — the default
/// `AnimatedSwitcher` layout centres a shorter child against a taller one
/// mid-swap, which floats a few-row body mid-screen. Used wherever a screen
/// swaps whole bodies (Search's loading/loaded/error, Product Details'
/// Descriptions/Reviews tabs).
class DailyMartTopSwitcher extends StatelessWidget {
  final Widget child;

  const DailyMartTopSwitcher({super.key, required this.child});

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    switchInCurve: Curves.easeInOut,
    switchOutCurve: Curves.easeInOut,
    layoutBuilder: (currentChild, previousChildren) => Stack(
      alignment: Alignment.topCenter,
      children: [...previousChildren, ?currentChild],
    ),
    child: child,
  );
}
