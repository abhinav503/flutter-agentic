import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Static singleton wrapping `FirebaseAuth.instance` — gravia's own
/// infrastructure, not `core` (Firebase is a per-app dependency, same
/// reasoning as `firebase_core` in `doc_scanner`; not every app needs auth).
/// Follows the same pattern as `HttpService`/`SharedPreferenceService`:
/// private constructor, `static final instance`, never registered in GetIt.
class FirebaseAuthService {
  FirebaseAuthService._();

  static final FirebaseAuthService instance = FirebaseAuthService._();

  /// Codes that mean this device's local session can never recover on its
  /// own — most commonly the refresh token getting revoked by a password
  /// change/reset made *elsewhere* (another device, the emailed reset
  /// link). Deliberately narrow: things like `network-request-failed` are
  /// transient and must NOT sign the user out.
  static const _deadSessionCodes = {
    'user-token-expired',
    'invalid-user-token',
    'user-disabled',
    'user-not-found',
  };

  /// Fires exactly once whenever [idToken] discovers a dead session (see
  /// [_deadSessionCodes]) — the single signal every authenticated call in
  /// the app funnels through, so no individual feature has to special-case
  /// this. `app.dart`'s `_SessionExpiredGuard` listens here and redirects to
  /// Login; kept separate from `authStateChanges()` so a manual "Logout"
  /// tap (which already navigates itself) never double-fires it.
  final ValueNotifier<int> sessionExpired = ValueNotifier<int>(0);

  /// `AuthBloc.started()` reads this unconditionally on every screen that
  /// resumes a session (Splash, ShellPage, Login, Signup) — including on
  /// web, where `Firebase.initializeApp()` is never called (main.dart's
  /// `kIsWeb` guard), and in widget tests that mount those screens without
  /// setting up a Firebase test app. Neither should throw: no initialized
  /// Firebase app honestly means no signed-in user, not a crash.
  User? get currentUser {
    try {
      return FirebaseAuth.instance.currentUser;
    } on FirebaseException {
      return null;
    }
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) => FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) => FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  Future<void> signOut() => FirebaseAuth.instance.signOut();

  Future<void> sendEmailVerification() async {
    await currentUser?.sendEmailVerification();
  }

  Future<void> updateDisplayName(String displayName) async {
    await currentUser?.updateDisplayName(displayName);
  }

  /// Reloads the current user off Firebase and returns the fresh
  /// `emailVerified` flag — `false` (never throws) when there's no signed-in
  /// user, so a caller can poll this unconditionally.
  Future<bool> reloadAndCheckVerified() async {
    final user = currentUser;
    if (user == null) return false;
    await user.reload();
    return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  }

  /// `forceRefresh: true` mints a fresh token carrying the current
  /// `email_verified` claim — needed right after verification, since a
  /// previously-issued token is stale until refreshed.
  ///
  /// On a dead-session code (see [_deadSessionCodes]), signs out locally
  /// and fires [sessionExpired] before rethrowing — every authenticated
  /// data source call passes through here, so this is the one place that
  /// needs to know, not each of them individually.
  Future<String?> idToken({bool forceRefresh = false}) async {
    final user = currentUser;
    if (user == null) return null;
    try {
      return await user.getIdToken(forceRefresh);
    } on FirebaseAuthException catch (e) {
      if (_deadSessionCodes.contains(e.code)) {
        await FirebaseAuth.instance.signOut();
        sessionExpired.value++;
      }
      rethrow;
    }
  }

  /// Re-proves the current password before a sensitive change —
  /// `updatePassword` throws `requires-recent-login` on a session that
  /// isn't fresh, so this always runs first. Throws `FirebaseAuthException`
  /// (`wrong-password`/`invalid-credential`) if `currentPassword` is wrong,
  /// which also doubles as the "confirm your password" check.
  Future<void> reauthenticate({required String currentPassword}) async {
    final user = currentUser;
    if (user == null || user.email == null) return;
    await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      ),
    );
  }

  Future<void> updatePassword(String newPassword) async {
    await currentUser?.updatePassword(newPassword);
  }

  /// Firebase emails the reset link itself — there's no in-app step after
  /// this call succeeds beyond telling the user to check their inbox.
  Future<void> sendPasswordResetEmail(String email) =>
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

/// Maps `FirebaseAuthException` codes to human-readable messages —
/// `e.message` alone is often terse/technical (e.g. "The email address is
/// badly formatted."), and some codes have none at all.
extension FirebaseAuthExceptionX on FirebaseAuthException {
  String get readableMessage => switch (code) {
    'email-already-in-use' =>
      'An account already exists with this email address.',
    'weak-password' => 'Password must be at least 6 characters.',
    'invalid-email' => 'Enter a valid email address.',
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' => 'Incorrect email or password.',
    'requires-recent-login' =>
      'For your security, please log in again before retrying.',
    'too-many-requests' =>
      'Too many attempts. Please wait a moment and try again.',
    'network-request-failed' =>
      'Network error. Check your connection and try again.',
    _ => message ?? 'Something went wrong. Please try again.',
  };
}
