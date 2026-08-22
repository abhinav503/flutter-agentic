import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/bottom_fade.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';

/// The `surface → transparent` fade every DailyMart floating action sits
/// over (spec sheet §11) — core's [BottomFade] at this pack's height, whose
/// default `solidUntil` is already the 0.24 the spec calls for.
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
  Widget build(BuildContext context) =>
      BottomFade(height: height, color: color);
}
