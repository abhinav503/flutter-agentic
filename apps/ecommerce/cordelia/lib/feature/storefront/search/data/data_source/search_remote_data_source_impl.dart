import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/enums/recent_search_type.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:dio/dio.dart';

import 'package:core/core/network/http_service.dart';

import '../../domain/entities/recent_search_entity.dart';
import '../models/recent_search_model.dart';
import '../models/search_model.dart';
import '../models/search_results_model.dart';
import 'search_remote_data_source.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  const SearchRemoteDataSourceImpl();

  // Recents are per-user, keyed on the verified token's uid. The token is
  // optional for the initial screen fetch (a signed-out shopper still sees
  // popular products, just no recents) but required to record/remove one,
  // where a missing token no-ops with an empty list instead of failing.
  Future<String?> get _idToken => FirebaseAuthService.instance.idToken();

  Options? _authOptions(String? idToken) => idToken == null
      ? null
      : Options(headers: {'Authorization': 'Bearer $idToken'});

  @override
  Future<SearchModel> getSearch(String storeId) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.searchPath(storeId),
      options: _authOptions(await _idToken),
    );
    return SearchModel.fromJson(response.data!);
  }

  @override
  Future<SearchResultsModel> searchCatalog(String storeId, String query) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.searchPath(storeId),
      queryParameters: {'q': query},
    );
    return SearchResultsModel.fromJson(response.data!);
  }

  @override
  Future<List<RecentSearchModel>> addRecentSearch(
    String storeId,
    RecentSearchEntity item,
  ) async {
    final idToken = await _idToken;
    if (idToken == null) return const [];

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.recentSearchesPath(storeId),
      data: {'item': RecentSearchModel.fromEntity(item).toJson()},
      options: _authOptions(idToken),
    );
    return _parseRecents(response.data!);
  }

  @override
  Future<List<RecentSearchModel>> removeRecentSearch({
    required String storeId,
    required String id,
    required RecentSearchType type,
  }) async {
    final idToken = await _idToken;
    if (idToken == null) return const [];

    final response = await HttpService.instance.delete<Map<String, dynamic>>(
      ApiConstants.recentSearchesPath(storeId),
      queryParameters: {'id': id, 'type': type.wireValue},
      options: _authOptions(idToken),
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
