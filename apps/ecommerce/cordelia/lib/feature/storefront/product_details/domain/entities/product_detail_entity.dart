import '../../../home/domain/entities/category_entity.dart';
import '../../../home/domain/entities/product_entity.dart';
import 'brand_entity.dart';
import 'size_variant_entity.dart';

/// Wraps [ProductEntity] rather than duplicating its fields — this entity
/// only adds what a detail page needs beyond a card: a photo carousel,
/// long-form copy, selectable package sizes, and cross-sell products.
class ProductDetailEntity {
  final ProductEntity product;
  final List<String> images;
  final String description;

  /// Selectable package sizes with their real prices — what the "Select QTY"
  /// row renders and what a selection charges. Empty = no size picker; the
  /// repository guarantees every element is priced (legacy size-only
  /// responses are upgraded on load), so screens never price a size
  /// themselves.
  final List<SizeVariantEntity> sizeVariants;
  final List<ProductEntity> similarProducts;

  /// The first category this product belongs to, if any — a product can carry
  /// several and the backend resolves one. Null when it belongs to none, or
  /// to one that has since been deleted.
  final CategoryEntity? category;

  /// Null for an unbranded product, or when its brand has since been deleted.
  final BrandEntity? brand;

  const ProductDetailEntity({
    required this.product,
    required this.images,
    required this.description,
    required this.sizeVariants,
    required this.similarProducts,
    this.category,
    this.brand,
  });
}
