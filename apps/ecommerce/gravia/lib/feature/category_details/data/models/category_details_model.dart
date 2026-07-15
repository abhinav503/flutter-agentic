import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/data/models/product_model.dart';
import '../../domain/entities/category_details_entity.dart';

part 'category_details_model.freezed.dart';
part 'category_details_model.g.dart';

@freezed
abstract class CategoryDetailsModel with _$CategoryDetailsModel {
  const CategoryDetailsModel._();

  const factory CategoryDetailsModel({
    required List<ProductModel> products,
  }) = _CategoryDetailsModel;

  factory CategoryDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryDetailsModelFromJson(json);

  factory CategoryDetailsModel.fromEntity(CategoryDetailsEntity e) => CategoryDetailsModel(
        products: e.products.map(ProductModel.fromEntity).toList(),
      );

  CategoryDetailsEntity toEntity() =>
      CategoryDetailsEntity(products: products.map((p) => p.toEntity()).toList());
}
