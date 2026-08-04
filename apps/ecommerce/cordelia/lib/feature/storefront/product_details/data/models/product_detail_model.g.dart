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
      sizeVariants:
          (json['size_variants'] as List<dynamic>?)
              ?.map((e) => SizeVariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SizeVariantModel>[],
      similarProducts: (json['similar_products'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      brand: json['brand'] == null
          ? null
          : BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
      rating: json['rating'] == null
          ? const ProductRatingModel()
          : ProductRatingModel.fromJson(json['rating'] as Map<String, dynamic>),
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReviewModel>[],
    );

Map<String, dynamic> _$ProductDetailModelToJson(_ProductDetailModel instance) =>
    <String, dynamic>{
      'product': instance.product,
      'images': instance.images,
      'description': instance.description,
      'size_options': instance.sizeOptions,
      'size_variants': instance.sizeVariants,
      'similar_products': instance.similarProducts,
      'category': instance.category,
      'brand': instance.brand,
      'rating': instance.rating,
      'reviews': instance.reviews,
    };
