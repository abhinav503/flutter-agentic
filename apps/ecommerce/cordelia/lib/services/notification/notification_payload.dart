import 'package:cordelia/enums/notification_type.dart';

/// The FCM **data** block, parsed. App-level infrastructure rather than a
/// feature DTO, so it does not follow the `*Model`/`*Entity` pairing rule.
///
/// The sender is `admin/src/lib/push.ts`; keep the two in step. Shape:
/// ```json
/// { "notificationType": "routeToPage", "route": "notifications",
///   "storeId": "abc123" }
/// ```
class NotificationPayload {
  final NotificationType type;
  final String? route;

  /// Which store the message came from — absent on a CordeliaApps platform
  /// notification, which belongs to no store.
  final String? storeId;

  const NotificationPayload({required this.type, this.route, this.storeId});

  factory NotificationPayload.fromData(Map<String, dynamic> data) =>
      NotificationPayload(
        type: (data['notificationType']?.toString() ?? '').toNotificationType(),
        route: data['route']?.toString(),
        storeId: data['storeId']?.toString(),
      );
}
