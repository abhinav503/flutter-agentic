import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';

/// One cart line — identified by (product, [sizeValue]), not product alone:
/// the same product in two package sizes is two lines with two prices.
class CartItemEntity {
  final ProductEntity product;
  final int quantity;

  /// The selected package size, or null for the base pack
  /// ([ProductEntity.unitValue] at [ProductEntity.price]) — the shape every
  /// pre-variant line and every card quick-add produces.
  final double? sizeValue;

  /// The selected size's per-pack prices; null falls back to the product's
  /// own. Display-only — the server re-prices every line from the live
  /// catalog at checkout, so a stale copy here can't change what's charged.
  final double? unitPrice;
  final double? originalUnitPrice;

  const CartItemEntity({
    required this.product,
    required this.quantity,
    this.sizeValue,
    this.unitPrice,
    this.originalUnitPrice,
  });

  CartItemEntity copyWith({int? quantity}) => CartItemEntity(
    product: product,
    quantity: quantity ?? this.quantity,
    sizeValue: sizeValue,
    unitPrice: unitPrice,
    originalUnitPrice: originalUnitPrice,
  );

  bool matchesLine(String productId, double? sizeValue) =>
      product.id == productId && this.sizeValue == sizeValue;
}

extension CartItemX on CartItemEntity {
  double get effectiveUnitPrice => unitPrice ?? product.price;

  double get effectiveOriginalUnitPrice =>
      originalUnitPrice ?? product.originalPrice;

  /// The pack size this line holds — format with
  /// `product.unitType.format(effectiveSizeValue)` for display.
  double get effectiveSizeValue => sizeValue ?? product.unitValue;

  double get lineTotal => effectiveUnitPrice * quantity;

  /// This line asks for more than the store has left. Stock is
  /// product-level, so a sized line is checked against the same number as a
  /// base-pack one — which is also how the server checks it.
  bool get exceedsStock {
    final stock = product.stock;
    return stock != null && quantity > stock;
  }

  /// True once the line can't be bought as it stands — sold out, or more
  /// units than remain. What blocks checkout, and what a row flags.
  bool get isUnavailable => product.isOutOfStock || exceedsStock;

  /// Whether a row's **+** does anything — false once the line already holds
  /// everything the store has left. A stepper takes this as its enable
  /// condition, the mirror of its floor of 1 on the other side.
  bool get canAddMore {
    final stock = product.stock;
    return stock == null || quantity < stock;
  }
}

extension CartItemsX on List<CartItemEntity> {
  int get itemCount => fold(0, (sum, item) => sum + item.quantity);

  /// Checkout would be refused by the server as this cart stands. Screens
  /// check this before starting a payment, so the refusal arrives as the
  /// shopper's own language beside the offending row rather than as the
  /// server's English "Insufficient stock for X" after the sheet opens.
  bool get hasUnavailableItems => any((item) => item.isUnavailable);

  /// The pre-discount (original-price) sum — the "Item Total" line a summary
  /// shows the discount subtracted *from*. Summing selling prices here made
  /// [grandTotal] subtract the discount twice and understate what checkout
  /// actually charges.
  double get itemTotal => fold(
    0,
    (sum, item) => sum + item.effectiveOriginalUnitPrice * item.quantity,
  );

  double get discountTotal => fold(
    0,
    (sum, item) =>
        sum +
        (item.effectiveOriginalUnitPrice - item.effectiveUnitPrice) *
            item.quantity,
  );

  // Delivery is a flat free perk in this pack — no separate fee to subtract.
  // Always equals the selling-price sum, which is exactly what the server
  // charges (it prices the same lines from the live catalog).
  double get grandTotal => itemTotal - discountTotal;
}
