part of 'product_details_bloc.dart';

@freezed
sealed class ProductDetailsState with _$ProductDetailsState {
  const factory ProductDetailsState.loading() = ProductDetailsLoading;
  const factory ProductDetailsState.loaded({required ProductDetailEntity detail}) =
      ProductDetailsLoaded;
  // Carries productId so the screen can retry without inspecting prior state.
  const factory ProductDetailsState.error({
    required String message,
    required String productId,
  }) = ProductDetailsError;
}
