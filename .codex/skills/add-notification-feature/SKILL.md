---
name: add-notification-feature
description: >
  Add Firebase Cloud Messaging (FCM) push notifications to one app under apps/{app}/:
  device token, foreground/background/terminated handling, topic subscriptions,
  tap-to-open-a-page routing, and image (rich) notifications. FCM only — no CleverTap.
  Builds on connect-firebase (the app must already be connected). Steps are split into
  Part A (shared Flutter code), Part B (iOS), Part C (Android), Part D (test).
  Recommend a real Android device for FCM testing — emulator Play services is flaky.
  Invoke with $add-notification-feature or ask to add push/FCM notifications to an app.
---

Adds **FCM push notifications** to one app under `apps/{app}/`. FCM only — no
CleverTap. Present the steps **separated by iOS and Android** so the user follows only
the platform(s) they ship. This skill **builds on** `$connect-firebase` — it does not
run the FlutterFire CLI itself.

> **Monorepo note:** messaging is **per app**. Each app lists its **own**
> `firebase_messaging` / `flutter_local_notifications` deps — **never** add them to
> `core`.

## Step 0 — Prerequisite: Firebase must already be connected

Pick the app (if not passed, list `apps/` and ask). Verify it's connected:

```bash
ls apps/{app}/lib/firebase_options.dart
grep -n "firebase_core" apps/{app}/pubspec.yaml
grep -n "Firebase.initializeApp" apps/{app}/lib/main.dart
```

Any missing → **stop**, tell the user to run `$connect-firebase` first. Also ask
**which platform(s)** the app targets (decides Part B / Part C / both).

### Don't-skip gotchas (these bit us on the first real run)
- **Don't hardcode versions** — `flutter pub add firebase_messaging
  flutter_local_notifications`; messaging major must match `firebase_core` major
  (`core ^4 → messaging ^16`, `core ^3 → messaging ^15`).
- **`flutter_local_notifications` v22 uses named params** (`initialize(settings:)`,
  `show(id:, notificationDetails:)`).
- **Android needs core-library desugaring** (Part C0) or the Gradle build fails.
- **Guard `getToken()`** — it can throw; log and continue.

---

# Part A — Shared Flutter code (iOS + Android, always)

## A1 — Dependencies (agent)
```bash
cd apps/{app} && flutter pub add firebase_messaging flutter_local_notifications
```
`firebase_core` is already present from `$connect-firebase`. No extra permission
package needed — `requestPermission()` drives both the iOS prompt and Android 13+
`POST_NOTIFICATIONS`.

## A2 — Why init lives on the home screen, not `main()`
Listeners + terminated-state `getInitialMessage()` run from the home screen's first
frame via `addPostFrameCallback`. On **iOS**, querying the launch notification too
early (in `main()`, before the navigator is mounted) **drops** the tap that opened
the app from a killed state. Only the background-handler registration stays in
`main()` (must run before `runApp`; handler is a top-level function).

## A3 — Enums — `apps/{app}/lib/enums/notification_type.dart`
```dart
enum NotificationType { normal, routeToPage }

extension NotificationTypeParse on String {
  NotificationType toNotificationType() => switch (this) {
        'routeToPage' => NotificationType.routeToPage,
        _ => NotificationType.normal,
      };
}

enum NotificationAppState { foreground, background, terminated }
```

## A4 — Payload — `apps/{app}/lib/services/notification/notification_payload.dart`
Plain class (app-level infra, not a feature DTO). Parse the wire payload here.
```dart
import 'package:{app}/enums/notification_type.dart';

class NotificationPayload {
  final NotificationType type;
  final String? route;
  const NotificationPayload({required this.type, this.route});

  factory NotificationPayload.fromData(Map<String, dynamic> data) =>
      NotificationPayload(
        type: (data['notificationType']?.toString() ?? '').toNotificationType(),
        route: data['route']?.toString(),
      );
}
```
Expected FCM **data** payload: `{ "notificationType": "routeToPage", "route": "scan" }`

## A5 — Navigation key — `…/notification/notification_navigator.dart`
Standalone global key (imports nothing from the app → no import cycle):
```dart
import 'package:flutter/widgets.dart';
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
```
Wire into the existing `GoRouter` in `app.dart`: `GoRouter(navigatorKey: rootNavigatorKey, routes: [...])`.
A payload `route` of `scan` maps to the `'/scan'` route; add a `GoRoute` per tap destination.

## A6 — Local notification service — `…/notification/local_notification_service.dart`
Android renders foreground messages via this service; iOS shows them natively (A7b),
so it no-ops on iOS.
```dart
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_payload.dart';
import 'notification_router.dart';

@pragma('vm:entry-point')
void _onTapLocalNotification(NotificationResponse response) {
  final raw = response.payload;
  if (raw == null || raw.isEmpty) return;
  NotificationRouter.route(
      NotificationPayload.fromData(jsonDecode(raw) as Map<String, dynamic>));
}

class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  static const _channelId = 'default_channel';
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (Platform.isIOS) return;
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit), // named in v22+
      onDidReceiveNotificationResponse: _onTapLocalNotification,
    );
    const channel = AndroidNotificationChannel(_channelId, 'General',
        description: 'General notifications', importance: Importance.high);
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> show(RemoteMessage message) async {
    if (Platform.isIOS) return;
    final n = message.notification;
    await _plugin.show(
      id: Random().nextInt(100000),         // all named in v22+
      title: n?.title,
      body: n?.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(_channelId, 'General',
            importance: Importance.high, priority: Priority.high),
      ),
      payload: jsonEncode(message.data),
    );
  }
}
```

## A7 — Router + messaging service
**Router** — `…/notification/notification_router.dart`:
```dart
import 'package:go_router/go_router.dart';

import '../../enums/notification_type.dart';
import 'notification_navigator.dart';
import 'notification_payload.dart';

class NotificationRouter {
  const NotificationRouter._();
  static void route(NotificationPayload payload) {
    switch (payload.type) {
      case NotificationType.routeToPage:
        final route = payload.route;
        final ctx = rootNavigatorKey.currentContext;
        if (route == null || route.isEmpty || ctx == null) return;
        ctx.go('/$route');
      case NotificationType.normal:
        break;
    }
  }
}
```
**Service** — `…/notification/firebase_messaging_service.dart` (static singleton —
never in GetIt; call via `.instance`):
```dart
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification_service.dart';
import 'notification_payload.dart';
import 'notification_router.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._();
  static final FirebaseMessagingService instance = FirebaseMessagingService._();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call once from the home screen's first frame (see A2).
  Future<void> init() async {
    await _messaging.requestPermission();
    await _messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true); // iOS foreground (no-op on Android)
    await LocalNotificationService.instance.init();

    try {
      debugPrint('FCM token: ${await _messaging.getToken()}');
    } catch (e) {
      debugPrint('FCM getToken failed: $e'); // registration can fail — log, continue
    }

    final initial = await _messaging.getInitialMessage(); // terminated → tap
    if (initial != null) {
      NotificationRouter.route(NotificationPayload.fromData(initial.data));
    }
    FirebaseMessaging.onMessage.listen(LocalNotificationService.instance.show);
    FirebaseMessaging.onMessageOpenedApp.listen((m) =>
        NotificationRouter.route(NotificationPayload.fromData(m.data)));
  }

  Future<String?> getToken() => _messaging.getToken();
  Future<void> subscribeToTopic(String t) => _messaging.subscribeToTopic(t);
  Future<void> unsubscribeFromTopic(String t) => _messaging.unsubscribeFromTopic(t);
}
```

## A8 — Wire it up
**`main.dart`** — top-level background handler, registered before `runApp`:
```dart
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // separate isolate; keep light; no navigation here
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Web-safe: FCM/Firebase are mobile-only; guard so the Flutter Web preview
  // boots. Needs: import 'package:flutter/foundation.dart' show kIsWeb;
  if (!kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  // ...existing initDependencies() + runApp(...)
}
```
**`home_screen.dart`** — init on first frame (guard so the web preview stays off native-only plugins; needs `import 'package:flutter/foundation.dart' show kIsWeb;`):
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!kIsWeb) FirebaseMessagingService.instance.init();
  });
}
```
After Part A, run `make analyze`. Code compiles on both platforms but can't deliver a
push until the platform track below is done.

---

# Part B — iOS track (skip if not shipping iOS)

- **B1 (user):** Apple **APNs auth key** (.p8 from developer.apple.com → Keys, with
  Key ID + Team ID) uploaded to Firebase Console → Project settings → Cloud Messaging
  → Apple app config. iOS delivery depends on it. None of iOS works on the Simulator.
- **B2 (user, Xcode):** open `ios/Runner.xcworkspace` → Runner target → Signing &
  Capabilities → + Capability → add **Push Notifications** and **Background Modes →
  Remote notifications**. Default `AppDelegate.swift` needs no edits.
- **B3 (agent) verify:**
  ```bash
  grep -A2 "UIBackgroundModes" apps/{app}/ios/Runner/Info.plist        # remote-notification
  grep -c "aps-environment" apps/{app}/ios/Runner/Runner.entitlements  # ≥1
  grep "IPHONEOS_DEPLOYMENT_TARGET" apps/{app}/ios/Runner.xcodeproj/project.pbxproj # ≥15.0
  ```

---

# Part C — Android track (skip if not shipping Android)

No Firebase Console action — `google-services.json` + Gradle plugin from
`$connect-firebase` are enough.

- **C0 (agent, REQUIRED):** core-library desugaring in `android/app/build.gradle.kts`
  or the Gradle build fails on `flutter_local_notifications`:
  ```kotlin
  android { compileOptions { isCoreLibraryDesugaringEnabled = true /* + Java 17 */ } }
  dependencies { coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") }
  ```
- **C1 (agent):** add to `AndroidManifest.xml` inside `<manifest>`:
  `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>`
- **C2 (agent, optional):** inside `<application>`, a default channel meta-data:
  `<meta-data android:name="com.google.firebase.messaging.default_notification_channel_id" android:value="default_channel"/>`

---

# Part D — Test

Grab the FCM token from the run log (the service logs it).

### D-iOS
Physical device only (no Simulator), needs the APNs key. Firebase Console → Messaging
→ Send test message → paste token → Test → expect a banner.

### D-Android
> **Use a real Android phone for FCM, not an emulator.** Emulator Play services is
> unreliable: a "Google APIs" image fails `getToken()` with `IOException: FCM
> Registration failed!`, and even a Play image can crash its push registrar
> (`com.google.android.gms … PushMessagingRegistrar … NetworkCapability NN out of
> range`) after auto-updating — token looks valid but **nothing is delivered**. A
> physical device ships a matched Play-services build and just works.

If using an emulator it **must** be a Google **Play** image (`google_apis_playstore`
/ Play Store icon). If push still doesn't arrive: **Device Manager → ⋮ → Wipe Data** +
cold boot (most common fix); check logcat for the `PushMessagingRegistrar` crash → if
present, switch to a real device. **SHA fingerprints are NOT needed for FCM.** Confirm
the project's **FCM API (V1)** is enabled (Firebase Console → Cloud Messaging).

### Tap-to-route (both platforms)
A console test message has no data payload. Send a **data** message to test routing:
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=<SERVER_KEY>" -H "Content-Type: application/json" \
  -d '{"to":"<DEVICE_TOKEN>","notification":{"title":"Open scan","body":"Tap"},"data":{"notificationType":"routeToPage","route":"scan"}}'
```
Test **foreground** (`onMessage`), **background** (`onMessageOpenedApp`), and
**terminated** (`getInitialMessage` — the iOS-sensitive case).

### Image (rich) notifications
- **Push:** add an `image` URL to the FCM `notification` block; the OS renders it
  when backgrounded. Keep it **≤ ~300 KB** (e.g. `https://picsum.photos/400/200`).
- **Foreground (Android):** download bytes (`dio`) → `ByteArrayAndroidBitmap` →
  `BigPictureStyleInformation` via the local-notification service.

### Local notification (emulator-friendly, no push)
`flutter_local_notifications.show(...)` bypasses FCM/Play services, so display +
tap-routing can be verified on a broken emulator. Use a debug-only `showTest()` helper
fired from the home screen (guard with `kDebugMode`; remove before shipping).

---

## Forbidden / gotchas
- Never add `firebase_messaging` / `flutter_local_notifications` to `core`.
- Never register `FirebaseMessagingService` / `LocalNotificationService` in GetIt —
  `static final instance`, called via `.instance`.
- Never set up listeners / `getInitialMessage()` in `main()` — home screen first
  frame only.
- Background handler must be top-level + `@pragma('vm:entry-point')`; no navigation.
- iOS push: untestable on Simulator and without the APNs key.
- Guard `getToken()` (can throw); notification copy → `ValueConst`, not literals.
