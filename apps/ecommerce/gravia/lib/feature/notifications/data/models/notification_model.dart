import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required String id,
    required String icon,
    required String title,
    required String message,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  factory NotificationModel.fromEntity(NotificationEntity e) =>
      NotificationModel(
        id: e.id,
        icon: e.iconAsset,
        title: e.title,
        message: e.message,
      );

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    iconAsset: icon,
    title: title,
    message: message,
  );
}
