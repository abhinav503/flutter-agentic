import 'package:gravia/enums/recent_search_type.dart';

import '../../domain/entities/recent_search_entity.dart';
import '../models/recent_search_model.dart';
import '../models/search_model.dart';
import '../models/search_results_model.dart';

abstract interface class SearchRemoteDataSource {
  Future<SearchModel> getSearch();
  Future<SearchResultsModel> searchCatalog(String query);

  /// Both mutations return the server's updated recents list so callers can
  /// sync state from the response instead of refetching the whole screen.
  Future<List<RecentSearchModel>> addRecentSearch(RecentSearchEntity item);
  Future<List<RecentSearchModel>> removeRecentSearch({
    required String id,
    required RecentSearchType type,
  });
}
