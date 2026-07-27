import 'package:cordelia/constants/api_constants.dart';
import 'package:core/core/network/http_service.dart';
import '../models/categories_model.dart';
import 'categories_remote_data_source.dart';

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  const CategoriesRemoteDataSourceImpl();

  @override
  Future<CategoriesModel> getCategories(String storeId) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.categoriesPath(storeId),
    );
    return CategoriesModel.fromJson(response.data!);
  }
}
