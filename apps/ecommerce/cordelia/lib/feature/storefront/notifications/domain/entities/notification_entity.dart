import 'package:cordelia/enums/notification_kind.dart';

class NotificationEntity {
  final String id;
  final NotificationKind kind;
  final String title;
  final String message;

  const NotificationEntity({
    required this.id,
    required this.kind,
    required this.title,
    required this.message,
  });
}
