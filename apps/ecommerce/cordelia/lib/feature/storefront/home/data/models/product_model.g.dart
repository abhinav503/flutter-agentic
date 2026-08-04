// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['original_price'] as num).toDouble(),
      discountPercentage: (json['discount_percentage'] as num).toDouble(),
      unitValue: (json['unit_value'] as num).toDouble(),
      unitType: json['unit_type'] as String,
      prepTime: json['prep_time'] as String,
      isFavourite: json['is_favourite'] as bool? ?? false,
      ratingAverage: (json['rating_average'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'original_price': instance.originalPrice,
      'discount_percentage': instance.discountPercentage,
      'unit_value': instance.unitValue,
      'unit_type': instance.unitType,
      'prep_time': instance.prepTime,
      'is_favourite': instance.isFavourite,
      'rating_average': instance.ratingAverage,
      'review_count': instance.reviewCount,
    };
