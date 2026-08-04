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

  /// Rates a delivered order 1-5 with optional text. Rating again replaces
  /// the previous one. Not optimistic, unlike [OrdersCancelled]: the write
  /// changes nothing about where the order sits in the list, so there is
  /// nothing for a shopper to watch happen — and a rating that silently
  /// reverted would be worse than one that took a moment to appear.
  const factory OrdersEvent.rated({
    required String orderId,
    required int rating,
    required String text,
  }) = OrdersRated;

  /// A null [filter] clears the date constraint — what `dailymart`'s filter
  /// sheet sends from Reset, and from Apply with no range picked. gravia's
  /// sheet has no Reset and always passes one.
  const factory OrdersEvent.filterApplied({OrdersFilter? filter}) =
      OrdersFilterApplied;

  /// `dailymart`'s chip row and search field (kit frame `35`). Both narrow
  /// the already-fetched list — neither re-queries the backend.
  const factory OrdersEvent.statusFilterChanged({
    required OrdersStatusFilter filter,
  }) = OrdersStatusFilterChanged;
  const factory OrdersEvent.searched({required String term}) = OrdersSearched;
}
