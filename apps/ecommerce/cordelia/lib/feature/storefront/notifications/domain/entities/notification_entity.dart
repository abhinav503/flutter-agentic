import 'package:cordelia/enums/notification_kind.dart';
import 'package:cordelia/enums/notification_source.dart';

class NotificationEntity {
  final String id;
  final NotificationKind kind;
  final String title;
  final String message;

  /// Optional artwork sent with the push, drawn under the row in the
  /// notification centre as well as on the banner. Empty when the sender
  /// attached none, which is every order update — those are functional, and
  /// a basket has no one photo to stand for it.
  final String imageUrl;

  /// Store-authored or CordeliaApps-authored — see [NotificationSource].
  final NotificationSource source;

  /// When it was sent. What the repository groups the feed by, so the
  /// "Today"/"Yesterday" headings are the app's own translated copy rather
  /// than a server-authored string that could only ever be in one language.
  final DateTime sentAt;

  /// Whether this shopper has already opened the notifications screen since
  /// it arrived. Always false for a signed-out shopper — read receipts belong
  /// to an account, and the screen is reachable without one.
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.kind,
    required this.title,
    required this.message,
    required this.imageUrl,
    required this.source,
    required this.sentAt,
    required this.isRead,
  });
}
