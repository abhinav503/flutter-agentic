import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/notification_section_entity.dart';

abstract interface class NotificationsRepository {
  /// This store's notifications merged with CordeliaApps' platform feed,
  /// already grouped into dated sections ("Today", "Yesterday", "Earlier").
  ///
  /// Grouping happens here rather than server-side because the section titles
  /// are copy: a heading composed by the API could only ever be in one
  /// language, and would print English into a Hindi or German storefront.
  Future<Either<Failure, List<NotificationSectionEntity>>> getNotifications({
    required String storeId,
  });

  /// Records that the shopper has seen [notificationIds].
  ///
  /// Returns nothing on success and swallows nothing on failure — the caller
  /// decides whether a missed receipt is worth surfacing. It generally isn't:
  /// the cost is an unread dot that reappears.
  Future<Either<Failure, Unit>> markRead({
    required String storeId,
    required List<String> notificationIds,
  });
}
