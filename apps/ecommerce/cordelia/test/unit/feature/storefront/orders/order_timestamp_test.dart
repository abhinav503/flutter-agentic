import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/feature/storefront/orders/data/models/order_model.dart';
import 'package:cordelia/feature/storefront/orders/data/models/order_status_change_model.dart';

/// The server stamps every order timestamp with `new Date().toISOString()` —
/// UTC, with a `Z`. `DateTime.parse` keeps such a string in UTC, and
/// `DateFormat` renders a `DateTime` in its own zone, so a timestamp that
/// reaches the UI still in UTC prints the wrong wall clock: an IST shopper
/// read a 9:33 PM order as 4:04 PM, and a US one would have read the wrong
/// day. The conversion belongs at the data boundary, and this pins it there.
void main() {
  const instant = '2026-08-21T16:03:00.000Z';
  final expected = DateTime.utc(2026, 8, 21, 16, 3);

  Map<String, dynamic> orderJson() => {
    'id': 'order-1',
    'status': 'PENDING',
    'refund_status': 'NONE',
    'placed_at': instant,
    'reviewed_at': instant,
    'status_history': [
      {'status': 'PENDING', 'at': instant},
    ],
    'delivery_otp': '',
    'payment_id': '',
    'items': <dynamic>[],
  };

  test('placedAt arrives local, keeping the same instant', () {
    final order = OrderModel.fromJson(orderJson()).toEntity();

    expect(
      order.placedAt.isUtc,
      isFalse,
      reason: 'DateFormat renders in the DateTime\'s own zone',
    );
    expect(order.placedAt.toUtc(), expected);
  });

  test('every dated step in the timeline is local too', () {
    final order = OrderModel.fromJson(orderJson()).toEntity();
    final step = order.statusHistory.single;

    expect(step.at.isUtc, isFalse);
    expect(step.at.toUtc(), expected);
  });

  test('an order rating carries the same treatment', () {
    final order = OrderModel.fromJson(orderJson()).toEntity();

    expect(order.reviewedAt!.isUtc, isFalse);
    expect(order.reviewedAt!.toUtc(), expected);
  });

  test('a model built back from an entity puts UTC on the wire', () {
    // The round trip has to preserve the instant, not the wall clock — the
    // server only ever speaks UTC.
    final order = OrderModel.fromJson(orderJson()).toEntity();

    expect(OrderModel.fromEntity(order).placedAt, endsWith('Z'));
    expect(
      DateTime.parse(OrderModel.fromEntity(order).placedAt).toUtc(),
      expected,
    );
    expect(
      OrderStatusChangeModel.fromEntity(order.statusHistory.single).at,
      endsWith('Z'),
    );
  });
}
