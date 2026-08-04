import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/order_entity.dart';
import '../entities/payment_intent_entity.dart';
import '../entities/payment_result_entity.dart';

abstract interface class OrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders(String storeId);

  Future<Either<Failure, PaymentIntentEntity>> createPayment(
    String storeId,
    List<CartItemEntity> items,
    String addressId, {
    String couponCode,
  });

  Future<Either<Failure, OrderEntity>> createOrder(
    String storeId,
    List<CartItemEntity> items,
    String addressId, {
    PaymentResultEntity? payment,
    String couponCode,
  });

  Future<Either<Failure, OrderEntity>> cancelOrder(
    String storeId,
    String orderId,
  );

  /// Rates the shopper's own delivered order; resolves to the order with the
  /// rating applied. Re-rating replaces the previous one.
  Future<Either<Failure, OrderEntity>> rateOrder(
    String storeId,
    String orderId,
    int rating,
    String text,
  );
}
