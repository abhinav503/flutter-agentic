import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/cart_item_entity.dart';
import '../repository/cart_repository.dart';

class SaveCartUseCase
    extends UseCase<Either<Failure, List<CartItemEntity>>, List<CartItemEntity>> {
  final CartRepository _repository;

  const SaveCartUseCase(this._repository);

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(
    List<CartItemEntity> params,
  ) => _repository.saveCart(params);
}
