import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_entity.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required String id,
    required String name,
    required String image,
    required double price,
    @JsonKey(name: 'original_price') required double originalPrice,
    @JsonKey(name: 'discount_percentage') required double discountPercentage,
    required String weight,
    @JsonKey(name: 'prep_time') required String prepTime,
    @JsonKey(name: 'is_favourite') @Default(false) bool isFavourite,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  factory ProductModel.fromEntity(ProductEntity e) => ProductModel(
        id: e.id,
        name: e.name,
        image: e.imageUrl,
        price: e.price,
        originalPrice: e.originalPrice,
        discountPercentage: e.discountPercentage,
        weight: e.weight,
        prepTime: e.prepTime,
        isFavourite: e.isFavourite,
      );

  ProductEntity toEntity() => ProductEntity(
        id: id,
        name: name,
        imageUrl: image,
        price: price,
        originalPrice: originalPrice,
        discountPercentage: discountPercentage,
        weight: weight,
        prepTime: prepTime,
        isFavourite: isFavourite,
      );
}
