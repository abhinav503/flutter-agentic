import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/cart_item_entity.dart';
import '../repository/cart_repository.dart';

class SaveCartParams {
  final String storeId;
  final List<CartItemEntity> items;

  const SaveCartParams({required this.storeId, required this.items});
}

class SaveCartUseCase
    extends UseCase<Either<Failure, List<CartItemEntity>>, SaveCartParams> {
  final CartRepository _repository;

  const SaveCartUseCase(this._repository);

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(SaveCartParams params) =>
      _repository.saveCart(params.storeId, params.items);
}
