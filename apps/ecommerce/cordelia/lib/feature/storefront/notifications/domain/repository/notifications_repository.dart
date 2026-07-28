import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import 'package:cordelia/feature/storefront/template/storefront_template.dart';

import '../entities/notification_section_entity.dart';

abstract interface class NotificationsRepository {
  Future<Either<Failure, List<NotificationSectionEntity>>> getNotifications(
    StorefrontTemplate template,
  );
}
