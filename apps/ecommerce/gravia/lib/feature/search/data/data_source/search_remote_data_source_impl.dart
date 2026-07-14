import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/search_model.dart';
import 'search_remote_data_source.dart';

/// Backed by a bundled JSON asset today, shaped exactly like the real search
/// API response this stands in for — same pattern as HomeRemoteDataSourceImpl.
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  const SearchRemoteDataSourceImpl();

  @override
  Future<SearchModel> getSearch() async {
    final raw = await rootBundle.loadString('assets/data/search_page.json');
    return SearchModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
