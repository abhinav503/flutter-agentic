import '../../../home/domain/entities/product_entity.dart';

class CartItemEntity {
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({required this.product, required this.quantity});

  CartItemEntity copyWith({int? quantity}) =>
      CartItemEntity(product: product, quantity: quantity ?? this.quantity);
}

extension CartItemsX on List<CartItemEntity> {
  int get itemCount => fold(0, (sum, item) => sum + item.quantity);

  double get itemTotal =>
      fold(0, (sum, item) => sum + item.product.price * item.quantity);

  double get discountTotal => fold(
    0,
    (sum, item) =>
        sum + (item.product.originalPrice - item.product.price) * item.quantity,
  );

  // Delivery is a flat free perk in this pack — no separate fee to subtract.
  double get grandTotal => itemTotal - discountTotal;
}
