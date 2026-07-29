import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

/// Persistent "cart isn't empty" pill for DailyMart screens pushed *outside*
/// the shell (Product Details, Search) — inside the shell the cart is a nav
/// tab, which is the whole affordance, so the shell never docks this (spec
/// sheet §8). Rendered by the caller only while the shared cart is
/// non-empty.
///
/// Styled as the pack's floating-pill signature (primary fill, full radius,
/// the Filter FAB's shadow), not gravia's full-width docked bar.
class DailyMartCartStatusBar extends StatelessWidget {
  final int itemCount;
  final double grandTotal;
  final VoidCallback onTap;

  const DailyMartCartStatusBar({
    super.key,
    required this.itemCount,
    required this.grandTotal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.full,
        boxShadow: DailyMartElevation.floatingAction,
      ),
      child: Material(
        color: cs.primary,
        borderRadius: AppRadius.full,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.full,
          child: Container(
            height: DailyMartDimenConst.controlHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                AppSvgImage.asset(
                  DailyMartImageConst.navCart,
                  color: cs.onPrimary,
                  width: AppSpacing.xl2,
                  height: AppSpacing.xl2,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    DailyMartValueConst.cartSummaryLabel(itemCount, grandTotal),
                    style: DailyMartTextStyleConst.bodySmSemibold(
                      tt,
                    ).copyWith(color: cs.onPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  DailyMartValueConst.viewCartLabel,
                  style: DailyMartTextStyleConst.bodySmSemibold(
                    tt,
                  ).copyWith(color: cs.onPrimary),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: AppSpacing.xl2,
                  color: cs.onPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
