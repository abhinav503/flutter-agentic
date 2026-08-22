import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_storefront_use_cases.dart';

import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';

/// A picker only knows a product's total stock, never what this cart is
/// already holding of it — so "3 left" plus "3 already in the bag" built a
/// line of 6 that the server refused at payment. The ceiling belongs at the
/// one place every add goes through.

ProductEntity _product({int? stock}) => ProductEntity(
  id: 'p1',
  name: 'Apples',
  imageUrl: '',
  price: 10,
  originalPrice: 12,
  discountPercentage: 0,
  unitValue: 500,
  unitType: ProductUnitType.grams,
  prepTime: '10 Min',
  isFavourite: false,
  stock: stock,
);

void main() {
  late CartCubit cubit;
  late FakeGetCartUseCase getCart;

  setUp(() {
    getCart = FakeGetCartUseCase();
    cubit = CartCubit(
      getCartUseCase: getCart,
      saveCartUseCase: FakeSaveCartUseCase(),
    );
  });

  tearDown(() => cubit.close());

  group('stock ceiling', () {
    test('a fresh line cannot exceed what is left', () {
      expect(cubit.addToCart(_product(stock: 3), 5), 3);
      expect(cubit.state.single.quantity, 3);
    });

    test('an existing line counts against the ceiling', () {
      cubit.addToCart(_product(stock: 3), 3);
      expect(
        cubit.addToCart(_product(stock: 3), 3),
        0,
        reason: 'the bag already held everything that was left',
      );
      expect(cubit.state.single.quantity, 3);
    });

    test('unknown stock stays unbounded', () {
      expect(cubit.addToCart(_product(), 9), 9);
      expect(cubit.state.single.quantity, 9);
    });

    test('the row + obeys the same ceiling', () {
      cubit.addToCart(_product(stock: 2), 2);
      cubit.incrementQuantity('p1');
      expect(cubit.state.single.quantity, 2);
    });
  });

  group('reset', () {
    test('a hydrate still in flight cannot repaint the old account', () async {
      getCart.gate = Completer<List<CartItemEntity>>();
      final hydrating = cubit.hydrate('store-1');

      cubit.reset();
      getCart.gate!.complete([
        CartItemEntity(product: _product(stock: 5), quantity: 2),
      ]);
      await hydrating;

      expect(
        cubit.state,
        isEmpty,
        reason: 'the session ended while the fetch was in the air',
      );
    });

    test('forgets the store, so a guest refresh asks for nothing', () async {
      await cubit.hydrate('store-1');
      final before = getCart.calls;

      cubit.reset();
      await cubit.refresh();

      expect(getCart.calls, before);
    });
  });
}
