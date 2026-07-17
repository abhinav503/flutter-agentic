import 'package:gravia/constants/value_const.dart';

/// The Orders filter sheet's quick date-range picks ("Select a Reason").
/// Used purely in-memory (chosen on the sheet, never crosses a JSON
/// boundary), so it needs no wire-string conversion.
enum OrdersFilterPeriod { lastWeek, lastMonth }

extension OrdersFilterPeriodX on OrdersFilterPeriod {
  String get label => switch (this) {
    OrdersFilterPeriod.lastWeek => ValueConst.filterLastWeekLabel,
    OrdersFilterPeriod.lastMonth => ValueConst.filterLastMonthLabel,
  };

  /// Start of the trailing window that ends at [end]: seven days back for
  /// last week, one calendar month back for last month.
  DateTime startBefore(DateTime end) => switch (this) {
    OrdersFilterPeriod.lastWeek => end.subtract(const Duration(days: 7)),
    OrdersFilterPeriod.lastMonth => DateTime(end.year, end.month - 1, end.day),
  };
}
