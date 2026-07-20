import '../../../home/domain/entities/category_entity.dart';
import '../../../home/domain/entities/product_entity.dart';

/// One query's matches across the catalog. Reuses Home's [ProductEntity] and
/// [CategoryEntity] — search results are the same concepts, just filtered.
class SearchResultsEntity {
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;

  const SearchResultsEntity({required this.products, required this.categories});
}
