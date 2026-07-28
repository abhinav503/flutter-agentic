import 'banner_entity.dart';
import 'category_entity.dart';
import 'product_entity.dart';

class HomeEntity {
  final List<CategoryEntity> categories;
  final List<ProductEntity> popularProducts;

  /// Admin-authored promo banners, already filtered to the live ones and in
  /// carousel order by the API. Empty for a store that hasn't added any — a
  /// template then falls back to whatever it showed before banners existed.
  final List<BannerEntity> banners;

  const HomeEntity({
    required this.categories,
    required this.popularProducts,
    required this.banners,
  });

  HomeEntity copyWith({
    List<CategoryEntity>? categories,
    List<ProductEntity>? popularProducts,
    List<BannerEntity>? banners,
  }) => HomeEntity(
    categories: categories ?? this.categories,
    popularProducts: popularProducts ?? this.popularProducts,
    banners: banners ?? this.banners,
  );
}
