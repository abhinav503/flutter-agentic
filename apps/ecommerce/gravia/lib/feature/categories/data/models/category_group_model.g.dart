// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryGroupModel _$CategoryGroupModelFromJson(Map<String, dynamic> json) =>
    _CategoryGroupModel(
      name: json['name'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryGroupModelToJson(_CategoryGroupModel instance) =>
    <String, dynamic>{'name': instance.name, 'categories': instance.categories};
