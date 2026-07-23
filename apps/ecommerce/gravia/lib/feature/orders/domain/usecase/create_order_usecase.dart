import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';

import '../entities/order_entity.dart';
import '../entities/payment_result_entity.dart';
import '../repository/orders_repository.dart';

class CreateOrderParams {
  final List<CartItemEntity> items;
  final String addressId;

  /// The verified Razorpay result on mobile; null on the web preview, where
  /// a test-mode store places a payment-less order.
  final PaymentResultEntity? payment;

  const CreateOrderParams({
    required this.items,
    required this.addressId,
    this.payment,
  });
}

class CreateOrderUseCase
    extends UseCase<Either<Failure, OrderEntity>, CreateOrderParams> {
  final OrdersRepository _repository;

  const CreateOrderUseCase(this._repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) =>
      _repository.createOrder(
        params.items,
        params.addressId,
        payment: params.payment,
      );
}
