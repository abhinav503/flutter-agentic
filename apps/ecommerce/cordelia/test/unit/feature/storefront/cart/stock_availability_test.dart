import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';

/// Stock is enforced server-side at both checkout steps, and its refusal can
/// only be English. These are the rules the storefront uses to refuse first —
/// including the one that must never fire by accident: a backend that doesn't
/// send `stock` at all leaves every product buyable.
void main() {
  ProductEntity product({int? stock}) => ProductEntity(
    id: 'p1',
    name: 'Apple',
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

  group('product stock', () {
    test('unknown stock sells', () {
      expect(product().isOutOfStock, isFalse);
      expect(product().purchaseLimit, isNull);
    });

    test('zero stock is sold out and has no purchase limit to offer', () {
      expect(product(stock: 0).isOutOfStock, isTrue);
      expect(product(stock: 0).purchaseLimit, isNull);
    });

    test('remaining units cap a quantity picker', () {
      expect(product(stock: 3).isInStock, isTrue);
      expect(product(stock: 3).purchaseLimit, 3);
    });

    test('low stock is a band, not everything above zero', () {
      expect(product(stock: 4).isLowStock, isTrue);
      // The threshold itself is not low — "below 5" is the rule.
      expect(product(stock: 5).isLowStock, isFalse);
      // Sold out is its own state, and unknown is never "few".
      expect(product(stock: 0).isLowStock, isFalse);
      expect(product().isLowStock, isFalse);
    });
  });

  group('cart line availability', () {
    CartItemEntity line({int? stock, required int quantity}) => CartItemEntity(
      product: product(stock: stock),
      quantity: quantity,
    );

    test('a line within stock is buyable and can still grow', () {
      final item = line(stock: 3, quantity: 2);
      expect(item.isUnavailable, isFalse);
      expect(item.canAddMore, isTrue);
    });

    test('a line at stock stops growing', () {
      expect(line(stock: 3, quantity: 3).canAddMore, isFalse);
      expect(line(stock: 3, quantity: 3).isUnavailable, isFalse);
    });

    test('a line above stock blocks checkout', () {
      // The state a cart reaches by sitting there while the store sells out
      // from under it — the quantity was legal when it was added.
      final item = line(stock: 1, quantity: 2);
      expect(item.exceedsStock, isTrue);
      expect(item.isUnavailable, isTrue);
      expect([item].hasUnavailableItems, isTrue);
    });

    test('a sold-out product blocks checkout at any quantity', () {
      expect([line(stock: 0, quantity: 1)].hasUnavailableItems, isTrue);
    });

    test('unknown stock never blocks checkout', () {
      expect([line(quantity: 99)].hasUnavailableItems, isFalse);
      expect(line(quantity: 99).canAddMore, isTrue);
    });
  });
}
