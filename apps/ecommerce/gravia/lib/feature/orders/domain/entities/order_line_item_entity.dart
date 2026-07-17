class OrderLineItemEntity {
  final String productName;
  final String weight;
  final String imageUrl;
  final double price;
  final int quantity;

  const OrderLineItemEntity({
    required this.productName,
    required this.weight,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
}

extension OrderLineItemEntityX on OrderLineItemEntity {
  double get lineTotal => price * quantity;
}

extension OrderLineItemsX on List<OrderLineItemEntity> {
  double get total => fold(0, (sum, item) => sum + item.lineTotal);
}
