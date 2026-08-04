import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/notification_section_entity.dart';
import '../repository/notifications_repository.dart';

/// Which store's notifications to load. Threaded as call params rather than
/// injected, the same way `storeId` is elsewhere — one registered use case
/// serves every storefront, and nothing needs re-registering when the shopper
/// opens a different store. [templateId] is the store's `template_id` wire
/// string, carried as store data (not a UI concept).
class GetNotificationsParams {
  final String storeId;
  final String templateId;

  const GetNotificationsParams({
    required this.storeId,
    required this.templateId,
  });
}

class GetNotificationsUseCase
    extends
        UseCase<
          Either<Failure, List<NotificationSectionEntity>>,
          GetNotificationsParams
        > {
  final NotificationsRepository _repository;

  const GetNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, List<NotificationSectionEntity>>> call(
    GetNotificationsParams params,
  ) => _repository.getNotifications(
    storeId: params.storeId,
    templateId: params.templateId,
  );
}
