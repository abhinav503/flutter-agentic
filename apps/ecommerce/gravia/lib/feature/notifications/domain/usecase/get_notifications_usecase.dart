import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/notification_section_entity.dart';
import '../repository/notifications_repository.dart';

class GetNotificationsUseCase
    extends UseCase<Either<Failure, List<NotificationSectionEntity>>, NoParams> {
  final NotificationsRepository _repository;

  const GetNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, List<NotificationSectionEntity>>> call(
    NoParams params,
  ) => _repository.getNotifications();
}
