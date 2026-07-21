import '../../../home/data/models/product_model.dart';

abstract interface class FavouritesRemoteDataSource {
  Future<List<ProductModel>> getFavourites();
  Future<void> addFavourite(String productId);
  Future<void> removeFavourite(String productId);
}
