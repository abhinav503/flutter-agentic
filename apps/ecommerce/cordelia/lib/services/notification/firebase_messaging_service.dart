import 'dart:async';
import 'dart:io' show Platform;

import 'package:core/core/network/http_service.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:cordelia/constants/api_constants.dart';

import 'local_notification_service.dart';
import 'notification_payload.dart';
import 'notification_router.dart';

/// FCM wiring for the shopper app. Static singleton like every other service
/// with a `static final instance` — never registered in GetIt.
///
/// **Two ways to be addressed, for two different jobs.**
///
/// *Topics* carry every push the product sends today — `platform`
/// (CordeliaApps announcements, everyone), `store_{storeId}` (a store's own
/// broadcast, its shoppers), `user_{uid}` (order updates, one shopper). They
/// need no registry, no fan-out and no stale-token cleanup, and a reinstall
/// re-subscribes itself.
///
/// *Device tokens* are filed with the backend on sign-in and refreshed on
/// every launch. Nothing sends to them yet; they exist because a topic can
/// address an audience but never a **device**, and because the row is also
/// the record of who accepted the permission, on what, and when it was last
/// seen alive.
///
/// A device row is keyed by its **token**, with the owning uid as a field —
/// the token is unique per install, so signing in takes ownership by writing
/// it and two accounts can never hold the same handset. Sign-out
/// ([releaseDevice]) is hygiene on top of that, not the thing correctness
/// rests on.
class FirebaseMessagingService {
  FirebaseMessagingService._();
  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  // A getter, not a field: `FirebaseMessaging.instance` throws
  // `[core/no-app]` when Firebase hasn't been initialised, and as a field
  // initializer that fires the moment anything touches
  // `FirebaseMessagingService.instance` — including a widget test that only
  // wanted the storefront's teardown. Resolving it per call keeps merely
  // referencing the service free, and each call site already tolerates a
  // failure.
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  /// FCM topic names accept `[a-zA-Z0-9-_.~%]` only. Firestore auto-ids and
  /// Firebase uids are alphanumeric, so these compose safely — but a store id
  /// that ever gains another character would silently fail to subscribe, so
  /// the sender (`admin/src/lib/push.ts`) derives its topics the same way.
  static String storeTopic(String storeId) => 'store_$storeId';
  static String userTopic(String uid) => 'user_$uid';
  static const platformTopic = 'platform';

  /// Call once from the home screen's first frame — never from `main()`.
  ///
  /// On iOS, querying the launch notification before the first frame drops
  /// the tap that opened the app from a terminated state, and the navigator
  /// this routes through isn't mounted yet either.
  ///
  /// Note what this does **not** do: ask for permission. The prompt belongs
  /// to signing in (see [_followSignedInUser]) — a visitor still deciding
  /// whether to make an account shouldn't be interrupted by a system dialog
  /// they have no reason to accept yet, and iOS only ever offers it once.
  Future<void> init() async {
    // iOS only: show a banner while the app is foregrounded. No-op on
    // Android, which draws foreground pushes via LocalNotificationService.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await LocalNotificationService.instance.init();

    // FCM rotates a token on its own schedule (reinstall, restore, cache
    // clear). Without this the backend keeps a token that still accepts
    // sends and silently delivers nothing.
    //
    // The outgoing row is released first: rows are keyed by token, so the
    // replacement is a *different* document and the old one would otherwise
    // sit there forever, live-looking and undeliverable.
    _messaging.onTokenRefresh.listen((token) async {
      await releaseDevice();
      await _registerDevice(token: token, granted: await isPermissionGranted());
    });

    // Everyone hears CordeliaApps. The store topic is subscribed where its
    // scope begins (StorefrontPage); the user topic follows auth below.
    await _subscribe(platformTopic);

    _followSignedInUser();

    // Terminated → opened by a tap. Queried after the router is mounted.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      NotificationRouter.route(NotificationPayload.fromData(initial.data));
    }

    FirebaseMessaging.onMessage.listen(LocalNotificationService.instance.show);

    // Background (alive, not foregrounded) → the user tapped the notification.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      NotificationRouter.route(NotificationPayload.fromData(message.data));
    });
  }

  /// Starts/stops hearing a store's broadcasts. Called as a storefront
  /// session opens and closes, so leaving a store stops its notifications
  /// without the shopper having to mute anything.
  Future<void> subscribeToStore(String storeId) =>
      _subscribe(storeTopic(storeId));

  Future<void> unsubscribeFromStore(String storeId) =>
      _unsubscribe(storeTopic(storeId));

  /// The token last filed with the backend, so a sign-out knows which row to
  /// delete — `getToken()` would still return it, but not if the sign-out
  /// raced a rotation.
  String? _registeredToken;

  /// The uid currently subscribed to, so a sign-out knows what to drop —
  /// `authStateChanges` reports the *new* state and has already forgotten
  /// who left.
  String? _subscribedUid;

  /// Keeps `user_{uid}` in step with who is signed in.
  ///
  /// Driven off auth rather than the sign-in and sign-out call sites: one
  /// listener covers signing in, signing out, deleting the account, a token
  /// expiring, and a relaunch that restores a session — all of which change
  /// who should receive order pushes, and only one of which is a button.
  ///
  /// Dropping the old topic matters more than adding the new one: without it
  /// the next person to sign in on this device keeps receiving the previous
  /// account's order updates.
  void _followSignedInUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      final nextUid = user?.uid;

      // The first report of the launch is the only one that says anything
      // about who this device was hearing *before* it started.
      if (!_reconciled) {
        _reconciled = true;
        await _reconcileTopics(nextUid);
      }

      if (nextUid == _subscribedUid) return;

      final previousUid = _subscribedUid;
      _subscribedUid = nextUid;

      if (previousUid != null) {
        // The device row is released by [releaseDevice], called *before* the
        // sign-out that got us here — by now there is no ID token to
        // authenticate that call with. All that's left to do locally is stop
        // treating this token as filed.
        _registeredToken = null;
        await _unsubscribe(userTopic(previousUid));
      }

      if (nextUid != null) {
        await _subscribe(userTopic(nextUid));
        // Signing in is where the permission prompt belongs, and where the
        // token first becomes attributable to someone. On every later launch
        // this same path runs again with permission already decided, which
        // is what refreshes the stored token.
        await requestPermission();
      }
    });
  }

  /// Whether the OS is currently letting this app show notifications.
  ///
  /// Never prompts — [requestPermission] is what raises the dialog. Read by
  /// the Notifications screen, which offers to turn them on before it shows
  /// a centre the shopper is not being notified from.
  ///
  /// Web reports granted: Firebase isn't initialised there at all, so there
  /// is nothing to enable and an offer to do so would be a dead button.
  Future<bool> isPermissionGranted() async {
    if (kIsWeb) return true;
    try {
      return _isGranted(await _messaging.getNotificationSettings());
    } catch (error) {
      debugPrint('FCM permission status unavailable: $error');
      // Granted when the check itself fails, deliberately: its caller uses
      // this to decide whether to put a prompt in front of the notification
      // centre, and a status read that couldn't run is no reason to hide a
      // feed that loads fine.
      return true;
    }
  }

  /// Raises the OS permission dialog if it hasn't been answered, files this
  /// device's token if the answer was yes, and reports where it landed.
  ///
  /// Calling this again after a decision is safe and cheap: both platforms
  /// return the standing status rather than re-prompting, so it doubles as
  /// the "is it still allowed?" check on later launches, and a shopper who
  /// revoked permission in Settings stops re-registering. It also means a
  /// shopper who already said no gets `false` back with no dialog shown —
  /// only Settings can move them from there.
  Future<bool> requestPermission() async {
    if (kIsWeb) return true;
    try {
      final granted = _isGranted(await _messaging.requestPermission());
      // Filed either way, with the answer on the row. Registering only on a
      // yes would leave `updatedAt` frozen for a device that is alive and
      // merely muted, and a staleness sweep can't tell that apart from a
      // handset that is gone.
      await _registerDevice(granted: granted);
      return granted;
    } catch (error) {
      debugPrint('FCM permission/registration failed: $error');
      return false;
    }
  }

  /// Provisional (iOS quiet delivery) counts as granted — notifications do
  /// arrive, just silently, so there is nothing left to ask the shopper for.
  static bool _isGranted(NotificationSettings settings) =>
      settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;

  /// Files this device against the caller's uid, which the backend takes from
  /// the verified ID token — never one passed in.
  ///
  /// [granted] records whether the OS is currently letting this device show
  /// notifications, so a row can say "alive but muted" instead of going
  /// silent and looking abandoned.
  ///
  /// HTTP straight from a service rather than through a feature's data
  /// source: a device token has no domain meaning and no entity to model, so
  /// wrapping it in a repository would invent a feature to hold one call.
  Future<void> _registerDevice({String? token, required bool granted}) async {
    // On iOS this is null until APNs registration completes, which needs
    // permission — so a shopper who said no files no row there at all. On
    // Android the token exists regardless, which is what makes the muted-row
    // case reachable.
    final fcmToken = token ?? await this.token();
    if (fcmToken == null) return;

    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (idToken == null) return;

    try {
      await HttpService.instance.post<Map<String, dynamic>>(
        ApiConstants.userDevicesPath,
        data: {
          'token': fcmToken,
          'platform': _platformName,
          'granted': granted,
        },
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
      _registeredToken = fcmToken;
    } catch (error) {
      // A device that fails to register still receives every topic push —
      // only per-device targeting is lost, and the next launch retries.
      debugPrint('FCM device registration failed: $error');
    }
  }

  /// Releases this device from the account that is about to sign out.
  ///
  /// **Must be called before `FirebaseAuth.signOut()`** — the endpoint
  /// authenticates with an ID token, and after sign-out there is none. That
  /// is precisely why the auth listener can't do this itself: it is told
  /// about the sign-out only once there is no longer a token to prove who
  /// left. [FirebaseAuthService.signOut] is the choke point that calls it.
  ///
  /// Hygiene, not correctness. A device row is keyed by its token with the
  /// uid as a field, so the next account to sign in on this handset takes
  /// ownership by writing it — a release that never reaches the server can
  /// leave a stale row, never two accounts holding the same device.
  Future<void> releaseDevice() async {
    final fcmToken = _registeredToken;
    if (fcmToken == null) return;
    _registeredToken = null;

    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (idToken == null) return;

    // Not awaited: the ID token — the only part that expires with the
    // session — is already in hand, and a sign-out must not sit waiting on a
    // network round trip to a call nothing depends on.
    unawaited(_deleteDevice(fcmToken, idToken));
  }

  Future<void> _deleteDevice(String fcmToken, String idToken) async {
    try {
      await HttpService.instance.delete<Map<String, dynamic>>(
        ApiConstants.userDevicesPath,
        data: {'token': fcmToken, 'platform': _platformName},
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
    } catch (error) {
      debugPrint('FCM device unregistration failed: $error');
    }
  }

  static String get _platformName => Platform.isIOS ? 'ios' : 'android';

  Future<String?> token() async {
    // Can throw on a device with broken Play services ('FCM Registration
    // failed', transient SERVICE_NOT_AVAILABLE). Swallowed so a flaky
    // registration can't take the foreground and tap listeners down with it.
    try {
      return await _messaging.getToken();
    } catch (error) {
      debugPrint('FCM token unavailable: $error');
      return null;
    }
  }

  /// The topics this device believes it is subscribed to.
  ///
  /// Persisted because an FCM subscription lives on the **device** and
  /// outlives the process, while the fact that we asked for it used to live
  /// only in memory. A sign-out that couldn't reach FCM — no network, or the
  /// app killed before the call landed — therefore left the handset on the
  /// previous account's `user_{uid}` topic with nothing left that knew to
  /// undo it, and the next person to sign in kept receiving their order
  /// updates. This is the record that lets [_reconcileTopics] finish the job
  /// on the next launch.
  static const _subscribedTopicsPrefKey = 'fcm_subscribed_topics';

  Set<String> get _persistedTopics =>
      SharedPreferenceService.instance
          .getStringList(_subscribedTopicsPrefKey)
          ?.toSet() ??
      {};

  Future<void> _rememberTopic(String topic) async {
    final topics = _persistedTopics..add(topic);
    await SharedPreferenceService.instance.setStringList(
      _subscribedTopicsPrefKey,
      topics.toList(),
    );
  }

  Future<void> _forgetTopic(String topic) async {
    final topics = _persistedTopics..remove(topic);
    await SharedPreferenceService.instance.setStringList(
      _subscribedTopicsPrefKey,
      topics.toList(),
    );
  }

  /// Whether this launch has already reconciled. Auth reports many times per
  /// session (token refresh, reload); only the first tells us anything about
  /// what the *previous* session left behind.
  bool _reconciled = false;

  /// Drops every subscription this device holds that it shouldn't.
  ///
  /// At launch exactly two are legitimate: [platformTopic], and the signed-in
  /// shopper's own. A store topic is session-scoped and no storefront is open
  /// yet, so any that survived is a storefront that never got to tear down;
  /// a `user_` topic for anyone but [uid] is the leak described on
  /// [_subscribedTopicsPrefKey].
  ///
  /// Each unsubscribe that fails stays on the list and is retried on the next
  /// launch, which is the whole point of persisting it.
  Future<void> _reconcileTopics(String? uid) async {
    final keep = {platformTopic, if (uid != null) userTopic(uid)};
    for (final topic in _persistedTopics) {
      if (keep.contains(topic)) continue;
      await _unsubscribe(topic);
    }
  }

  // Subscription is a network call and fails the same way getToken does. A
  // missed subscription costs notifications, never a broken screen.
  Future<void> _subscribe(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      // Recorded only after FCM accepted it, so a failed subscribe doesn't
      // leave the device believing it is listening to something.
      await _rememberTopic(topic);
    } catch (error) {
      debugPrint('FCM subscribe to $topic failed: $error');
    }
  }

  Future<void> _unsubscribe(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      await _forgetTopic(topic);
    } catch (error) {
      debugPrint('FCM unsubscribe from $topic failed: $error');
    }
  }
}
