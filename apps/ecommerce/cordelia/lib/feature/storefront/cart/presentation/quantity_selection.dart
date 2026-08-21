import 'package:flutter/widgets.dart';

/// Quantity-picker state with a floor of 1 — shared by Product Details
/// (via `ProductDetailsActions`) and both templates' add-to-cart sheets, so
/// the disabled-decrement rule can't drift between them.
mixin QuantitySelection<T extends StatefulWidget> on State<T> {
  int quantity = 1;

  void incrementQuantity() => setState(() => quantity++);

  /// [incrementQuantity], or null once [quantity] has reached [max] (null =
  /// unbounded) — the ceiling counterpart of [decrementQuantity]'s floor.
  /// Callers pass the product's remaining stock, so a shopper can't build a
  /// quantity the server will refuse at payment. Taken as an argument rather
  /// than read off a field because the limit arrives with the BLoC state the
  /// screen is building against, not with the screen itself.
  VoidCallback? incrementQuantityUpTo(int? max) =>
      max != null && quantity >= max ? null : incrementQuantity;

  /// Null once [quantity] is at its floor of 1 — steppers take this directly
  /// as their decrement callback, so the disabled state falls out for free.
  VoidCallback? get decrementQuantity =>
      quantity > 1 ? () => setState(() => quantity--) : null;

  void resetQuantity() => setState(() => quantity = 1);
}
