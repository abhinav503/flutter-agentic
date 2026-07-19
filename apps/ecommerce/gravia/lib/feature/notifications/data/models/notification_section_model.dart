import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_section_entity.dart';
import 'notification_model.dart';

part 'notification_section_model.freezed.dart';
part 'notification_section_model.g.dart';

@freezed
abstract class NotificationSectionModel with _$NotificationSectionModel {
  const NotificationSectionModel._();

  const factory NotificationSectionModel({
    required String title,
    required List<NotificationModel> notifications,
  }) = _NotificationSectionModel;

  factory NotificationSectionModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSectionModelFromJson(json);

  factory NotificationSectionModel.fromEntity(NotificationSectionEntity e) =>
      NotificationSectionModel(
        title: e.title,
        notifications: e.notifications
            .map(NotificationModel.fromEntity)
            .toList(),
      );

  NotificationSectionEntity toEntity() => NotificationSectionEntity(
    title: title,
    notifications: notifications.map((m) => m.toEntity()).toList(),
  );
}
