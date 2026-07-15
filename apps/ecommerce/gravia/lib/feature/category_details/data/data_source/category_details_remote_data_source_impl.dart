import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/category_details_model.dart';
import 'category_details_remote_data_source.dart';

/// Backed by a bundled JSON asset keyed by category id — same pattern as
/// [ProductDetailsRemoteDataSourceImpl], with a `"default"` fallback entry
/// for ids the mock doesn't have a dedicated entry for.
class CategoryDetailsRemoteDataSourceImpl implements CategoryDetailsRemoteDataSource {
  const CategoryDetailsRemoteDataSourceImpl();

  @override
  Future<CategoryDetailsModel> getCategoryDetails(String categoryId) async {
    final raw = await rootBundle.loadString('assets/data/category_details.json');
    final byId = jsonDecode(raw) as Map<String, dynamic>;
    final json = (byId[categoryId] ?? byId['default']) as Map<String, dynamic>;
    return CategoryDetailsModel.fromJson(json);
  }
}
