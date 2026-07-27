// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoriesModel _$CategoriesModelFromJson(Map<String, dynamic> json) =>
    _CategoriesModel(
      groups: (json['groups'] as List<dynamic>)
          .map((e) => CategoryGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoriesModelToJson(_CategoriesModel instance) =>
    <String, dynamic>{'groups': instance.groups};
