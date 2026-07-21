import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/feature/favourites/domain/repository/favourites_repository.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';

class FakeFavouritesRepository implements FavouritesRepository {
  /// Set per test to control what [getFavourites] resolves to.
  Either<Failure, List<ProductEntity>> result = right(const []);

  /// Set per test to control what [addFavourite]/[removeFavourite] resolve
  /// to — defaults to success since these are fire-and-forget from
  /// [FavouritesCubit]'s perspective.
  Either<Failure, void> mutationResult = right(null);

  String? lastAddedId;
  String? lastRemovedId;

  @override
  Future<Either<Failure, List<ProductEntity>>> getFavourites() async =>
      result;

  @override
  Future<Either<Failure, void>> addFavourite(String productId) async {
    lastAddedId = productId;
    return mutationResult;
  }

  @override
  Future<Either<Failure, void>> removeFavourite(String productId) async {
    lastRemovedId = productId;
    return mutationResult;
  }
}
