// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => _BannerModel(
  id: json['id'] as String,
  image: json['image'] as String,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String? ?? '',
  targetType: json['target_type'] as String? ?? 'none',
  targetId: json['target_id'] as String? ?? '',
);

Map<String, dynamic> _$BannerModelToJson(_BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'target_type': instance.targetType,
      'target_id': instance.targetId,
    };
