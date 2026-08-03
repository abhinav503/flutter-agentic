import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/enums/orders_filter_period.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_chip.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_form_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_options_sheet_content.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';

import '../../../bloc/orders_bloc.dart';

/// Body of My Orders' date-filter sheet — **dates only**, on the pack's own
/// sheet grammar: quick-pick chips, the range as a picklist-trigger field
/// opening the platform range picker, then Apply over Reset stacked
/// vertically (this pack never sets two actions side by side).
///
/// No status control: this template puts status on the screen itself as the
/// chip row over the list, and a second status control inside the sheet
/// would let the two disagree about what's being shown — the same call
/// dailymart's sheet documents.
///
/// Everything is sheet-local draft state until Reset or Apply hands the
/// result to [onApply]. A null [OrdersFilter] means no date constraint at
/// all, which is what both an untouched sheet and Reset send.
class GrofastOrdersDateFilterSheetContent extends StatefulWidget {
  /// The filter currently narrowing the list, or null when none is applied —
  /// so reopening the sheet shows what's in force rather than a blank form.
  final OrdersFilter? initialFilter;

  /// End of the quick picks' trailing windows and the calendar's upper
  /// bound; the screen passes `DateTime.now()`. Injected rather than read
  /// here so the sheet stays deterministic under test.
  final DateTime anchor;

  final ValueChanged<OrdersFilter?> onApply;

  const GrofastOrdersDateFilterSheetContent({
    super.key,
    required this.initialFilter,
    required this.anchor,
    required this.onApply,
  });

  @override
  State<GrofastOrdersDateFilterSheetContent> createState() =>
      _GrofastOrdersDateFilterSheetContentState();
}

class _GrofastOrdersDateFilterSheetContentState
    extends State<GrofastOrdersDateFilterSheetContent> {
  late OrdersFilterPeriod? _period = widget.initialFilter?.period;
  late DateTime? _from = widget.initialFilter?.from;
  late DateTime? _to = widget.initialFilter?.to;

  static const _quickPicks = <(OrdersFilterPeriod, String)>[
    (OrdersFilterPeriod.lastWeek, GrofastValueConst.ordersFilterLastWeekLabel),
    (
      OrdersFilterPeriod.lastMonth,
      GrofastValueConst.ordersFilterLastMonthLabel,
    ),
  ];

  /// Tapping the selected chip again clears it — with only two windows and
  /// no "All time" chip, that's the only way back to an unbounded range
  /// without opening the calendar.
  void _toggle(int index) => setState(() {
    final (period, _) = _quickPicks[index];
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

  void _close(OrdersFilter? result) {
    Navigator.of(context).pop();
    widget.onApply(result);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final from = _from;
    final to = _to;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GrofastSheetSection(
          title: GrofastValueConst.ordersDateFilterTitle,
          child: GrofastChipRow(
            labels: [for (final (_, label) in _quickPicks) label],
            selectedIndex: _period == null
                ? -1
                : _quickPicks.indexWhere((pick) => pick.$1 == _period),
            onSelected: _toggle,
          ),
        ),
        const SizedBox(height: AppSpacing.xl4),
        GrofastDropdownField(
          label: GrofastValueConst.ordersDateRangeLabel,
          hint: GrofastValueConst.ordersAllTimeLabel,
          value: from == null || to == null
              ? ''
              : GrofastValueConst.ordersDateRangeValue(from, to),
          onTap: _pickRange,
        ),
        const SizedBox(height: AppSpacing.xl6),
        GrofastPrimaryButton(
          label: GrofastValueConst.applyLabel,
          onTap: () => _close(
            from == null || to == null
                ? null
                : OrdersFilter(from: from, to: to, period: _period),
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        AppButton(
          label: GrofastValueConst.resetLabel,
          variant: AppButtonVariant.secondary,
          size: AppButtonSize.large,
          fullWidth: true,
          height: GrofastDimenConst.controlHeight,
          borderRadius: AppRadius.full,
          borderColor: cs.outline,
          labelStyle: GrofastTextStyleConst.labelSemibold(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
          onTap: () => _close(null),
        ),
      ],
    );
  }
}
