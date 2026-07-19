import 'package:dio/dio.dart';

import 'package:core/core/network/http_service.dart';

import 'package:gravia/constants/api_constants.dart';
import 'package:gravia/services/firebase_auth_service.dart';

import '../models/profile_model.dart';
import 'profile_remote_data_source.dart';

/// Reads the signed-in shopper's profile off the admin API's `/api/users`
/// (the same endpoint `feature/auth` writes to on signup/verification) —
/// replaces the earlier bundled-mock-JSON version now that real signed-up
/// users exist.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl();

  @override
  Future<ProfileModel> getProfile() async {
    final idToken = await FirebaseAuthService.instance.idToken();
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.usersPath,
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
    return ProfileModel.fromJson(response.data!);
  }
}
