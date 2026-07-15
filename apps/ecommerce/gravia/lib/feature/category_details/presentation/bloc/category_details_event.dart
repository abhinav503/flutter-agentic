part of 'category_details_bloc.dart';

@freezed
sealed class CategoryDetailsEvent with _$CategoryDetailsEvent {
  const factory CategoryDetailsEvent.started({
    required String categoryId,
    required String categoryName,
  }) = CategoryDetailsStarted;

  const factory CategoryDetailsEvent.sortChanged({required ProductSortOption sort}) =
      CategoryDetailsSortChanged;

  const factory CategoryDetailsEvent.priceFilterChanged({
    required ProductPriceFilter priceFilter,
  }) = CategoryDetailsPriceFilterChanged;
}
