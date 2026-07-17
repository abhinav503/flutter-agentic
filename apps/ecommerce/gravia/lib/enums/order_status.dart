/// An order's lifecycle stage. Drives which tab it appears under
/// (`OrderStatus.inProcess` → Upcoming; delivered/cancelled → Past) and
/// which parts of `OrderItemCard` render (OTP + Cancel/Track Order are
/// in-process-only — a delivered or cancelled order has nothing left to
/// track or cancel).
enum OrderStatus { inProcess, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  bool get isUpcoming => this == OrderStatus.inProcess;
}

// String -> enum only: orders.json is read-only mock data, never written
// back, so there's no enum -> wire-string direction to support.
extension OrderStatusParse on String {
  OrderStatus toOrderStatus() => switch (this) {
    'DELIVERED' => OrderStatus.delivered,
    'CANCELLED' => OrderStatus.cancelled,
    _ => OrderStatus.inProcess,
  };
}
