/// The base unit a product's numeric unit value is expressed in — mass,
/// volume, or a bare count — so quantity math (grams × cart quantity,
/// millilitres × cart quantity, …) never mixes incompatible units.
enum ProductUnitType { grams, milliliters, pieces }

extension ProductUnitTypeX on ProductUnitType {
  /// Enum → wire value, for the data layer's model-to-JSON mapping.
  String get wireValue => switch (this) {
    ProductUnitType.grams => 'g',
    ProductUnitType.milliliters => 'ml',
    ProductUnitType.pieces => 'pcs',
  };

  /// Formats [amount] — already in this type's base unit — into kit-style
  /// copy, converting to the larger unit (kg / L) once it crosses 1000.
  /// Pieces never convert; there's no larger unit to roll up into.
  String format(double amount) => switch (this) {
    ProductUnitType.grams => _withLargeUnit(amount, small: 'g', large: 'kg'),
    ProductUnitType.milliliters => _withLargeUnit(
      amount,
      small: 'ml',
      large: 'L',
    ),
    ProductUnitType.pieces => _pieces(amount),
  };

  /// What a price is *per*, for a "$1.8/kg" suffix — the pack [format] would
  /// print, minus a leading "1" that reads better implied: 1000 g → `kg`,
  /// 1 pc → `pc`, but 500 g → `500 g` and 1.5 kg → `1.5 kg`.
  ///
  /// The unit alone is only honest when the pack *is* one of them. A 500 g
  /// pack labelled `/g` prices the product per gram — off by 500× — which is
  /// what this used to print, since it took the last word of the formatted
  /// pack and threw the amount away. Derived from [format] so the suffix and
  /// the pack size shown beside it can't disagree.
  String pricePerLabel(double amount) {
    final formatted = format(amount);
    final parts = formatted.split(' ');
    return parts.first == '1' ? parts.last : formatted;
  }

  static String _withLargeUnit(
    double amount, {
    required String small,
    required String large,
  }) {
    if (amount < 1000) return '${amount.toStringAsFixed(0)} $small';
    final rolled = amount / 1000;
    final isWhole = rolled == rolled.roundToDouble();
    return '${isWhole ? rolled.toStringAsFixed(0) : rolled.toStringAsFixed(1)} $large';
  }

  // Singular "pc" for a single piece; "pcs" otherwise. Pluralised off the
  // displayed count so it always agrees with the shown number.
  static String _pieces(double amount) {
    final count = amount.toStringAsFixed(0);
    return '$count ${count == '1' ? 'pc' : 'pcs'}';
  }
}

/// Wire value → enum: tolerates unknown values by defaulting to grams,
/// since that's the majority case in the current catalog.
extension ProductUnitTypeParse on String {
  ProductUnitType toProductUnitType() => switch (this) {
    'ml' => ProductUnitType.milliliters,
    'pcs' => ProductUnitType.pieces,
    _ => ProductUnitType.grams,
  };
}
