import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/enums/product_price_filter.dart';
import 'package:cordelia/enums/product_sort_option.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';

import 'grofast_chip.dart';
import 'grofast_options_sheet_content.dart';
import 'grofast_primary_button.dart';

/// The kit's Search-Option sheet (frame `23:285`), shared by Search results
/// and Category Details: a chip row per axis over one Apply CTA.
///
/// **Deviations from the frame,** both because the data behind them doesn't
/// exist: the kit's "Free Shipping" row is dropped (no shipping model), and
/// its Lowest/Highest price *inputs* become the app's existing
/// [ProductPriceFilter] bands as chips — a free-entry range would need a
/// filter axis the shared bloc doesn't have.
///
/// Both axes are sheet-local draft state until Apply, the same
/// "screen-local until submit" carve-out the address form uses.
class GrofastFilterSheetContent extends StatefulWidget {
  final ProductSortOption initialSort;
  final ProductPriceFilter initialPriceFilter;
  final void Function(ProductSortOption sort, ProductPriceFilter priceFilter)
  onApply;

  const GrofastFilterSheetContent({
    super.key,
    required this.initialSort,
    required this.initialPriceFilter,
    required this.onApply,
  });

  @override
  State<GrofastFilterSheetContent> createState() =>
      _GrofastFilterSheetContentState();
}

class _GrofastFilterSheetContentState extends State<GrofastFilterSheetContent> {
  late ProductSortOption _sort = widget.initialSort;
  late ProductPriceFilter _priceFilter = widget.initialPriceFilter;

  /// The two axes the shared `CategoryDetailsBloc`/`SearchBloc` expose.
  static const _sortOptions = [
    ProductSortOption.relevance,
    ProductSortOption.priceLowToHigh,
    ProductSortOption.priceHighToLow,
    ProductSortOption.discountHighToLow,
    ProductSortOption.ratingHighToLow,
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      GrofastSheetSection(
        title: GrofastValueConst.sortByTitle,
        child: GrofastChipRow(
          labels: [for (final option in _sortOptions) option.label],
          selectedIndex: _sortOptions.indexOf(_sort),
          onSelected: (index) => setState(() => _sort = _sortOptions[index]),
        ),
      ),
      const SizedBox(height: AppSpacing.xl4),
      GrofastSheetSection(
        title: GrofastValueConst.priceTitle,
        child: GrofastChipRow(
          labels: [
            for (final filter in ProductPriceFilter.values) filter.label,
          ],
          selectedIndex: ProductPriceFilter.values.indexOf(_priceFilter),
          onSelected: (index) =>
              setState(() => _priceFilter = ProductPriceFilter.values[index]),
        ),
      ),
      const SizedBox(height: AppSpacing.xl6),
      GrofastPrimaryButton(
        label: GrofastValueConst.applyLabel,
        onTap: () {
          Navigator.of(context).pop();
          widget.onApply(_sort, _priceFilter);
        },
      ),
    ],
  );
}
