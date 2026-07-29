import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';

/// DailyMart's quantity stepper — a square green **−**, the count at
/// Heading/H5, and a matching square green **+**, sitting bare on the
/// surface. (The kit exported the + as a round disc; it's squared to the
/// −'s silhouette so the pair reads as one control.)
///
/// Deliberately **not** built on core's `QuantityStepper`: that block draws a
/// bordered, tinted pill *around* the controls, and this kit draws no
/// container at all — overriding the pill away would mean fighting every one
/// of its style slots (same §12 reasoning as `DailyMartProductCard` vs the
/// product-card block).
///
/// A null [onDecrement]/[onIncrement] disables that side, dimming it by
/// opacity. The assets are bare glyphs; the square container ([AppRadius.sm]
/// at `cs.primary`) is drawn here, so the disc restyles with the theme
/// instead of shipping baked into the SVG.
class DailyMartQuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  /// The control disc's edge — 24 in the kit's Product Details; cart rows
  /// may size it down.
  final double controlSize;

  /// Both glyphs ship on the same square 16 canvas (the minus bar centered
  /// with transparent margins), rendered at 16/24 of the kit's 24px disc.
  /// The square canvas is load-bearing: `SvgPicture` stretches a non-square
  /// canvas to fill an explicit width x height box, so a bare 14x2 bar
  /// renders as a fat block.
  static const double _kitControlSize = 24;
  static const double _glyphCanvasSize = 16;

  const DailyMartQuantityStepper({
    super.key,
    required this.value,
    this.onIncrement,
    this.onDecrement,
    this.controlSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepControl(
          asset: DailyMartImageConst.minus,
          size: controlSize,
          glyphSize: controlSize * _glyphCanvasSize / _kitControlSize,
          onTap: onDecrement,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Text(
            '$value',
            style: DailyMartTextStyleConst.headingH5(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
        ),
        _StepControl(
          asset: DailyMartImageConst.plus,
          size: controlSize,
          glyphSize: controlSize * _glyphCanvasSize / _kitControlSize,
          onTap: onIncrement,
        ),
      ],
    );
  }
}

class _StepControl extends StatelessWidget {
  final String asset;
  final double size;
  final double glyphSize;
  final VoidCallback? onTap;

  const _StepControl({
    required this.asset,
    required this.size,
    required this.glyphSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Opacity(
      opacity: onTap == null ? 0.38 : 1,
      child: Material(
        color: cs.primary,
        borderRadius: AppRadius.sm,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.sm,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: AppSvgImage.asset(
                asset,
                color: cs.onPrimary,
                width: glyphSize,
                height: glyphSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
