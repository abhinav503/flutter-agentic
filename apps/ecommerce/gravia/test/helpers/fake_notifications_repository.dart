import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/feature/notifications/domain/entities/notification_entity.dart';
import 'package:gravia/feature/notifications/domain/entities/notification_section_entity.dart';
import 'package:gravia/feature/notifications/domain/repository/notifications_repository.dart';

class FakeNotificationsRepository implements NotificationsRepository {
  /// Set per test to control what [getNotifications] resolves to.
  Either<Failure, List<NotificationSectionEntity>> result = right(const [
    NotificationSectionEntity(
      title: 'Today',
      notifications: [
        NotificationEntity(
          id: 'notif_1',
          iconAsset: 'assets/icons/badge-percent.svg',
          title: 'Best Deal of the Day',
          message: 'Buy 1 Get 1 Offer on selected product… hurry up',
        ),
      ],
    ),
  ]);

  @override
  Future<Either<Failure, List<NotificationSectionEntity>>>
  getNotifications() async => result;
}
