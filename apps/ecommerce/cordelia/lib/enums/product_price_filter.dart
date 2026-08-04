import 'package:cordelia/constants/value_const.dart';

/// Price-range bucket for Category Details' "Price" filter sheet. Used
/// purely in-memory, same reasoning as [ProductSortOption].
enum ProductPriceFilter { all, under100, from100To250, from250To500, over500 }

extension ProductPriceFilterX on ProductPriceFilter {
  /// App-wide wording (not per-pack) — see [ProductSortOptionX.label].
  String get label => switch (this) {
    ProductPriceFilter.all => ValueConst.priceFilterAllLabel,
    ProductPriceFilter.under100 => ValueConst.priceFilterUnder100Label,
    ProductPriceFilter.from100To250 => ValueConst.priceFilter100To250Label,
    ProductPriceFilter.from250To500 => ValueConst.priceFilter250To500Label,
    ProductPriceFilter.over500 => ValueConst.priceFilterOver500Label,
  };

  bool matches(double price) => switch (this) {
    ProductPriceFilter.all => true,
    ProductPriceFilter.under100 => price < 100,
    ProductPriceFilter.from100To250 => price >= 100 && price <= 250,
    ProductPriceFilter.from250To500 => price > 250 && price <= 500,
    ProductPriceFilter.over500 => price > 500,
  };
}
