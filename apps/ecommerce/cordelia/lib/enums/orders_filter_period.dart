/// The Orders filter sheet's quick date-range picks ("Select a Reason").
/// Used purely in-memory (chosen on the sheet, never crosses a JSON
/// boundary), so it needs no wire-string conversion. Display labels live in
/// each pack (`GraviaOrdersFilterPeriodLabelX` / `DailyMartValueConst`) so
/// this stays template-neutral.
enum OrdersFilterPeriod { lastWeek, lastMonth }

extension OrdersFilterPeriodX on OrdersFilterPeriod {
  /// Start of the trailing window that ends at [end]: seven days back for
  /// last week, one calendar month back for last month.
  DateTime startBefore(DateTime end) => switch (this) {
    OrdersFilterPeriod.lastWeek => end.subtract(const Duration(days: 7)),
    OrdersFilterPeriod.lastMonth => DateTime(end.year, end.month - 1, end.day),
  };
}
