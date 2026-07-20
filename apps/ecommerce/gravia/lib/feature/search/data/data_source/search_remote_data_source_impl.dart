import 'package:core/core/network/http_service.dart';

import 'package:gravia/constants/api_constants.dart';
import 'package:gravia/enums/recent_search_type.dart';
import 'package:gravia/services/firebase_auth_service.dart';

import '../../domain/entities/recent_search_entity.dart';
import '../models/recent_search_model.dart';
import '../models/search_model.dart';
import '../models/search_results_model.dart';
import 'search_remote_data_source.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  const SearchRemoteDataSourceImpl();

  // Same signed-out degrade as the cart data source: recents are per-user,
  // so without a uid the server has nothing to look up and the mutation
  // calls no-op with an empty list instead of failing the screen.
  String? get _uid => FirebaseAuthService.instance.currentUser?.uid;

  @override
  Future<SearchModel> getSearch() async {
    final uid = _uid;
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.searchPath,
      queryParameters: {'userId': ?uid},
    );
    return SearchModel.fromJson(response.data!);
  }

  @override
  Future<SearchResultsModel> searchCatalog(String query) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.searchPath,
      queryParameters: {'q': query},
    );
    return SearchResultsModel.fromJson(response.data!);
  }

  @override
  Future<List<RecentSearchModel>> addRecentSearch(
    RecentSearchEntity item,
  ) async {
    final uid = _uid;
    if (uid == null) return const [];

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.recentSearchesPath,
      data: {
        'userId': uid,
        'item': RecentSearchModel.fromEntity(item).toJson(),
      },
    );
    return _parseRecents(response.data!);
  }

  @override
  Future<List<RecentSearchModel>> removeRecentSearch({
    required String id,
    required RecentSearchType type,
  }) async {
    final uid = _uid;
    if (uid == null) return const [];

    final response = await HttpService.instance.delete<Map<String, dynamic>>(
      ApiConstants.recentSearchesPath,
      queryParameters: {'userId': uid, 'id': id, 'type': type.wireValue},
    );
    return _parseRecents(response.data!);
  }

  List<RecentSearchModel> _parseRecents(Map<String, dynamic> json) {
    final items = json['recent_searches'] as List<dynamic>;
    return items
        .map((item) => RecentSearchModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
