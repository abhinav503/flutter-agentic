import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cordelia/enums/notification_kind.dart';
import 'package:cordelia/enums/notification_source.dart';

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
    @JsonKey(name: 'image_url') required String imageUrl,
    required String source,
    @JsonKey(name: 'created_at_ms') required int createdAtMs,
    @JsonKey(name: 'is_read') required bool isRead,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  factory NotificationModel.fromEntity(NotificationEntity e) =>
      NotificationModel(
        id: e.id,
        kind: e.kind.name,
        title: e.title,
        message: e.message,
        imageUrl: e.imageUrl,
        source: e.source.name,
        createdAtMs: e.sentAt.millisecondsSinceEpoch,
        isRead: e.isRead,
      );

  // The wire strings are parsed here, in the data layer — every presentation
  // template only ever sees the enums.
  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    kind: kind.toNotificationKind(),
    title: title,
    message: message,
    imageUrl: imageUrl,
    source: source.toNotificationSource(),
    sentAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
    isRead: isRead,
  );
}
