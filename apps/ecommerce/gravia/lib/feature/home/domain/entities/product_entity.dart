class ProductEntity {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double originalPrice;
  final double discountPercentage;
  final String weight;
  final String prepTime;
  final bool isFavourite;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.weight,
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
        weight: weight,
        prepTime: prepTime,
        isFavourite: isFavourite ?? this.isFavourite,
      );
}
