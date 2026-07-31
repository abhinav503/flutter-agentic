import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

/// The kit's floating Filter pill (`6007:3304`, drawn on the Search-results
/// frame) — a primary-filled 52px pill at radius 40 under
/// [DailyMartElevation.floatingAction], the funnel glyph and a 16/500
/// `onPrimary` label centred in it. It shrink-wraps its content rather than
/// stretching, so it can sit centred over a [DailyMartBottomFade].
///
/// The kit floats it on Search; this pack removed it from there (§10) and
/// My Orders is where it actually earns its place — that screen is the only
/// one with a filter to open. [active] draws the kit's plain pill with a
/// small `onPrimary` dot after the label, since a filter that's already
/// narrowing the list has to say so from the collapsed state — otherwise a
/// shopper looking at four of their twenty orders has nothing on screen
/// explaining why.
class DailyMartFilterPill extends StatelessWidget {
  final VoidCallback onTap;
  final bool active;

  const DailyMartFilterPill({
    super.key,
    required this.onTap,
    this.active = false,
  });

  static const _dotSize = 6.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(DailyMartDimenConst.filterPillRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: DailyMartElevation.floatingAction,
      ),
      child: Material(
        color: cs.primary,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            height: DailyMartDimenConst.filterPillHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppSvgImage.asset(
                  DailyMartImageConst.filterSolid,
                  color: cs.onPrimary,
                  width: AppSpacing.xl2,
                  height: AppSpacing.xl2,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  DailyMartValueConst.filterLabel,
                  style: DailyMartTextStyleConst.bodyMdMedium(
                    tt,
                  ).copyWith(color: cs.onPrimary),
                ),
                if (active) ...[
                  const SizedBox(width: AppSpacing.xs2),
                  Container(
                    width: _dotSize,
                    height: _dotSize,
                    decoration: BoxDecoration(
                      color: cs.onPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
