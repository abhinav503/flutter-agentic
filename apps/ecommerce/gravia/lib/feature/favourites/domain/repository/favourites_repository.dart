import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../../home/domain/entities/product_entity.dart';

abstract interface class FavouritesRepository {
  Future<Either<Failure, List<ProductEntity>>> getFavourites();
  Future<Either<Failure, void>> addFavourite(String productId);
  Future<Either<Failure, void>> removeFavourite(String productId);
}
