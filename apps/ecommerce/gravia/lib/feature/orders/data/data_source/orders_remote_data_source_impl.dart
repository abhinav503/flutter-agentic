import 'package:dio/dio.dart';

import 'package:core/core/network/http_service.dart';

import 'package:gravia/constants/api_constants.dart';
import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:gravia/services/firebase_auth_service.dart';

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
  Future<List<OrderModel>> getOrders() async {
    final idToken = await FirebaseAuthService.instance.idToken();
    if (idToken == null) return const [];

    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.ordersPath,
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
    final orders = response.data!['orders'] as List<dynamic>;
    return orders
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PaymentIntentModel> createPayment(
    List<CartItemEntity> items,
    String addressId,
  ) async {
    final idToken = await FirebaseAuthService.instance.idToken();

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.paymentsPath,
      data: {'addressId': addressId, 'items': _itemsPayload(items)},
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
    return PaymentIntentModel.fromJson(response.data!);
  }

  @override
  Future<OrderModel> createOrder(
    List<CartItemEntity> items,
    String addressId, {
    PaymentResultEntity? payment,
  }) async {
    // Checkout is only reachable while signed in; the server rejects a
    // missing/invalid token with 401, surfaced as a Failure.
    final idToken = await FirebaseAuthService.instance.idToken();

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.ordersPath,
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

  List<Map<String, dynamic>> _itemsPayload(List<CartItemEntity> items) => items
      .map((item) => {'productId': item.product.id, 'quantity': item.quantity})
      .toList();
}
