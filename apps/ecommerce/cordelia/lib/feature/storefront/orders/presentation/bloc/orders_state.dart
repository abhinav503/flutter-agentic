part of 'orders_bloc.dart';

@freezed
sealed class OrdersState with _$OrdersState {
  const factory OrdersState.loading() = OrdersLoading;
  const factory OrdersState.loaded({
    required List<OrderEntity> orders,
    required OrdersTab selectedTab,

    /// Null until the filter sheet's Apply Filter is tapped — no filter,
    /// every order in the selected tab shows.
    OrdersFilter? filter,

    /// True only when a silent background refresh (a warm start seeded from
    /// OrdersBloc's cached data) fails — the already-visible cached content
    /// stays on screen; the listener surfaces this via a snackbar instead of
    /// replacing it with the error view.
    @Default(false) bool refreshFailed,

    /// True for one emission after a cancel request fails and its optimistic
    /// update is rolled back — the listener surfaces a snackbar, and any
    /// later event (tab/filter change) clears it so it can't re-fire.
    @Default(false) bool cancelFailed,
  }) = OrdersLoaded;
  const factory OrdersState.error({required String message}) = OrdersError;
}

/// The filter sheet's applied selection. [period] is only the quick pick
/// that produced [from]/[to] (kept so the sheet re-opens showing it);
/// filtering reads the dates and [status] alone. Null [status] = all.
@freezed
abstract class OrdersFilter with _$OrdersFilter {
  const factory OrdersFilter({
    required DateTime from,
    required DateTime to,
    OrdersFilterPeriod? period,
    OrderStatus? status,
  }) = _OrdersFilter;
}

extension OrdersFilterX on OrdersFilter {
  /// [to] is a calendar date, so compare against the following midnight —
  /// an order placed later that same day still matches.
  bool matches(OrderEntity order) =>
      (status == null || order.status == status) &&
      !order.placedAt.isBefore(DateTime(from.year, from.month, from.day)) &&
      order.placedAt.isBefore(DateTime(to.year, to.month, to.day + 1));
}
