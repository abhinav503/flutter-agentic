import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/order_entity.dart';
import '../entities/payment_result_entity.dart';
import '../repository/orders_repository.dart';

class CreateOrderParams {
  final String storeId;
  final List<CartItemEntity> items;
  final String addressId;

  /// The verified Razorpay result on mobile; null on the web preview, where
  /// a test-mode store places a payment-less order.
  final PaymentResultEntity? payment;

  /// '' = no coupon. Only the code travels — the server re-validates and
  /// prices it inside the order transaction.
  final String couponCode;

  const CreateOrderParams({
    required this.storeId,
    required this.items,
    required this.addressId,
    this.payment,
    this.couponCode = '',
  });
}

class CreateOrderUseCase
    extends UseCase<Either<Failure, OrderEntity>, CreateOrderParams> {
  final OrdersRepository _repository;

  const CreateOrderUseCase(this._repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) =>
      _repository.createOrder(
        params.storeId,
        params.items,
        params.addressId,
        payment: params.payment,
        couponCode: params.couponCode,
      );
}
