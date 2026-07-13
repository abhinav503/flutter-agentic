import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/home_entity.dart';
import 'category_model.dart';
import 'product_model.dart';

part 'home_model.freezed.dart';
part 'home_model.g.dart';

@freezed
abstract class HomeModel with _$HomeModel {
  const HomeModel._();

  const factory HomeModel({
    required List<CategoryModel> categories,
    @JsonKey(name: 'popular_products') required List<ProductModel> popularProducts,
  }) = _HomeModel;

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);

  factory HomeModel.fromEntity(HomeEntity e) => HomeModel(
        categories: e.categories.map(CategoryModel.fromEntity).toList(),
        popularProducts: e.popularProducts.map(ProductModel.fromEntity).toList(),
      );

  HomeEntity toEntity() => HomeEntity(
        categories: categories.map((c) => c.toEntity()).toList(),
        popularProducts: popularProducts.map((p) => p.toEntity()).toList(),
      );
}
