import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/order_entity.dart';
import '../repository/orders_repository.dart';

class RateOrderParams {
  final String storeId;
  final String orderId;
  final int rating;
  final String text;

  const RateOrderParams({
    required this.storeId,
    required this.orderId,
    required this.rating,
    required this.text,
  });
}

/// Rating again replaces the previous rating, so this covers both giving and
/// changing one — there is no separate update use case, the same shape
/// `SubmitProductReviewUseCase` takes.
class RateOrderUseCase
    extends UseCase<Either<Failure, OrderEntity>, RateOrderParams> {
  final OrdersRepository _repository;
  const RateOrderUseCase(this._repository);

  @override
  Future<Either<Failure, OrderEntity>> call(RateOrderParams params) =>
      _repository.rateOrder(
        params.storeId,
        params.orderId,
        params.rating,
        params.text,
      );
}
