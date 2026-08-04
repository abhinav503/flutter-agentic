part of 'category_details_bloc.dart';

@freezed
sealed class CategoryDetailsState with _$CategoryDetailsState {
  const factory CategoryDetailsState.loading() = CategoryDetailsLoading;

  const factory CategoryDetailsState.loaded({
    required String categoryName,
    required CategoryDetailsEntity details,
    required ProductSortOption sort,
    required ProductPriceFilter priceFilter,
  }) = CategoryDetailsLoaded;

  const factory CategoryDetailsState.error({
    required String message,
    required String storeId,
    required String categoryId,
    required String categoryName,
  }) = CategoryDetailsError;
}

extension CategoryDetailsLoadedX on CategoryDetailsLoaded {
  /// Products after applying [priceFilter] and [sort].
  List<ProductEntity> get visibleProducts {
    final filtered = details.products
        .where((p) => priceFilter.matches(p.price))
        .toList();
    switch (sort) {
      case ProductSortOption.priceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case ProductSortOption.priceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
      case ProductSortOption.discountHighToLow:
        filtered.sort(
          (a, b) => b.discountPercentage.compareTo(a.discountPercentage),
        );
      case ProductSortOption.ratingHighToLow:
        // Unrated products sort last rather than mixing in at 0.0 — nobody
        // asking for the best-rated wants the never-rated at the bottom of
        // the good ones, but they do want them after everything rated.
        filtered.sort((a, b) => b.ratingAverage.compareTo(a.ratingAverage));
      case ProductSortOption.relevance:
        break;
    }
    return filtered;
  }
}
