import 'package:cordelia/enums/order_status.dart';
import 'package:cordelia/enums/orders_filter_period.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/extensions/gravia_order_labels.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_dropdown_field.dart';
import 'package:cordelia/templates/gravia/widgets/radio_options_sheet_content.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:core/core/theme/app_spacing.dart';

import '../../../../domain/entities/order_entity.dart';
import '../../../bloc/orders_bloc.dart';

/// Body of the Orders filter sheet: quick-period radios ("Select a Reason"),
/// a Status picklist field, a Date range field, and the Apply Filter CTA.
/// Everything is sheet-local draft state until Apply hands the finished
/// [OrdersFilter] to [onApply] — the same "screen-local until submit"
/// carve-out the Add/Edit Address form uses.
class OrdersFilterSheetContent extends StatefulWidget {
  final OrdersFilter initialFilter;

  /// End of the quick periods' trailing windows and the calendar picker's
  /// upper bound — the screen passes `DateTime.now()`; injected rather than
  /// read here so the sheet stays deterministic under test.
  final DateTime anchor;

  final ValueChanged<OrdersFilter> onApply;

  /// The screen's own `showGraviaSheet`, passed down because the Status
  /// picklist opens its sheet from inside this sheet and the extension lives
  /// on `BaseScreenState`.
  final Future<void> Function({required String title, required Widget child})
  showSheet;

  const OrdersFilterSheetContent({
    super.key,
    required this.initialFilter,
    required this.anchor,
    required this.onApply,
    required this.showSheet,
  });

  @override
  State<OrdersFilterSheetContent> createState() =>
      _OrdersFilterSheetContentState();
}

class _OrdersFilterSheetContentState extends State<OrdersFilterSheetContent> {
  late OrdersFilterPeriod? _period = widget.initialFilter.period;
  late OrderStatus? _status = widget.initialFilter.status;
  late DateTime _from = widget.initialFilter.from;
  late DateTime _to = widget.initialFilter.to;

  void _selectPeriod(OrdersFilterPeriod period) => setState(() {
    _period = period;
    _from = period.startBefore(widget.anchor);
    _to = widget.anchor;
  });

  void _pickStatus() {
    widget.showSheet(
      title: GraviaValueConst.filterStatusLabel,
      child: RadioOptionsSheetContent<OrderStatus?>(
        options: [null, ...OrderStatus.values],
        labelOf: (status) =>
            status?.label ?? GraviaValueConst.filterAllStatusesLabel,
        selected: _status,
        onSelected: (status) => setState(() => _status = status),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(_from.year - 1),
      // An order can't be placed in the future, so future dates are disabled.
      lastDate: widget.anchor,
      initialDateRange: DateTimeRange(start: _from, end: _to),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _from = picked.start;
      _to = picked.end;
      // A hand-picked range no longer corresponds to a quick period.
      _period = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

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
          Text(
            GraviaValueConst.filterReasonHeading,
            style: GraviaTextStyleConst.textMdBold(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final period in OrdersFilterPeriod.values)
            RadioOptionRow(
              label: period.label,
              selected: _period == period,
              onTap: () => _selectPeriod(period),
            ),
          const SizedBox(height: AppSpacing.base),
          GraviaDropdownField(
            label: GraviaValueConst.filterStatusLabel,
            value: _status?.label ?? GraviaValueConst.filterAllStatusesLabel,
            onTap: _pickStatus,
          ),
          const SizedBox(height: AppSpacing.base),
          GraviaDropdownField(
            label: GraviaValueConst.filterDateLabel,
            value: GraviaValueConst.filterDateRangeLabel(
              _from.asFilterDate,
              _to.asFilterDate,
            ),
            trailingIcon: Icons.calendar_today_outlined,
            onTap: _pickDateRange,
          ),
          const SizedBox(height: AppSpacing.xl2),
          GraviaPrimaryButton(
            label: GraviaValueConst.applyFilterLabel,
            onTap: () => widget.onApply(
              OrdersFilter(
                from: _from,
                to: _to,
                period: _period,
                status: _status,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
