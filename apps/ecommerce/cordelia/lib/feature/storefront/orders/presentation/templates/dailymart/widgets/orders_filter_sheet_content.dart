import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_action_pair.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_dropdown_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_filter_chip.dart';

import '../../../bloc/orders_bloc.dart';
import '../../../orders_date_filter_state.dart';

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
    extends State<DailyMartOrdersFilterSheetContent>
    with OrdersDateFilterState {
  @override
  OrdersFilter? get initialFilter => widget.initialFilter;

  @override
  DateTime get anchor => widget.anchor;

  /// This pack's copy for the shared windows, in the mixin's order. A
  /// getter, not `static const` — the labels come from L10n.
  static List<String> get _labels => [
    DailyMartValueConst.ordersFilterLastWeekLabel,
    DailyMartValueConst.ordersFilterLastMonthLabel,
  ];

  void _reset() => widget.onApply(null);

  void _apply() => widget.onApply(selectedFilter);

  @override
  Widget build(BuildContext context) {
    final start = from;
    final end = to;

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
              for (var i = 0; i < _labels.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                DailyMartFilterChip(
                  label: _labels[i],
                  selected: period == OrdersDateFilterState.quickPicks[i],
                  onTap: () =>
                      togglePeriod(OrdersDateFilterState.quickPicks[i]),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          DailyMartDropdownField(
            label: DailyMartValueConst.ordersDateRangeLabel,
            value: start == null || end == null
                ? DailyMartValueConst.ordersAllTimeLabel
                : DailyMartValueConst.ordersDateRangeValue(start, end),
            onTap: pickRange,
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
