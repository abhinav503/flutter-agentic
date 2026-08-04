// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_variant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SizeVariantModel _$SizeVariantModelFromJson(Map<String, dynamic> json) =>
    _SizeVariantModel(
      value: (json['value'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['original_price'] as num).toDouble(),
      discountPercentage: (json['discount_percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$SizeVariantModelToJson(_SizeVariantModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'price': instance.price,
      'original_price': instance.originalPrice,
      'discount_percentage': instance.discountPercentage,
    };
