import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/order_entity.dart';
import '../repository/orders_repository.dart';

class GetOrdersUseCase
    extends UseCase<Either<Failure, List<OrderEntity>>, NoParams> {
  final OrdersRepository _repository;

  const GetOrdersUseCase(this._repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) =>
      _repository.getOrders();
}
