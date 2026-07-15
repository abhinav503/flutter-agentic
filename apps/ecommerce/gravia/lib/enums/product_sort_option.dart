/// How the product grid on [CategoryDetailsScreen] is ordered. Used purely
/// in-memory (chosen in a bottom sheet, never crosses a JSON boundary), so
/// it needs no wire-string conversion.
enum ProductSortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
  discountHighToLow,
}

extension ProductSortOptionX on ProductSortOption {
  String get label => switch (this) {
        ProductSortOption.relevance => 'Relevance',
        ProductSortOption.priceLowToHigh => 'Price (Low to High)',
        ProductSortOption.priceHighToLow => 'Price (High to Low)',
        ProductSortOption.ratingHighToLow => 'Rating (High to Low)',
        ProductSortOption.discountHighToLow => 'Discount (High to Low)',
      };
}
