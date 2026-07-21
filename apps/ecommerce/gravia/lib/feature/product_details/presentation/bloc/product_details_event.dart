part of 'product_details_bloc.dart';

@freezed
sealed class ProductDetailsEvent with _$ProductDetailsEvent {
  const factory ProductDetailsEvent.started({required String productId}) =
      ProductDetailsStarted;
}
