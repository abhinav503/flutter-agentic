import 'package:cordelia/constants/api_constants.dart';
import 'package:core/core/network/http_service.dart';

import '../models/category_details_model.dart';
import 'category_details_remote_data_source.dart';

class CategoryDetailsRemoteDataSourceImpl
    implements CategoryDetailsRemoteDataSource {
  const CategoryDetailsRemoteDataSourceImpl();

  @override
  Future<CategoryDetailsModel> getCategoryDetails(
    String storeId,
    String categoryId,
  ) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.categoryProductsPath(storeId, categoryId),
    );
    return CategoryDetailsModel.fromJson(response.data!);
  }
}
