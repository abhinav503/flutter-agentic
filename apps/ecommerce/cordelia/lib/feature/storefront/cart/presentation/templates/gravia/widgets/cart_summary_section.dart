import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:flutter/material.dart';

import '../../../coupon_input.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/ecommerce/price_breakdown.dart';

import 'package:cordelia/feature/home/domain/entities/store_delivery_entity.dart';

import '../../../../domain/entities/cart_item_entity.dart';
import '../../../cubit/coupon_cubit.dart';

/// Coupon row + the Item Total/Discount/Delivery/Grand Total breakdown,
/// computed from [CartItemsX]. The coupon row is live: the code is typed
/// inline in the kit's bordered pill and validated by the backend
/// ([CouponCubit]); an applied coupon adds its own breakdown line and the
/// grand total nets it off — the same figure checkout charges.
class CartSummarySection extends StatefulWidget {
  final List<CartItemEntity> items;

  /// The store's delivery policy — this widget owns the arithmetic because
  /// it already owns the subtotal the fee is measured against.
  final StoreDeliveryEntity delivery;

  final CouponState couponState;
  final ValueChanged<String> onApplyCoupon;
  final VoidCallback onRemoveCoupon;

  const CartSummarySection({
    super.key,
    required this.items,
    required this.delivery,
    required this.couponState,
    required this.onApplyCoupon,
    required this.onRemoveCoupon,
  });

  @override
  State<CartSummarySection> createState() => _CartSummarySectionState();
}

class _CartSummarySectionState extends State<CartSummarySection>
    with CouponInput {
  @override
  CouponState get couponState => widget.couponState;

  @override
  ValueChanged<String> get onApplyCoupon => widget.onApplyCoupon;

  @override
  VoidCallback get onRemoveCoupon => widget.onRemoveCoupon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Read into locals so the null checks below promote — a getter can't.
    final applied = appliedCoupon;
    final errorMessage = couponError;
    final applying = isApplyingCoupon;
    // Delivery is charged on the basket *after* the coupon, matching the
    // server; the grand total is that basket plus the fee.
    final goods = widget.items.grandTotal - (applied?.discount ?? 0);
    final deliveryFee = widget.delivery.feeFor(goods);
    final grandTotal = goods + deliveryFee;

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
                  width: AppSpacing.xl2,
                  height: AppSpacing.xl2,
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
                          controller: codeController,
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
                          onSubmitted: (_) => applyCoupon(),
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
                    onTap: applied != null ? removeCoupon : applyCoupon,
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
          // "FREE" stays the pack's accent green; a real charge is an amount
          // like any other line, so it reads in the ordinary ink.
          value: deliveryFee > 0
              ? deliveryFee.asPrice
              : GraviaValueConst.deliveryFreeLabel,
          labelStyle: GraviaTextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
          valueStyle: GraviaTextStyleConst.textSmMedium(
            tt,
          ).copyWith(color: deliveryFee > 0 ? cs.onSurface : cs.primary),
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
