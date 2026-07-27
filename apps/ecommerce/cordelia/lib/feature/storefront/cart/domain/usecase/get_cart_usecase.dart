import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/cart_item_entity.dart';
import '../repository/cart_repository.dart';

class GetCartParams {
  final String storeId;

  const GetCartParams({required this.storeId});
}

class GetCartUseCase
    extends UseCase<Either<Failure, List<CartItemEntity>>, GetCartParams> {
  final CartRepository _repository;

  const GetCartUseCase(this._repository);

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(GetCartParams params) =>
      _repository.getCart(params.storeId);
}
