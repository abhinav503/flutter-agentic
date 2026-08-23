import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_variant_entity.dart';

part 'product_variant_model.freezed.dart';
part 'product_variant_model.g.dart';

@freezed
abstract class ProductVariantModel with _$ProductVariantModel {
  const ProductVariantModel._();

  const factory ProductVariantModel({
    required String id,
    @Default(<String>[]) List<String> options,
    required double price,
    @JsonKey(name: 'original_price') required double originalPrice,
    @JsonKey(name: 'discount_percentage')
    @Default(0.0)
    double discountPercentage,
    int? stock,
    @JsonKey(name: 'sell_when_out_of_stock')
    @Default(false)
    bool sellWhenOutOfStock,
    @Default('') String image,
    @JsonKey(name: 'pack_size') @Default(0.0) double packSize,
  }) = _ProductVariantModel;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantModelFromJson(json);

  factory ProductVariantModel.fromEntity(ProductVariantEntity e) =>
      ProductVariantModel(
        id: e.id,
        options: e.options,
        price: e.price,
        originalPrice: e.originalPrice,
        discountPercentage: e.discountPercentage,
        stock: e.stock,
        sellWhenOutOfStock: e.sellWhenOutOfStock,
        image: e.imageUrl,
        packSize: e.packSize,
      );

  ProductVariantEntity toEntity() => ProductVariantEntity(
    id: id,
    options: options,
    price: price,
    originalPrice: originalPrice,
    discountPercentage: discountPercentage,
    stock: stock,
    sellWhenOutOfStock: sellWhenOutOfStock,
    imageUrl: image,
    packSize: packSize,
  );
}
