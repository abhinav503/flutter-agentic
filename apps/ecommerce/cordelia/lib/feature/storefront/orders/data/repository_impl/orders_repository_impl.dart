import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/entities/payment_intent_entity.dart';
import '../../domain/entities/payment_result_entity.dart';
import '../../domain/repository/orders_repository.dart';
import '../data_source/orders_remote_data_source.dart';

class OrdersRepositoryImpl with BaseRepository implements OrdersRepository {
  final OrdersRemoteDataSource _dataSource;

  const OrdersRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders(String storeId) =>
      handleRequest(() async {
        final models = await _dataSource.getOrders(storeId);
        return right(models.map((m) => m.toEntity()).toList());
      });

  @override
  Future<Either<Failure, PaymentIntentEntity>> createPayment(
    String storeId,
    List<CartItemEntity> items,
    String addressId, {
    String couponCode = '',
  }) => handleRequest(() async {
    final model = await _dataSource.createPayment(
      storeId,
      items,
      addressId,
      couponCode: couponCode,
    );
    return right(model.toEntity());
  });

  @override
  Future<Either<Failure, OrderEntity>> createOrder(
    String storeId,
    List<CartItemEntity> items,
    String addressId, {
    PaymentResultEntity? payment,
    String couponCode = '',
  }) => handleRequest(() async {
    final model = await _dataSource.createOrder(
      storeId,
      items,
      addressId,
      payment: payment,
      couponCode: couponCode,
    );
    return right(model.toEntity());
  });

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(
    String storeId,
    String orderId,
  ) => handleRequest(() async {
    final model = await _dataSource.cancelOrder(storeId, orderId);
    return right(model.toEntity());
  });
}
