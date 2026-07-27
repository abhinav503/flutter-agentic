import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../repository/favourites_repository.dart';

class GetFavouritesParams {
  final String storeId;

  const GetFavouritesParams({required this.storeId});
}

class GetFavouritesUseCase
    extends UseCase<Either<Failure, List<ProductEntity>>, GetFavouritesParams> {
  final FavouritesRepository _repository;

  const GetFavouritesUseCase(this._repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetFavouritesParams params,
  ) => _repository.getFavourites(params.storeId);
}
