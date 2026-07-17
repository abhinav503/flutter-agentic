import 'notification_entity.dart';

/// One dated grouping of notifications (e.g. "Today", "Yesterday") — the
/// section title is data, not a fixed enum, since a mocked backend could add
/// any label ("Last Week", "This Month") without a client change.
class NotificationSectionEntity {
  final String title;
  final List<NotificationEntity> notifications;

  const NotificationSectionEntity({
    required this.title,
    required this.notifications,
  });
}
