# add-notification-feature

Adds **Firebase Cloud Messaging (FCM) push notifications** to one app under
`apps/{app}/`: device token, foreground/background/terminated handling, topic
subscriptions, **tap-to-open-a-page** routing, and **image (rich) notifications**.
FCM only — no CleverTap.

The guide is split into platform tracks — present the steps **separated by iOS and
Android** so the user can follow only the platform(s) they ship:

- **Part A — Shared Flutter code** (deps + Dart): identical for both platforms;
  always do it.
- **Part B — iOS track**: Apple/Firebase credential + Xcode capabilities.
- **Part C — Android track**: manifest permission + channel.
- **Part D — Test**: separate iOS and Android instructions.

Follow every step in the guide below. Notes on how this skill splits the work:

## 1. Pick the app, platform(s), and confirm Firebase is connected

If the app was not passed as an argument, list `apps/` and ask which one. Also ask
**which platform(s)** it targets — that decides whether you do Part B, Part C, or
both.

This skill **builds on** `/connect-firebase` — it does **not** run the FlutterFire
CLI itself. Verify the app is already connected:

```bash
ls apps/{app}/lib/firebase_options.dart
grep -n "firebase_core" apps/{app}/pubspec.yaml
grep -n "Firebase.initializeApp" apps/{app}/lib/main.dart
```

If any is missing → **stop**, tell the user to run `/connect-firebase` first, then
return here.

## 2. Part A — shared Flutter code (agent, both platforms)

Add `firebase_messaging` + `flutter_local_notifications` to **this app's**
`pubspec.yaml` (never `core`), then create under
`apps/{app}/lib/services/notification/` the payload, navigator key, local
notification service, router, and `FirebaseMessagingService` (static singleton — not
in GetIt), plus `notification_type.dart` enums. Register the background handler in
`main.dart`; call `FirebaseMessagingService.instance.init()` from the **home
screen's** `addPostFrameCallback`. This part is platform-agnostic.

### Don't-skip gotchas (these bit us on the first real run)

- **Don't hardcode versions** — `flutter pub add firebase_messaging
  flutter_local_notifications` and let pub match the app's `firebase_core` major
  (`core ^4 → messaging ^16`; `core ^3 → messaging ^15`).
- **`flutter_local_notifications` v22 uses named params** —
  `initialize(settings: …)`, `show(id: …, notificationDetails: …)`. The older
  positional form won't compile.
- **Android build needs core-library desugaring** (see Part C) — skipping it is the
  most common Gradle build failure.
- **Guard `getToken()` in try/catch** — it can throw (`FCM Registration failed`,
  transient `SERVICE_NOT_AVAILABLE`); don't let it crash `init()`.

### The home-screen init is load-bearing — don't move it to `main()`

Listeners and the terminated-state `getInitialMessage()` run from the home screen's
first frame, **not** `main()`. On iOS, querying the launch notification too early
drops the tap that opened the app from a killed state, and the router isn't mounted
yet. `addPostFrameCallback` guarantees both Firebase readiness and a mounted
navigator. Only the background-handler registration stays in `main()`.

## 3. Part B — iOS track (only if shipping iOS)

- **User:** upload an Apple **APNs auth key** to Firebase Console (Project settings
  → Cloud Messaging). iOS delivery depends on it; it's user-only (Apple portal +
  Console).
- **User (Xcode):** add **Push Notifications** + **Background Modes → Remote
  notifications** capabilities. The default `AppDelegate.swift` needs no edits.
- **Agent:** verify `aps-environment`, `UIBackgroundModes`, and the 15.0+
  deployment target.

## 4. Part C — Android track (only if shipping Android)

- **Agent (required):** enable **core-library desugaring** in
  `android/app/build.gradle.kts` (`isCoreLibraryDesugaringEnabled = true` +
  `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")`) — without it
  the Gradle build fails on `flutter_local_notifications`.
- **Agent:** add `POST_NOTIFICATIONS` to the manifest; optionally the
  `default_notification_channel_id` meta-data.
- No Firebase Console action — the existing `google-services.json` + Gradle plugin
  are enough.

## 5. Part D — hand the user the test steps (per platform)

> **Strongly recommend a real Android phone for FCM testing, not an emulator.**
> Emulator Google Play services is flaky for push: a "Google APIs" image fails
> `getToken()` with `IOException: FCM Registration failed!`, and even a Play image
> can crash its push registrar (`com.google.android.gms … PushMessagingRegistrar …
> NetworkCapability NN out of range`) after it auto-updates — the token looks valid
> but **nothing is ever delivered**. A physical device ships a matched Play-services
> build and Just Works. We burned real time on this — lead with the device.

Get the FCM token from the run log, then:
- **iOS:** physical device only (no Simulator), needs the APNs key; send a test from
  Firebase Console.
- **Android:** **physical device recommended.** If using an emulator it **must** be a
  Google _Play_ image (`google_apis_playstore` / Play Store icon); if push still
  doesn't arrive, **wipe data + cold boot** and check logcat for the
  `PushMessagingRegistrar` crash above (→ switch to a real device). SHA fingerprints
  are **not** needed for FCM.

Then send a **data payload** (`notificationType` + `route`) to test tap-to-route
across **foreground / background / terminated** on each platform. The terminated
case on iOS is the one the home-screen init exists to make work.

**Image (rich) notifications work too** — offer them to the user:
- **Push:** add an `image` URL to the FCM `notification` block; the OS renders it
  automatically when backgrounded. Keep it **≤ ~300 KB** (e.g.
  `https://picsum.photos/400/200`).
- **Foreground (Android):** download the bytes and show a `BigPictureStyleInformation`
  via the local-notification service.

**Emulator-only display/routing check (no push needed):** a local notification
(`flutter_local_notifications.show(...)`) bypasses FCM/Play services entirely, so it
renders and tap-routes even on a broken emulator — handy to verify the UI while
delivery is tested on a device. See the guide's "Testing local notifications without
push" and "Image (rich) notifications" sections.

@docs/how-to/add-notification-feature.md
