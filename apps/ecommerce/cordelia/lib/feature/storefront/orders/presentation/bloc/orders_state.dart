part of 'orders_bloc.dart';

/// [OrdersLoaded.refreshFailed], [OrdersLoaded.cancelFailed] and
/// [OrdersLoaded.rateFailed] are one-shot signals to the screen's listener,
/// not state the screen renders — every later emission clears them through
/// `OrdersBloc._emitView`.
@freezed
sealed class OrdersState with _$OrdersState {
  const factory OrdersState.loading() = OrdersLoading;
  const factory OrdersState.loaded({
    required List<OrderEntity> orders,
    required OrdersTab selectedTab,

    /// Null until the filter sheet's Apply Filter is tapped — no filter,
    /// every order in the selected tab shows.
    OrdersFilter? filter,

    /// `dailymart`'s chip row and search field. Both are view selections the
    /// same way [selectedTab] and [filter] are — the screen renders them, it
    /// doesn't own them. gravia leaves both at their defaults, which match
    /// everything, so its list is unaffected.
    @Default(OrdersStatusFilter.all) OrdersStatusFilter statusFilter,
    @Default('') String searchTerm,

    /// True for one emission when a silent background refresh (a warm start
    /// seeded from OrdersBloc's cached data) fails — the already-visible
    /// cached content stays on screen; the listener surfaces this via a
    /// snackbar instead of replacing it with the error view.
    @Default(false) bool refreshFailed,

    /// True for one emission after a cancel request fails and its optimistic
    /// update is rolled back — the listener surfaces a snackbar.
    @Default(false) bool cancelFailed,

    /// True for one emission after rating an order fails, including a stale
    /// tap on one that has left the list. The list is untouched either way
    /// (the rating is written straight through, not optimistically — there
    /// is nothing to roll back).
    ///
    /// Read by the *sheet*, not a screen listener: it stays open on a
    /// failure and prints the reason itself, keeping what the shopper wrote.
    /// A snackbar behind an open modal is invisible while it matters, and
    /// the sheet is the only way to reach this event.
    @Default(false) bool rateFailed,
  }) = OrdersLoaded;
  const factory OrdersState.error({required String message}) = OrdersError;
}

extension OrdersStateOrderX on OrdersState {
  /// The freshest copy of [order] — the one in the loaded list when it's
  /// there, the passed-in one otherwise.
  ///
  /// A screen opened with an order handed to it (Track Order takes one
  /// through `extra`) would otherwise keep rendering that snapshot after a
  /// write, so a rating it just saved wouldn't show. Falling back to the
  /// original keeps it working before the list has loaded, and for an order
  /// that has since left it.
  OrderEntity freshest(OrderEntity order) => switch (this) {
    OrdersLoaded(:final orders) => orders.firstWhere(
      (o) => o.id == order.id,
      orElse: () => order,
    ),
    OrdersLoading() || OrdersError() => order,
  };
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

extension OrdersStatusFilterX on OrdersStatusFilter {
  /// Active bundles `pending` *and* `inProcess` — the chip asks "is this
  /// order still coming?", which is exactly what [OrderStatusX.isUpcoming]
  /// already answers.
  bool matches(OrderEntity order) => switch (this) {
    OrdersStatusFilter.all => true,
    OrdersStatusFilter.active => order.status.isUpcoming,
    OrdersStatusFilter.completed => order.status == OrderStatus.delivered,
    OrdersStatusFilter.cancelled => order.status == OrderStatus.cancelled,
  };
}

extension OrdersFilterX on OrdersFilter {
  /// [to] is a calendar date, so compare against the following midnight —
  /// an order placed later that same day still matches.
  bool matches(OrderEntity order) =>
      (status == null || order.status == status) &&
      !order.placedAt.isBefore(DateTime(from.year, from.month, from.day)) &&
      order.placedAt.isBefore(DateTime(to.year, to.month, to.day + 1));
}
