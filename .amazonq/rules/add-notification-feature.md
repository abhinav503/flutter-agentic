# Add Firebase Push Notifications (FCM) to an App

When the user asks to add push/FCM notifications to an app, follow every step below.
FCM only — no CleverTap. Present steps **separated by iOS and Android**.

> **Monorepo note:** messaging is **per app**. Each app lists its **own**
> `firebase_messaging` / `flutter_local_notifications` deps — **never** add to `core`.
> This builds on the connect-firebase flow; the app must already be connected.

---

## Step 0 — Prerequisite + pick app/platform

Pick the app (list `apps/` and ask if unspecified). Verify it's connected:

```bash
ls apps/{app}/lib/firebase_options.dart
grep -n "firebase_core" apps/{app}/pubspec.yaml
grep -n "Firebase.initializeApp" apps/{app}/lib/main.dart
```

Any missing → stop; connect the app to Firebase first. Ask which platform(s) it ships
(decides the iOS / Android tracks).

**Don't-skip gotchas:**
- Don't hardcode versions — `flutter pub add firebase_messaging
  flutter_local_notifications`; messaging major must match `firebase_core` (`^4 → ^16`,
  `^3 → ^15`).
- `flutter_local_notifications` v22 uses **named** params (`initialize(settings:)`,
  `show(id:, notificationDetails:)`).
- Android needs **core-library desugaring** (Part C) or the build fails.
- Guard `getToken()` (can throw `FCM Registration failed`) — log and continue.

---

## Part A — Shared Flutter code (both platforms)

1. **Deps:** `cd apps/{app} && flutter pub add firebase_messaging flutter_local_notifications`.
2. Under `apps/{app}/lib/services/notification/` create:
   - `notification_payload.dart` — plain class parsing `{notificationType, route}`.
   - `notification_navigator.dart` — `final rootNavigatorKey = GlobalKey<NavigatorState>();`
     (imports nothing from the app → no cycle).
   - `local_notification_service.dart` — static singleton; Android channel +
     `show(RemoteMessage)`; `_onTapLocalNotification` → `NotificationRouter.route`.
   - `notification_router.dart` — `route(payload)` does `rootNavigatorKey.currentContext.go('/$route')`.
   - `firebase_messaging_service.dart` — static singleton (never in GetIt). `init()`:
     `requestPermission`, `setForegroundNotificationPresentationOptions`, local init,
     `getInitialMessage` (terminated tap), `onMessage` → local show, `onMessageOpenedApp`
     → route. Wrap `getToken()` in try/catch.
3. `lib/enums/notification_type.dart` — `enum NotificationType { normal, routeToPage }`
   with a `String.toNotificationType()` extension; plus `NotificationAppState`.
4. `app.dart` — `GoRouter(navigatorKey: rootNavigatorKey, ...)`.
5. `main.dart` — top-level `@pragma('vm:entry-point')` background handler, registered
   with `FirebaseMessaging.onBackgroundMessage(...)` **before** `runApp`.
6. `home_screen.dart` `initState` — `addPostFrameCallback((_) => FirebaseMessagingService.instance.init())`.

**Why home-screen init, not `main()`:** on iOS, querying the launch notification too
early drops the terminated-state tap and the router isn't mounted. `addPostFrameCallback`
fixes both. Only the background-handler registration stays in `main()`.

---

## Part B — iOS track (if shipping iOS)

- **User:** upload an Apple **APNs auth key** (.p8 + Key ID + Team ID) to Firebase
  Console → Project settings → Cloud Messaging. iOS delivery depends on it.
- **User (Xcode):** `ios/Runner.xcworkspace` → Runner → Signing & Capabilities → add
  **Push Notifications** + **Background Modes → Remote notifications**. Default
  `AppDelegate.swift` needs no edits.
- **Agent verify:** `aps-environment` present, `UIBackgroundModes` has
  `remote-notification`, deployment target ≥ 15.0. iOS push needs a physical device.

---

## Part C — Android track (if shipping Android)

- **Required:** core-library desugaring in `android/app/build.gradle.kts`:
  `isCoreLibraryDesugaringEnabled = true` +
  `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")`.
- Add `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>`.
- Optional: `com.google.firebase.messaging.default_notification_channel_id` meta-data.
- No Firebase Console action needed.

---

## Part D — Test

Grab the FCM token from the run log.

- **Use a real Android phone for FCM, not an emulator.** Emulator Play services is
  flaky: "Google APIs" images fail `getToken()` (`IOException: FCM Registration
  failed!`); even Play images can crash the push registrar
  (`PushMessagingRegistrar … NetworkCapability NN out of range`) — token looks valid
  but nothing is delivered. If you must use an emulator, use a **Google Play** image;
  if push still fails, **wipe data + cold boot**. **SHA fingerprints are NOT needed for
  FCM.** Ensure the project's **FCM API (V1)** is enabled.
- **iOS:** physical device only (no Simulator), needs the APNs key.
- **Tap-to-route:** send a **data** payload (`notificationType` + `route`); test
  foreground / background / terminated.
- **Image (rich) notifications:** add an `image` URL to the FCM `notification` block
  (OS renders when backgrounded; keep ≤ ~300 KB, e.g. `https://picsum.photos/400/200`);
  for foreground Android download bytes → `BigPictureStyleInformation`.
- **Local notification** (`flutter_local_notifications.show`) bypasses FCM/Play
  services — use a debug-only helper to verify display + routing on a broken emulator.

---

## Forbidden / gotchas
- Never add `firebase_messaging` / `flutter_local_notifications` to `core`.
- Never register the notification services in GetIt — `static final instance`.
- Never set up listeners / `getInitialMessage()` in `main()` — home screen first frame.
- Background handler: top-level + `@pragma('vm:entry-point')`, no navigation.
- Notification copy → `ValueConst`, not inline literals.
