/// What a *push* should do when the shopper taps it — distinct from
/// [NotificationKind] (what the message is about) and [NotificationSource]
/// (who wrote it). Those two describe the row in the notification centre;
/// this one only ever describes the tap.
enum NotificationType { normal, routeToPage }

extension NotificationTypeParse on String {
  NotificationType toNotificationType() => switch (this) {
    'routeToPage' => NotificationType.routeToPage,
    _ => NotificationType.normal, // safe default: open the app, route nowhere
  };
}

/// Which of the three delivery paths a message arrived on. Not used for
/// routing decisions — kept because the three take genuinely different code
/// paths and naming them makes the service readable.
enum NotificationAppState { foreground, background, terminated }
