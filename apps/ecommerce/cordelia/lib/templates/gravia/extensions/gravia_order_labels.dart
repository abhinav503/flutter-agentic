import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/enums/orders_filter_period.dart';

import '../constants/gravia_value_const.dart';

/// Gravia's shopper-facing wording for the shared order enums. Lives in the
/// pack — not `lib/enums/` — so the shared orders stack stays
/// template-neutral; dailymart maps the same enums through
/// `DailyMartValueConst.orderStatusLabel` / `refundStatusLabel`.
extension GraviaOrderStatusLabelX on OrderStatus {
  String get label => switch (this) {
    OrderStatus.pending => GraviaValueConst.pendingStatusLabel,
    OrderStatus.inProcess => GraviaValueConst.inProcessStatusLabel,
    OrderStatus.delivered => GraviaValueConst.deliveredStatusLabel,
    OrderStatus.cancelled => GraviaValueConst.cancelledStatusLabel,
  };
}

extension GraviaRefundStatusLabelX on RefundStatus {
  /// The shopper-facing note; null for [RefundStatus.none] — nothing to show
  /// when no money was ever taken.
  String? get label => switch (this) {
    RefundStatus.none => null,
    RefundStatus.pending => GraviaValueConst.refundPendingLabel,
    RefundStatus.processed => GraviaValueConst.refundProcessedLabel,
    RefundStatus.failed => GraviaValueConst.refundFailedLabel,
  };
}

extension GraviaOrdersFilterPeriodLabelX on OrdersFilterPeriod {
  String get label => switch (this) {
    OrdersFilterPeriod.lastWeek => GraviaValueConst.filterLastWeekLabel,
    OrdersFilterPeriod.lastMonth => GraviaValueConst.filterLastMonthLabel,
  };
}
