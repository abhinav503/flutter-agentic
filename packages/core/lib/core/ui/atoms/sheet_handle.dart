import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';

/// The grab bar at the top of a bottom sheet — 44 × 3, fully rounded.
///
/// [AppBottomSheet] draws one for the sheets it owns, but a sheet that opts
/// out of the header (or that a pack presents itself) still needs the same
/// bar, and each was hand-drawing the two numbers. One widget so the affordance
/// can't come out a different size on one sheet than another.
///
/// [color] defaults to the theme's `onSurfaceVariant` at 40% — packs whose kit
/// specs a hairline pass `context.appColors.sheetHairline`.
class SheetHandle extends StatelessWidget {
  static const Size defaultSize = Size(44, 3);

  final Color? color;
  final Size size;

  /// Space under the bar. Zero by default: [AppBottomSheet] centres it in
  /// its own symmetric padding, while a hand-built sheet body usually wants
  /// the gap on this side only.
  final double bottomSpacing;

  const SheetHandle({
    super.key,
    this.color,
    this.size = defaultSize,
    this.bottomSpacing = 0,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: size.width,
    height: size.height,
    margin: EdgeInsets.only(bottom: bottomSpacing),
    decoration: BoxDecoration(
      color:
          color ??
          Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      borderRadius: AppRadius.full,
    ),
  );
}
