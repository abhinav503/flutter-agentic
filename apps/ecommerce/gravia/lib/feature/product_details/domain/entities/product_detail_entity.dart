import '../../../home/domain/entities/product_entity.dart';

/// Wraps [ProductEntity] rather than duplicating its fields — this entity
/// only adds what a detail page needs beyond a card: a photo carousel,
/// long-form copy, selectable package sizes, and cross-sell products.
class ProductDetailEntity {
  final ProductEntity product;
  final List<String> images;
  final String description;

  /// Selectable package sizes, in [ProductEntity.unitType]'s base unit —
  /// same reasoning as [ProductEntity.unitValue]; format with
  /// `product.unitType.format(size)` for display.
  final List<double> sizeOptions;
  final List<ProductEntity> similarProducts;

  const ProductDetailEntity({
    required this.product,
    required this.images,
    required this.description,
    required this.sizeOptions,
    required this.similarProducts,
  });

  ProductDetailEntity copyWith({bool? isFavourite}) => ProductDetailEntity(
    product: isFavourite == null
        ? product
        : product.copyWith(isFavourite: isFavourite),
    images: images,
    description: description,
    sizeOptions: sizeOptions,
    similarProducts: similarProducts,
  );
}
