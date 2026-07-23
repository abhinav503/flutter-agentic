import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';

import '../../domain/entities/payment_result_entity.dart';
import '../models/order_model.dart';
import '../models/payment_intent_model.dart';

abstract interface class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders();

  /// Creates the Razorpay order the checkout sheet opens against. The server
  /// prices the cart from the live catalog and creates the order with the
  /// store's own credentials — the client sends only `productId`+`quantity`.
  Future<PaymentIntentModel> createPayment(
    List<CartItemEntity> items,
    String addressId,
  );

  /// Server recomputes price/stock from the live catalog — only
  /// `productId`+`quantity` are sent, read off each [CartItemEntity]. The
  /// server reads the address doc for [addressId] and snapshots it onto the
  /// order. [payment] is the verified Razorpay result on mobile; null on the
  /// web preview, where a test-mode store places a payment-less order.
  Future<OrderModel> createOrder(
    List<CartItemEntity> items,
    String addressId, {
    PaymentResultEntity? payment,
  });
}
