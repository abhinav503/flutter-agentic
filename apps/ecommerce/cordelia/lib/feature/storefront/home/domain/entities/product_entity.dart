import 'package:cordelia/enums/product_unit_type.dart';

class ProductEntity {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double originalPrice;
  final double discountPercentage;

  /// Package size in [unitType]'s base unit (grams, millilitres, or a bare
  /// count) — kept numeric, rather than a formatted "500 g" string, so it
  /// can be multiplied by a cart quantity; format for display with
  /// `unitType.format(unitValue)`.
  final double unitValue;
  final ProductUnitType unitType;
  final String prepTime;
  final bool isFavourite;

  /// The product's rolled-up rating, denormalized onto every product payload
  /// so a card can print it without loading any reviews. [reviewCount] 0
  /// means unrated — render that as such, never as 0.0 stars.
  final double ratingAverage;
  final int reviewCount;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.unitValue,
    required this.unitType,
    required this.prepTime,
    required this.isFavourite,
    this.ratingAverage = 0,
    this.reviewCount = 0,
  });
}

extension ProductEntityRatingX on ProductEntity {
  bool get hasRating => reviewCount > 0;
}
