import 'package:doc_scanner/enums/notification_type.dart';

class NotificationPayload {
  final NotificationType type;
  final String? route;

  const NotificationPayload({required this.type, this.route});

  factory NotificationPayload.fromData(Map<String, dynamic> data) =>
      NotificationPayload(
        type: (data['notificationType']?.toString() ?? '').toNotificationType(),
        route: data['route']?.toString(),
      );
}
