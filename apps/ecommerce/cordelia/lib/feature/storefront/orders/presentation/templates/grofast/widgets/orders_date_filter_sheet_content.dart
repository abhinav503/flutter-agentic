import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_chip.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_form_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_options_sheet_content.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';

import '../../../bloc/orders_bloc.dart';
import '../../../orders_date_filter_state.dart';

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
    extends State<GrofastOrdersDateFilterSheetContent>
    with OrdersDateFilterState {
  @override
  OrdersFilter? get initialFilter => widget.initialFilter;

  @override
  DateTime get anchor => widget.anchor;

  /// This pack's copy for the shared windows, in the mixin's order. A
  /// getter, not `static const` — the labels come from L10n.
  static List<String> get _labels => [
    GrofastValueConst.ordersFilterLastWeekLabel,
    GrofastValueConst.ordersFilterLastMonthLabel,
  ];

  void _close(OrdersFilter? result) {
    Navigator.of(context).pop();
    widget.onApply(result);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GrofastSheetSection(
          title: GrofastValueConst.ordersDateFilterTitle,
          child: GrofastChipRow(
            labels: _labels,
            selectedIndex: period == null
                ? -1
                : OrdersDateFilterState.quickPicks.indexOf(period!),
            onSelected: (index) =>
                togglePeriod(OrdersDateFilterState.quickPicks[index]),
          ),
        ),
        const SizedBox(height: AppSpacing.xl4),
        GrofastDropdownField(
          label: GrofastValueConst.ordersDateRangeLabel,
          hint: GrofastValueConst.ordersAllTimeLabel,
          value: from == null || to == null
              ? ''
              : GrofastValueConst.ordersDateRangeValue(from!, to!),
          onTap: pickRange,
        ),
        const SizedBox(height: AppSpacing.xl6),
        GrofastPrimaryButton(
          label: GrofastValueConst.applyLabel,
          onTap: () => _close(selectedFilter),
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
