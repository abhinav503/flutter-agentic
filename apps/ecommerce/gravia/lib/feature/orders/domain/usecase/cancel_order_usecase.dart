import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/order_entity.dart';
import '../repository/orders_repository.dart';

class CancelOrderUseCase extends UseCase<Either<Failure, OrderEntity>, String> {
  final OrdersRepository _repository;

  const CancelOrderUseCase(this._repository);

  @override
  Future<Either<Failure, OrderEntity>> call(String orderId) =>
      _repository.cancelOrder(orderId);
}
