/// The chip row on `dailymart`'s My Orders (kit frame `35`) — a status
/// filter, unlike gravia's two-segment [OrdersTab], which splits the same
/// list by *time* (upcoming vs past).
///
/// Used purely in-memory (chosen on the screen, never crosses a JSON
/// boundary), so it needs no wire-string conversion. The predicate lives in
/// `orders_state.dart` beside `OrdersFilterX`, where the order entity is
/// already in scope.
enum OrdersStatusFilter { all, active, completed, cancelled }
