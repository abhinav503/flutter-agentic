import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/notification_section_entity.dart';

abstract interface class NotificationsRepository {
  /// [templateId] is the store's `template_id` wire string (plain store data,
  /// same as [storeId]) — not a UI template concept, so this layer stays free
  /// of the presentation-side `StorefrontTemplate` enum.
  Future<Either<Failure, List<NotificationSectionEntity>>> getNotifications({
    required String storeId,
    required String templateId,
  });
}
