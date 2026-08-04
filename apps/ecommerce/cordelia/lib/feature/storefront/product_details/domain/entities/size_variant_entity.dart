/// One selectable package size on the "Select QTY" row, with its own price —
/// 500g is not just 2× the 250g chip visually, it is what the cart will
/// charge for that pack. [value] is in the product's unit-type base unit,
/// same convention as `ProductEntity.unitValue`.
class SizeVariantEntity {
  final double value;
  final double price;
  final double originalPrice;
  final double discountPercentage;

  const SizeVariantEntity({
    required this.value,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
  });
}
