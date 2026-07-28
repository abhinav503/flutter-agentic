import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cordelia/enums/notification_kind.dart';

import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required String id,
    required String kind,
    required String title,
    required String message,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  factory NotificationModel.fromEntity(NotificationEntity e) =>
      NotificationModel(
        id: e.id,
        kind: e.kind.name,
        title: e.title,
        message: e.message,
      );

  // The wire string is parsed here, in the data layer — every presentation
  // template only ever sees the enum.
  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    kind: kind.toNotificationKind(),
    title: title,
    message: message,
  );
}
