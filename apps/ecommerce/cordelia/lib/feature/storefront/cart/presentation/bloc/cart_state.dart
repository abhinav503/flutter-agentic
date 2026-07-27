part of 'cart_bloc.dart';

@freezed
sealed class CartState with _$CartState {
  const factory CartState.loading() = CartLoading;
  const factory CartState.loaded({required List<ProductEntity> suggestions}) =
      CartLoaded;
  const factory CartState.error({required String message}) = CartError;
}
