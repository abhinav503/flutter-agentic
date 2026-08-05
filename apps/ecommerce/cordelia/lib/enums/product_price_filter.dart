import 'package:core/core/extensions/num_extensions.dart';

import 'package:cordelia/constants/value_const.dart';

/// Price-range bucket for Category Details' "Price" filter sheet. Used
/// purely in-memory, same reasoning as [ProductSortOption].
enum ProductPriceFilter { all, under100, from100To250, from250To500, over500 }

extension ProductPriceFilterX on ProductPriceFilter {
  /// App-wide wording (not per-pack) — see [ProductSortOptionX.label].
  ///
  /// Built from [_bounds] rather than four fixed strings, so the currency
  /// glyph and separators come from the active store + locale via `asPrice`.
  /// Baking `'₹100'` into the copy printed rupees at a euro store.
  String get label => switch (this) {
    ProductPriceFilter.all => ValueConst.priceFilterAllLabel,
    ProductPriceFilter.under100 => ValueConst.priceFilterUnderLabel(
      100.asPrice,
    ),
    ProductPriceFilter.from100To250 => ValueConst.priceFilterRangeLabel(
      100.asPrice,
      250.asPrice,
    ),
    ProductPriceFilter.from250To500 => ValueConst.priceFilterRangeLabel(
      250.asPrice,
      500.asPrice,
    ),
    ProductPriceFilter.over500 => ValueConst.priceFilterOverLabel(500.asPrice),
  };

  bool matches(double price) => switch (this) {
    ProductPriceFilter.all => true,
    ProductPriceFilter.under100 => price < 100,
    ProductPriceFilter.from100To250 => price >= 100 && price <= 250,
    ProductPriceFilter.from250To500 => price > 250 && price <= 500,
    ProductPriceFilter.over500 => price > 500,
  };
}
