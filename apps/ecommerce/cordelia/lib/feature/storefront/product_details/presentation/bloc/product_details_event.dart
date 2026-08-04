part of 'product_details_bloc.dart';

@freezed
sealed class ProductDetailsEvent with _$ProductDetailsEvent {
  const factory ProductDetailsEvent.started({
    required String storeId,
    required String productId,
  }) = ProductDetailsStarted;

  /// Re-reads the product **without** dropping to `loading` — the screen
  /// stays exactly as it is until fresh data lands. Dispatched after the
  /// shopper writes a review: the rating shown beside the product's name
  /// comes off the product doc's aggregates, which the reviews bloc's own
  /// reload can't update.
  const factory ProductDetailsEvent.refreshed({
    required String storeId,
    required String productId,
  }) = ProductDetailsRefreshed;
}
