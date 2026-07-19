# add-firebase-auth

Adds **Firebase Authentication (email/password)** to one app under `apps/{app}/` as a
full Clean-Architecture `feature/auth/`: sign up, sign in, sign out, a **persistent
email-verification bottom sheet** (non-dismissible, 3-second poll, correctly resumes
across app relaunches), and an optional **backend profile sync** (dual-write:
Firebase Auth's own record + a Firestore `users/{uid}` doc via a server API that
verifies the Firebase ID token). This is the proven pattern from `apps/ecommerce/gravia`.

Follow every step in the guide below. Notes on how this skill splits the work:

## 1. Confirm Firebase is connected, and ask about a backend

This skill **builds on** `/connect-firebase` — it does not run the FlutterFire CLI.
Verify:

```bash
ls apps/{app}/lib/firebase_options.dart
grep -n "firebase_core" apps/{app}/pubspec.yaml
grep -n "Firebase.initializeApp" apps/{app}/lib/main.dart
```

Missing any → **stop**, tell the user to run `/connect-firebase` first.

Also tell the user: enable **Email/Password** under Firebase Console → Authentication
→ Sign-in method — nothing here turns it on automatically, and calls fail with
`operation-not-allowed` until it is.

Ask whether the app has (or will have) a backend to sync profile fields
(name/mobile/etc.) to. If yes, do Step 4 of the guide (server-side token
verification + `/api/users` upsert) before wiring the Flutter data source, since the
data source's `_saveUserProfile` calls that endpoint. If no, skip it and simplify the
data source to build `UserModel` straight from `FirebaseAuthService`.

## 2. Dependencies and native requirements (agent)

```bash
cd apps/{app} && flutter pub add firebase_auth
```

Don't hardcode a version — let it match the app's `firebase_core` major. Then verify
(don't assume) Android `minSdk` is 23+ — Auth's floor is higher than
`firebase_core`'s 21+:

```bash
grep -n "minSdk" apps/{app}/android/app/build.gradle.kts
```

If it already reads `flutter.minSdkVersion`, no edit needed (current stable Flutter's
floor is 23+). No new native config files are needed — Auth reuses what
`/connect-firebase` already wrote.

## 3. Build the feature (agent)

In order: `FirebaseAuthService` (static singleton in `lib/services/`, never in
GetIt) → (if backend) the server guard + `/api/users` route → `feature/auth/`'s
three layers, with the **thin-repository / fat-data-source** split — all Firebase
SDK calls and backend sync live in `AuthRemoteDataSourceImpl`, the repository only
calls the data source and converts Model→Entity → `AuthBloc` (states: initial,
loading, awaitingVerification, authenticated, unauthenticated, error; the 3s poll
timer + `kPendingEmailVerificationPrefKey` persisted flag for relaunch-resume) → the
persistent verify-email sheet (top-level function, `isDismissible: false`,
`enableDrag: false`, content wrapped in `PopScope(canPop: false, ...)`) → Login/Signup
screens → wire the sheet's open/close into whatever shell/home widget hosts the app
post-login via a `BlocListener<AuthBloc, AuthState>`.

If doing the profile-cache and edit-profile pieces (Steps 8–9 of the guide), also
add `UserProfileCacheService` and wire cache-first reads into the profile feature's
repository, and clear both the cache and the pending-verification pref key on
sign-out.

Always guard every Firebase Auth call with `kIsWeb` (apps preview as Flutter Web,
where `Firebase.initializeApp()` is never called) — emit a friendly
`ValueConst`-backed error instead of letting the call throw.

## 4. Verify

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # new Freezed models/bloc files
flutter analyze apps/{app}
flutter test
```

@docs/how-to/add-firebase-auth.md
