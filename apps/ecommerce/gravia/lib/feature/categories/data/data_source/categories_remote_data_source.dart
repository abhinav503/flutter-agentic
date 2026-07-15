import '../models/categories_model.dart';

abstract interface class CategoriesRemoteDataSource {
  Future<CategoriesModel> getCategories();
}
