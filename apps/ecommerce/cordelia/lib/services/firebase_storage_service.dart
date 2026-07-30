import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Static singleton wrapping `FirebaseStorage.instance` — this app's own
/// infrastructure, not `core` (Firebase is a per-app dependency, same
/// reasoning as [FirebaseAuthService]). Follows the same pattern as
/// `HttpService`/`SharedPreferenceService`: private constructor,
/// `static final instance`, never registered in GetIt.
///
/// Only the shopper's own avatar lives here. Everything else in the bucket
/// (a store's catalog, banner and logo artwork) is written by the admin
/// dashboard, never by this app — see `storage.rules`, which gates
/// `users/{uid}/**` to that uid and the store prefixes to their owner.
class FirebaseStorageService {
  FirebaseStorageService._();

  static final FirebaseStorageService instance = FirebaseStorageService._();

  /// One fixed object per user rather than a timestamped name, so a shopper
  /// replacing their photo overwrites the old one instead of leaking an
  /// orphan on every save.
  static String _avatarPath(String uid) => 'users/$uid/avatar.jpg';

  /// Uploads [bytes] as the shopper's avatar and returns its download URL —
  /// the value that goes to the admin API as `avatar_url`.
  ///
  /// The overwrite means the URL's path is stable, but the download token
  /// changes per upload, so callers must persist the returned URL rather
  /// than deriving one from the uid.
  Future<String> uploadAvatar({
    required String uid,
    required Uint8List bytes,
  }) async {
    final ref = FirebaseStorage.instance.ref(_avatarPath(uid));
    // Without an explicit contentType the object lands as
    // application/octet-stream and browsers download it instead of
    // rendering it — image_picker hands over raw bytes, not a typed file.
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }
}
