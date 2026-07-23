import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/enums/order_status.dart';
import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:gravia/feature/orders/domain/entities/order_entity.dart';
import 'package:gravia/feature/orders/domain/entities/order_line_item_entity.dart';
import 'package:gravia/feature/orders/domain/entities/payment_intent_entity.dart';
import 'package:gravia/feature/orders/domain/entities/payment_result_entity.dart';
import 'package:gravia/feature/orders/domain/repository/orders_repository.dart';

class FakeOrdersRepository implements OrdersRepository {
  /// Set per test to control what [getOrders] resolves to.
  Either<Failure, List<OrderEntity>> result = right([
    OrderEntity(
      id: '1',
      status: OrderStatus.delivered,
      placedAt: DateTime(2026, 3, 9, 10, 15),
      deliveryOtp: '',
      items: const [
        OrderLineItemEntity(
          productName: 'Washington Red Apple',
          weight: '1kg',
          imageUrl: 'https://example.com/apple.png',
          price: 6.30,
          quantity: 1,
        ),
      ],
    ),
  ]);

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async => result;

  /// Set per test to control what [createPayment] resolves to.
  Either<Failure, PaymentIntentEntity> paymentResult = right(
    const PaymentIntentEntity(
      razorpayOrderId: 'order_test',
      razorpayKeyId: 'rzp_test_key',
      amount: 630,
      currency: 'INR',
    ),
  );

  @override
  Future<Either<Failure, PaymentIntentEntity>> createPayment(
    List<CartItemEntity> items,
    String addressId,
  ) async => paymentResult;

  @override
  Future<Either<Failure, OrderEntity>> createOrder(
    List<CartItemEntity> items,
    String addressId, {
    PaymentResultEntity? payment,
  }) async => result.map((orders) => orders.first);
}
