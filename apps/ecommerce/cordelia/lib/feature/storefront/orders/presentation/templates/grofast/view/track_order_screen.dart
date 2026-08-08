import 'package:cordelia/constants/value_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/extensions/text_style_extensions.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/feature/storefront/orders/domain/entities/order_entity.dart';
import 'package:cordelia/feature/storefront/orders/domain/entities/order_line_item_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_line_item_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_price.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_section_header.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';

import '../../../../../reviews/presentation/templates/grofast/widgets/write_review_sheet_content.dart';
import '../../../bloc/orders_bloc.dart';
import '../../../order_review_actions.dart';

/// `grofast` template's Track Order (kit frames `122:1025` / `171:2573` /
/// `171:2696`) — Order Detail with the kit's side-by-side Status and
/// Purchase Date fields, the id rows with a **copy** action, the Tracking
/// Detail feed (newest event on a tinted card, earlier ones as bullet rows),
/// the order's items, and the kit's Total row.
///
/// **Deviations from the frames,** all where the kit shows data this backend
/// doesn't have: the delivery **map** header is dropped — the page starts at
/// Order Detail; the kit's courier feed (staging depots, city names, "See N
/// more updates") becomes the statuses the backend actually records, dated by
/// `statusHistory` and without locations; its courier tracking id becomes the
/// order id; and there is no ETA or rating CTA (spec sheet §11).
///
/// The order arrives whole via the route's `extra` — My Orders already holds
/// it — and the screen re-reads it from [OrdersBloc] so an optimistic cancel
/// lands here too.
class TrackOrderScreen extends BaseScreen {
  final OrderEntity order;

  const TrackOrderScreen({super.key, required this.order});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends BaseScreenState<TrackOrderScreen>
    with OrderReviewActions {
  @override
  Future<void> showRateOrderSheet({
    required int initialRating,
    required String initialText,
    required void Function(int rating, String text) onSubmit,
  }) => showGrofastSheet<void>(
    title: ValueConst.rateOrderSheetTitle,
    child: GrofastWriteReviewSheetContent(
      initialRating: initialRating,
      initialText: initialText,
      textLabel: ValueConst.rateOrderTextLabel,
      textHint: ValueConst.rateOrderTextHint,
      onSubmit: onSubmit,
      onMessage: showSnackBar,
    ),
  );

  /// The freshest copy of this order — the bloc's list wins over the routed
  /// snapshot, so a cancel made here (or a refresh) is reflected immediately.
  void _confirmCancel(OrderEntity order) => showGrofastConfirmSheet(
    context: context,
    title: GrofastValueConst.cancelOrderTitle,
    message: GrofastValueConst.cancelOrderMessage,
    confirmLabel: GrofastValueConst.cancelOrderConfirmLabel,
    onConfirm: () => context.read<OrdersBloc>().add(
      OrdersEvent.cancelled(orderId: order.id),
    ),
  );

  Future<void> _copy(String label, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    showSnackBar(GrofastValueConst.copiedMessage(label));
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state case OrdersLoaded(cancelFailed: true)) {
            showSnackBar(GrofastValueConst.orderCancelFailedMessage);
          }
          if (state case OrdersLoaded(rateFailed: true)) {
            showSnackBar(ValueConst.orderRatingFailedMessage);
          }
        },
        builder: (context, state) {
          final order = state.freshest(widget.order);
          final canCancel = order.status.isUpcoming;

          return GrofastScreenBody(
            title: GrofastValueConst.trackOrderTitle,
            onBack: () => context.pop(),
            gap: AppSpacing.xl4,
            // The kit's Cancel Order is a quiet outlined neutral, not a
            // destructive red — the confirm sheet carries the red. The
            // secondary variant's own fill is transparent, which is right on
            // a page but not floating over the fade: content would scroll
            // through the button, so it gets an opaque surface behind it.
            // Cancel while it's coming; once it has arrived the same slot
            // asks how the delivery went. A cancelled order gets neither —
            // there is nothing left to stop and no delivery to rate.
            floatingAction: order.canBeRated
                ? GrofastPrimaryButton(
                    label: order.isRated
                        ? ValueConst.editOrderRatingLabel
                        : ValueConst.rateOrderLabel,
                    onTap: () => rateOrder(order),
                  )
                : canCancel
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: AppRadius.full,
                    ),
                    child: AppButton(
                      label: GrofastValueConst.cancelOrderLabel,
                      variant: AppButtonVariant.secondary,
                      size: AppButtonSize.large,
                      fullWidth: true,
                      height: GrofastDimenConst.controlHeight,
                      borderRadius: AppRadius.full,
                      borderColor: Theme.of(context).colorScheme.outline,
                      labelStyle:
                          GrofastTextStyleConst.labelSemibold(
                            Theme.of(context).textTheme,
                          ).copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                      onTap: () => _confirmCancel(order),
                    ),
                  )
                : null,
            body: _TrackOrderContent(order: order, onCopy: _copy),
          );
        },
      ),
    );
  }
}

class _TrackOrderContent extends StatelessWidget {
  final OrderEntity order;
  final void Function(String label, String value) onCopy;

  const _TrackOrderContent({required this.order, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final refund = GrofastValueConst.refundStatusLabel(order.refundStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrofastSectionHeader(title: GrofastValueConst.orderDetailTitle),
        const SizedBox(height: AppSpacing.lg),
        // The kit's pair: Status and Purchase Date side by side, each a
        // label over a 33-tall tinted field.
        Row(
          children: [
            Expanded(
              child: _LabeledField(
                label: GrofastValueConst.orderStatusLabel,
                child: _StatusField(status: order.status),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: _LabeledField(
                label: GrofastValueConst.purchaseDateLabel,
                child: _TrackField(
                  text: order.placedAt.asFilterDate,
                  fill: cs.surfaceContainerLow,
                  ink: cs.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl2),
        _CopyableRow(
          label: GrofastValueConst.orderIdLabel,
          value: order.id,
          onCopy: onCopy,
        ),
        if (order.paymentId.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.base),
          _CopyableRow(
            label: GrofastValueConst.paymentIdLabel,
            value: order.paymentId,
            onCopy: onCopy,
          ),
        ],
        if (order.couponCode.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.base),
          _DetailRow(
            label: GrofastValueConst.couponDetailLabel,
            child: Text(
              GrofastValueConst.couponDetailValue(
                order.couponCode,
                order.couponDiscount.asPrice,
              ),
              style: GrofastTextStyleConst.bodyMedium(
                tt,
              ).copyWith(color: cs.onSurface),
            ),
          ),
        ],
        if (order.status == OrderStatus.inProcess &&
            order.deliveryOtp.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.base),
          _DetailRow(
            label: GrofastValueConst.deliveryOtpLabel,
            child: Text(
              order.deliveryOtp,
              style: GrofastTextStyleConst.bodyMedium(
                tt,
              ).copyWith(color: cs.onSurface),
            ),
          ),
        ],
        if (refund != null) ...[
          const SizedBox(height: AppSpacing.base),
          _DetailRow(
            label: GrofastValueConst.refundLabel,
            child: Text(
              refund,
              style: GrofastTextStyleConst.bodyMedium(
                tt,
              ).copyWith(color: cs.error),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl6),
        GrofastSectionHeader(title: GrofastValueConst.trackingDetailTitle),
        const SizedBox(height: AppSpacing.lg),
        _TrackingDetail(order: order),
        const SizedBox(height: AppSpacing.xl6),
        GrofastSectionHeader(title: GrofastValueConst.itemsTitle),
        const SizedBox(height: AppSpacing.lg),
        for (final item in order.items) ...[
          GrofastLineItemRow(
            imageUrl: item.imageUrl,
            name: item.productName,
            subtitle: item.weight,
            price: item.lineTotal,
            trailing: Text(
              GrofastValueConst.orderLineQuantity(item.quantity),
              style: GrofastTextStyleConst.meta(
                tt,
              ).copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        const SizedBox(height: AppSpacing.lg),
        // The kit's Total row: quiet label, the pack's big split price —
        // net of the coupon (the Coupon detail row above names it), the
        // figure the server actually charged.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              GrofastValueConst.amountPaidLabel,
              style: GrofastTextStyleConst.bodyMedium(
                tt,
              ).copyWith(color: cs.onSurface),
            ),
            GrofastPrice(
              value: order.payableTotal,
              scale: GrofastDimenConst.totalPriceScale,
            ),
          ],
        ),
      ],
    );
  }
}

/// A small label over its field, the kit's `Status` / `Purchase Date` pair.
class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: GrofastDimenConst.fieldLabelInset,
          ),
          child: Text(
            label,
            style: GrofastTextStyleConst.bodySmall(
              tt,
            ).copyWith(color: cs.headerInk),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }
}

/// One 33-tall radius-13 field (kit `Track/Date` and the status variants).
class _TrackField extends StatelessWidget {
  final String text;
  final Color? fill;
  final Gradient? gradient;
  final Color ink;

  const _TrackField({
    required this.text,
    required this.ink,
    this.fill,
    this.gradient,
  }) : assert(
         (fill == null) != (gradient == null),
         'Pass a flat fill or a gradient, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      height: GrofastDimenConst.trackFieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: fill,
        gradient: gradient,
        borderRadius: BorderRadius.circular(GrofastDimenConst.trackFieldRadius),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GrofastTextStyleConst.bodySmall(tt).copyWith(color: ink),
      ),
    );
  }
}

/// The status field's fills per status: Delivered fills with the **brand
/// gradient** under white text (`Track/Status-Delivered` — delivery is an
/// affirmative outcome, and affirmative fills in this pack are the gradient,
/// never flat green), an in-flight order takes the mint tint with the kit's
/// Medium-Green ink, cancelled the error tint.
class _StatusField extends StatelessWidget {
  final OrderStatus status;

  const _StatusField({required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = GrofastValueConst.orderStatusName(status);

    return switch (status) {
      OrderStatus.delivered => _TrackField(
        text: text,
        gradient: GrofastColorConst.brandGradient,
        ink: cs.onPrimary,
      ),
      OrderStatus.pending || OrderStatus.inProcess => _TrackField(
        text: text,
        fill: cs.surfaceContainer,
        ink: GrofastColorConst.chipActiveInk,
      ),
      OrderStatus.cancelled => _TrackField(
        text: text,
        fill: cs.errorContainer,
        ink: cs.error,
      ),
    };
  }
}

/// A label → value row whose value can be copied — the copy glyph is the
/// affordance, and the whole row is its tap target.
class _CopyableRow extends StatelessWidget {
  final String label;
  final String value;
  final void Function(String label, String value) onCopy;

  const _CopyableRow({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: GrofastValueConst.copyTooltip,
      child: GestureDetector(
        onTap: () => onCopy(label, value),
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Text(
              label,
              style: GrofastTextStyleConst.bodyMedium(
                tt,
              ).copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: GrofastTextStyleConst.bodyMedium(
                  tt,
                ).copyWith(color: cs.onSurface),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(Icons.copy_rounded, size: AppSpacing.lg, color: cs.primary),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _DetailRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GrofastTextStyleConst.bodyMedium(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(width: AppSpacing.lg),
        Flexible(
          child: Align(alignment: Alignment.centerRight, child: child),
        ),
      ],
    );
  }
}

/// The kit's Tracking Detail feed: the **newest** event on a 70-tall tinted
/// card (`Track/New`, or its red `-Canceled` variant), the earlier ones as
/// small bullet rows under it, joined by a hairline. Only statuses the order
/// actually reached appear — the kit's feed is a log of what happened, not a
/// pipeline of what might.
class _TrackingDetail extends StatelessWidget {
  final OrderEntity order;

  const _TrackingDetail({required this.order});

  /// Reached steps, oldest → newest. Placement is always reached — orders
  /// predating `statusHistory` still know when they were placed.
  List<(OrderStatus, DateTime?)> get _reached {
    final steps = order.status == OrderStatus.cancelled
        ? const [OrderStatus.pending, OrderStatus.cancelled]
        : const [
            OrderStatus.pending,
            OrderStatus.inProcess,
            OrderStatus.delivered,
          ];

    return [
      for (final step in steps)
        if (step == OrderStatus.pending)
          (step, order.statusReachedAt(step) ?? order.placedAt)
        else if (order.statusReachedAt(step) != null || step == order.status)
          (step, order.statusReachedAt(step)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final reached = _reached;
    final newest = reached.last;
    final past = reached.reversed.skip(1).toList();
    final isCancelled = newest.$1 == OrderStatus.cancelled;
    final accent = isCancelled ? cs.error : GrofastColorConst.chipActiveInk;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Newest event — the tinted card.
        Container(
          height: GrofastDimenConst.trackEventCardHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
          decoration: BoxDecoration(
            color: isCancelled ? cs.errorContainer : cs.surfaceContainer,
            borderRadius: BorderRadius.circular(GrofastDimenConst.tileRadius),
          ),
          child: Row(
            children: [
              Icon(
                isCancelled
                    ? Icons.cancel_outlined
                    : Icons.check_circle_outline_rounded,
                size: AppSpacing.xl2,
                color: accent,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      GrofastValueConst.orderStatusName(newest.$1),
                      style: GrofastTextStyleConst.bodySmall(
                        tt,
                      ).atWeight(FontWeight.w700).copyWith(color: accent),
                    ),
                    const SizedBox(height: AppSpacing.xs3),
                    Text(
                      newest.$2?.orderPlacedLabel ??
                          GrofastValueConst.orderStepUndatedLabel,
                      style: GrofastTextStyleConst.meta(
                        tt,
                      ).copyWith(color: accent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Earlier events — bullet rows on the connector line, newest first.
        if (past.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              left: GrofastDimenConst.timelinePastIndent,
            ),
            child: Column(
              children: [
                for (final (step, at) in past)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BulletRail(accent: accent),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.base,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GrofastValueConst.orderStatusName(step),
                                  style: GrofastTextStyleConst.bodySmall(tt)
                                      .atWeight(FontWeight.w700)
                                      .copyWith(color: cs.headerInk),
                                ),
                                const SizedBox(height: AppSpacing.xs4),
                                Text(
                                  at?.orderPlacedLabel ??
                                      GrofastValueConst.orderStepUndatedLabel,
                                  style: GrofastTextStyleConst.meta(
                                    tt,
                                  ).copyWith(color: cs.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// The past row's rail: the connector line running the row's full height
/// with the bullet centred on it.
class _BulletRail extends StatelessWidget {
  final Color accent;

  const _BulletRail({required this.accent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: GrofastDimenConst.timelineDiscSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: GrofastDimenConst.timelineLineWidth,
            color: accent.withValues(alpha: 0.3),
          ),
          Container(
            width: GrofastDimenConst.timelineDiscSize,
            height: GrofastDimenConst.timelineDiscSize,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
