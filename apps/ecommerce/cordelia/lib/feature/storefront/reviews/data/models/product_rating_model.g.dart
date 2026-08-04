// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductRatingModel _$ProductRatingModelFromJson(Map<String, dynamic> json) =>
    _ProductRatingModel(
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
      count: (json['count'] as num?)?.toInt() ?? 0,
      buckets:
          (json['buckets'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[0, 0, 0, 0, 0],
    );

Map<String, dynamic> _$ProductRatingModelToJson(_ProductRatingModel instance) =>
    <String, dynamic>{
      'average': instance.average,
      'count': instance.count,
      'buckets': instance.buckets,
    };
