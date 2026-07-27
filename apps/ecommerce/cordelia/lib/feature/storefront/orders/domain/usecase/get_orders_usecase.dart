import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/order_entity.dart';
import '../repository/orders_repository.dart';

class GetOrdersParams {
  final String storeId;

  const GetOrdersParams({required this.storeId});
}

class GetOrdersUseCase
    extends UseCase<Either<Failure, List<OrderEntity>>, GetOrdersParams> {
  final OrdersRepository _repository;

  const GetOrdersUseCase(this._repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(GetOrdersParams params) =>
      _repository.getOrders(params.storeId);
}
