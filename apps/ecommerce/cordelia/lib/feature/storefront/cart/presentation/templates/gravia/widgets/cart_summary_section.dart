import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:flutter/material.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/ecommerce/price_breakdown.dart';

import '../../../../domain/entities/cart_item_entity.dart';
import '../../../cubit/coupon_cubit.dart';

/// Coupon row + the Item Total/Discount/Delivery/Grand Total breakdown,
/// computed from [CartItemsX]. The coupon row is live: the code is typed
/// inline in the kit's bordered pill and validated by the backend
/// ([CouponCubit]); an applied coupon adds its own breakdown line and the
/// grand total nets it off — the same figure checkout charges.
class CartSummarySection extends StatefulWidget {
  final List<CartItemEntity> items;
  final CouponState couponState;
  final ValueChanged<String> onApplyCoupon;
  final VoidCallback onRemoveCoupon;

  const CartSummarySection({
    super.key,
    required this.items,
    required this.couponState,
    required this.onApplyCoupon,
    required this.onRemoveCoupon,
  });

  @override
  State<CartSummarySection> createState() => _CartSummarySectionState();
}

class _CartSummarySectionState extends State<CartSummarySection> {
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final applied = switch (widget.couponState) {
      CouponApplied(:final coupon) => coupon,
      _ => null,
    };
    final errorMessage = switch (widget.couponState) {
      CouponFailed(:final message) => message,
      _ => null,
    };
    final applying = widget.couponState is CouponApplying;
    final grandTotal = widget.items.grandTotal - (applied?.discount ?? 0);

    return PriceBreakdown(
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                  child: applied != null
                      ? Text(
                          GraviaValueConst.couponAppliedLabel(applied.code),
                          style: GraviaTextStyleConst.textSmMedium(
                            tt,
                          ).copyWith(color: cs.onSurface),
                        )
                      // The pill IS the field chrome — every border is
                      // stripped explicitly, because the theme's
                      // inputDecorationTheme injects the pack's input border
                      // even into a collapsed decoration.
                      : TextField(
                          controller: _code,
                          enabled: !applying,
                          textCapitalization: TextCapitalization.characters,
                          style: GraviaTextStyleConst.textSmRegular(
                            tt,
                          ).copyWith(color: cs.onSurface),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: GraviaValueConst.couponCodeLabel,
                            hintStyle: GraviaTextStyleConst.textSmRegular(
                              tt,
                            ).copyWith(color: cs.onSurfaceVariant),
                          ),
                          onSubmitted: widget.onApplyCoupon,
                          // Same dismissal rule AppTextField bakes in — tapping
                          // outside drops focus and the keyboard.
                          onTapOutside: (_) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                        ),
                ),
                if (applying)
                  const LoadingDots()
                else
                  GestureDetector(
                    onTap: applied != null
                        ? () {
                            _code.clear();
                            widget.onRemoveCoupon();
                          }
                        : () => widget.onApplyCoupon(_code.text),
                    child: Text(
                      applied != null
                          ? GraviaValueConst.couponRemoveLabel
                          : GraviaValueConst.applyLabel,
                      style: GraviaTextStyleConst.textSmMedium(tt).copyWith(
                        color: applied != null ? cs.error : cs.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                errorMessage,
                style: GraviaTextStyleConst.textXsRegular(
                  tt,
                ).copyWith(color: cs.error),
              ),
            ),
          ],
        ],
      ),
      leadingGap: AppSpacing.xl2,
      lines: [
        PriceLine(
          label: GraviaValueConst.itemTotalLabel,
          value: widget.items.itemTotal.asPrice,
          labelStyle: GraviaTextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
          valueStyle: GraviaTextStyleConst.textSmMedium(
            tt,
          ).copyWith(color: cs.onSurface),
        ),
        PriceLine(
          label: GraviaValueConst.discountLabel,
          value: widget.items.discountTotal.asPrice,
          labelStyle: GraviaTextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
          valueStyle: GraviaTextStyleConst.textSmMedium(
            tt,
          ).copyWith(color: cs.primary),
        ),
        if (applied != null)
          PriceLine(
            label: GraviaValueConst.couponLineLabel(applied.code),
            value: '- ${applied.discount.asPrice}',
            labelStyle: GraviaTextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
            valueStyle: GraviaTextStyleConst.textSmMedium(
              tt,
            ).copyWith(color: cs.primary),
          ),
        PriceLine(
          label: GraviaValueConst.deliveryLabel,
          value: GraviaValueConst.deliveryFreeLabel,
          labelStyle: GraviaTextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
          valueStyle: GraviaTextStyleConst.textSmMedium(
            tt,
          ).copyWith(color: cs.primary),
        ),
      ],
      total: PriceLine(
        label: GraviaValueConst.grandTotalLabel,
        value: grandTotal.asPrice,
        labelStyle: GraviaTextStyleConst.textMdBold(
          tt,
        ).copyWith(color: cs.onSurface),
        valueStyle: GraviaTextStyleConst.textMdBold(
          tt,
        ).copyWith(color: cs.onSurface),
      ),
      dividerColor: cs.outlineVariant,
    );
  }
}
