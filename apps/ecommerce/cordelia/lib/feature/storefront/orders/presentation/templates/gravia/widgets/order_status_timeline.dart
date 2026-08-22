import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/enums/order_status.dart';

import '../../../order_timeline_steps.dart';
import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';

import '../../../../domain/entities/order_entity.dart';

/// Track Order's dated status timeline — a filled tick per step reached,
/// hollow for one still ahead, joined by a connector that runs in the brand
/// colour as far as the order has actually got.
///
/// **Three steps, not a fulfilment pipeline.** `OrderStatus` has exactly the
/// states the backend reports; inventing "Packed"/"Shipped" rows would put
/// permanently-hollow steps on every order and imply tracking the store
/// never sends. A cancelled order replaces the two delivery steps with a
/// single Cancelled one — they aren't pending, they're never happening.
///
/// Dates come from `statusHistory`. A step the order has reached but that
/// predates the server recording transitions renders undated rather than
/// guessing a time (see [OrderEntityX.statusReachedAt]).
class GraviaOrderStatusTimeline extends StatelessWidget {
  final OrderEntity order;

  const GraviaOrderStatusTimeline({super.key, required this.order});

  /// The pack's wording over the shared derivation
  /// ([OrderTimelineX.timelineSteps]) — which steps exist and when each was
  /// reached is the order's business, not this pack's.
  List<_Step> _steps() => [
    for (final step in order.timelineSteps)
      _Step(
        label: switch (step.status) {
          OrderStatus.pending => GraviaValueConst.orderStepPlacedLabel,
          OrderStatus.inProcess => GraviaValueConst.orderStepOnTheWayLabel,
          OrderStatus.delivered => GraviaValueConst.orderStepDeliveredLabel,
          OrderStatus.cancelled => GraviaValueConst.orderStepCancelledLabel,
        },
        at: step.at,
        reached: step.reached,
        isCancellation: step.status == OrderStatus.cancelled,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final steps = _steps();

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          _StepRow(
            step: steps[i],
            // The connector belongs to the step above it, and runs solid
            // only when the step below was also reached — a half-lit line
            // is what makes "got this far" readable at a glance.
            showConnector: i < steps.length - 1,
            connectorReached: i < steps.length - 1 && steps[i + 1].reached,
          ),
      ],
    );
  }
}

class _Step {
  final String label;
  final DateTime? at;
  final bool reached;

  /// A cancellation reads in the error colour — it's the one step that isn't
  /// good news, and a green tick beside "Cancelled" is actively confusing.
  final bool isCancellation;

  const _Step({
    required this.label,
    required this.at,
    required this.reached,
    this.isCancellation = false,
  });
}

class _StepRow extends StatelessWidget {
  final _Step step;
  final bool showConnector;
  final bool connectorReached;

  static const double _markSize = 24;
  static const double _connectorWidth = 2;
  static const double _connectorHeight = 28;

  const _StepRow({
    required this.step,
    required this.showConnector,
    required this.connectorReached,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairline = context.appColors.dockedHairline;
    final markColor = step.isCancellation ? cs.error : cs.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: _markSize,
              height: _markSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: step.reached ? markColor : Colors.transparent,
                border: Border.all(
                  color: step.reached ? markColor : hairline,
                  width: _connectorWidth,
                ),
              ),
              child: step.reached
                  ? Icon(
                      step.isCancellation
                          ? Icons.close_rounded
                          : Icons.check_rounded,
                      size: AppSpacing.base,
                      // Each disc's own foreground: the cancelled one is
                      // filled with `error`, and `onPrimary` is white — which
                      // all but disappears on the pale red the dark theme
                      // resolves `error` to.
                      color: step.isCancellation ? cs.onError : cs.onPrimary,
                    )
                  : null,
            ),
            if (showConnector)
              Container(
                width: _connectorWidth,
                height: _connectorHeight,
                color: connectorReached ? markColor : hairline,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: Padding(
            // Aligns the label's cap-height with the mark beside it rather
            // than the row's top edge.
            padding: const EdgeInsets.only(top: AppSpacing.xs3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: GraviaTextStyleConst.textSmMedium(tt).copyWith(
                    color: step.reached
                        ? cs.onSurface
                        : GraviaColorConst.gray500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs4),
                Text(
                  // A reached step with no recorded time says so; an
                  // unreached one has nothing to date at all.
                  step.at?.orderPlacedLabel ??
                      (step.reached
                          ? GraviaValueConst.orderStepUndatedLabel
                          : ''),
                  style: GraviaTextStyleConst.textXsRegular(
                    tt,
                  ).copyWith(color: GraviaColorConst.gray500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
