import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/categories_model.dart';
import 'categories_remote_data_source.dart';

/// Backed by a bundled JSON asset today, shaped exactly like the real
/// categories API response this stands in for — same pattern as
/// SearchRemoteDataSourceImpl.
class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  const CategoriesRemoteDataSourceImpl();

  @override
  Future<CategoriesModel> getCategories() async {
    final raw = await rootBundle.loadString('assets/data/categories_page.json');
    return CategoriesModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
