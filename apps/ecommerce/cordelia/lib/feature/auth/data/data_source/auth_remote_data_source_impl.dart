import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:core/core/network/http_service.dart';

import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:cordelia/services/firebase_storage_service.dart';

import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl();

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    await FirebaseAuthService.instance.signUp(email: email, password: password);
    await FirebaseAuthService.instance.sendEmailVerification();
    final idToken = await FirebaseAuthService.instance.idToken();
    return _saveUserProfile(idToken: idToken!, name: name, mobile: mobile);
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    await FirebaseAuthService.instance.signIn(email: email, password: password);
    final idToken = await FirebaseAuthService.instance.idToken();
    // No name/mobile — self-heals a missing profile doc and re-syncs
    // emailVerified without overwriting the existing name/mobile.
    return _saveUserProfile(idToken: idToken!);
  }

  @override
  Future<void> signOut() => FirebaseAuthService.instance.signOut();

  @override
  Future<void> deleteAccount() async {
    final idToken = await FirebaseAuthService.instance.idToken();

    await HttpService.instance.delete<Map<String, dynamic>>(
      ApiConstants.usersPath,
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
  }

  @override
  Future<void> resendVerificationEmail() =>
      FirebaseAuthService.instance.sendEmailVerification();

  @override
  Future<UserModel?> checkEmailVerified() async {
    final verified = await FirebaseAuthService.instance
        .reloadAndCheckVerified();
    if (!verified) return null;

    final idToken = await FirebaseAuthService.instance.idToken(
      forceRefresh: true,
    );
    if (idToken == null) return null;

    return _saveUserProfile(idToken: idToken);
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    required String mobile,
    Uint8List? avatarBytes,
  }) async {
    await FirebaseAuthService.instance.updateDisplayName(name);

    // Upload before the profile write, not after: the API stores the URL,
    // so a failed upload must abort the whole save rather than leave the
    // doc pointing at an object that was never written.
    String? avatarUrl;
    if (avatarBytes != null) {
      final uid = FirebaseAuthService.instance.currentUser!.uid;
      avatarUrl = await FirebaseStorageService.instance.uploadAvatar(
        uid: uid,
        bytes: avatarBytes,
      );
    }

    final idToken = await FirebaseAuthService.instance.idToken();
    return _saveUserProfile(
      idToken: idToken!,
      name: name,
      mobile: mobile,
      avatarUrl: avatarUrl,
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await FirebaseAuthService.instance.reauthenticate(
      currentPassword: currentPassword,
    );
    await FirebaseAuthService.instance.updatePassword(newPassword);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      FirebaseAuthService.instance.sendPasswordResetEmail(email);

  /// Upserts the caller's `users/{uid}` profile on the admin API. Every
  /// field is optional — omit them all to just re-sync `emailVerified` off a
  /// freshly-refreshed token without touching the rest of the profile, and
  /// omit [avatarUrl] alone to keep the existing photo.
  Future<UserModel> _saveUserProfile({
    required String idToken,
    String? name,
    String? mobile,
    String? avatarUrl,
  }) async {
    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.usersPath,
      data: {'name': ?name, 'mobile': ?mobile, 'avatar_url': ?avatarUrl},
      headers: {'Authorization': 'Bearer $idToken'},
    );
    return UserModel.fromJson(response.data!);
  }
}
