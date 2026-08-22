import 'package:cordelia/enums/order_status.dart';

import '../domain/entities/order_entity.dart';

/// One row of an order's status timeline.
class OrderTimelineStep {
  final OrderStatus status;

  /// When it happened, or null for a step this order has no dated record of
  /// — either it hasn't happened yet, or the order predates `statusHistory`.
  final DateTime? at;

  /// Whether the order has got this far.
  final bool reached;

  const OrderTimelineStep({
    required this.status,
    required this.at,
    required this.reached,
  });
}

/// The steps a Track Order timeline draws, oldest first — the same three
/// (or, once cancelled, the same two) in every template.
///
/// Shared because *which* steps exist and *when* each was reached is the
/// order's business, not the pack's; each template was deriving it again
/// beside its own discs and connectors. What stays per-pack is the wording
/// and the drawing.
extension OrderTimelineX on OrderEntity {
  List<OrderTimelineStep> get timelineSteps {
    // Placement is always dated: `placedAt` is known even on an order
    // written before `statusHistory` existed.
    final placed = OrderTimelineStep(
      status: OrderStatus.pending,
      at: statusReachedAt(OrderStatus.pending) ?? placedAt,
      reached: true,
    );

    if (status == OrderStatus.cancelled) {
      return [
        placed,
        OrderTimelineStep(
          status: OrderStatus.cancelled,
          at: statusReachedAt(OrderStatus.cancelled),
          reached: true,
        ),
      ];
    }

    return [
      placed,
      OrderTimelineStep(
        status: OrderStatus.inProcess,
        at: statusReachedAt(OrderStatus.inProcess),
        reached:
            status == OrderStatus.inProcess || status == OrderStatus.delivered,
      ),
      OrderTimelineStep(
        status: OrderStatus.delivered,
        at: statusReachedAt(OrderStatus.delivered),
        reached: status == OrderStatus.delivered,
      ),
    ];
  }
}
