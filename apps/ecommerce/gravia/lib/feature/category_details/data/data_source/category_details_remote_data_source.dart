import '../models/category_details_model.dart';

abstract interface class CategoryDetailsRemoteDataSource {
  Future<CategoryDetailsModel> getCategoryDetails(String categoryId);
}
