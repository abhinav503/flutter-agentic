/// An order's lifecycle stage. Drives which tab it appears under
/// (`pending`/`inProcess` → Upcoming; delivered/cancelled → Past) and
/// which parts of `OrderItemCard` render (OTP + Cancel/Track Order are
/// upcoming-only — a delivered or cancelled order has nothing left to
/// track or cancel). `pending` is the backend's freshly-placed-but-not-yet-
/// accepted state (`OrderStatus` in `admin/src/lib/types.ts`) — bucketed
/// with `inProcess` under Upcoming since neither has anything to view/review
/// yet, but labelled distinctly so a shopper can tell "just placed" from
/// "store accepted it."
enum OrderStatus { pending, inProcess, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  bool get isUpcoming =>
      this == OrderStatus.pending || this == OrderStatus.inProcess;

  /// The wire value [OrderStatusParse] reads back — `OrderStatus` in
  /// `admin/src/lib/types.ts`. Only the mock-data write path needs it (the
  /// server owns every real status change), but both `OrderModel` and
  /// `OrderStatusChangeModel` serialize through it, so it lives here rather
  /// than inline in one of them.
  String get wireValue => switch (this) {
    OrderStatus.pending => 'PENDING',
    OrderStatus.inProcess => 'IN_PROCESS',
    OrderStatus.delivered => 'DELIVERED',
    OrderStatus.cancelled => 'CANCELLED',
  };
}

extension OrderStatusParse on String {
  OrderStatus toOrderStatus() => switch (this) {
    'PENDING' => OrderStatus.pending,
    'DELIVERED' => OrderStatus.delivered,
    'CANCELLED' => OrderStatus.cancelled,
    _ => OrderStatus.inProcess,
  };
}

/// The refund lifecycle for a cancelled order — an axis orthogonal to
/// [OrderStatus] (mirrors `RefundStatus` in `admin/src/lib/types.ts`), so a
/// cancelled order carries separately whether its money has been returned.
/// [none] = never paid (test/web) or not cancelled; [pending] = Razorpay
/// accepted the refund, still settling; [processed] = settled; [failed] = the
/// refund call errored (order is still cancelled — retriable).
enum RefundStatus { none, pending, processed, failed }

extension RefundStatusParse on String {
  RefundStatus toRefundStatus() => switch (this) {
    'PENDING' => RefundStatus.pending,
    'PROCESSED' => RefundStatus.processed,
    'FAILED' => RefundStatus.failed,
    _ => RefundStatus.none,
  };
}
