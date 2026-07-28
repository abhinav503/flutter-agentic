import 'package:cordelia/feature/storefront/template/storefront_template.dart';

import '../models/notification_section_model.dart';

abstract interface class NotificationsRemoteDataSource {
  Future<List<NotificationSectionModel>> getNotifications(
    StorefrontTemplate template,
  );
}
