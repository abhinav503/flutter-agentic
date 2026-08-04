import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/data/models/category_model.dart';
import '../../../home/data/models/product_model.dart';
import '../../domain/entities/product_detail_entity.dart';
import 'brand_model.dart';
import 'size_variant_model.dart';

part 'product_detail_model.freezed.dart';
part 'product_detail_model.g.dart';

@freezed
abstract class ProductDetailModel with _$ProductDetailModel {
  const ProductDetailModel._();

  const factory ProductDetailModel({
    required ProductModel product,
    required List<String> images,
    required String description,
    // The pre-variant wire field (values only, price implied linear) — kept
    // so responses from a backend that predates size_variants still parse;
    // the repository upgrades it to priced variants on load.
    @JsonKey(name: 'size_options') required List<double> sizeOptions,
    // Defaulted, not required: a backend that predates per-size pricing
    // answers without the key.
    @JsonKey(name: 'size_variants')
    @Default(<SizeVariantModel>[])
    List<SizeVariantModel> sizeVariants,
    @JsonKey(name: 'similar_products')
    required List<ProductModel> similarProducts,
    // Nullable, not required: a product need not belong to a category, and
    // stores created before this field shipped answer without the key.
    CategoryModel? category,
    // Nullable like category — unbranded products (and pre-brand backends)
    // answer without the key.
    BrandModel? brand,
  }) = _ProductDetailModel;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailModelFromJson(json);

  factory ProductDetailModel.fromEntity(
    ProductDetailEntity e,
  ) => ProductDetailModel(
    product: ProductModel.fromEntity(e.product),
    images: e.images,
    description: e.description,
    // Derived, same rule as the backend: size_options is always the
    // variants' values.
    sizeOptions: e.sizeVariants.map((v) => v.value).toList(),
    sizeVariants: e.sizeVariants.map(SizeVariantModel.fromEntity).toList(),
    similarProducts: e.similarProducts.map(ProductModel.fromEntity).toList(),
    category: e.category == null ? null : CategoryModel.fromEntity(e.category!),
    brand: e.brand == null ? null : BrandModel.fromEntity(e.brand!),
  );

  ProductDetailEntity toEntity() => ProductDetailEntity(
    product: product.toEntity(),
    images: images,
    description: description,
    sizeVariants: sizeVariants.map((v) => v.toEntity()).toList(),
    similarProducts: similarProducts.map((p) => p.toEntity()).toList(),
    category: category?.toEntity(),
    brand: brand?.toEntity(),
  );
}
