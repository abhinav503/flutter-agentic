import '../models/user_model.dart';

/// Owns every remote auth operation — both the Firebase Auth SDK calls
/// (sign up/in/out, verification) and the admin API profile persistence
/// that follows each one. Kept behind this one interface (not called
/// directly from the repository) so the auth provider/backend can change
/// without touching `AuthRepositoryImpl`, which only ever calls a data
/// source method and converts the result — same shape as every other
/// repository in this app.
abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String mobile,
    required String password,
  });

  Future<UserModel> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> resendVerificationEmail();

  /// Reloads the Firebase user; if now verified, re-syncs the profile
  /// (`emailVerified` flips server-side) and returns it. Returns `null`
  /// while still unverified — the caller polls this on a timer.
  Future<UserModel?> checkEmailVerified();

  /// Updates both the Firebase Auth user's display name and the Firestore
  /// profile doc (name + mobile) — email is untouched here; changing it
  /// needs Firebase's own re-verification flow, out of scope for this call.
  Future<UserModel> updateProfile({
    required String name,
    required String mobile,
  });

  /// Re-authenticates with [currentPassword], then sets [newPassword] on
  /// the Firebase Auth user. No profile-doc write — password isn't part of
  /// the synced profile.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> sendPasswordResetEmail({required String email});
}
