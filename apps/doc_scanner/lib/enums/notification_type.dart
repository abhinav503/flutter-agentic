enum NotificationType { normal, routeToPage }

extension NotificationTypeParse on String {
  NotificationType toNotificationType() => switch (this) {
        'routeToPage' => NotificationType.routeToPage,
        _ => NotificationType.normal, // safe default for unknown / missing values
      };
}

enum NotificationAppState { foreground, background, terminated }
