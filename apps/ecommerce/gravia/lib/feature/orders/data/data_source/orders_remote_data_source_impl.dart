import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/order_model.dart';
import 'orders_remote_data_source.dart';

/// Backed by a bundled JSON asset — same pattern as the other mocked data
/// sources in this app.
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  const OrdersRemoteDataSourceImpl();

  @override
  Future<List<OrderModel>> getOrders() async {
    final raw = await rootBundle.loadString('assets/data/orders.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
