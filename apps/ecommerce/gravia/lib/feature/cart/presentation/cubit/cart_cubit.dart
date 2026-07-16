import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Cart state shared across the whole app (Home, Product Details, the Cart
/// screen itself) — provided once at the app root in `app.dart`, not scoped
/// to any single `BasePage`/`BaseScreen`, since Product Details and Cart are
/// separate GoRouter pages rather than descendants of one shell. Plain
/// in-memory list state, same category as the `KeptJokesCubit` pattern
/// (docs/reference/architecture.md) — no domain/data layer needed.
class CartCubit extends Cubit<List<CartItemEntity>> {
  CartCubit() : super(const []);

  void addToCart(ProductEntity product, int quantity) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      emit([...state, CartItemEntity(product: product, quantity: quantity)]);
      return;
    }
    emit([
      for (var i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(quantity: state[i].quantity + quantity)
        else
          state[i],
    ]);
  }

  void incrementQuantity(String productId) => emit([
    for (final item in state)
      item.product.id == productId
          ? item.copyWith(quantity: item.quantity + 1)
          : item,
  ]);

  void decrementQuantity(String productId) {
    final item = state.firstWhere((item) => item.product.id == productId);
    if (item.quantity <= 1) {
      removeItem(productId);
      return;
    }
    emit([
      for (final item in state)
        item.product.id == productId
            ? item.copyWith(quantity: item.quantity - 1)
            : item,
    ]);
  }

  void removeItem(String productId) =>
      emit(state.where((item) => item.product.id != productId).toList());

  void clear() => emit(const []);
}
