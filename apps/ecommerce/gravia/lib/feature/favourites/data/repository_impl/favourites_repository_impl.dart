import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/repository/favourites_repository.dart';
import '../data_source/favourites_remote_data_source.dart';

class FavouritesRepositoryImpl
    with BaseRepository
    implements FavouritesRepository {
  final FavouritesRemoteDataSource _dataSource;

  const FavouritesRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getFavourites() =>
      handleRequest(() async {
        final models = await _dataSource.getFavourites();
        return right(models.map((m) => m.toEntity()).toList());
      });

  @override
  Future<Either<Failure, void>> addFavourite(String productId) =>
      handleRequest(() async {
        await _dataSource.addFavourite(productId);
        return right(null);
      });

  @override
  Future<Either<Failure, void>> removeFavourite(String productId) =>
      handleRequest(() async {
        await _dataSource.removeFavourite(productId);
        return right(null);
      });
}
