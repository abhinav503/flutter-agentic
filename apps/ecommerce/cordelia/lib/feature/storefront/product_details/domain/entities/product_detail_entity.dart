import '../../../home/domain/entities/category_entity.dart';
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

  /// The first category this product belongs to, if any — a product can carry
  /// several and the backend resolves one. Null when it belongs to none, or
  /// to one that has since been deleted.
  final CategoryEntity? category;

  const ProductDetailEntity({
    required this.product,
    required this.images,
    required this.description,
    required this.sizeOptions,
    required this.similarProducts,
    this.category,
  });
}
