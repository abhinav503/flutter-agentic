import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/favourites_repository.dart';

class AddFavouriteParams {
  final String storeId;
  final String productId;

  const AddFavouriteParams({required this.storeId, required this.productId});
}

class AddFavouriteUseCase
    extends UseCase<Either<Failure, void>, AddFavouriteParams> {
  final FavouritesRepository _repository;

  const AddFavouriteUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(AddFavouriteParams params) =>
      _repository.addFavourite(params.storeId, params.productId);
}
