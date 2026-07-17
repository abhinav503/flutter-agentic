import 'package:core/core/network/http_service.dart';

import 'package:gravia/constants/api_constants.dart';

import '../models/categories_model.dart';
import 'categories_remote_data_source.dart';

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  const CategoriesRemoteDataSourceImpl();

  @override
  Future<CategoriesModel> getCategories() async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.categoriesPath,
    );
    return CategoriesModel.fromJson(response.data!);
  }
}
