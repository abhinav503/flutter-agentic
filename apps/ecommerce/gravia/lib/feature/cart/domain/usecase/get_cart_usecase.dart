import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/cart_item_entity.dart';
import '../repository/cart_repository.dart';

class GetCartUseCase
    extends UseCase<Either<Failure, List<CartItemEntity>>, NoParams> {
  final CartRepository _repository;

  const GetCartUseCase(this._repository);

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(NoParams params) =>
      _repository.getCart();
}
