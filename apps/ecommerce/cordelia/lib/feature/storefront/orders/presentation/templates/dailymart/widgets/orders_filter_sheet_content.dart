import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/enums/orders_filter_period.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_action_pair.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_dropdown_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_filter_chip.dart';

import '../../../bloc/orders_bloc.dart';

/// Body of My Orders' Filter sheet — **dates only**, in the pack's own sheet
/// grammar (kit frame `21`): quick-pick chips, one bordered select field,
/// and the Reset / Apply pair.
///
/// No status control, unlike gravia's version of this sheet: this template
/// puts status on the screen itself as the chip row over the list, and a
/// second status control inside the sheet would let the two disagree about
/// what's being shown.
///
/// Everything is sheet-local draft state until Reset or Apply hands the
/// result to [onApply] — the same "screen-local until submit" carve-out the
/// Add/Edit Address form uses. A null [OrdersFilter] means no date
/// constraint at all, which is what both an untouched sheet and Reset send.
class DailyMartOrdersFilterSheetContent extends StatefulWidget {
  /// The filter currently narrowing the list, or null when none is applied —
  /// so reopening the sheet shows what's in force rather than a blank form.
  final OrdersFilter? initialFilter;

  /// End of the quick picks' trailing windows and the calendar's upper
  /// bound; the screen passes `DateTime.now()`. Injected rather than read
  /// here so the sheet stays deterministic under test.
  final DateTime anchor;

  final ValueChanged<OrdersFilter?> onApply;

  const DailyMartOrdersFilterSheetContent({
    super.key,
    required this.initialFilter,
    required this.anchor,
    required this.onApply,
  });

  @override
  State<DailyMartOrdersFilterSheetContent> createState() =>
      _DailyMartOrdersFilterSheetContentState();
}

class _DailyMartOrdersFilterSheetContentState
    extends State<DailyMartOrdersFilterSheetContent> {
  late OrdersFilterPeriod? _period = widget.initialFilter?.period;
  late DateTime? _from = widget.initialFilter?.from;
  late DateTime? _to = widget.initialFilter?.to;

  static const _quickPicks = <(OrdersFilterPeriod, String)>[
    (
      OrdersFilterPeriod.lastWeek,
      DailyMartValueConst.ordersFilterLastWeekLabel,
    ),
    (
      OrdersFilterPeriod.lastMonth,
      DailyMartValueConst.ordersFilterLastMonthLabel,
    ),
  ];

  /// Tapping the selected chip again clears it — with only two windows and
  /// no "All time" chip, that's the only way back to an unbounded range
  /// without opening the calendar.
  void _toggle(OrdersFilterPeriod period) => setState(() {
    if (_period == period) {
      _period = null;
      _from = null;
      _to = null;
      return;
    }
    _period = period;
    _from = period.startBefore(widget.anchor);
    _to = widget.anchor;
  });

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(widget.anchor.year - 1),
      // An order can't be placed in the future, so future dates are disabled.
      lastDate: widget.anchor,
      initialDateRange: _from == null || _to == null
          ? null
          : DateTimeRange(start: _from!, end: _to!),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _from = picked.start;
      _to = picked.end;
      // A hand-picked range no longer corresponds to a quick pick.
      _period = null;
    });
  }

  void _reset() => widget.onApply(null);

  void _apply() {
    final from = _from;
    final to = _to;
    widget.onApply(
      from == null || to == null
          ? null
          : OrdersFilter(from: from, to: to, period: _period),
    );
  }

  @override
  Widget build(BuildContext context) {
    final from = _from;
    final to = _to;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (final (period, label) in _quickPicks) ...[
                if (period != _quickPicks.first.$1)
                  const SizedBox(width: AppSpacing.sm),
                DailyMartFilterChip(
                  label: label,
                  selected: _period == period,
                  onTap: () => _toggle(period),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          DailyMartDropdownField(
            label: DailyMartValueConst.ordersDateRangeLabel,
            value: from == null || to == null
                ? DailyMartValueConst.ordersAllTimeLabel
                : DailyMartValueConst.ordersDateRangeValue(from, to),
            onTap: _pickRange,
          ),
          const SizedBox(height: AppSpacing.xl2),
          DailyMartActionPair(
            cancelLabel: DailyMartValueConst.resetLabel,
            confirmLabel: DailyMartValueConst.applyLabel,
            // Reset commits straight away rather than only clearing the
            // draft: "Reset" then having to press Apply to see it take
            // effect reads as a control that didn't work.
            onCancel: _reset,
            onConfirm: _apply,
          ),
        ],
      ),
    );
  }
}
