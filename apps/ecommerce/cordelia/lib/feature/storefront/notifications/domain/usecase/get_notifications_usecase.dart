import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/notification_section_entity.dart';
import '../repository/notifications_repository.dart';

/// Which store's notifications to load. Threaded as a call param rather than
/// injected, the same way `storeId` is elsewhere — one registered use case
/// serves every storefront, and nothing needs re-registering when the shopper
/// opens a different store.
///
/// No `templateId` any more: the feed is per-store data now that a real
/// backend serves it, and the template only decides how it's drawn.
class GetNotificationsParams {
  final String storeId;

  const GetNotificationsParams({required this.storeId});
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
  ) => _repository.getNotifications(storeId: params.storeId);
}
