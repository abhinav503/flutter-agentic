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
    required String categoryId,
    required String categoryName,
  }) = CategoryDetailsError;
}

extension CategoryDetailsLoadedX on CategoryDetailsLoaded {
  /// Products after applying [priceFilter] and [sort].
  List<ProductEntity> get visibleProducts {
    final filtered = details.products.where((p) => priceFilter.matches(p.price)).toList();
    switch (sort) {
      case ProductSortOption.priceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case ProductSortOption.priceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
      case ProductSortOption.discountHighToLow:
        filtered.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
      case ProductSortOption.relevance:
      case ProductSortOption.ratingHighToLow:
        break;
    }
    return filtered;
  }
}
