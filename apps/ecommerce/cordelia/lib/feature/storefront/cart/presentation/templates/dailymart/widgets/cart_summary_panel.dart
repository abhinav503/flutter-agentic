import 'package:flutter/material.dart';

import '../../../coupon_input.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:core/core/ui/blocks/ecommerce/price_breakdown.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';

import 'package:cordelia/feature/home/domain/entities/store_delivery_entity.dart';

import '../../../../domain/entities/cart_item_entity.dart';
import '../../../cubit/coupon_cubit.dart';

/// The cart's coupon row + totals breakdown (kit frames `24`/`25`) —
/// rendered inside the cart's scroll, after the item cards, so a long cart
/// keeps the whole breakdown reachable while only the checkout CTA
/// ([DailyMartCartCheckoutBar]) stays docked. The coupon row is live: the
/// code is typed in the kit's recessed strip and validated by the backend
/// ([CouponCubit]); an applied coupon adds its own line and the total nets
/// it off — the same figure checkout charges.
class DailyMartCartSummarySection extends StatelessWidget {
  final List<CartItemEntity> items;

  /// The store's delivery policy — this widget owns the arithmetic because
  /// it already owns the subtotal the fee is measured against.
  final StoreDeliveryEntity delivery;

  final CouponState couponState;
  final ValueChanged<String> onApplyCoupon;
  final VoidCallback onRemoveCoupon;

  const DailyMartCartSummarySection({
    super.key,
    required this.items,
    required this.delivery,
    required this.couponState,
    required this.onApplyCoupon,
    required this.onRemoveCoupon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final colors = context.appColors;

    final mutedLabel = DailyMartTextStyleConst.bodyMdRegular(
      tt,
    ).copyWith(color: cs.onSurfaceVariant);
    final inkValue = DailyMartTextStyleConst.bodyMdSemibold(
      tt,
    ).copyWith(color: cs.onSurface);
    final primaryValue = DailyMartTextStyleConst.bodyMdSemibold(
      tt,
    ).copyWith(color: cs.primary);

    final applied = switch (couponState) {
      CouponApplied(:final coupon) => coupon,
      _ => null,
    };
    // Charged on the basket after the coupon, matching the server.
    final goods = items.grandTotal - (applied?.discount ?? 0);
    final deliveryFee = delivery.feeFor(goods);

    return PriceBreakdown(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      leading: _CouponRow(
        couponState: couponState,
        onApply: onApplyCoupon,
        onRemove: onRemoveCoupon,
      ),
      lines: [
        PriceLine(
          label: DailyMartValueConst.subTotalLabel,
          value: items.itemTotal.asPrice,
          labelStyle: mutedLabel,
          valueStyle: inkValue,
        ),
        PriceLine(
          label: DailyMartValueConst.deliveryLabel,
          // Free delivery keeps the pack's accent; a real charge is an
          // ordinary amount and reads in the ordinary ink.
          value: deliveryFee > 0
              ? deliveryFee.asPrice
              : DailyMartValueConst.deliveryFreeLabel,
          labelStyle: mutedLabel,
          valueStyle: deliveryFee > 0 ? inkValue : primaryValue,
        ),
        PriceLine(
          label: DailyMartValueConst.discountLabel,
          value: items.discountTotal.asPrice,
          labelStyle: mutedLabel,
          valueStyle: primaryValue,
        ),
        if (applied != null)
          PriceLine(
            label: DailyMartValueConst.couponLineLabel(applied.code),
            value: '- ${applied.discount.asPrice}',
            labelStyle: mutedLabel,
            valueStyle: primaryValue,
          ),
      ],
      total: PriceLine(
        label: DailyMartValueConst.totalCostLabel,
        value: (goods + deliveryFee).asPrice,
        labelStyle: DailyMartTextStyleConst.bodyMdSemibold(
          tt,
        ).copyWith(color: cs.onSurface),
        valueStyle: DailyMartTextStyleConst.bodyLgSemibold(
          tt,
        ).copyWith(color: cs.onSurface),
      ),
      dividerColor: colors.dockedHairline,
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
    final shapes = context.appShapes;

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

/// The coupon row — the kit's recessed field-shaped strip (badge glyph, the
/// code, the action), now live: type a code and Apply, or Remove the one
/// applied. Validation errors print under the strip with the server's
/// reason, keeping the typed code in place for a retry.
class _CouponRow extends StatefulWidget {
  final CouponState couponState;
  final ValueChanged<String> onApply;
  final VoidCallback onRemove;

  const _CouponRow({
    required this.couponState,
    required this.onApply,
    required this.onRemove,
  });

  @override
  State<_CouponRow> createState() => _CouponRowState();
}

class _CouponRowState extends State<_CouponRow> with CouponInput {
  @override
  CouponState get couponState => widget.couponState;

  @override
  ValueChanged<String> get onApplyCoupon => widget.onApply;

  @override
  VoidCallback get onRemoveCoupon => widget.onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Read into locals so the null checks below promote — a getter can't.
    final applied = appliedCoupon;
    final errorMessage = couponError;
    final applying = isApplyingCoupon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: DailyMartDimenConst.controlHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: AppRadius.lg,
          ),
          child: Row(
            children: [
              Icon(
                Icons.discount_outlined,
                size: AppSpacing.xl2,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: applied != null
                    ? Text(
                        DailyMartValueConst.couponAppliedLabel(applied.code),
                        style: DailyMartTextStyleConst.bodySmSemibold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                      )
                    // The strip IS the field chrome — every border is
                    // stripped explicitly, because the theme's
                    // inputDecorationTheme injects the pack's input border
                    // even into a collapsed decoration.
                    : TextField(
                        controller: codeController,
                        enabled: !applying,
                        textCapitalization: TextCapitalization.characters,
                        style: DailyMartTextStyleConst.bodySmSemibold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: DailyMartValueConst.couponHint,
                          hintStyle: DailyMartTextStyleConst.bodySmSemibold(
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
                        ? DailyMartValueConst.couponRemoveLabel
                        : DailyMartValueConst.applyLabel,
                    style: DailyMartTextStyleConst.bodySmSemibold(
                      tt,
                    ).copyWith(color: applied != null ? cs.error : cs.primary),
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
              style: DailyMartTextStyleConst.bodyXsMedium(
                tt,
              ).copyWith(color: cs.error),
            ),
          ),
        ],
      ],
    );
  }
}
