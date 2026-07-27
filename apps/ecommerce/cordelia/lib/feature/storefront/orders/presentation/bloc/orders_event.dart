part of 'orders_bloc.dart';

@freezed
sealed class OrdersEvent with _$OrdersEvent {
  const factory OrdersEvent.started() = OrdersStarted;
  const factory OrdersEvent.tabChanged({required OrdersTab tab}) =
      OrdersTabChanged;

  /// Cancels the order through the backend (restock + refund if it was paid).
  /// Applied optimistically — the card flips to [OrderStatus.cancelled]
  /// immediately, then reconciles with the server's returned order (its real
  /// [RefundStatus]) or rolls back on failure.
  const factory OrdersEvent.cancelled({required String orderId}) =
      OrdersCancelled;

  const factory OrdersEvent.filterApplied({required OrdersFilter filter}) =
      OrdersFilterApplied;
}
