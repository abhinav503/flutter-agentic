import 'package:cordelia/constants/value_const.dart';

/// Price-range bucket for Category Details' "Price" filter sheet. Used
/// purely in-memory, same reasoning as [ProductSortOption].
enum ProductPriceFilter { all, under5, from5To10, from10To20, over20 }

extension ProductPriceFilterX on ProductPriceFilter {
  /// App-wide wording (not per-pack) — see [ProductSortOptionX.label].
  String get label => switch (this) {
    ProductPriceFilter.all => ValueConst.priceFilterAllLabel,
    ProductPriceFilter.under5 => ValueConst.priceFilterUnder5Label,
    ProductPriceFilter.from5To10 => ValueConst.priceFilter5To10Label,
    ProductPriceFilter.from10To20 => ValueConst.priceFilter10To20Label,
    ProductPriceFilter.over20 => ValueConst.priceFilterOver20Label,
  };

  bool matches(double price) => switch (this) {
    ProductPriceFilter.all => true,
    ProductPriceFilter.under5 => price < 5,
    ProductPriceFilter.from5To10 => price >= 5 && price <= 10,
    ProductPriceFilter.from10To20 => price > 10 && price <= 20,
    ProductPriceFilter.over20 => price > 20,
  };
}
