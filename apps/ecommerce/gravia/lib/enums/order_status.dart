import 'package:gravia/constants/value_const.dart';

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

  String get label => switch (this) {
    OrderStatus.pending => ValueConst.pendingStatusLabel,
    OrderStatus.inProcess => ValueConst.inProcessStatusLabel,
    OrderStatus.delivered => ValueConst.deliveredStatusLabel,
    OrderStatus.cancelled => ValueConst.cancelledStatusLabel,
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

extension RefundStatusX on RefundStatus {
  /// The shopper-facing note; null for [none] — nothing to show when no money
  /// was ever taken.
  String? get label => switch (this) {
    RefundStatus.none => null,
    RefundStatus.pending => ValueConst.refundPendingLabel,
    RefundStatus.processed => ValueConst.refundProcessedLabel,
    RefundStatus.failed => ValueConst.refundFailedLabel,
  };
}

extension RefundStatusParse on String {
  RefundStatus toRefundStatus() => switch (this) {
    'PENDING' => RefundStatus.pending,
    'PROCESSED' => RefundStatus.processed,
    'FAILED' => RefundStatus.failed,
    _ => RefundStatus.none,
  };
}
