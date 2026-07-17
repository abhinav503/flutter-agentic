import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/notification_section_entity.dart';

abstract interface class NotificationsRepository {
  Future<Either<Failure, List<NotificationSectionEntity>>> getNotifications();
}
