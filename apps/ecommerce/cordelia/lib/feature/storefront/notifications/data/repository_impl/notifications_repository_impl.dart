import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import 'package:cordelia/constants/value_const.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/notification_section_entity.dart';
import '../../domain/repository/notifications_repository.dart';
import '../data_source/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl
    with BaseRepository
    implements NotificationsRepository {
  final NotificationsRemoteDataSource _dataSource;

  const NotificationsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<NotificationSectionEntity>>> getNotifications({
    required String storeId,
  }) => handleRequest(() async {
    final models = await _dataSource.getNotifications(storeId: storeId);
    return right(_intoSections(models.map((m) => m.toEntity()).toList()));
  });

  @override
  Future<Either<Failure, Unit>> markRead({
    required String storeId,
    required List<String> notificationIds,
  }) => handleRequest(() async {
    await _dataSource.markRead(
      storeId: storeId,
      notificationIds: notificationIds,
    );
    return right(unit);
  });

  /// Groups an already-newest-first list into the three dated sections the
  /// screens render.
  ///
  /// Empty sections are dropped rather than sent through with no rows: a
  /// heading with nothing under it reads as a loading failure. The order of
  /// the notifications inside each section is the API's, untouched.
  static List<NotificationSectionEntity> _intoSections(
    List<NotificationEntity> notifications,
  ) {
    if (notifications.isEmpty) return const [];

    // Compared as calendar days in the device's own timezone, not as an
    // elapsed-hours window: something sent at 11pm is "Yesterday" by 1am, not
    // 24 hours later.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final buckets = <String, List<NotificationEntity>>{
      ValueConst.notificationsSectionToday: [],
      ValueConst.notificationsSectionYesterday: [],
      ValueConst.notificationsSectionEarlier: [],
    };

    for (final notification in notifications) {
      final sentAt = notification.sentAt;
      final day = DateTime(sentAt.year, sentAt.month, sentAt.day);
      final title = !day.isBefore(today)
          ? ValueConst.notificationsSectionToday
          : !day.isBefore(yesterday)
          ? ValueConst.notificationsSectionYesterday
          : ValueConst.notificationsSectionEarlier;
      buckets[title]!.add(notification);
    }

    return [
      for (final entry in buckets.entries)
        if (entry.value.isNotEmpty)
          NotificationSectionEntity(
            title: entry.key,
            notifications: entry.value,
          ),
    ];
  }
}
