import 'package:gravia/enums/product_unit_type.dart';

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
  });

  ProductEntity copyWith({bool? isFavourite}) => ProductEntity(
        id: id,
        name: name,
        imageUrl: imageUrl,
        price: price,
        originalPrice: originalPrice,
        discountPercentage: discountPercentage,
        unitValue: unitValue,
        unitType: unitType,
        prepTime: prepTime,
        isFavourite: isFavourite ?? this.isFavourite,
      );
}
