import '../models/notification_model.dart';

abstract interface class NotificationsRemoteDataSource {
  /// This store's notifications merged with CordeliaApps' platform-wide feed,
  /// newest first. The API does the merging so the app can't show one and
  /// miss the other.
  Future<List<NotificationModel>> getNotifications({required String storeId});

  /// Records that the shopper has seen [notificationIds]. Fire-and-forget
  /// from the caller's point of view — a failed receipt costs an unread dot,
  /// not the screen.
  Future<void> markRead({
    required String storeId,
    required List<String> notificationIds,
  });
}
