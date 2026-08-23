// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfigModel _$AppConfigModelFromJson(Map<String, dynamic> json) =>
    _AppConfigModel(
      minVersion:
          (json['min_version'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      updateUrl:
          (json['update_url'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$AppConfigModelToJson(_AppConfigModel instance) =>
    <String, dynamic>{
      'min_version': instance.minVersion,
      'update_url': instance.updateUrl,
    };
