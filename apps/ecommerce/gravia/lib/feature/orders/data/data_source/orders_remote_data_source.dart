import '../models/order_model.dart';

abstract interface class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders();
}
