import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/order_entity.dart';

abstract interface class OrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders();
}
