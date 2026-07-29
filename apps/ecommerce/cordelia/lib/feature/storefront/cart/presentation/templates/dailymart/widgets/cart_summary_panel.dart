import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';

import '../../../../domain/entities/cart_item_entity.dart';

/// The cart's coupon row + totals breakdown (kit frames `24`/`25`) —
/// rendered inside the cart's scroll, after the item cards, so a long cart
/// keeps the whole breakdown reachable while only the checkout CTA
/// ([DailyMartCartCheckoutBar]) stays docked.
class DailyMartCartSummarySection extends StatelessWidget {
  final List<CartItemEntity> items;
  final VoidCallback onApplyCoupon;

  const DailyMartCartSummarySection({
    super.key,
    required this.items,
    required this.onApplyCoupon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    final mutedLabel = DailyMartTextStyleConst.bodyMdRegular(
      tt,
    ).copyWith(color: cs.onSurfaceVariant);
    final inkValue = DailyMartTextStyleConst.bodyMdSemibold(
      tt,
    ).copyWith(color: cs.onSurface);
    final primaryValue = DailyMartTextStyleConst.bodyMdSemibold(
      tt,
    ).copyWith(color: cs.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CouponRow(onTap: onApplyCoupon),
        const SizedBox(height: AppSpacing.lg),
        _SummaryRow(
          label: DailyMartValueConst.subTotalLabel,
          value: DailyMartValueConst.formattedPrice(items.itemTotal),
          labelStyle: mutedLabel,
          valueStyle: inkValue,
        ),
        const SizedBox(height: AppSpacing.base),
        _SummaryRow(
          label: DailyMartValueConst.deliveryLabel,
          value: DailyMartValueConst.deliveryFreeLabel,
          labelStyle: mutedLabel,
          valueStyle: primaryValue,
        ),
        const SizedBox(height: AppSpacing.base),
        _SummaryRow(
          label: DailyMartValueConst.discountLabel,
          value: DailyMartValueConst.formattedPrice(items.discountTotal),
          labelStyle: mutedLabel,
          valueStyle: primaryValue,
        ),
        const SizedBox(height: AppSpacing.lg),
        Divider(height: 1, thickness: 1, color: colors.dockedHairline),
        const SizedBox(height: AppSpacing.lg),
        _SummaryRow(
          label: DailyMartValueConst.totalCostLabel,
          value: DailyMartValueConst.formattedPrice(items.grandTotal),
          labelStyle: DailyMartTextStyleConst.bodyMdSemibold(
            tt,
          ).copyWith(color: cs.onSurface),
          valueStyle: DailyMartTextStyleConst.bodyLgSemibold(
            tt,
          ).copyWith(color: cs.onSurface),
        ),
      ],
    );
  }
}

/// The cart's one docked control — the checkout CTA on a sheet-cornered
/// surface lifted on the nav shadow, separating from the scrolling list the
/// same way the bottom nav does (spec sheet §6). The totals live in the
/// scroll ([DailyMartCartSummarySection]), not here.
class DailyMartCartCheckoutBar extends StatelessWidget {
  final bool busy;
  final VoidCallback onCheckout;

  const DailyMartCartCheckoutBar({
    super.key,
    required this.busy,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(shapes.sheetRadius),
        ),
        boxShadow: DailyMartElevation.nav,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: DailyMartPrimaryButton(
            label: DailyMartValueConst.proceedToCheckoutLabel,
            state: busy ? AppButtonState.loading : AppButtonState.idle,
            onTap: busy ? null : onCheckout,
          ),
        ),
      ),
    );
  }
}

/// The coupon trigger — a recessed field-shaped row (badge glyph, the code,
/// a chevron). No coupon backend exists yet, so the caller stubs the tap
/// with the app's coming-soon snackbar, same as gravia's Apply.
class _CouponRow extends StatelessWidget {
  final VoidCallback onTap;

  const _CouponRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: AppRadius.lg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lg,
        child: Container(
          height: DailyMartDimenConst.controlHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                Icons.discount_outlined,
                size: AppSpacing.xl2,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  DailyMartValueConst.couponLabel,
                  style: DailyMartTextStyleConst.bodySmSemibold(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: AppSpacing.xl4,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: labelStyle),
      Text(value, style: valueStyle),
    ],
  );
}
