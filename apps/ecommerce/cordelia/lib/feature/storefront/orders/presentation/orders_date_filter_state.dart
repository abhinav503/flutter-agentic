import 'package:flutter/material.dart';

import 'package:cordelia/enums/orders_filter_period.dart';

import 'bloc/orders_bloc.dart';

/// The date-filter sheet's state, shared by every pack that ships one.
///
/// The *chrome* differs per kit (dailymart's plain sheet, grofast's domed one)
/// but the decisions don't: two quick-pick windows, a hand-picked range from
/// the calendar, and the rules for how the two interact. Only the pack's own
/// labels and layout stay in each screen.
///
/// The host supplies [initialFilter] and [anchor] (the "now" the windows count
/// back from — injected rather than read here so a sheet stays deterministic
/// under test).
mixin OrdersDateFilterState<T extends StatefulWidget> on State<T> {
  OrdersFilter? get initialFilter;
  DateTime get anchor;

  late OrdersFilterPeriod? period = initialFilter?.period;
  late DateTime? from = initialFilter?.from;
  late DateTime? to = initialFilter?.to;

  /// The windows every pack offers. Labels are the pack's business — a screen
  /// zips its own copy against this order.
  static const quickPicks = <OrdersFilterPeriod>[
    OrdersFilterPeriod.lastWeek,
    OrdersFilterPeriod.lastMonth,
  ];

  /// Tapping the selected window again clears it — with only two windows and
  /// no "All time" chip, that's the only way back to an unbounded range
  /// without opening the calendar.
  void togglePeriod(OrdersFilterPeriod picked) => setState(() {
    if (period == picked) {
      period = null;
      from = null;
      to = null;
      return;
    }
    period = picked;
    from = picked.startBefore(anchor);
    to = anchor;
  });

  Future<void> pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(anchor.year - 1),
      // An order can't be placed in the future, so future dates are disabled.
      lastDate: anchor,
      initialDateRange: from == null || to == null
          ? null
          : DateTimeRange(start: from!, end: to!),
    );
    if (picked == null || !mounted) return;
    setState(() {
      from = picked.start;
      to = picked.end;
      // A hand-picked range no longer corresponds to a quick pick.
      period = null;
    });
  }

  /// The filter the current selection stands for — null when nothing is
  /// chosen, which every pack's Reset also reports.
  OrdersFilter? get selectedFilter {
    final start = from;
    final end = to;
    if (start == null || end == null) return null;
    return OrdersFilter(period: period, from: start, to: end);
  }
}
