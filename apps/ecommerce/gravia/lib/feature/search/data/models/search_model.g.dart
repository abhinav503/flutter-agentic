// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchModel _$SearchModelFromJson(Map<String, dynamic> json) => _SearchModel(
  recentSearches: (json['recent_searches'] as List<dynamic>)
      .map((e) => RecentSearchModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  popularProducts: (json['popular_products'] as List<dynamic>)
      .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SearchModelToJson(_SearchModel instance) =>
    <String, dynamic>{
      'recent_searches': instance.recentSearches,
      'popular_products': instance.popularProducts,
    };
