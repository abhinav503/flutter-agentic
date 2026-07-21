import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../repository/favourites_repository.dart';

class GetFavouritesUseCase
    extends UseCase<Either<Failure, List<ProductEntity>>, NoParams> {
  final FavouritesRepository _repository;

  const GetFavouritesUseCase(this._repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) =>
      _repository.getFavourites();
}
