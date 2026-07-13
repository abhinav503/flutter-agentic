import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/home_model.dart';
import 'home_remote_data_source.dart';

/// Backed by a bundled JSON asset today, shaped exactly like the real
/// storefront API response this stands in for — swapping in an HTTP-backed
/// impl later needs no change to the interface, domain, or presentation
/// layers.
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl();

  @override
  Future<HomeModel> getHome() async {
    final raw = await rootBundle.loadString('assets/data/home_page.json');
    return HomeModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
