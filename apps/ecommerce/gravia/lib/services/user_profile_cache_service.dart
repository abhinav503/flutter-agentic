import 'dart:convert';

import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';

/// Static singleton wrapping `SharedPreferenceService` — same pattern as
/// `FirebaseAuthService`. Caches the signed-in user's profile locally so
/// `ProfileScreen` doesn't have to re-fetch (and show a loader) every time
/// the Profile tab is opened; `feature/auth`'s repository writes to it right
/// after signup/login/verification, `feature/profile`'s repository reads it
/// first before falling back to a real network fetch.
class UserProfileCacheService {
  UserProfileCacheService._();

  static final UserProfileCacheService instance = UserProfileCacheService._();

  static const _key = 'cached_user_profile';

  Future<void> save(Map<String, dynamic> json) =>
      SharedPreferenceService.instance.setString(_key, jsonEncode(json));

  Map<String, dynamic>? read() {
    final raw = SharedPreferenceService.instance.getString(_key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> clear() => SharedPreferenceService.instance.remove(_key);
}
