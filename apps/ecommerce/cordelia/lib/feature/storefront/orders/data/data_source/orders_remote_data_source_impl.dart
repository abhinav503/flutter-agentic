import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:dio/dio.dart';

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
    String addressId,
  ) async {
    final idToken = await FirebaseAuthService.instance.idToken();

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.paymentsPath(storeId),
      data: {'addressId': addressId, 'items': _itemsPayload(items)},
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
    return PaymentIntentModel.fromJson(response.data!);
  }

  @override
  Future<OrderModel> createOrder(
    String storeId,
    List<CartItemEntity> items,
    String addressId, {
    PaymentResultEntity? payment,
  }) async {
    // Checkout is only reachable while signed in; the server rejects a
    // missing/invalid token with 401, surfaced as a Failure.
    final idToken = await FirebaseAuthService.instance.idToken();

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.ordersPath(storeId),
      data: {
        'addressId': addressId,
        'items': _itemsPayload(items),
        // Present only on mobile; the server verifies the signature before
        // placing the order. Omitted on web (test-mode payment-less path).
        if (payment != null) ...{
          'razorpayOrderId': payment.razorpayOrderId,
          'razorpayPaymentId': payment.razorpayPaymentId,
          'razorpaySignature': payment.razorpaySignature,
        },
      },
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
    return OrderModel.fromJson(response.data!['order'] as Map<String, dynamic>);
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

  List<Map<String, dynamic>> _itemsPayload(List<CartItemEntity> items) => items
      .map((item) => {'productId': item.product.id, 'quantity': item.quantity})
      .toList();
}
