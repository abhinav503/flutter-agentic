import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'package:doc_scanner/enums/notification_type.dart';
import 'notification_navigator.dart';
import 'notification_payload.dart';

class NotificationRouter {
  const NotificationRouter._();

  static void route(NotificationPayload payload) {
    debugPrint('NotificationRouter.route type=${payload.type} route=${payload.route}');
    switch (payload.type) {
      case NotificationType.routeToPage:
        final route = payload.route;
        final ctx = rootNavigatorKey.currentContext;
        if (route == null || route.isEmpty || ctx == null) return;
        ctx.go('/$route');
      case NotificationType.normal:
        break; // nothing to route; the notification was informational
    }
  }
}
