import 'dart:async';

import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecase/get_cart_usecase.dart';
import '../../domain/usecase/save_cart_usecase.dart';

/// Cart state shared across the whole app (Home, Product Details, the Cart
/// screen itself) — provided once at the app root in `app.dart`, not scoped
/// to any single `BasePage`/`BaseScreen`, since Product Details and Cart are
/// separate GoRouter pages rather than descendants of one shell. Local state
/// is the source of truth for the UI (every mutation below emits
/// synchronously, no waiting on the network); the backend cart is kept in
/// sync as a best-effort side effect via [_persist], same category as the
/// `KeptJokesCubit` pattern (docs/reference/architecture.md) but with a
/// persistence layer bolted on rather than pure in-memory state.
class CartCubit extends Cubit<List<CartItemEntity>> {
  final GetCartUseCase _getCart;
  final SaveCartUseCase _saveCart;

  // CartCubit is a single app-root instance (see class doc) reused across
  // every store a shopper opens — this tracks which store's cart is
  // currently loaded so mutations persist to the right store and switching
  // stores doesn't leak the previous store's items into the new one.
  String? _storeId;

  CartCubit({
    required GetCartUseCase getCartUseCase,
    required SaveCartUseCase saveCartUseCase,
  }) : _getCart = getCartUseCase,
       _saveCart = saveCartUseCase,
       super(const []);

  /// Loads the signed-in shopper's persisted cart for [storeId] from the
  /// backend — called once per store, from `ShellPage.initState`, the first
  /// screen reached only after a session is confirmed (Splash routes
  /// signed-out users to Login before the shell ever mounts). A failed load
  /// leaves the cart empty rather than surfacing an error — an empty cart is
  /// always a safe, recoverable start state, not worth blocking the shell on.
  Future<void> hydrate(String storeId) async {
    if (_storeId != storeId) {
      _storeId = storeId;
      // Switching stores — the previous store's items aren't this store's
      // cart, so don't leave them on screen while the fresh fetch is in flight.
      emit(const []);
    }
    final result = await _getCart(GetCartParams(storeId: storeId));
    result.fold((failure) {}, (items) => emit(items));
  }

  void addToCart(ProductEntity product, int quantity) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      _emitAndPersist([
        ...state,
        CartItemEntity(product: product, quantity: quantity),
      ]);
      return;
    }
    _emitAndPersist([
      for (var i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(quantity: state[i].quantity + quantity)
        else
          state[i],
    ]);
  }

  void incrementQuantity(String productId) => _emitAndPersist([
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
    _emitAndPersist([
      for (final item in state)
        item.product.id == productId
            ? item.copyWith(quantity: item.quantity - 1)
            : item,
    ]);
  }

  void removeItem(String productId) => _emitAndPersist(
    state.where((item) => item.product.id != productId).toList(),
  );

  void clear() => _emitAndPersist(const []);

  /// Local-only reset for sign-out — unlike [clear], this must NOT persist:
  /// the signed-out user's server-side cart should survive untouched for
  /// their next sign-in, this is just dropping this device's in-memory copy
  /// so the next signed-in account doesn't briefly see a stranger's cart.
  void reset() => emit(const []);

  void _emitAndPersist(List<CartItemEntity> items) {
    emit(items);
    final storeId = _storeId;
    if (storeId != null) {
      unawaited(_saveCart(SaveCartParams(storeId: storeId, items: items)));
    }
  }
}
