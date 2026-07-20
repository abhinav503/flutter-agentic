// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_results_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchResultsModel _$SearchResultsModelFromJson(Map<String, dynamic> json) =>
    _SearchResultsModel(
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchResultsModelToJson(_SearchResultsModel instance) =>
    <String, dynamic>{
      'products': instance.products,
      'categories': instance.categories,
    };
