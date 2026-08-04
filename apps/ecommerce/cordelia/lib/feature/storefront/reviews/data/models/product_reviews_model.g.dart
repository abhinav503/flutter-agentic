// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_reviews_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductReviewsModel _$ProductReviewsModelFromJson(Map<String, dynamic> json) =>
    _ProductReviewsModel(
      rating: json['rating'] == null
          ? const ProductRatingModel()
          : ProductRatingModel.fromJson(json['rating'] as Map<String, dynamic>),
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReviewModel>[],
    );

Map<String, dynamic> _$ProductReviewsModelToJson(
  _ProductReviewsModel instance,
) => <String, dynamic>{'rating': instance.rating, 'reviews': instance.reviews};
