import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';

/// One cart line — identified by (product, [variantId]), not product alone:
/// the same product in two sizes or colours is two lines with two prices.
class CartItemEntity {
  final ProductEntity product;
  final int quantity;

  /// The chosen variant, or null for a simple product's line. Assigned by
  /// the server on every sync (a pack size picked locally resolves to the
  /// variant carrying it), so a line that was added by [sizeValue] still
  /// comes back identified this way.
  final String? variantId;

  /// "500 g", "M / Red" — what tells this line apart from the product's
  /// other lines. Empty for a simple product.
  final String variantLabel;

  /// Units this line can still buy — the variant's own stock when the
  /// product tracks stock per variant, the product's otherwise; null when
  /// the server said nothing (sells) or the unit sells past zero.
  final int? available;

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
    this.variantId,
    this.variantLabel = '',
    this.available,
    this.sizeValue,
    this.unitPrice,
    this.originalUnitPrice,
  });

  CartItemEntity copyWith({int? quantity}) => CartItemEntity(
    product: product,
    quantity: quantity ?? this.quantity,
    variantId: variantId,
    variantLabel: variantLabel,
    available: available,
    sizeValue: sizeValue,
    unitPrice: unitPrice,
    originalUnitPrice: originalUnitPrice,
  );

  /// A variant id is the exact identity when the caller has one; a pack
  /// size is the pre-variant way of naming the same line, still what the
  /// size chips pass.
  bool matchesLine(String productId, double? sizeValue, {String? variantId}) {
    if (product.id != productId) return false;
    if (variantId != null && this.variantId != null) {
      return this.variantId == variantId;
    }
    return this.sizeValue == sizeValue;
  }
}

extension CartItemX on CartItemEntity {
  double get effectiveUnitPrice => unitPrice ?? product.price;

  double get effectiveOriginalUnitPrice =>
      originalUnitPrice ?? product.originalPrice;

  /// The pack size this line holds — format with
  /// `product.unitType.format(effectiveSizeValue)` for display.
  double get effectiveSizeValue => sizeValue ?? product.unitValue;

  double get lineTotal => effectiveUnitPrice * quantity;

  /// What the server will check this line against: the variant's own
  /// count once it has been synced, the product's until then.
  int? get stockLimit => available ?? product.stock;

  /// This line asks for more than the store has left of its unit.
  bool get exceedsStock {
    final stock = stockLimit;
    return stock != null && quantity > stock;
  }

  /// True once the line can't be bought as it stands — sold out, or more
  /// units than remain. What blocks checkout, and what a row flags.
  bool get isUnavailable =>
      (available == null ? product.isOutOfStock : available! <= 0) ||
      exceedsStock;

  /// Whether a row's **+** does anything — false once the line already holds
  /// everything the store has left. A stepper takes this as its enable
  /// condition, the mirror of its floor of 1 on the other side.
  bool get canAddMore {
    final stock = stockLimit;
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
