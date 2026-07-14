import '../models/search_model.dart';

abstract interface class SearchRemoteDataSource {
  Future<SearchModel> getSearch();
}
