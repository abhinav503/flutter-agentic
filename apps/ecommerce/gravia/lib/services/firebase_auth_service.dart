import 'package:firebase_auth/firebase_auth.dart';

/// Static singleton wrapping `FirebaseAuth.instance` — gravia's own
/// infrastructure, not `core` (Firebase is a per-app dependency, same
/// reasoning as `firebase_core` in `doc_scanner`; not every app needs auth).
/// Follows the same pattern as `HttpService`/`SharedPreferenceService`:
/// private constructor, `static final instance`, never registered in GetIt.
class FirebaseAuthService {
  FirebaseAuthService._();

  static final FirebaseAuthService instance = FirebaseAuthService._();

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
  Future<String?> idToken({bool forceRefresh = false}) =>
      currentUser?.getIdToken(forceRefresh) ?? Future.value(null);
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
    'too-many-requests' =>
      'Too many attempts. Please wait a moment and try again.',
    'network-request-failed' =>
      'Network error. Check your connection and try again.',
    _ => message ?? 'Something went wrong. Please try again.',
  };
}
