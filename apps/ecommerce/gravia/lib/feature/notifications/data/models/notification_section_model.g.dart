// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSectionModel _$NotificationSectionModelFromJson(
  Map<String, dynamic> json,
) => _NotificationSectionModel(
  title: json['title'] as String,
  notifications: (json['notifications'] as List<dynamic>)
      .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NotificationSectionModelToJson(
  _NotificationSectionModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'notifications': instance.notifications,
};
