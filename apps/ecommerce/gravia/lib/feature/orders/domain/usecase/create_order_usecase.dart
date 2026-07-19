import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';

import '../entities/order_entity.dart';
import '../repository/orders_repository.dart';

class CreateOrderUseCase
    extends UseCase<Either<Failure, OrderEntity>, List<CartItemEntity>> {
  final OrdersRepository _repository;

  const CreateOrderUseCase(this._repository);

  @override
  Future<Either<Failure, OrderEntity>> call(List<CartItemEntity> params) =>
      _repository.createOrder(params);
}
