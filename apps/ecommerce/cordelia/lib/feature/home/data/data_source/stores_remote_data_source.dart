import '../models/store_model.dart';

abstract interface class StoresRemoteDataSource {
  Future<List<StoreModel>> getStores({String? query});

  Future<StoreModel> getStore({required String storeId});
}
