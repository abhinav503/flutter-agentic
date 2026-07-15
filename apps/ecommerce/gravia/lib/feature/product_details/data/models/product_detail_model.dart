import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/data/models/product_model.dart';
import '../../domain/entities/product_detail_entity.dart';

part 'product_detail_model.freezed.dart';
part 'product_detail_model.g.dart';

@freezed
abstract class ProductDetailModel with _$ProductDetailModel {
  const ProductDetailModel._();

  const factory ProductDetailModel({
    required ProductModel product,
    required List<String> images,
    required String description,
    @JsonKey(name: 'size_options') required List<double> sizeOptions,
    @JsonKey(name: 'similar_products') required List<ProductModel> similarProducts,
  }) = _ProductDetailModel;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailModelFromJson(json);

  factory ProductDetailModel.fromEntity(ProductDetailEntity e) => ProductDetailModel(
        product: ProductModel.fromEntity(e.product),
        images: e.images,
        description: e.description,
        sizeOptions: e.sizeOptions,
        similarProducts: e.similarProducts.map(ProductModel.fromEntity).toList(),
      );

  ProductDetailEntity toEntity() => ProductDetailEntity(
        product: product.toEntity(),
        images: images,
        description: description,
        sizeOptions: sizeOptions,
        similarProducts: similarProducts.map((p) => p.toEntity()).toList(),
      );
}
