import 'package:cordelia/enums/order_status.dart';

/// One dated step in an order's lifecycle — mirrors `OrderStatusChange` in
/// `admin/src/lib/types.ts`.
///
/// The server appends one of these per transition, which is the only record
/// of *when* an order moved: [OrderEntity.status] holds the current value and
/// overwrites the previous one on every update. A Track Order timeline dates
/// its steps from this list.
class OrderStatusChangeEntity {
  final OrderStatus status;
  final DateTime at;

  const OrderStatusChangeEntity({required this.status, required this.at});
}
