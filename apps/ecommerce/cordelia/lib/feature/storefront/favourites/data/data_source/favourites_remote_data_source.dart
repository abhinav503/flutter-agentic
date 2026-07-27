import '../../../home/data/models/product_model.dart';

abstract interface class FavouritesRemoteDataSource {
  Future<List<ProductModel>> getFavourites(String storeId);
  Future<void> addFavourite(String storeId, String productId);
  Future<void> removeFavourite(String storeId, String productId);
}
