import '../../../home/domain/entities/category_entity.dart';

/// A named section on the Categories screen (e.g. "Snacks & Drinks"), each
/// holding its own [CategoryEntity] tiles — reuses Home's category concept
/// rather than duplicating it, same reasoning as `SearchEntity` reusing
/// `ProductEntity`.
class CategoryGroupEntity {
  final String name;
  final List<CategoryEntity> categories;

  const CategoryGroupEntity({required this.name, required this.categories});
}
