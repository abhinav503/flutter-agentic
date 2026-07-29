import 'package:flutter/widgets.dart';

/// Quantity-picker state with a floor of 1 — shared by Product Details
/// (via `ProductDetailsActions`) and both templates' add-to-cart sheets, so
/// the disabled-decrement rule can't drift between them.
mixin QuantitySelection<T extends StatefulWidget> on State<T> {
  int quantity = 1;

  void incrementQuantity() => setState(() => quantity++);

  /// Null once [quantity] is at its floor of 1 — steppers take this directly
  /// as their decrement callback, so the disabled state falls out for free.
  VoidCallback? get decrementQuantity =>
      quantity > 1 ? () => setState(() => quantity--) : null;

  void resetQuantity() => setState(() => quantity = 1);
}
