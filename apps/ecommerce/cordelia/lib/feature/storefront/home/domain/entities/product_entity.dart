import 'package:cordelia/enums/product_unit_type.dart';

import 'product_variant_entity.dart';

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

  /// Units the store has left, or null when the backend didn't say. The
  /// server enforces this at both checkout steps, so a storefront that
  /// ignored it would let a shopper fill a cart it can never pay for.
  /// Null is deliberately *not* zero — see [ProductEntityStockX].
  final int? stock;

  /// The choices a shopper makes to pick a unit — ["Size", "Colour"] — and
  /// the units themselves. Both empty for a simple product. A backend that
  /// predates variants answers without them, which reads as simple.
  final List<String> optionNames;
  final List<ProductVariantEntity> variants;

  /// Facts shown as a spec list on the product page ("Material: Cotton").
  /// Never read by checkout.
  final Map<String, String> attributes;

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
    this.stock,
    this.optionNames = const [],
    this.variants = const [],
    this.attributes = const {},
  });
}

extension ProductEntityVariantsX on ProductEntity {
  bool get hasVariants => optionNames.isNotEmpty && variants.isNotEmpty;

  /// The distinct values of one option axis, in the order variants list
  /// them — what a chip row renders.
  List<String> optionValues(int axis) {
    final seen = <String>[];
    for (final v in variants) {
      if (axis < v.options.length && !seen.contains(v.options[axis])) {
        seen.add(v.options[axis]);
      }
    }
    return seen;
  }
}

extension ProductEntityRatingX on ProductEntity {
  bool get hasRating => reviewCount > 0;
}

extension ProductEntityStockX on ProductEntity {
  /// Below this many units left, a product says so on its card and its
  /// details page. A threshold, not a rule of nature: high enough that a
  /// shopper has time to act on it, low enough that an ordinary grocery
  /// shelf isn't shouting on every tile.
  static const int lowStockThreshold = 5;

  /// Unknown stock ([stock] null) sells: refusing a sale because the backend
  /// stayed silent would break every storefront the moment it talks to an
  /// API older than this field.
  bool get isOutOfStock => stock != null && stock! <= 0;

  bool get isInStock => !isOutOfStock;

  /// Running out, but still buyable — the state worth telling a shopper
  /// about while they can still do something about it. Unknown stock is
  /// never low: the backend said nothing, which is not the same as saying
  /// "few".
  bool get isLowStock {
    final left = stock;
    return left != null && left > 0 && left < lowStockThreshold;
  }

  /// The most a shopper may put in the cart, or null when unbounded — what
  /// a quantity stepper caps at, so the cart can't be built to fail at
  /// payment. Zero stock has no ceiling to express: nothing is addable, and
  /// the add control is disabled outright.
  int? get purchaseLimit => isOutOfStock ? null : stock;
}
