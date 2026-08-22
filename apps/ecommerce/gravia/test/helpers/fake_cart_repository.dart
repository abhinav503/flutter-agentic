import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:gravia/feature/cart/domain/repository/cart_repository.dart';

/// An empty bag that saves whatever it is handed — enough for any screen
/// that only needs `CartCubit` to hydrate without reaching the network.
class FakeCartRepository implements CartRepository {
  Either<Failure, List<CartItemEntity>> result = right(const []);

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCart() async => result;

  @override
  Future<Either<Failure, List<CartItemEntity>>> saveCart(
    List<CartItemEntity> items,
  ) async => right(items);
}
