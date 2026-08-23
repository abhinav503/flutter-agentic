// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductVariantModel _$ProductVariantModelFromJson(
  Map<String, dynamic> json,
) => _ProductVariantModel(
  id: json['id'] as String,
  options:
      (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  price: (json['price'] as num).toDouble(),
  originalPrice: (json['original_price'] as num).toDouble(),
  discountPercentage: (json['discount_percentage'] as num?)?.toDouble() ?? 0.0,
  stock: (json['stock'] as num?)?.toInt(),
  sellWhenOutOfStock: json['sell_when_out_of_stock'] as bool? ?? false,
  image: json['image'] as String? ?? '',
  packSize: (json['pack_size'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$ProductVariantModelToJson(
  _ProductVariantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'options': instance.options,
  'price': instance.price,
  'original_price': instance.originalPrice,
  'discount_percentage': instance.discountPercentage,
  'stock': instance.stock,
  'sell_when_out_of_stock': instance.sellWhenOutOfStock,
  'image': instance.image,
  'pack_size': instance.packSize,
};
