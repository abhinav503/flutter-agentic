/// Who is signed in, as the rest of the app needs to know it.
///
/// The **reads** an app makes about the current session, plus the signal
/// that one has died — deliberately not a general auth façade. Signing up,
/// signing in, resetting a password and signing out are operations, and
/// they belong behind a repository and use cases like any other write.
///
/// This exists because those reads are the part that leaks. A screen asking
/// "is anyone signed in?" has no business naming a provider, but with
/// nowhere to ask, every gate and BLoC ends up importing the SDK wrapper
/// directly — and then swapping the provider is a change across the
/// presentation layer instead of one registration.
///
/// The five members are the ones every provider models the same way, which
/// is what makes the interface likely to survive a second implementation.
/// Anything provider-shaped (a `User` object, a token, email-verification
/// state) is deliberately absent: it would put the SDK back in the callers.
///
/// Register one implementation for the app and resolve it like any other
/// dependency:
/// ```dart
/// sl.registerLazySingleton<AuthSession>(() => FirebaseAuthSession());
/// ```
abstract interface class AuthSession {
  bool get isSignedIn;

  /// Null when signed out. The stable id for "this shopper" — what tells
  /// their own review, order or cart apart from anyone else's.
  String? get currentUid;

  String? get currentEmail;

  /// The signed-in uid, or null, emitted whenever *who* is signed in
  /// changes. Anything derived from the account (a profile, a personalised
  /// header) should follow this rather than wait to be told by whichever
  /// screen happened to run the sign-in.
  ///
  /// Implementations replay the current value on listen, so a subscriber
  /// starts in sync. Consumers that already know the current uid should
  /// compare before reacting, or they will do their first load twice.
  Stream<String?> get uidChanges;

  /// Emits once each time a session dies in a way it cannot recover from —
  /// a revoked refresh token, a 401 from the app's own API.
  ///
  /// Distinct from [uidChanges], and deliberately so: this is the signal to
  /// *navigate*, and it ignores a manual sign-out, which navigates itself.
  /// Conflating them double-fires on the one path that already handles it.
  Stream<void> get expirations;

  /// Ends a session that cannot recover and announces it on [expirations].
  /// Idempotent: a burst of failed calls must produce one expiry, not one
  /// each.
  Future<void> endSession();
}
