import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/order_entity.dart';
import '../repository/orders_repository.dart';

class CancelOrderParams {
  final String storeId;
  final String orderId;

  const CancelOrderParams({required this.storeId, required this.orderId});
}

class CancelOrderUseCase
    extends UseCase<Either<Failure, OrderEntity>, CancelOrderParams> {
  final OrdersRepository _repository;

  const CancelOrderUseCase(this._repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CancelOrderParams params) =>
      _repository.cancelOrder(params.storeId, params.orderId);
}
