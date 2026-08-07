import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/notifications_repository.dart';

class MarkNotificationsReadParams {
  final String storeId;
  final List<String> notificationIds;

  const MarkNotificationsReadParams({
    required this.storeId,
    required this.notificationIds,
  });
}

/// Acknowledges the notifications the shopper has just been shown.
///
/// Separate from loading them rather than folded into it: the read happens
/// when the screen opens, and a failure here must not turn a screenful of
/// notifications into an error state.
class MarkNotificationsReadUseCase
    extends UseCase<Either<Failure, Unit>, MarkNotificationsReadParams> {
  final NotificationsRepository _repository;

  const MarkNotificationsReadUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(MarkNotificationsReadParams params) =>
      _repository.markRead(
        storeId: params.storeId,
        notificationIds: params.notificationIds,
      );
}
