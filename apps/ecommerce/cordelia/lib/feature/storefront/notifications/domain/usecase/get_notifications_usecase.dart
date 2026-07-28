import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import 'package:cordelia/feature/storefront/template/storefront_template.dart';

import '../entities/notification_section_entity.dart';
import '../repository/notifications_repository.dart';

/// Which template's notifications to load. Threaded as a call param rather
/// than injected, the same way `storeId` is — one registered use case serves
/// every storefront, and nothing needs re-registering when the shopper opens
/// a store running a different template.
class GetNotificationsParams {
  final StorefrontTemplate template;

  const GetNotificationsParams({required this.template});
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
  ) => _repository.getNotifications(params.template);
}
