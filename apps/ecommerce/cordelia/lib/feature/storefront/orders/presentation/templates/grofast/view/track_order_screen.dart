import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/blocks/ecommerce/price_breakdown.dart';

import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/feature/storefront/orders/domain/entities/order_entity.dart';
import 'package:cordelia/feature/storefront/orders/domain/entities/order_line_item_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_line_item_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_section_header.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';

import '../../../bloc/orders_bloc.dart';
import '../widgets/order_status_pill.dart';

/// `grofast` template's Track Order (kit frames `122:1025` / `171:2573` /
/// `171:2696`) — Order Detail (status + purchase date), the dated Tracking
/// Detail timeline, the order's items, the totals, and Cancel Order for an
/// order that hasn't shipped.
///
/// **Deviations from the frames,** all where the kit shows data this backend
/// doesn't have: the live delivery **map** header is dropped; the kit's
/// six-step pipeline becomes the three statuses the backend actually records
/// (placed → on the way → delivered, or cancelled); its courier tracking id
/// becomes the order id; and there is no delivery ETA (spec sheet §11).
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

class _TrackOrderScreenState extends BaseScreenState<TrackOrderScreen> {
  /// The freshest copy of this order — the bloc's list wins over the routed
  /// snapshot, so a cancel made here (or a refresh) is reflected immediately.
  OrderEntity _current(OrdersState state) => switch (state) {
    OrdersLoaded(:final orders) => orders.firstWhere(
      (o) => o.id == widget.order.id,
      orElse: () => widget.order,
    ),
    _ => widget.order,
  };

  void _confirmCancel(OrderEntity order) => showGrofastConfirmSheet(
    context: context,
    title: GrofastValueConst.cancelOrderTitle,
    message: GrofastValueConst.cancelOrderMessage,
    confirmLabel: GrofastValueConst.cancelOrderConfirmLabel,
    onConfirm: () => context.read<OrdersBloc>().add(
      OrdersEvent.cancelled(orderId: order.id),
    ),
  );

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
        },
        builder: (context, state) {
          final order = _current(state);
          final canCancel = order.status.isUpcoming;

          return GrofastScreenBody(
            title: GrofastValueConst.trackOrderTitle,
            onBack: () => context.pop(),
            gap: AppSpacing.xl4,
            floatingAction: canCancel
                ? AppButton(
                    label: GrofastValueConst.cancelOrderLabel,
                    variant: AppButtonVariant.secondary,
                    size: AppButtonSize.large,
                    fullWidth: true,
                    height: GrofastDimenConst.controlHeight,
                    borderColor: Theme.of(context).colorScheme.error,
                    labelStyle: GrofastTextStyleConst.labelSemibold(
                      Theme.of(context).textTheme,
                    ).copyWith(color: Theme.of(context).colorScheme.error),
                    onTap: () => _confirmCancel(order),
                  )
                : null,
            body: _TrackOrderContent(order: order),
          );
        },
      ),
    );
  }
}

class _TrackOrderContent extends StatelessWidget {
  final OrderEntity order;

  const _TrackOrderContent({required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final label = GrofastTextStyleConst.bodyMedium(
      tt,
    ).copyWith(color: cs.onSurfaceVariant);
    final value = GrofastTextStyleConst.bodyMedium(
      tt,
    ).copyWith(color: cs.onSurface);
    final refund = GrofastValueConst.refundStatusLabel(order.refundStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GrofastSectionHeader(title: GrofastValueConst.orderDetailTitle),
        const SizedBox(height: AppSpacing.lg),
        _DetailRow(
          label: GrofastValueConst.orderStatusLabel,
          child: GrofastOrderStatusPill(status: order.status),
        ),
        const SizedBox(height: AppSpacing.base),
        _DetailRow(
          label: GrofastValueConst.purchaseDateLabel,
          child: Text(order.placedAt.orderPlacedLabel, style: value),
        ),
        const SizedBox(height: AppSpacing.base),
        _DetailRow(
          label: GrofastValueConst.orderIdLabel,
          child: Text(order.id, style: value),
        ),
        if (order.status == OrderStatus.inProcess &&
            order.deliveryOtp.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.base),
          _DetailRow(
            label: GrofastValueConst.deliveryOtpLabel,
            child: Text(order.deliveryOtp, style: value),
          ),
        ],
        if (refund != null) ...[
          const SizedBox(height: AppSpacing.base),
          _DetailRow(
            label: GrofastValueConst.refundLabel,
            child: Text(refund, style: value.copyWith(color: cs.error)),
          ),
        ],
        const SizedBox(height: AppSpacing.xl6),
        const GrofastSectionHeader(
          title: GrofastValueConst.trackingDetailTitle,
        ),
        const SizedBox(height: AppSpacing.lg),
        _StatusTimeline(order: order),
        const SizedBox(height: AppSpacing.xl6),
        const GrofastSectionHeader(title: GrofastValueConst.itemsTitle),
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
        PriceBreakdown(
          lines: [
            PriceLine(
              label: GrofastValueConst.subtotalLabel,
              value: order.totalPrice.asPrice,
              labelStyle: label,
              valueStyle: value,
            ),
            if (order.paymentId.isNotEmpty)
              PriceLine(
                label: GrofastValueConst.paymentIdLabel,
                value: order.paymentId,
                labelStyle: label,
                valueStyle: value,
              )
            else
              PriceLine(
                label: GrofastValueConst.paymentIdLabel,
                value: GrofastValueConst.noOnlinePaymentLabel,
                labelStyle: label,
                valueStyle: value,
              ),
          ],
          total: PriceLine(
            label: GrofastValueConst.amountPaidLabel,
            value: order.totalPrice.asPrice,
            labelStyle: GrofastTextStyleConst.rowTitleBold(tt),
            valueStyle: GrofastTextStyleConst.price(
              tt,
            ).copyWith(color: cs.primary),
          ),
          dividerColor: cs.outlineVariant,
        ),
      ],
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

/// The kit's dated step list. Each step is reached-or-not by the order's own
/// [OrderEntity.statusHistory], so an order that never shipped shows its
/// later steps greyed and undated rather than inventing progress.
class _StatusTimeline extends StatelessWidget {
  final OrderEntity order;

  const _StatusTimeline({required this.order});

  /// Cancellation replaces the rest of the pipeline — an order can't be both
  /// cancelled and on its way.
  List<OrderStatus> get _steps => order.status == OrderStatus.cancelled
      ? const [OrderStatus.pending, OrderStatus.cancelled]
      : const [
          OrderStatus.pending,
          OrderStatus.inProcess,
          OrderStatus.delivered,
        ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final steps = _steps;

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          Builder(
            builder: (context) {
              final step = steps[i];
              final reachedAt = order.statusReachedAt(step);
              final isReached =
                  reachedAt != null || step == OrderStatus.pending;
              final isCancelled = step == OrderStatus.cancelled;
              final accent = isCancelled ? cs.error : cs.primary;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: GrofastDimenConst.timelineDiscSize,
                          height: GrofastDimenConst.timelineDiscSize,
                          decoration: BoxDecoration(
                            color: isReached
                                ? accent
                                : cs.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            isCancelled
                                ? Icons.close_rounded
                                : Icons.check_rounded,
                            size: AppSpacing.md,
                            color: isReached
                                ? cs.onPrimary
                                : cs.onSurfaceVariant,
                          ),
                        ),
                        if (i < steps.length - 1)
                          Expanded(
                            child: Container(
                              width: GrofastDimenConst.timelineLineWidth,
                              color: isReached
                                  ? accent.withValues(alpha: 0.4)
                                  : cs.surfaceContainerHighest,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xl2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              GrofastValueConst.orderStatusName(step),
                              style: GrofastTextStyleConst.rowTitleBold(tt)
                                  .copyWith(
                                    color: isReached
                                        ? cs.onSurface
                                        : cs.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.xs4),
                            Text(
                              switch ((isReached, reachedAt)) {
                                (false, _) =>
                                  GrofastValueConst.orderStepPendingLabel,
                                (true, null) =>
                                  GrofastValueConst.orderStepUndatedLabel,
                                (true, final at?) => at.orderPlacedLabel,
                              },
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
              );
            },
          ),
      ],
    );
  }
}
