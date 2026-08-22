import 'package:cordelia/enums/checkout_refusal_code.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';

import '../../domain/entities/payment_result_entity.dart';
import '../models/order_model.dart';
import '../models/payment_intent_model.dart';

/// A checkout the server turned down for a reason it tagged with a
/// machine-readable `code`, re-written on this side in the shopper's own
/// language.
///
/// Carries the [code] as well as the finished [message]: the words tell the
/// shopper what happened, the code tells the screen what to *do* about it
/// (re-read the cart for a stock refusal, point at the address for an
/// unserviceable one). `OrdersRepositoryImpl` maps it to `Failure.refused`,
/// which is what carries both across the layer boundary.
class CheckoutRefusedException implements Exception {
  final CheckoutRefusalCode code;
  final String message;

  const CheckoutRefusedException(this.code, this.message);

  @override
  String toString() => message;
}

abstract interface class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders(String storeId);

  /// Creates the Razorpay order the checkout sheet opens against. The server
  /// prices the cart from the live catalog (minus [couponCode]'s discount,
  /// which it validates itself) and creates the order with the store's own
  /// credentials — the client sends only line ids/quantities and the code.
  Future<PaymentIntentModel> createPayment(
    String storeId,
    List<CartItemEntity> items,
    String addressId, {
    String couponCode,
  });

  /// Server recomputes price/stock from the live catalog — only
  /// `productId`+`quantity`(+`sizeValue`) are sent, read off each
  /// [CartItemEntity], plus [couponCode], which the server re-validates and
  /// prices inside the order transaction. The server reads the address doc
  /// for [addressId] and snapshots it onto the order. [payment] is the
  /// verified Razorpay result on mobile; null on the web preview, where a
  /// test-mode store places a payment-less order.
  Future<OrderModel> createOrder(
    String storeId,
    List<CartItemEntity> items,
    String addressId, {
    PaymentResultEntity? payment,
    String couponCode,
  });

  /// Cancels the shopper's own order server-side (restock + refund if it was
  /// paid) and returns the updated order, whose `refund_status` reflects the
  /// refund outcome. The server authorizes by the verified token's uid.
  Future<OrderModel> cancelOrder(String storeId, String orderId);

  /// Rates the shopper's own delivered order, returning it with the rating
  /// applied. Re-rating replaces the previous one. The server authorizes by
  /// the verified token's uid and refuses anything not delivered — this is
  /// about the delivery, so there is nothing to judge before it arrives.
  Future<OrderModel> rateOrder(
    String storeId,
    String orderId,
    int rating,
    String text,
  );
}
