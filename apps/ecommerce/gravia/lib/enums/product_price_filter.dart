/// Price-range bucket for [CategoryDetailsScreen]'s "Price" filter sheet.
/// Used purely in-memory, same reasoning as [ProductSortOption].
enum ProductPriceFilter { all, under5, from5To10, from10To20, over20 }

extension ProductPriceFilterX on ProductPriceFilter {
  String get label => switch (this) {
        ProductPriceFilter.all => 'All Prices',
        ProductPriceFilter.under5 => 'Under \$5',
        ProductPriceFilter.from5To10 => '\$5 - \$10',
        ProductPriceFilter.from10To20 => '\$10 - \$20',
        ProductPriceFilter.over20 => 'Over \$20',
      };

  bool matches(double price) => switch (this) {
        ProductPriceFilter.all => true,
        ProductPriceFilter.under5 => price < 5,
        ProductPriceFilter.from5To10 => price >= 5 && price <= 10,
        ProductPriceFilter.from10To20 => price > 10 && price <= 20,
        ProductPriceFilter.over20 => price > 20,
      };
}
