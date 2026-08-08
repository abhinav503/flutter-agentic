// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: json['id'] as String,
      kind: json['kind'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      imageUrl: json['image_url'] as String,
      source: json['source'] as String,
      createdAtMs: (json['created_at_ms'] as num).toInt(),
      isRead: json['is_read'] as bool,
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': instance.kind,
      'title': instance.title,
      'message': instance.message,
      'image_url': instance.imageUrl,
      'source': instance.source,
      'created_at_ms': instance.createdAtMs,
      'is_read': instance.isRead,
    };
