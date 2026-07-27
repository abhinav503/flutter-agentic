import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repository/cart_repository.dart';
import '../data_source/cart_remote_data_source.dart';

class CartRepositoryImpl with BaseRepository implements CartRepository {
  final CartRemoteDataSource _dataSource;

  const CartRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCart(String storeId) =>
      handleRequest(() async {
        final models = await _dataSource.getCart(storeId);
        return right(models.map((m) => m.toEntity()).toList());
      });

  @override
  Future<Either<Failure, List<CartItemEntity>>> saveCart(
    String storeId,
    List<CartItemEntity> items,
  ) => handleRequest(() async {
    final models = await _dataSource.saveCart(storeId, items);
    return right(models.map((m) => m.toEntity()).toList());
  });
}
