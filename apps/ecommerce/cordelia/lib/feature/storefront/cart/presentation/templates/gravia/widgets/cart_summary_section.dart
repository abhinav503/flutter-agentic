import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:flutter/material.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import '../../../../domain/entities/cart_item_entity.dart';

/// Coupon row + the Item Total/Discount/Delivery/Grand Total breakdown,
/// computed from [CartItemsX] — no coupon backend exists yet, so Apply is a
/// stub (matches the `onComingSoon` pattern used elsewhere in this app for
/// unbuilt flows).
class CartSummarySection extends StatelessWidget {
  final List<CartItemEntity> items;
  final VoidCallback onApplyCoupon;

  const CartSummarySection({
    super.key,
    required this.items,
    required this.onApplyCoupon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onApplyCoupon,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.base,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: cs.outlineVariant),
              borderRadius: AppRadius.full,
            ),
            child: Row(
              children: [
                AppSvgImage.asset(
                  GraviaImageConst.gift,
                  color: isDark ? cs.onPrimary : GraviaColorConst.gray900,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    GraviaValueConst.couponCodeLabel,
                    style: GraviaTextStyleConst.textSmRegular(
                      tt,
                    ).copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                Text(
                  GraviaValueConst.applyLabel,
                  style: GraviaTextStyleConst.textSmMedium(
                    tt,
                  ).copyWith(color: cs.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl2),
        _SummaryRow(
          label: GraviaValueConst.itemTotalLabel,
          value: GraviaValueConst.formattedPrice(items.itemTotal),
          labelStyle: GraviaTextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
          valueStyle: GraviaTextStyleConst.textSmMedium(
            tt,
          ).copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.base),
        _SummaryRow(
          label: GraviaValueConst.discountLabel,
          value: GraviaValueConst.formattedPrice(items.discountTotal),
          labelStyle: GraviaTextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
          valueStyle: GraviaTextStyleConst.textSmMedium(
            tt,
          ).copyWith(color: cs.primary),
        ),
        const SizedBox(height: AppSpacing.base),
        _SummaryRow(
          label: GraviaValueConst.deliveryLabel,
          value: GraviaValueConst.deliveryFreeLabel,
          labelStyle: GraviaTextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
          valueStyle: GraviaTextStyleConst.textSmMedium(
            tt,
          ).copyWith(color: cs.primary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Divider(color: cs.outlineVariant, height: 1, thickness: 1),
        const SizedBox(height: AppSpacing.lg),
        _SummaryRow(
          label: GraviaValueConst.grandTotalLabel,
          value: GraviaValueConst.formattedPrice(items.grandTotal),
          labelStyle: GraviaTextStyleConst.textMdBold(
            tt,
          ).copyWith(color: cs.onSurface),
          valueStyle: GraviaTextStyleConst.textMdBold(
            tt,
          ).copyWith(color: cs.onSurface),
        ),
      ],
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
