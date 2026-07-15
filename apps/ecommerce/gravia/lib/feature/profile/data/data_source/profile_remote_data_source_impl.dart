import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/profile_model.dart';
import 'profile_remote_data_source.dart';

/// Backed by a bundled JSON asset — same pattern as the other mocked
/// data sources in this app (a single object, no id keying needed since
/// there's only ever one signed-in profile).
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl();

  @override
  Future<ProfileModel> getProfile() async {
    final raw = await rootBundle.loadString('assets/data/profile_page.json');
    return ProfileModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
