import 'package:core/core/network/http_service.dart';

import 'package:cordelia/constants/api_constants.dart';

import '../models/store_model.dart';
import 'stores_remote_data_source.dart';

class StoresRemoteDataSourceImpl implements StoresRemoteDataSource {
  const StoresRemoteDataSourceImpl();

  @override
  Future<List<StoreModel>> getStores({String? query}) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.storesPath,
      queryParameters: {if (query != null && query.isNotEmpty) 'q': query},
    );
    final stores = response.data!['stores'] as List;
    return stores
        .map((s) => StoreModel.fromJson(s as Map<String, dynamic>))
        .toList();
  }
}
