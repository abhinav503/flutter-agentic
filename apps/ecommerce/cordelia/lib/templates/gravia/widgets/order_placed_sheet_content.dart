import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/concentric_circles.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_primary_button.dart';

/// The Cart screen's "Proceed to Checkout" confirmation. Unlike every other
/// gravia sheet, the kit's spec has no title row and no close control — just
/// a handle, the success graphic, copy, and the CTA — so this is built
/// directly (`showOrderPlacedSheet` in `gravia_sheet.dart` calls
/// `showModalBottomSheet` itself) rather than through `showGraviaSheet`.
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
                  color: context.appColors.sheetHairline,
                  borderRadius: AppRadius.full,
                ),
              ),
              _SuccessIcon(cs: cs),
              const SizedBox(height: AppSpacing.xl4),
              Text(
                GraviaValueConst.orderPlacedTitle,
                textAlign: TextAlign.center,
                style: GraviaTextStyleConst.displayXsBold(
                  tt,
                ).copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                GraviaValueConst.orderPlacedSubtitle,
                textAlign: TextAlign.center,
                style: GraviaTextStyleConst.textSmRegular(
                  tt,
                ).copyWith(color: context.appColors.onSheetMuted),
              ),
              const SizedBox(height: AppSpacing.xl4),
              GraviaPrimaryButton(
                label: GraviaValueConst.trackYourOrderLabel,
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
/// primary disc holding the check glyph.
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
      // Not tintedPrimaryFill: the rings must stay translucent so the
      // middle circle compositing over the outer one reads darker — an
      // opaque pastel would flatten both rings to one tone.
      cs.primary.withValues(alpha: 0.1),
      cs.primary.withValues(alpha: 0.1),
      cs.primary,
    ],
    child: AppSvgImage.asset(
      GraviaImageConst.circleCheck,
      color: cs.onPrimary,
      width: _iconSize,
      height: _iconSize,
    ),
  );
}
