import 'category_entity.dart';
import 'product_entity.dart';

class HomeEntity {
  final List<CategoryEntity> categories;
  final List<ProductEntity> popularProducts;

  const HomeEntity({required this.categories, required this.popularProducts});

  HomeEntity copyWith({
    List<CategoryEntity>? categories,
    List<ProductEntity>? popularProducts,
  }) => HomeEntity(
    categories: categories ?? this.categories,
    popularProducts: popularProducts ?? this.popularProducts,
  );
}
