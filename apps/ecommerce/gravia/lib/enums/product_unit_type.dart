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
    ProductUnitType.pieces => '${amount.toStringAsFixed(0)} pcs',
  };

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
