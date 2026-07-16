import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:gravia/enums/product_unit_type.dart';

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
    @JsonKey(name: 'unit_value') required double unitValue,
    // Raw wire string ('g' / 'ml' / 'pcs') — parsed to ProductUnitType only
    // in toEntity(), per the data-layer-parses-wire-strings convention.
    @JsonKey(name: 'unit_type') required String unitType,
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
    unitValue: e.unitValue,
    unitType: e.unitType.wireValue,
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
    unitValue: unitValue,
    unitType: unitType.toProductUnitType(),
    prepTime: prepTime,
    isFavourite: isFavourite,
  );
}
