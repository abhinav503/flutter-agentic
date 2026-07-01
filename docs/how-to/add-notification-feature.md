# How to Add Firebase Push Notifications to an App

Wires one app under `apps/{app}/` for **Firebase Cloud Messaging (FCM)** push
notifications: device token, foreground/background/terminated message handling,
topic subscriptions, and **tap-to-open-a-page** routing.

> **Monorepo note:** like Firebase config itself, messaging is **per app**. Every
> path below is relative to the target app folder `apps/{app}/`. Each app lists its
> **own** `firebase_messaging` / `flutter_local_notifications` dependencies — these
> are **never** added to `core` (not every app needs push, and `core` stays
> dependency-lean — see `docs/ai-rules/conventions.md`).

> **Scope:** this adds **FCM only**. The reference (`atwork-mobile-app`) ships
> CleverTap alongside FCM; none of the CleverTap pieces are ported here.

---

## How this guide is organised

The work splits into **three parts** — do them in order:

1. **Part A — Shared Flutter code** (agent): deps + Dart files. **Identical for iOS
   and Android.** Always do this.
2. **Part B — iOS track**: Apple/Firebase credentials + Xcode capabilities. Do this
   only if shipping to iOS.
3. **Part C — Android track**: manifest permission + channel. Do this only if
   shipping to Android.

Then **Part D — Test**, which also has separate iOS and Android instructions.

| | iOS | Android |
|---|---|---|
| Backend credential | APNs auth key → Firebase Console (**user**) | none — `google-services.json` is enough |
| Native config | Xcode: Push Notifications + Background Modes (**user**) | `POST_NOTIFICATIONS` + channel meta-data (**agent**) |
| Foreground display | native (Dart opt-in) | `flutter_local_notifications` renders it |
| Test device | physical device only (no Simulator) | emulator w/ Google Play, or device |

---

## Step 0 — Prerequisite: Firebase must already be connected

This skill **builds on** `/connect-firebase`. Pick the app (if not passed as an
argument, list `apps/` and ask which one), then verify it is connected:

```bash
ls apps/{app}/lib/firebase_options.dart
grep -n "firebase_core" apps/{app}/pubspec.yaml
grep -n "Firebase.initializeApp" apps/{app}/lib/main.dart
```

- All three present → continue.
- Any missing → **stop**, tell the user to run `/connect-firebase` first, then
  return here. Do not run the FlutterFire CLI flow from this skill.

Also ask **which platform(s)** the app targets — it decides whether you do Part B,
Part C, or both.

---

# Part A — Shared Flutter code (iOS + Android, always)

Everything in Part A is platform-agnostic Dart and runs the same on both platforms.

## A1 — Dependencies (agent)

**Don't hardcode versions — let pub resolve them**, because `firebase_messaging`'s
major version must match the app's existing `firebase_core` major:

| `firebase_core` | `firebase_messaging` |
|---|---|
| `^4.x` | `^16.x` |
| `^3.x` | `^15.x` |

From the **app folder**, add both and let pub pick compatible versions:

```bash
cd apps/{app} && flutter pub add firebase_messaging flutter_local_notifications
```

This writes resolved constraints into `apps/{app}/pubspec.yaml` (only this app —
never `core`) and runs a workspace resolve. `firebase_core` is already present from
`/connect-firebase`.

> **`flutter_local_notifications` v19 → v22 changed the API to named parameters**
> (`initialize(settings: …)`, `show(id: …, notificationDetails: …)`). The A6 snippet
> below uses the **named** form, which is what v22+ resolves to. If pub gives you an
> older major, adjust accordingly.

No extra permission package is needed — `firebase_messaging`'s
`requestPermission()` drives both the iOS prompt and the Android 13+
`POST_NOTIFICATIONS` runtime prompt.

## A2 — Why init lives on the home screen, not in `main()`

**Listeners and the terminated-state `getInitialMessage()` are set up from the home
screen's first frame, not from `main()`.** This is deliberate:

- On **iOS**, if you query the launch notification too early (during `main()`,
  before the first frame / before the Flutter view and navigator exist), the
  initial message that opened the app from a **terminated** state is frequently
  **missed** — the tap that launched the app is dropped and no routing happens.
- Setting up in the home screen's `initState` via `addPostFrameCallback` guarantees
  the **router/navigator is mounted** before any tap routing runs.

The **only** messaging line that stays in `main()` is the background-handler
registration (`FirebaseMessaging.onBackgroundMessage`) — it must run before
`runApp`, and the handler must be a top-level function.

## A3 — Notification type + app-state enums (agent)

`apps/{app}/lib/enums/notification_type.dart` — bare enums; parsing in an extension
(per the enum convention in `docs/reference/architecture.md`):

```dart
enum NotificationType { normal, routeToPage }

extension NotificationTypeParse on String {
  NotificationType toNotificationType() => switch (this) {
        'routeToPage' => NotificationType.routeToPage,
        _ => NotificationType.normal, // safe default
      };
}

enum NotificationAppState { foreground, background, terminated }
```

> Keep the enum minimal. The reference app also has a `sendMessage` case that
> re-dispatches into its chat BLoC — that's app-specific. Add cases only when a
> real payload needs them.

## A4 — Payload (plain class — infra, not a feature DTO)

`apps/{app}/lib/services/notification/notification_payload.dart`. App-level
infrastructure, so it does **not** follow the per-feature `*Model`/`*Entity` pairing
rule. Parse the wire payload here (the data layer of messaging):

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

Expected FCM **data** payload shape (set by whoever sends the push):

```json
{ "notificationType": "routeToPage", "route": "scan" }
```

## A5 — Navigation key (agent)

go_router navigates from a `BuildContext`. To route from a notification tap (outside
the widget tree) without an import cycle, use a standalone global navigator key —
this file imports nothing from the app:

`apps/{app}/lib/services/notification/notification_navigator.dart`:

```dart
import 'package:flutter/widgets.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
```

Wire it into the existing `GoRouter` in `apps/{app}/lib/app.dart`:

```dart
final _router = GoRouter(
  navigatorKey: rootNavigatorKey, // add this line
  routes: [ /* unchanged */ ],
);
```

The router's existing routes are the navigation targets — a payload `route` of
`scan` maps to the `'/scan'` route. Add a `GoRoute` for any new tap destination.

## A6 — Local notification service (agent)

Android does **not** show a system notification for a foreground message on its own
— `flutter_local_notifications` renders it and carries the tap payload. iOS shows
foreground notifications natively (opted into in A7b), so this service no-ops on
iOS.

`apps/{app}/lib/services/notification/local_notification_service.dart`:

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
  final payload =
      NotificationPayload.fromData(jsonDecode(raw) as Map<String, dynamic>);
  NotificationRouter.route(payload);
}

class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  static const _channelId = 'default_channel';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (Platform.isIOS) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit), // named in v22+
      onDidReceiveNotificationResponse: _onTapLocalNotification,
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      'General',
      description: 'General notifications',
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> show(RemoteMessage message) async {
    if (Platform.isIOS) return;
    final notification = message.notification;
    await _plugin.show(
      id: Random().nextInt(100000),         // all named in v22+
      title: notification?.title,
      body: notification?.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'General',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }
}
```

## A7 — Router + messaging service (agent)

### A7a. The router — one place that turns a payload into navigation
`apps/{app}/lib/services/notification/notification_router.dart`:

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
        break; // nothing to route; the notification was informational
    }
  }
}
```

### A7b. The messaging service — static singleton, FCM only
`apps/{app}/lib/services/notification/firebase_messaging_service.dart`. Like all
`static final instance` services it is **never** registered in GetIt — call it via
`.instance`. `setForegroundNotificationPresentationOptions` is what makes **iOS**
show notifications while the app is foregrounded (it's a no-op on Android, which
uses the local-notification path above).

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification_service.dart';
import 'notification_payload.dart';
import 'notification_router.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._();
  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call once from the home screen's first frame (see A2 for why).
  Future<void> init() async {
    await _messaging.requestPermission();

    // iOS: show notifications while the app is in the foreground (no-op on Android).
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await LocalNotificationService.instance.init();

    // Terminated → opened by a notification tap. Query AFTER the router is mounted.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      NotificationRouter.route(NotificationPayload.fromData(initial.data));
    }

    // Foreground: Android renders via local notifications; iOS shows it natively.
    FirebaseMessaging.onMessage.listen(LocalNotificationService.instance.show);

    // Background (app alive, not foreground) → user taps the system notification.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      NotificationRouter.route(NotificationPayload.fromData(message.data));
    });
  }

  Future<String?> getToken() => _messaging.getToken();

  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);

  Future<bool> isEnabled() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}
```

## A8 — Wire it up (agent)

### A8a. `main.dart` — background handler only
Add the top-level handler and register it **before `runApp`** (the rest of `main`,
including `Firebase.initializeApp`, is already there from `/connect-firebase`):

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Runs in a separate isolate. Keep it light; no navigation here.
  // Tapping the delivered notification routes via onMessageOpenedApp / getInitialMessage.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Web-safe: FCM/Firebase are mobile-only; guard so the Flutter Web preview
  // boots (the Firebase.initializeApp guard also comes from /connect-firebase).
  if (!kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  // ...existing initDependencies() + runApp(...)
}
```

### A8b. Home screen — init on first frame
In the app's `home_screen.dart`, override `initState` on the `BaseScreenState`
subclass and kick off messaging after the first frame:

```dart
// needs: import 'package:flutter/foundation.dart' show kIsWeb;
@override
void initState() {
  super.initState();
  // FCM is the sole entry to the Firebase/local-notification stack, so this one
  // guard keeps the web preview off every native-only plugin.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!kIsWeb) FirebaseMessagingService.instance.init();
  });
}
```

> Send the token to your backend (and/or `subscribeToTopic`) from here too, once
> `init()` resolves, if your product needs server-addressable pushes.

After Part A, run `make analyze`. The code compiles on both platforms, but it can't
deliver a push until the matching platform track below is done.

---

# Part B — iOS track (skip if not shipping iOS)

iOS push has two user-only pieces (an Apple credential and an Xcode capability) plus
a verification the agent can do. **None of this works on the Simulator.**

## B1 — APNs auth key → Firebase (user; Apple portal + Console)

iOS push needs an Apple **APNs authentication key** uploaded to Firebase:

1. [Apple Developer → Certificates, Identifiers & Profiles → Keys](https://developer.apple.com/account/resources/authkeys/list)
   → **+** → enable **Apple Push Notifications service (APNs)** → download the
   `.p8` file (downloadable only once). Note the **Key ID** and your **Team ID**.
2. [Firebase Console](https://console.firebase.google.com/) → your project →
   **Project settings → Cloud Messaging → Apple app configuration → APNs Authentication Key**
   → **Upload** the `.p8`, with the Key ID and Team ID.

> Cloud Messaging API is on by default for new projects. If the console shows it
> disabled, enable it under the same Cloud Messaging tab.

This is a one-time manual step; wait for the user to confirm before relying on iOS
delivery.

## B2 — Xcode capabilities (user)

Open `apps/{app}/ios/Runner.xcworkspace` in Xcode → **Runner target → Signing &
Capabilities → + Capability**, and add:

1. **Push Notifications** — creates `Runner.entitlements` with `aps-environment`.
2. **Background Modes** → tick **Remote notifications** — adds `remote-notification`
   to `UIBackgroundModes`.

## B3 — Verify (agent)

```bash
grep -A2 "UIBackgroundModes" apps/{app}/ios/Runner/Info.plist
grep -c "aps-environment" apps/{app}/ios/Runner/Runner.entitlements
grep "IPHONEOS_DEPLOYMENT_TARGET" apps/{app}/ios/Runner.xcodeproj/project.pbxproj
```

- `UIBackgroundModes` should list `remote-notification`.
- `aps-environment` count ≥ 1.
- Deployment target must be **15.0+** (`/connect-firebase` already ensures this).

> The default Flutter `AppDelegate.swift` needs **no edits** — `firebase_messaging`
> uses method swizzling, and foreground presentation is set in Dart (A7b).

---

# Part C — Android track (skip if not shipping Android)

Android needs no Firebase Console action — the `google-services.json` and Gradle
plugin from `/connect-firebase` are enough. The edits below are all agent-doable.

## C0 — Core-library desugaring (agent, **required**)

`flutter_local_notifications` v17+ uses `java.time` APIs and **will fail the Gradle
build** without core-library desugaring. Edit
`apps/{app}/android/app/build.gradle.kts`:

```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true   // add this
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

// at the bottom of the file:
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

(Skipping this is the most common Android build failure for this feature.)

## C1 — `POST_NOTIFICATIONS` permission (agent)

Add to `apps/{app}/android/app/src/main/AndroidManifest.xml`, inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

(Android 13+ requires this; `firebase_messaging`'s `requestPermission()` triggers
the runtime prompt.)

## C2 — Default channel meta-data (agent, optional)

So notifications sent with a `notification` block while the app is backgrounded use
the channel created in A6, add inside `<application>`:

```xml
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="default_channel"/>
```

## C3 — Verify (agent)

```bash
grep -n "POST_NOTIFICATIONS" apps/{app}/android/app/src/main/AndroidManifest.xml
grep -n "google-services" apps/{app}/android/app/build.gradle.kts   # from /connect-firebase
```

---

## Build check (both platforms)

```bash
flutter pub get          # repo root
make analyze             # whole workspace
cd apps/{app} && flutter run   # on the target platform's device
```

(No `build_runner` needed — none of these files use Freezed/JSON codegen.)

---

# Part D — Test with a real push

First grab the FCM token (same for both platforms) — log it after `init()`:
`FirebaseMessagingService.instance.getToken().then(print);` and copy it from the run
console.

### D-iOS — test on iOS
1. Run on a **physical device** — iOS push does **not** work on the Simulator, and
   needs the APNs key from B1.
2. Accept the permission prompt on first launch.
3. [Firebase Console](https://console.firebase.google.com/) → **Run → Messaging →
   Create campaign → Firebase Notification messages → Send test message** → paste
   the token → **Test**. Expect a banner.

### D-Android — test on Android

> **Use a real Android phone for FCM, not an emulator.** Emulator Play services is
> unreliable for push — see the two failure modes in the troubleshooting table below
> (registration failure, and a registrar crash where the token looks valid but
> nothing is delivered). A physical device ships a Play-services build matched to its
> OS and avoids the whole class of problems. Plug in, enable USB debugging, `flutter run`.

If you do use an emulator, **it must run a Google _Play_ system image, not "Google
APIs"** — FCM token registration needs the Play Store / Play services; a "Google
APIs" image fails `getToken()` with `IOException: FCM Registration failed!`.

- Check existing AVDs: `avdmanager list avd` → look for `Tag/ABI: google_apis_playstore`.
  In Android Studio's **Device Manager**, a Play image shows a **▷ Play Store icon**
  in the AVD row.
- If you don't have one: **Android Studio → Device Manager → Create Device →** pick a
  phone, then a system image whose **Services column says "Google Play"** (download
  it if needed) → Finish.

Then:
1. Launch the Play-enabled AVD and run the app.
2. On Android 13+, accept the `POST_NOTIFICATIONS` prompt.
3. Read the **`FCM token:`** line from the run log.
4. Firebase Console **Send test message** → paste the token → **Test** → expect a banner.

#### Troubleshooting `IOException: FCM Registration failed!`
Work down this list — in our experience the wipe-data step is what fixes it most often:

| Check | Fix |
|---|---|
| Emulator is a **Play** image? | Use `google_apis_playstore` (see above). "Google APIs" won't register. |
| **Stale Play services** (snapshot/quick boot) | **Device Manager → ⋮ → Wipe Data**, cold boot, open the **Play Store** app once, wait ~1 min, re-run. ✅ *most common fix* |
| Behind **VPN / proxy / corporate network**? | Emulator can't reach `*.googleapis.com`. Relaunch: `emulator -avd <name> -dns-server 8.8.8.8 -no-snapshot-load`, or test off-VPN. |
| Wrong **clock** on the emulator | Settings → Date & time → automatic. Skew breaks registration. |
| **Token is valid but push never arrives**, and logcat shows `com.google.android.gms … PushMessagingRegistrar … IllegalArgumentException: NetworkCapability NN out of range` | The emulator's **Google Play services crashed its push registrar** (it auto-updated to a build incompatible with the system image). `getToken()` returns a cached token but delivery is dead. Fixes: **test on a physical device** (most reliable), use a *different* Google-Play image (e.g. API 34 instead of 35), or wipe data and **don't open the Play Store** (which triggers the breaking GMS update). To verify display/routing meanwhile, use a **local notification** (see "Testing local notifications without push"). |
| Is it the emulator or the project? | Run on a **physical phone**. Works there → emulator issue; fails there too → re-check the project's FCM API. |

> **SHA‑1 / SHA‑256 fingerprints are _not_ required for FCM.** They're only for Google
> Sign‑In, Phone Auth, Dynamic Links, and App Check. Adding a SHA will not fix a
> registration failure.

> **FCM API must be enabled** for the project: Firebase Console → Project settings →
> Cloud Messaging → **Firebase Cloud Messaging API (V1) = Enabled** (enable via the ⋮
> → Google Cloud Console if off). New projects have it on by default.

### Test tap-to-route (both platforms)
A console "test message" sends only a notification (no data), so it routes nowhere.
To test **routing**, send a message with a **data payload**:

```bash
# Replace <SERVER_KEY> (Project settings → Cloud Messaging) and <DEVICE_TOKEN>.
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=<SERVER_KEY>" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "<DEVICE_TOKEN>",
    "notification": { "title": "Open scan", "body": "Tap to open" },
    "data": { "notificationType": "routeToPage", "route": "scan" }
  }'
```

Test all three app states — each takes a different code path on **both** platforms:

| App state | What to do | Path exercised |
|---|---|---|
| **Foreground** | App open on screen | `onMessage` → iOS native banner / Android local notification |
| **Background** | Home button, app alive → tap notification | `onMessageOpenedApp` → route |
| **Terminated** | Swipe-kill the app → tap notification | `getInitialMessage` → route (the iOS-sensitive case) |

If the **terminated** tap does not route on iOS, confirm `init()` is called from the
home screen's `addPostFrameCallback` (A8b) and **not** from `main()` — that is the
exact failure this placement prevents.

---

## Testing local notifications without push (emulator-friendly)

Local notifications are drawn **directly by the OS** — they never touch FCM or Google
Play services, so they work even on an emulator where push delivery is broken. Use a
local notification to test **display + tap-routing** independently of delivery.

Add a debug-only helper to `LocalNotificationService` and fire it from the home
screen's `addPostFrameCallback` (guard with `if (kDebugMode)`; remove before
shipping):

```dart
Future<void> showTest() async {
  await _plugin.show(
    id: 0,
    title: 'Local test notification',
    body: 'Tap me → should route to /scan',
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(_channelId, 'General',
          importance: Importance.high, priority: Priority.high),
    ),
    payload: jsonEncode({'notificationType': 'routeToPage', 'route': 'scan'}),
  );
}
```

Tapping it runs the same `_onTapLocalNotification` → `NotificationRouter.route` path a
real push tap uses — add a `debugPrint` in the router to confirm it fires.

## Image (rich) notifications

### Local / foreground (Android BigPicture)
`flutter_local_notifications` **cannot fetch a URL** — download the bytes first
(`dio`/`http`), then pass them as a `ByteArrayAndroidBitmap` in a
`BigPictureStyleInformation`:

```dart
Future<void> showTestImage([
  String imageUrl = 'https://picsum.photos/400/200', // ~20–40 KB JPEG, public
]) async {
  final response = await Dio().get<List<int>>(
    imageUrl,
    options: Options(responseType: ResponseType.bytes),
  );
  final bitmap = ByteArrayAndroidBitmap(Uint8List.fromList(response.data!));

  await _plugin.show(
    id: 1,
    title: 'Image notification',
    body: 'Tap me',
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(_channelId, 'General',
          importance: Importance.high,
          priority: Priority.high,
          largeIcon: bitmap,
          styleInformation: BigPictureStyleInformation(
            bitmap,
            hideExpandedLargeIcon: true,
          )),
    ),
    payload: jsonEncode({'notificationType': 'routeToPage', 'route': 'scan'}),
  );
}
```

### Via FCM push (backgrounded — system renders it for you)
Put an `image` URL on the **notification** block. The OS shows it automatically when
the app is backgrounded/terminated — no client code needed:

```json
{
  "message": {
    "token": "<DEVICE_TOKEN>",
    "notification": {
      "title": "Image push",
      "body": "Tap to open",
      "image": "https://picsum.photos/400/200"
    },
    "data": { "notificationType": "routeToPage", "route": "scan" }
  }
}
```

- **Keep the image small** — aim for **≤ ~300 KB** (1 MB hard cap on the FCM payload
  including the image fetch). Large images are silently dropped.
- Public test URLs: `https://picsum.photos/400/200` (real JPEG, ~20–40 KB) or the
  tiny `https://dummyimage.com/600x300/4caf50/ffffff.png&text=Notif`.
- **Foreground Android** needs the BigPicture path above (the OS only auto-renders
  the image while backgrounded). **iOS foreground** images require a *Notification
  Service Extension* — out of scope here.

## Forbidden / gotchas

- **Never** add `firebase_messaging` or `flutter_local_notifications` to `core`.
- **Never** register `FirebaseMessagingService` / `LocalNotificationService` in
  GetIt — they are `static final instance` singletons, called via `.instance`.
- **Never** set up listeners or `getInitialMessage()` in `main()` — first frame of
  the home screen only (A2).
- The background handler must be a **top-level** function annotated
  `@pragma('vm:entry-point')`; do no navigation in it.
- iOS push is untestable on the Simulator and without the APNs key (B1).
- `getToken()` can **throw** (`FCM Registration failed`, transient
  `SERVICE_NOT_AVAILABLE`). Guard it in `init()` with try/catch so a flaky or
  offline backend logs cleanly instead of crashing the whole notification setup with
  an unhandled exception — and so the foreground/tap listeners still wire up.
- Notification copy (titles/bodies you generate in-app) is app copy → `ValueConst`,
  not inline literals.
