import 'package:dio/dio.dart';

/// Turns a **401 from our own API** into the app's session-expired signal.
///
/// `FirebaseAuthService.idToken()` already ends a session the moment Firebase
/// itself refuses to mint a token (a password changed on another device, the
/// account disabled). That covers the cases Firebase knows about locally — and
/// misses the ones only the server can see. `getIdToken(false)` returns the
/// **cached** token without a network round trip, so for up to an hour after a
/// token is invalidated the app keeps presenting a string the server rejects
/// while Firebase reports a perfectly healthy user.
///
///
/// What the shopper saw: an error view, a Retry button that fires the same
/// doomed request, and no way out of the loop except reinstalling. Now the
/// first 401 ends the session and `_SessionExpiredGuard` lands them on Login.
///
/// Deliberately narrow, in three ways:
///
///  * **Only our API.** Scoped to [apiBaseUrl] so a 401 from any other host
///    (an image CDN, a third-party map tile) can never sign anybody out.
///  * **Only when signed in.** [onUnauthorized] no-ops without a current user;
///    plenty of endpoints here are browsable anonymously (discovery, a store's
///    catalog), and bouncing a signed-out browser to Login with "your session
///    expired" would be a lie.
///  * **Only 401.** A 403 is "you may not do this", which is a real answer to
///    a real question and leaves the session intact.
///
/// The error still propagates: `handler.next(err)` keeps `BaseRepository`'s
/// mapping and every existing failure path working. Signing out is an
/// additional consequence of the 401, not a replacement for reporting it.
class SessionExpiryInterceptor extends Interceptor {
  /// Called on the first qualifying 401. Takes no arguments and swallows the
  /// decision of whether anything should happen — see FirebaseAuthService's
  /// `endSession`, which is re-entrant and returns immediately when no one is
  /// signed in.
  final Future<void> Function() onUnauthorized;

  /// Requests whose URL starts with this are ours; nothing else qualifies.
  final String apiBaseUrl;

  const SessionExpiryInterceptor({
    required this.onUnauthorized,
    required this.apiBaseUrl,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.uri.toString().startsWith(apiBaseUrl)) {
      // Not awaited: an interceptor that blocks here would hold the error
      // (and every request queued behind it) until Firebase finishes signing
      // out. The guard reacts to the notifier, not to this call returning.
      onUnauthorized();
    }
    handler.next(err);
  }
}
