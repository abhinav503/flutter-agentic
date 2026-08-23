/// One sellable unit of a product that comes in choices — "M / Red", or a
/// pack size. [options] is aligned to the product's `optionNames`, so a
/// product with ["Size", "Colour"] has variants like ["M", "Red"]. Price and
/// stock are this unit's own; the product's are derived from them.
class ProductVariantEntity {
  final String id;
  final List<String> options;
  final double price;
  final double originalPrice;
  final double discountPercentage;

  /// Null = unknown, which sells (same rule as `ProductEntity.stock`).
  final int? stock;

  /// A made-to-order unit: stock is informational, never a ceiling.
  final bool sellWhenOutOfStock;
  final String imageUrl;

  /// The pack size this unit stood for before variants existed, in the
  /// product's unit type — what a weight label still formats. 0 = not a pack.
  final double packSize;

  const ProductVariantEntity({
    required this.id,
    required this.options,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    this.stock,
    this.sellWhenOutOfStock = false,
    this.imageUrl = '',
    this.packSize = 0,
  });
}

extension ProductVariantEntityX on ProductVariantEntity {
  String get label => options.where((o) => o.isNotEmpty).join(' / ');

  bool get isOutOfStock => !sellWhenOutOfStock && stock != null && stock! <= 0;

  /// What a stepper may count up to; null = unbounded.
  int? get purchaseLimit => sellWhenOutOfStock || isOutOfStock ? null : stock;

  bool get isLowStock {
    final left = stock;
    return !sellWhenOutOfStock && left != null && left > 0 && left < 5;
  }
}
