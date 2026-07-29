import 'package:flutter/material.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';

/// The `surface → transparent` fade every DailyMart floating action sits
/// over (spec sheet §11) — an [IgnorePointer] so the list beneath stays
/// scrollable through it. The zero-alpha end stop reuses the surface
/// colour: `Colors.transparent` produces a grey halo on some engines.
///
/// Position it yourself (`Positioned` across the stack's bottom edge);
/// this widget is only the gradient.
class DailyMartBottomFade extends StatelessWidget {
  final double height;

  /// The colour the fade dissolves into — pass the canvas actually behind it
  /// when that isn't `cs.surface` (e.g. Home's mint `cs.canvas`).
  final Color? color;

  const DailyMartBottomFade({
    super.key,
    this.height = DailyMartDimenConst.bottomFadeHeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final fadeColor = color ?? Theme.of(context).colorScheme.surface;

    return IgnorePointer(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.24, 1],
            colors: [fadeColor, fadeColor.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
