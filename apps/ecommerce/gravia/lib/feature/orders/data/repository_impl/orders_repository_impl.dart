import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/entities/payment_intent_entity.dart';
import '../../domain/entities/payment_result_entity.dart';
import '../../domain/repository/orders_repository.dart';
import '../data_source/orders_remote_data_source.dart';

class OrdersRepositoryImpl with BaseRepository implements OrdersRepository {
  final OrdersRemoteDataSource _dataSource;

  const OrdersRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() =>
      handleRequest(() async {
        final models = await _dataSource.getOrders();
        return right(models.map((m) => m.toEntity()).toList());
      });

  @override
  Future<Either<Failure, PaymentIntentEntity>> createPayment(
    List<CartItemEntity> items,
    String addressId,
  ) => handleRequest(() async {
    final model = await _dataSource.createPayment(items, addressId);
    return right(model.toEntity());
  });

  @override
  Future<Either<Failure, OrderEntity>> createOrder(
    List<CartItemEntity> items,
    String addressId, {
    PaymentResultEntity? payment,
  }) => handleRequest(() async {
    final model = await _dataSource.createOrder(
      items,
      addressId,
      payment: payment,
    );
    return right(model.toEntity());
  });
}
