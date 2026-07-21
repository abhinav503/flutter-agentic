import 'package:core/core/network/http_service.dart';

import 'package:gravia/constants/api_constants.dart';
import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:gravia/services/firebase_auth_service.dart';

import '../models/order_model.dart';
import 'orders_remote_data_source.dart';

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  const OrdersRemoteDataSourceImpl();

  @override
  Future<List<OrderModel>> getOrders() async {
    final uid = FirebaseAuthService.instance.currentUser?.uid;
    if (uid == null) return const [];

    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.ordersPath,
      queryParameters: {'userId': uid},
    );
    final orders = response.data!['orders'] as List<dynamic>;
    return orders
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OrderModel> createOrder(
    List<CartItemEntity> items,
    String addressId,
  ) async {
    final uid = FirebaseAuthService.instance.currentUser!.uid;

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.ordersPath,
      data: {
        'userId': uid,
        'addressId': addressId,
        'items': items
            .map(
              (item) => {
                'productId': item.product.id,
                'quantity': item.quantity,
              },
            )
            .toList(),
      },
    );
    return OrderModel.fromJson(response.data!['order'] as Map<String, dynamic>);
  }
}
