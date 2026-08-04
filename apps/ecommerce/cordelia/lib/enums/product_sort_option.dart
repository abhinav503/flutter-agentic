import 'package:cordelia/constants/value_const.dart';

/// How the product grid on Category Details is ordered. Used purely
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
  /// App-wide wording (not per-pack): both templates run the same sort model,
  /// so the copy lives in [ValueConst] rather than a pack const.
  String get label => switch (this) {
    ProductSortOption.relevance => ValueConst.sortRelevanceLabel,
    ProductSortOption.priceLowToHigh => ValueConst.sortPriceLowToHighLabel,
    ProductSortOption.priceHighToLow => ValueConst.sortPriceHighToLowLabel,
    ProductSortOption.ratingHighToLow => ValueConst.sortRatingHighToLowLabel,
    ProductSortOption.discountHighToLow =>
      ValueConst.sortDiscountHighToLowLabel,
  };
}
