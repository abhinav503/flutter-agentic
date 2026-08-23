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

  // Bumped by every local mutation. A server fetch captures it before it
  // starts and drops its result if it changed while in flight — otherwise a
  // refresh landing just after a tap on **+** would put the pre-tap cart back
  // on screen.
  int _revision = 0;

  // The last persist, so a fetch can wait for it. `_emitAndPersist` fires the
  // PUT without awaiting (the UI must not wait on the network), which leaves
  // a window where a GET would read back the cart as it was *before* the
  // mutation and then save that over it.
  Future<void>? _pendingSave;

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
    await _fetch(storeId);
  }

  /// Re-reads the same store's cart from the server, which re-prices every
  /// line and re-checks its stock against the live catalog. Called where a
  /// stale line stops being cosmetic and starts costing money — opening the
  /// Cart, opening Checkout, and after a checkout the server turned down —
  /// since [hydrate] otherwise runs only once, when the storefront mounts.
  ///
  /// Silent: the rows are already on screen and a failed refresh just leaves
  /// them as they were, same reasoning as [hydrate]'s ignored failure.
  Future<void> refresh() async {
    final storeId = _storeId;
    if (storeId == null) return;
    await _fetch(storeId);
  }

  Future<void> _fetch(String storeId) async {
    // Order matters: wait out any in-flight save first, then snapshot the
    // revision, so the result can only be discarded for a mutation that
    // happened *during* the fetch.
    await _pendingSave;
    final revision = _revision;
    final result = await _getCart(GetCartParams(storeId: storeId));
    if (_revision != revision || _storeId != storeId) return;
    result.fold((failure) {}, (items) => emit(items));
  }

  /// A line is (product, size) — Product Details passes the selected
  /// variant's size and prices; cards and sheets pass nothing, which lands
  /// on the product's existing line if it has one (see [_lineIndex]) or
  /// starts a base-pack line.
  /// Returns how much actually went in — [quantity], or less once the line
  /// hits the product's stock, or zero when it was already there. A picker
  /// only knows the product's total stock, not what this cart is already
  /// holding of it, so "3 left" plus "3 already in the bag" would otherwise
  /// build a line of 6 that the server refuses at payment. Callers that
  /// confirm the add ("Added to cart") check the result rather than promise
  /// something that didn't happen.
  int addToCart(
    ProductEntity product,
    int quantity, {
    String? variantId,
    String variantLabel = '',
    int? available,
    double? sizeValue,
    double? unitPrice,
    double? originalUnitPrice,
  }) {
    final index = _lineIndex(product.id, sizeValue, variantId: variantId);
    final existing = index == -1 ? 0 : state[index].quantity;
    final added = _addable(
      index == -1
          ? available ?? product.purchaseLimit
          : state[index].stockLimit,
      existing,
      quantity,
    );
    if (added == 0) return 0;

    if (index == -1) {
      _emitAndPersist([
        ...state,
        CartItemEntity(
          product: product,
          quantity: added,
          variantId: variantId,
          variantLabel: variantLabel,
          available: available,
          sizeValue: sizeValue,
          unitPrice: unitPrice,
          originalUnitPrice: originalUnitPrice,
        ),
      ]);
      return added;
    }
    _emitAndPersist([
      for (var i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(quantity: existing + added)
        else
          state[i],
    ]);
    return added;
  }

  /// How much of [wanted] fits on top of [existing]. Unknown stock is
  /// unbounded, matching `ProductEntity.purchaseLimit` — refusing a sale
  /// because the backend didn't say is worse than the rare oversell. A
  /// sold-out product has no limit to express either; nothing is addable,
  /// and every pack disables its add control, so this only ever sees it as
  /// a race and lets the server have the final word.
  int _addable(int? limit, int existing, int wanted) {
    if (limit == null) return wanted;
    final room = limit - existing;
    return room <= 0 ? 0 : (wanted < room ? wanted : room);
  }

  void incrementQuantity(
    String productId, {
    double? sizeValue,
    String? variantId,
  }) {
    final index = _lineIndex(productId, sizeValue, variantId: variantId);
    if (index == -1) return;
    // Same ceiling as [addToCart]: a row already at (or past, after the
    // store cut its stock) what's left doesn't grow.
    final line = state[index];
    if (_addable(line.stockLimit, line.quantity, 1) == 0) return;
    _emitAndPersist([
      for (var i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(quantity: state[i].quantity + 1)
        else
          state[i],
    ]);
  }

  void decrementQuantity(
    String productId, {
    double? sizeValue,
    String? variantId,
  }) {
    final index = _lineIndex(productId, sizeValue, variantId: variantId);
    if (index == -1) return;
    if (state[index].quantity <= 1) {
      _emitAndPersist([
        for (var i = 0; i < state.length; i++)
          if (i != index) state[i],
      ]);
      return;
    }
    _emitAndPersist([
      for (var i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(quantity: state[i].quantity - 1)
        else
          state[i],
    ]);
  }

  void removeItem(String productId, {double? sizeValue, String? variantId}) {
    final index = _lineIndex(productId, sizeValue, variantId: variantId);
    if (index == -1) return;
    _emitAndPersist([
      for (var i = 0; i < state.length; i++)
        if (i != index) state[i],
    ]);
  }

  /// Exact (product, size) match first; a null size that finds no base-pack
  /// line falls back to the product's first line of any size. Cards and
  /// steppers outside Product Details don't know about sizes — "this
  /// product's line" is what they mean, and without the fallback a card's +
  /// on a variant-only product would grow a phantom base-pack line beside it.
  int _lineIndex(String productId, double? sizeValue, {String? variantId}) {
    final exact = state.indexWhere(
      (item) => item.matchesLine(productId, sizeValue, variantId: variantId),
    );
    if (exact != -1 || sizeValue != null || variantId != null) return exact;
    return state.indexWhere((item) => item.product.id == productId);
  }

  void clear() => _emitAndPersist(const []);

  /// Local-only reset for sign-out — unlike [clear], this must NOT persist:
  /// the signed-out user's server-side cart should survive untouched for
  /// their next sign-in, this is just dropping this device's in-memory copy
  /// so the next signed-in account doesn't briefly see a stranger's cart.
  ///
  /// Bumps the revision and forgets the store for the same reason [hydrate]
  /// tracks them: a fetch that was already in flight when the session ended
  /// would otherwise pass its own staleness check and put the previous
  /// account's lines back on a signed-out device. Forgetting the store also
  /// stops [refresh] firing a tokenless `GET /cart` for every Cart a guest
  /// opens afterwards.
  void reset() {
    _revision++;
    _storeId = null;
    emit(const []);
  }

  void _emitAndPersist(List<CartItemEntity> items) {
    _revision++;
    emit(items);
    final storeId = _storeId;
    if (storeId != null) {
      final save = _saveCart(SaveCartParams(storeId: storeId, items: items));
      _pendingSave = save;
      unawaited(save);
    }
  }
}
