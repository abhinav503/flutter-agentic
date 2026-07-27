import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/notification_section_entity.dart';
import '../../domain/repository/notifications_repository.dart';
import '../data_source/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl
    with BaseRepository
    implements NotificationsRepository {
  final NotificationsRemoteDataSource _dataSource;

  const NotificationsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<NotificationSectionEntity>>> getNotifications() =>
      handleRequest(() async {
        final models = await _dataSource.getNotifications();
        return right(models.map((m) => m.toEntity()).toList());
      });
}
