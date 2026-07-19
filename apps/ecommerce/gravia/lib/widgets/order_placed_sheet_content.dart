import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/concentric_circles.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_primary_button.dart';

/// The Cart screen's "Proceed to Checkout" confirmation. Unlike every other
/// gravia sheet, the kit's spec has no title row and no close control — just
/// a handle, the success graphic, copy, and the CTA — so this is built
/// directly (`showOrderPlacedSheet` in `gravia_sheet.dart` calls
/// `showModalBottomSheet` itself) rather than through
/// `showGraviaSheet`/`AppBottomSheet`, same reasoning as the onboarding
/// sheet (see `OnboardingScreen`).
class OrderPlacedSheetContent extends StatelessWidget {
  final VoidCallback onTrackOrder;

  const OrderPlacedSheetContent({super.key, required this.onTrackOrder});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(shapes.sheetRadius),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl4,
            AppSpacing.xs2,
            AppSpacing.xl4,
            AppSpacing.xl2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 3,
                margin: const EdgeInsets.only(bottom: AppSpacing.xl4),
                decoration: BoxDecoration(
                  color: cs.sheetHairline,
                  borderRadius: AppRadius.full,
                ),
              ),
              _SuccessIcon(cs: cs),
              const SizedBox(height: AppSpacing.xl4),
              Text(
                ValueConst.orderPlacedTitle,
                textAlign: TextAlign.center,
                style: TextStyleConst.displayXsBold(
                  tt,
                ).copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                ValueConst.orderPlacedSubtitle,
                textAlign: TextAlign.center,
                style: TextStyleConst.textSmRegular(tt).copyWith(
                  // Asymmetric pick (not a single ColorScheme role): Gray/700
                  // in light, white in dark — same reasoning as
                  // ColorScheme.dockedHairline/sheetHairline, matches the
                  // Verify Email sheet's subtitle.
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : ColorConst.gray700,
                ),
              ),
              const SizedBox(height: AppSpacing.xl4),
              GraviaPrimaryButton(
                label: ValueConst.trackYourOrderLabel,
                onTap: onTrackOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Concentric-circle success graphic — no glass. Two identical translucent
/// primary rings (outer, middle) stacked on top of each other so the
/// overlapping area reads visually darker than either alone, plus a solid
/// primary disc holding the check glyph. → [AppConcentricCircles] (core),
/// which owns the outer-in cascading reveal animation.
class _SuccessIcon extends StatelessWidget {
  final ColorScheme cs;

  const _SuccessIcon({required this.cs});

  static const double _outerSize = 128;
  static const double _middleSize = 96;
  static const double _innerSize = 64;
  static const double _iconSize = 28;

  @override
  Widget build(BuildContext context) => AppConcentricCircles(
    radii: const [_outerSize, _middleSize, _innerSize],
    colors: [
      cs.primary.withValues(alpha: 0.1),
      cs.primary.withValues(alpha: 0.1),
      cs.primary,
    ],
    child: AppSvgImage.asset(
      ImageConst.circleCheck,
      color: cs.onPrimary,
      width: _iconSize,
      height: _iconSize,
    ),
  );
}
