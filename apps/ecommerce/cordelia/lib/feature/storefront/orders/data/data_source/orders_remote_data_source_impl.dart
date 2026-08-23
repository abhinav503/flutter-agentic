import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/enums/checkout_refusal_code.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

import 'package:core/core/network/http_service.dart';

import '../../domain/entities/payment_result_entity.dart';
import '../models/order_model.dart';
import '../models/payment_intent_model.dart';
import 'orders_remote_data_source.dart';

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  const OrdersRemoteDataSourceImpl();

  // The server derives the shopper's uid from this verified token and
  // returns only that user's orders — a null token means signed out, so
  // the list degrades to empty rather than hitting the API.
  @override
  Future<List<OrderModel>> getOrders(String storeId) async {
    final idToken = await FirebaseAuthService.instance.idToken();
    if (idToken == null) return const [];

    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.ordersPath(storeId),
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
    final orders = response.data!['orders'] as List<dynamic>;
    return orders
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PaymentIntentModel> createPayment(
    String storeId,
    List<CartItemEntity> items,
    String addressId, {
    String couponCode = '',
  }) async {
    final idToken = await FirebaseAuthService.instance.idToken();

    try {
      final response = await HttpService.instance.post<Map<String, dynamic>>(
        ApiConstants.paymentsPath(storeId),
        data: {
          'addressId': addressId,
          'items': _itemsPayload(items),
          if (couponCode.isNotEmpty) 'couponCode': couponCode,
        },
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
      return PaymentIntentModel.fromJson(response.data!);
    } on DioException catch (e) {
      // Nothing has been charged at this step, so a refusal here is only a
      // message — but it's the same message, from the same `code`.
      throw refusalFrom(e, items) ?? e;
    }
  }

  @override
  Future<OrderModel> createOrder(
    String storeId,
    List<CartItemEntity> items,
    String addressId, {
    PaymentResultEntity? payment,
    String couponCode = '',
  }) async {
    // Checkout is only reachable while signed in; the server rejects a
    // missing/invalid token with 401, surfaced as a Failure.
    final idToken = await FirebaseAuthService.instance.idToken();

    try {
      final response = await HttpService.instance.post<Map<String, dynamic>>(
        ApiConstants.ordersPath(storeId),
        data: {
          'addressId': addressId,
          'items': _itemsPayload(items),
          if (couponCode.isNotEmpty) 'couponCode': couponCode,
          // Present only on mobile; the server verifies the payment before
          // placing the order. Omitted on web (test-mode payment-less path).
          // Provider-neutral names — the signature is Razorpay's only, and is
          // sent empty for Stripe, whose verification is a server-side
          // re-fetch.
          if (payment != null) ...{
            'paymentOrderId': payment.paymentOrderId,
            'paymentId': payment.paymentId,
            'paymentSignature': payment.signature,
          },
        },
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
      return OrderModel.fromJson(
        response.data!['order'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      // This is the refusal that can arrive with the money already taken —
      // the server refunds it and says so in `refunded`, which the shopper
      // needs told in the same breath as the reason.
      throw refusalFrom(e, items) ?? e;
    }
  }

  /// A refusal the server tagged with a `code`, re-written in the shopper's
  /// language; null for anything else, which falls through to the usual
  /// Dio → Failure mapping and surfaces the server's own `error` text.
  ///
  /// Exposed for tests: reaching it through [createOrder] would need a live
  /// HTTP call, and the translation is the part worth pinning.
  @visibleForTesting
  CheckoutRefusedException? refusalFrom(
    DioException e,
    List<CartItemEntity> items,
  ) {
    final body = e.response?.data;
    if (body is! Map) return null;
    final refunded = body['refunded'] == true;
    final code = (body['code'] as String?).toCheckoutRefusalCode();
    final reason = _reasonFor(code, body, items);
    if (reason == null && !refunded) return null;
    // Two sentences, joined: the reason, then the money. Concatenation
    // rather than one key per combination — both halves are whole sentences
    // in every locale, and the refund note is the same one whatever refused.
    final base = reason ?? ValueConst.checkoutFailedMessage;
    return CheckoutRefusedException(
      code,
      refunded ? '$base ${ValueConst.paymentRefundedNote}' : base,
    );
  }

  /// The localized half, or null for a code with no wording of its own —
  /// which still refuses when the money moved, on [ValueConst
  /// .checkoutFailedMessage] plus the refund note.
  String? _reasonFor(
    CheckoutRefusalCode code,
    Map<dynamic, dynamic> body,
    List<CartItemEntity> items,
  ) => switch (code) {
    CheckoutRefusalCode.insufficientStock => _stockReason(body, items),
    // The app pre-checks serviceability before it lets checkout start, so
    // reaching this means the store's areas changed under the shopper —
    // rare, and the same sentence the pre-check would have shown.
    CheckoutRefusalCode.unserviceableAddress =>
      ValueConst.deliveryUnavailableMessage,
    CheckoutRefusalCode.other => null,
  };

  /// The stock half: null unless the product is one this cart knows by name
  /// — a message about "a product" helps nobody, so an unresolvable id falls
  /// back to the generic wording rather than printing an id.
  String? _stockReason(Map<dynamic, dynamic> body, List<CartItemEntity> items) {
    final productId = body['productId'];
    final line = items
        .where((item) => item.product.id == productId)
        .firstOrNull;
    if (line == null) return ValueConst.cartUnavailableItemsMessage;
    final available = body['available'];
    return available is num && available <= 0
        ? ValueConst.productSoldOutMessage(line.product.name)
        : ValueConst.productStockReducedMessage(line.product.name);
  }

  @override
  Future<OrderModel> cancelOrder(String storeId, String orderId) async {
    // Cancel is only reachable while signed in; the server rejects a
    // missing/invalid token with 401, and a non-owner with 403 — both
    // surfaced as a Failure.
    final idToken = await FirebaseAuthService.instance.idToken();

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.orderCancelPath(storeId, orderId),
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
    return OrderModel.fromJson(response.data!['order'] as Map<String, dynamic>);
  }

  @override
  Future<OrderModel> rateOrder(
    String storeId,
    String orderId,
    int rating,
    String text,
  ) async {
    // Same signed-in-only path as cancel: 401 without a token, 404 for
    // someone else's order, 409 for one that hasn't been delivered.
    final idToken = await FirebaseAuthService.instance.idToken();

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.orderReviewPath(storeId, orderId),
      data: {'rating': rating, 'text': text},
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
    return OrderModel.fromJson(response.data!['order'] as Map<String, dynamic>);
  }

  List<Map<String, dynamic>> _itemsPayload(List<CartItemEntity> items) => items
      .map(
        (item) => {
          'productId': item.product.id,
          'quantity': item.quantity,
          // The server prices the line from this size's live variant — only
          // the size travels, never a client price. Omitted for a base-pack
          // line.
          if (item.variantId != null) 'variantId': item.variantId,
          if (item.sizeValue != null) 'sizeValue': item.sizeValue,
        },
      )
      .toList();
}
