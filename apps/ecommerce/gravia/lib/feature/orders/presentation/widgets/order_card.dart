import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/badge.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/order_status.dart';
import 'package:gravia/widgets/gravia_action_pair.dart';
import 'package:gravia/widgets/gravia_tint_badge.dart';

import '../../domain/entities/order_entity.dart';
import 'order_line_item_row.dart';

/// One order: an `OrderLineItemRow` per product (an order is one delivery of
/// possibly several products, each with its own quantity — never a single
/// product by itself), a full-width date + order-total row, and a final
/// action row that depends on [OrderStatus]: while the order is
/// [OrderStatus.inProcess], the Delivery OTP row plus Cancel/Track Order;
/// once delivered or cancelled, there's nothing left to track or hand an
/// OTP to, so that row is replaced by View Details/Write A Review instead.
class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onCancel;
  final VoidCallback onTrackOrder;
  final VoidCallback onViewDetails;
  final VoidCallback onWriteReview;

  const OrderCard({
    super.key,
    required this.order,
    required this.onCancel,
    required this.onTrackOrder,
    required this.onViewDetails,
    required this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final sheetHairline = Theme.of(
      context,
    ).extension<AppColorsExtension>()!.sheetHairline;
    final isUpcoming = order.status.isUpcoming;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < order.items.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.base),
          OrderLineItemRow(item: order.items[i]),
        ],
        const SizedBox(height: AppSpacing.base),
        Divider(color: sheetHairline, height: 1),
        const SizedBox(height: AppSpacing.base),
        Row(
          children: [
            Expanded(
              child: Text(
                order.placedAt.orderPlacedLabel,
                style: TextStyleConst.textSmRegular(
                  tt,
                ).copyWith(color: ColorConst.gray500),
              ),
            ),
            Row(
              children: [
                if (!isUpcoming) _StatusBadge(status: order.status),
                if (!isUpcoming) const SizedBox(width: AppSpacing.sm),
                Text(
                  ValueConst.formattedPrice(order.totalPrice),
                  style: TextStyleConst.textMdBold(
                    tt,
                  ).copyWith(color: cs.onSurface),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.base),
        Divider(color: sheetHairline, height: 1),
        const SizedBox(height: AppSpacing.base),
        if (isUpcoming) ...[
          Row(
            children: [
              Text(
                ValueConst.deliveryOtpLabel,
                style: TextStyleConst.textMdBold(
                  tt,
                ).copyWith(color: cs.onSurface),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusBadge(status: order.status),
              const Spacer(),
              Row(
                children: [
                  for (var i = 0; i < order.deliveryOtp.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.xs2),
                    _OtpDigitBox(digit: order.deliveryOtp[i]),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          Divider(color: sheetHairline, height: 1),
          const SizedBox(height: AppSpacing.lg),
          GraviaActionPair(
            left: GraviaAction(
              label: ValueConst.cancelOrderLabel,
              kind: GraviaActionKind.tintedError,
              onTap: onCancel,
            ),
            right: GraviaAction(
              label: ValueConst.trackOrderLabel,
              kind: GraviaActionKind.primary,
              onTap: onTrackOrder,
            ),
          ),
        ] else ...[
          if (order.status == OrderStatus.cancelled &&
              order.refundStatus.label != null) ...[
            _RefundNote(status: order.refundStatus),
            const SizedBox(height: AppSpacing.lg),
          ],
          GraviaActionPair(
            left: GraviaAction(
              label: ValueConst.viewDetailsLabel,
              kind: GraviaActionKind.secondary,
              onTap: onViewDetails,
            ),
            right: GraviaAction(
              label: ValueConst.writeReviewLabel,
              kind: GraviaActionKind.primary,
              onTap: onWriteReview,
            ),
          ),
        ],
      ],
    );
  }
}

class _RefundNote extends StatelessWidget {
  final RefundStatus status;

  const _RefundNote({required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    // A failed refund is the one case the shopper must notice — flag it in the
    // error colour; a pending/processed refund is reassuring, so it reads in
    // the muted body colour like the rest of the card's metadata.
    final isFailed = status == RefundStatus.failed;

    return Row(
      children: [
        Icon(
          isFailed ? Icons.error_outline : Icons.check_circle_outline,
          size: 16,
          color: isFailed ? cs.error : ColorConst.gray500,
        ),
        const SizedBox(width: AppSpacing.xs2),
        Text(
          status.label!,
          style: TextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: isFailed ? cs.error : ColorConst.gray500),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return switch (status) {
      // Same mint-on-tinted-primary look as ProductCard's weight badge and
      // AddressCard's tag badge — kept identical so status badges don't
      // drift into their own one-off colour.
      OrderStatus.pending => GraviaTintBadge(
        text: ValueConst.pendingStatusLabel,
      ),
      OrderStatus.inProcess => GraviaTintBadge(
        text: ValueConst.inProcessStatusLabel,
      ),
      OrderStatus.delivered => AppBadge(
        text: ValueConst.deliveredStatusLabel,
        intent: AppBadgeIntent.success,
        textStyle: TextStyleConst.badgeLabel(tt),
      ),
      OrderStatus.cancelled => AppBadge(
        text: ValueConst.cancelledStatusLabel,
        intent: AppBadgeIntent.error,
        textStyle: TextStyleConst.badgeLabel(tt),
      ),
    };
  }
}

class _OtpDigitBox extends StatelessWidget {
  final String digit;

  const _OtpDigitBox({required this.digit});

  static const double _size = 32;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(
          context,
        ).extension<AppColorsExtension>()!.tintedPrimaryFill,
        border: Border.all(color: cs.primary),
      ),
      alignment: Alignment.center,
      child: Text(
        digit,
        style: TextStyleConst.textMdBold(tt).copyWith(color: cs.onSurface),
      ),
    );
  }
}
