// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreModel _$StoreModelFromJson(Map<String, dynamic> json) => _StoreModel(
  id: json['id'] as String,
  name: json['name'] as String,
  image: json['image'] as String,
  description: json['description'] as String,
  templateId: json['template_id'] as String? ?? '',
  language: json['language'] as String? ?? '',
  currency: json['currency'] as String? ?? '',
);

Map<String, dynamic> _$StoreModelToJson(_StoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'template_id': instance.templateId,
      'language': instance.language,
      'currency': instance.currency,
    };
