import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

import '../../../../domain/entities/order_entity.dart';

/// Track Order's status timeline (kit frame `36`) — a checked disc per step
/// over a 2px connector that runs green as far as the order has got, then
/// grey.
///
/// **The kit draws six steps** (Placed, Confirmed, Preparing Items, Items
/// Shipped, Out for Delivery, Delivered); this renders the three the backend
/// actually has (`OrderStatus` in `admin/src/lib/types.ts`). Inventing the
/// other three would put permanently-grey rows on every order and imply a
/// fulfilment pipeline the store never reports — the timeline would be
/// decoration, not information. A cancelled order swaps the two delivery
/// steps for a single Cancelled one: they're not "pending", they're never
/// happening.
///
/// Dates come from `statusHistory`, which the server only started recording
/// recently — a step the order has reached but that predates it renders
/// undated rather than guessing (see [OrderEntityX.statusReachedAt]).
class DailyMartOrderStatusTimeline extends StatelessWidget {
  final OrderEntity order;

  const DailyMartOrderStatusTimeline({super.key, required this.order});

  List<_Step> _steps() {
    final placed = _Step(
      label: DailyMartValueConst.orderStepPlacedLabel,
      // placedAt is always known, so the first step is never undated even on
      // an order written before statusHistory existed.
      at: order.statusReachedAt(OrderStatus.pending) ?? order.placedAt,
      reached: true,
    );

    if (order.status == OrderStatus.cancelled) {
      return [
        placed,
        _Step(
          label: DailyMartValueConst.orderStepCancelledLabel,
          at: order.statusReachedAt(OrderStatus.cancelled),
          reached: true,
        ),
      ];
    }

    return [
      placed,
      _Step(
        label: DailyMartValueConst.orderStepOnTheWayLabel,
        at: order.statusReachedAt(OrderStatus.inProcess),
        reached:
            order.status == OrderStatus.inProcess ||
            order.status == OrderStatus.delivered,
      ),
      _Step(
        label: DailyMartValueConst.orderStepDeliveredLabel,
        at: order.statusReachedAt(OrderStatus.delivered),
        reached: order.status == OrderStatus.delivered,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final steps = _steps();

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          // The connector has to span the row *and* the gap below it, so it
          // stretches to the row's own height rather than a measured
          // constant — two-line steps and one-line steps then both join up.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: DailyMartDimenConst.orderStepDiscSize,
                  child: Column(
                    children: [
                      _StepDisc(reached: steps[i].reached),
                      if (i != steps.length - 1)
                        Expanded(
                          child: Center(
                            child: Container(
                              width: DailyMartDimenConst.orderStepLineWidth,
                              // Green only as far as the *next* step has been
                              // reached — the line marks progress made, not
                              // progress expected.
                              color: steps[i + 1].reached
                                  ? cs.primary
                                  : cs.outlineVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: i == steps.length - 1 ? 0 : AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[i].label,
                          style: DailyMartTextStyleConst.bodySmMedium(
                            tt,
                          ).copyWith(color: cs.onSurface),
                        ),
                        const SizedBox(height: AppSpacing.xs4),
                        Text(
                          steps[i].subtitle,
                          style: DailyMartTextStyleConst.bodySmRegular(
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
    );
  }
}

class _Step {
  final String label;
  final DateTime? at;
  final bool reached;

  const _Step({required this.label, required this.at, required this.reached});

  /// A reached step with no recorded time says so rather than showing a
  /// blank line — the gap is the server's, and hiding it would read as the
  /// step never having happened.
  String get subtitle => switch ((at, reached)) {
    (final DateTime at, _) => DailyMartValueConst.orderStepAt(at),
    (null, true) => DailyMartValueConst.orderStepUndatedLabel,
    (null, false) => DailyMartValueConst.orderStepPendingLabel,
  };
}

/// Reached steps take a filled primary disc with the kit's white tick;
/// pending ones keep the tick on `outlineVariant` (Greyscale/100), exactly
/// as the kit greys them — one silhouette in two fills, unlike Select
/// Address's disc, where the kit draws two different shapes.
class _StepDisc extends StatelessWidget {
  final bool reached;

  const _StepDisc({required this.reached});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: DailyMartDimenConst.orderStepDiscSize,
      height: DailyMartDimenConst.orderStepDiscSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: reached ? cs.primary : cs.outlineVariant,
      ),
      child: AppSvgImage.asset(
        DailyMartImageConst.check,
        color: cs.onPrimary,
        width: 12,
        height: 9,
      ),
    );
  }
}
