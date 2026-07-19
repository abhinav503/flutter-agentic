import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/cart_item_entity.dart';

abstract interface class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCart();
  Future<Either<Failure, List<CartItemEntity>>> saveCart(
    List<CartItemEntity> items,
  );
}
