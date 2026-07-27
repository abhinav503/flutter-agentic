import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/favourites_repository.dart';

class RemoveFavouriteParams {
  final String storeId;
  final String productId;

  const RemoveFavouriteParams({
    required this.storeId,
    required this.productId,
  });
}

class RemoveFavouriteUseCase
    extends UseCase<Either<Failure, void>, RemoveFavouriteParams> {
  final FavouritesRepository _repository;

  const RemoveFavouriteUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(RemoveFavouriteParams params) =>
      _repository.removeFavourite(params.storeId, params.productId);
}
