import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'notification/firebase_messaging_service.dart';

/// Static singleton wrapping `FirebaseAuth.instance` — this app's own
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

  /// Stands in for [currentUser] when there is no Firebase app to ask —
  /// which, per [currentUser]'s own note, is every widget test. Without it a
  /// test can only ever exercise the signed-out half of a screen, because
  /// "no initialized Firebase app" and "nobody is signed in" are the same
  /// answer.
  @visibleForTesting
  static bool? debugSignedIn;

  /// The single answer to "is anyone signed in" — `SignInGateX.isSignedIn`
  /// and the notification router both read it, so the question can't be
  /// asked two slightly different ways.
  bool get isSignedIn => debugSignedIn ?? currentUser != null;

  /// Emits whenever *who* is signed in changes — a sign-in, a sign-out, or a
  /// session ending. What anything derived from the account (the profile)
  /// should rebuild from, instead of every screen that can reach a Login
  /// remembering to tell it.
  ///
  /// Distinct from [sessionExpired], which is a one-shot *navigation* signal
  /// and deliberately ignores a manual logout. This is the data signal, and
  /// wants every change.
  ///
  /// Empty when there is no Firebase app — web and widget tests — for the
  /// same reason [currentUser] answers null there.
  Stream<User?> get authStateChanges {
    try {
      return FirebaseAuth.instance.authStateChanges();
    } on FirebaseException {
      return const Stream<User?>.empty();
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

  /// Releases this device's push registration first: the endpoint that does
  /// it authenticates with an ID token, and one frame later there won't be
  /// one. Never throws (it swallows its own failures), so a sign-out can't be
  /// blocked by it.
  Future<void> signOut() async {
    await FirebaseMessagingService.instance.releaseDevice();
    await FirebaseAuth.instance.signOut();
  }

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
      if (_deadSessionCodes.contains(e.code)) await endSession();
      rethrow;
    }
  }

  /// Ends a session that cannot recover: signs out locally, then fires
  /// [sessionExpired] once.
  ///
  /// Two callers, and the second is why this is public. [idToken] handles what
  /// Firebase can see for itself; `SessionExpiryInterceptor` handles what only
  /// the server can — a 401 against a token Firebase is still happily handing
  /// back from its cache, which it will keep doing for up to an hour after the
  /// token stops being accepted.
  ///
  /// A no-op when nobody is signed in: anonymous browsing hits authenticated
  /// endpoints too, and a 401 there is not an expired session.
  ///
  /// Re-entrancy is the whole reason this is a method rather than two lines at
  /// each call site. A screen usually fires several requests at once, so a
  /// dead token produces a burst of 401s within a frame or two; without the
  /// guard each one bumps the notifier and the shopper gets three snackbars
  /// and three redirects for one expiry.
  Future<void> endSession() async {
    if (_endingSession || currentUser == null) return;
    _endingSession = true;
    try {
      await FirebaseAuth.instance.signOut();
      sessionExpired.value++;
    } finally {
      _endingSession = false;
    }
  }

  bool _endingSession = false;

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
