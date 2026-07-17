part of 'orders_bloc.dart';

@freezed
sealed class OrdersEvent with _$OrdersEvent {
  const factory OrdersEvent.started() = OrdersStarted;
  const factory OrdersEvent.tabChanged({required OrdersTab tab}) =
      OrdersTabChanged;

  /// No real cancellation backend to call — this is a demo action that just
  /// flips the matching order to [OrderStatus.cancelled] in memory, the same
  /// "mutate the bloc's own state" shape as `AddressEvent.saved`.
  const factory OrdersEvent.cancelled({required String orderId}) =
      OrdersCancelled;

  const factory OrdersEvent.filterApplied({required OrdersFilter filter}) =
      OrdersFilterApplied;
}
