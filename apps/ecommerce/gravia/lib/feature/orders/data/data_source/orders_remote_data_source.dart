import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';

import '../models/order_model.dart';

abstract interface class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders();

  /// Server recomputes price/stock from the live catalog — only
  /// `productId`+`quantity` are sent, read off each [CartItemEntity]. The
  /// server reads the address doc for [addressId] and snapshots it onto the
  /// order.
  Future<OrderModel> createOrder(List<CartItemEntity> items, String addressId);
}
