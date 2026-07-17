import 'package:core/core/network/http_service.dart';

import 'package:gravia/constants/api_constants.dart';

import '../models/search_model.dart';
import 'search_remote_data_source.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  const SearchRemoteDataSourceImpl();

  @override
  Future<SearchModel> getSearch() async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.searchPath,
    );
    return SearchModel.fromJson(response.data!);
  }
}
