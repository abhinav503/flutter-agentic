// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductDetailModel _$ProductDetailModelFromJson(Map<String, dynamic> json) =>
    _ProductDetailModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String,
      sizeOptions: (json['size_options'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      similarProducts: (json['similar_products'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductDetailModelToJson(_ProductDetailModel instance) =>
    <String, dynamic>{
      'product': instance.product,
      'images': instance.images,
      'description': instance.description,
      'size_options': instance.sizeOptions,
      'similar_products': instance.similarProducts,
    };
