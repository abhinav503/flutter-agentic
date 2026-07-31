import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/enums/product_price_filter.dart';
import 'package:cordelia/enums/product_sort_option.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_action_pair.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_dropdown_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_radio_sheet_content.dart';

/// Body of Category Details' Filter sheet (kit frame `21`) — a bordered
/// select field per axis over the Reset / Apply pair.
///
/// The kit's frame stacks **three** fields: Category, Sort by, Price. The
/// Category one isn't reproduced: this screen is already scoped to a single
/// category it was pushed with, and changing that isn't a filter over the
/// loaded list — it's a different fetch, i.e. navigation, which the sheet
/// would be a confusing place to trigger. gravia's version of this screen
/// offers the same two axes, and both read the shared
/// `CategoryDetailsBloc`'s [ProductSortOption] / [ProductPriceFilter].
///
/// Both fields are sheet-local draft state until Reset or Apply — the same
/// "screen-local until submit" carve-out the Add/Edit Address form and My
/// Orders' filter sheet use.
class DailyMartCategoryFilterSheetContent extends StatefulWidget {
  final ProductSortOption initialSort;
  final ProductPriceFilter initialPriceFilter;

  final void Function(ProductSortOption sort, ProductPriceFilter priceFilter)
  onApply;

  /// The screen's own `showDailyMartSheet`. Passed down because each field
  /// opens its picklist as a second sheet over this one and the extension
  /// lives on `BaseScreenState` — the same hand-off gravia's Orders filter
  /// sheet makes.
  final Future<void> Function({required String title, required Widget child})
  showSheet;

  const DailyMartCategoryFilterSheetContent({
    super.key,
    required this.initialSort,
    required this.initialPriceFilter,
    required this.onApply,
    required this.showSheet,
  });

  @override
  State<DailyMartCategoryFilterSheetContent> createState() =>
      _DailyMartCategoryFilterSheetContentState();
}

class _DailyMartCategoryFilterSheetContentState
    extends State<DailyMartCategoryFilterSheetContent> {
  late ProductSortOption _sort = widget.initialSort;
  late ProductPriceFilter _priceFilter = widget.initialPriceFilter;

  void _pickSort() => widget.showSheet(
    title: DailyMartValueConst.sortSheetTitle,
    child: DailyMartRadioSheetContent<ProductSortOption>(
      options: ProductSortOption.values,
      labelOf: (option) => option.label,
      selected: _sort,
      onSelected: (sort) => setState(() => _sort = sort),
    ),
  );

  void _pickPrice() => widget.showSheet(
    title: DailyMartValueConst.priceSheetTitle,
    child: DailyMartRadioSheetContent<ProductPriceFilter>(
      options: ProductPriceFilter.values,
      labelOf: (option) => option.label,
      selected: _priceFilter,
      onSelected: (priceFilter) => setState(() => _priceFilter = priceFilter),
    ),
  );

  /// Commits the defaults rather than only clearing the draft — a Reset that
  /// needs a second tap on Apply to take effect reads as a control that
  /// didn't work.
  void _reset() =>
      widget.onApply(ProductSortOption.relevance, ProductPriceFilter.all);

  @override
  Widget build(BuildContext context) => Padding(
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
        DailyMartDropdownField(
          label: DailyMartValueConst.sortSheetTitle,
          value: _sort.label,
          onTap: _pickSort,
        ),
        const SizedBox(height: AppSpacing.base),
        DailyMartDropdownField(
          label: DailyMartValueConst.priceSheetTitle,
          value: _priceFilter.label,
          onTap: _pickPrice,
        ),
        const SizedBox(height: AppSpacing.xl2),
        DailyMartActionPair(
          cancelLabel: DailyMartValueConst.resetLabel,
          confirmLabel: DailyMartValueConst.applyLabel,
          onCancel: _reset,
          onConfirm: () => widget.onApply(_sort, _priceFilter),
        ),
      ],
    ),
  );
}
