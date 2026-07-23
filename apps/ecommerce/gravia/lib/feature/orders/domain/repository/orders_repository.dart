import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';

import '../entities/order_entity.dart';
import '../entities/payment_intent_entity.dart';
import '../entities/payment_result_entity.dart';

abstract interface class OrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders();

  Future<Either<Failure, PaymentIntentEntity>> createPayment(
    List<CartItemEntity> items,
    String addressId,
  );

  Future<Either<Failure, OrderEntity>> createOrder(
    List<CartItemEntity> items,
    String addressId, {
    PaymentResultEntity? payment,
  });

  Future<Either<Failure, OrderEntity>> cancelOrder(String orderId);
}
