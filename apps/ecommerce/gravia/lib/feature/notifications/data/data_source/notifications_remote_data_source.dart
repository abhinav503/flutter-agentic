import '../models/notification_section_model.dart';

abstract interface class NotificationsRemoteDataSource {
  Future<List<NotificationSectionModel>> getNotifications();
}
