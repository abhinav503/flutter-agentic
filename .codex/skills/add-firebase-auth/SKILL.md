---
name: add-firebase-auth
description: >
  Add Firebase Authentication (email/password) to one app under apps/{app}/ as a full
  Clean-Architecture feature/auth/: sign up, sign in, sign out, a persistent
  email-verification bottom sheet (non-dismissible, 3-second poll, resumes correctly
  across app relaunches), and an optional backend profile sync (dual-write: Firebase
  Auth's own record + a Firestore users/{uid} doc via a server API that verifies the
  Firebase ID token). Proven pattern from apps/ecommerce/gravia. Builds on
  connect-firebase (the app must already be connected).
  Invoke with $add-firebase-auth or ask to add email/password login/signup to an app.
---

Adds **Firebase Authentication (email/password)** to one app under `apps/{app}/` as a
full Clean-Architecture `feature/auth/`. This skill **builds on** `$connect-firebase`
— it does not run the FlutterFire CLI itself.

> **Monorepo note:** `firebase_auth` is this app's own dependency — **never** add it
> to `core`.

> **Scope:** email/password only. Render Google/Apple buttons as UI stubs
> ("coming soon" snackbar) — real OAuth wiring is a separate, larger piece of work.

## Step 0 — Prerequisite: Firebase connected + Email/Password enabled

Verify:
```bash
ls apps/{app}/lib/firebase_options.dart
grep -n "firebase_core" apps/{app}/pubspec.yaml
grep -n "Firebase.initializeApp" apps/{app}/lib/main.dart
```
Missing any → **stop**, run `$connect-firebase` first.

Tell the user: Firebase Console → Authentication → Sign-in method → enable
**Email/Password**. Nothing here does this automatically; calls fail with
`operation-not-allowed` until it's on.

## Decide: backend dual-write or not

Firebase Auth alone has no place to store `name`/`mobile`. If the app has (or will
have) a backend with `firebase-admin`, do the server-side dual-write (Step 4) so a
shopper's profile survives a reinstall and other backend logic can read it. If
purely local, skip Step 4 and have the data source build `UserModel` straight from
`FirebaseAuthService` fields.

## Step 1 — Dependencies
```bash
cd apps/{app} && flutter pub add firebase_auth
```
Let pub match the app's `firebase_core` major — don't hardcode a version. Then
`flutter pub get` from the repo root.

## Step 2 — Native/version requirements
`/connect-firebase` already sets iOS 15.0+. Auth needs Android **minSdk 23+**
(higher than `firebase_core`'s 21+) — verify, don't assume:
```bash
grep -n "minSdk" apps/{app}/android/app/build.gradle.kts
```
If it reads `flutter.minSdkVersion`, no edit needed (current stable Flutter's floor
is 23+). No new native config files — Auth reuses what `/connect-firebase` wrote.

## Step 3 — `FirebaseAuthService` (static singleton, never in GetIt)
`lib/services/firebase_auth_service.dart`:
```dart
class FirebaseAuthService {
  FirebaseAuthService._();
  static final FirebaseAuthService instance = FirebaseAuthService._();

  // Never throws — web preview never calls Firebase.initializeApp(), and
  // widget tests mount auth-aware screens without a Firebase test app.
  User? get currentUser {
    try { return FirebaseAuth.instance.currentUser; }
    on FirebaseException { return null; }
  }

  Future<UserCredential> signUp({required String email, required String password}) =>
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  Future<UserCredential> signIn({required String email, required String password}) =>
      FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  Future<void> signOut() => FirebaseAuth.instance.signOut();
  Future<void> sendEmailVerification() async => currentUser?.sendEmailVerification();
  Future<void> updateDisplayName(String name) async => currentUser?.updateDisplayName(name);

  Future<bool> reloadAndCheckVerified() async {
    final user = currentUser;
    if (user == null) return false;
    await user.reload();
    return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  }

  // forceRefresh mints a token carrying the fresh email_verified claim.
  Future<String?> idToken({bool forceRefresh = false}) =>
      currentUser?.getIdToken(forceRefresh) ?? Future.value(null);
}

extension FirebaseAuthExceptionX on FirebaseAuthException {
  String get readableMessage => switch (code) {
    'email-already-in-use' => 'An account already exists with this email address.',
    'weak-password' => 'Password must be at least 6 characters.',
    'invalid-email' => 'Enter a valid email address.',
    'user-not-found' || 'wrong-password' || 'invalid-credential' => 'Incorrect email or password.',
    'too-many-requests' => 'Too many attempts. Please wait a moment and try again.',
    'network-request-failed' => 'Network error. Check your connection and try again.',
    _ => message ?? 'Something went wrong. Please try again.',
  };
}
```

## Step 4 — Backend dual-write (skip if no backend)

Server guard — verify the **ID token**, never trust a client-supplied uid:
```ts
export async function requireAuthedUser(request: Request) {
  const match = (request.headers.get("authorization") ?? "").match(/^Bearer (.+)$/);
  if (!match) throw new UnauthorizedError("Missing bearer token");
  try {
    const decoded = await adminAuth.verifyIdToken(match[1]);
    return { uid: decoded.uid, email: decoded.email ?? "", emailVerified: decoded.email_verified ?? false };
  } catch { throw new UnauthorizedError("Invalid or expired token"); }
}
```

`POST /api/users` — `uid`/`email`/`emailVerified` always from the token;
`name`/`mobile` optional body fields (so the same endpoint re-syncs just
`emailVerified` after the verification poll, without wiping the rest):
```ts
export async function POST(request: Request) {
  const auth = await requireAuthedUser(request);
  const body = await request.json().catch(() => ({}));
  const name = typeof body.name === "string" ? body.name : undefined;
  const mobile = typeof body.mobile === "string" ? body.mobile : undefined;
  const ref = adminDb.collection("users").doc(auth.uid);
  const existing = await ref.get();
  await ref.set({
    uid: auth.uid, email: auth.email, emailVerified: auth.emailVerified,
    ...(name !== undefined ? { name } : {}), ...(mobile !== undefined ? { mobile } : {}),
    updatedAt: new Date().toISOString(), ...(existing.exists ? {} : { createdAt: new Date().toISOString() }),
  }, { merge: true });
  return NextResponse.json(/* serialized doc */);
}
```

**Vercel + Next.js + `firebase-admin` gotcha:** `jose`/ESM Turbopack bundling bug
causes a 500 on any route calling `verifyIdToken`/`adminDb` in production only. Fix:
`serverExternalPackages: ["firebase-admin"]` in `next.config.ts`, `"build": "next
build --webpack"` in `package.json`, `"overrides": { "jose": "^5" }`. Verify with a
local `next build && next start` + `curl` before redeploying.

## Step 5 — `feature/auth/` Clean Architecture

**Thin repository, fat data source** — all orchestration (Firebase SDK + backend
sync) lives in `AuthRemoteDataSourceImpl`; the repository only calls the data source
and converts Model→Entity.

```
feature/auth/domain/{entities/user_entity.dart, repository/auth_repository.dart,
  usecase/{sign_up,sign_in,sign_out,resend_verification_email,check_email_verified,update_profile}_usecase.dart}
feature/auth/data/{models/user_model.dart, data_source/auth_remote_data_source(_impl).dart,
  repository_impl/auth_repository_impl.dart}
feature/auth/presentation/{bloc/{auth_bloc,auth_event,auth_state}.dart,
  view/{login,signup}_{page,screen}.dart, widgets/verify_email_sheet_content.dart}
```

Data source:
```dart
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl();

  Future<UserModel> signUp({required String name, required String email,
      required String mobile, required String password}) async {
    await FirebaseAuthService.instance.signUp(email: email, password: password);
    await FirebaseAuthService.instance.sendEmailVerification();
    final idToken = await FirebaseAuthService.instance.idToken();
    return _saveUserProfile(idToken: idToken!, name: name, mobile: mobile);
  }

  Future<UserModel> signIn({required String email, required String password}) async {
    await FirebaseAuthService.instance.signIn(email: email, password: password);
    final idToken = await FirebaseAuthService.instance.idToken();
    return _saveUserProfile(idToken: idToken!); // self-heals + re-syncs emailVerified
  }

  Future<UserModel?> checkEmailVerified() async {
    if (!await FirebaseAuthService.instance.reloadAndCheckVerified()) return null;
    final idToken = await FirebaseAuthService.instance.idToken(forceRefresh: true);
    if (idToken == null) return null;
    return _saveUserProfile(idToken: idToken);
  }

  Future<UserModel> _saveUserProfile({required String idToken, String? name, String? mobile}) async {
    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.usersPath, data: {'name': ?name, 'mobile': ?mobile},
      headers: {'Authorization': 'Bearer $idToken'});
    return UserModel.fromJson(response.data!);
  }
}
```
(No backend → drop `_saveUserProfile`/`HttpService`; build `UserModel` straight from
`FirebaseAuthService`'s `currentUser` fields.)

Repository — every Firebase-calling method wrapped in
`on FirebaseAuthException catch (e) => left(Failure.unexpected(message: e.readableMessage))`,
layered on top of `BaseRepository.handleRequest`, not instead of it.

Register in `injection_container.dart`, data source → repository → use cases order.

## Step 6 — `AuthBloc`: states, poll, relaunch resume

States: `initial, loading, awaitingVerification({email}), authenticated({user}),
unauthenticated, error({message})`.

- `AuthStarted` (dispatched once per bloc creation, from every screen that can resume
  a session — Login, Signup, the app shell): reads `FirebaseAuthService.currentUser`
  **and** a persisted pending-verification flag. Session + pending → re-enter
  `awaitingVerification` (reopens the sheet). No session → `unauthenticated`. This is
  what makes a kill-and-relaunch mid-verification resume correctly instead of falling
  through to Home.
- `AuthSignUpRequested` success → `awaitingVerification` + start
  `Timer.periodic(Duration(seconds: 3))` dispatching `AuthVerificationTicked`.
- `AuthLoginRequested` → already-verified user goes straight to `authenticated`;
  unverified also enters `awaitingVerification`.
- `AuthVerificationTicked` → calls `checkEmailVerified`; `null` (still unverified) is
  a no-op, only a real result flips to `authenticated` and cancels the timer.
- Module-level key: `const kPendingEmailVerificationPrefKey = 'pending_email_verification';`
  — set `true` entering `awaitingVerification`, `false` on verified success **and**
  on sign-out (a stale `true` wrongly reopens the sheet for the next account on the
  device).
- `close()` cancels the timer — don't leak a live `Timer.periodic`.

## Step 7 — Persistent verify-email sheet

Top-level function (not just a screen-state extension — Login/Signup open it after
signing up/in, and the app shell opens it on relaunch resume, two different state
types):
```dart
Future<void> showVerifyEmailSheet({required BuildContext context, required String email,
    required VoidCallback onResend}) => showModalBottomSheet<void>(
  context: context, isScrollControlled: true,
  isDismissible: false, enableDrag: false, backgroundColor: Colors.transparent,
  builder: (_) => VerifyEmailSheetContent(email: email, onResend: onResend));
```
Content wrapped in `PopScope(canPop: false, ...)` too — blocks Android back on top of
the gesture blocks above. Only action: "Resend email" (client-side 30s cooldown via
its own `Timer.periodic`, no bloc involved).

Wire open/close at the shell level:
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAwaitingVerification) _openVerifySheet(state.email);
    if (state is AuthAuthenticated) _closeVerifySheet();
  },
  child: child)
```
Track a `_verifySheetOpen` bool to avoid stacking a duplicate sheet; close via
`Navigator.of(context).pop()` guarded by `canPop()`.

Google/Apple buttons: render + wire to a "coming soon" snackbar; real OAuth is future
work but the UI slot should exist now.

## Step 8 — Local profile cache (skip the loader flash)

```dart
class UserProfileCacheService { // lib/services/, static singleton, never in GetIt
  UserProfileCacheService._();
  static final UserProfileCacheService instance = UserProfileCacheService._();
  static const _key = 'cached_user_profile';
  Future<void> save(Map<String, dynamic> json) =>
      SharedPreferenceService.instance.setString(_key, jsonEncode(json));
  Map<String, dynamic>? read() {
    final raw = SharedPreferenceService.instance.getString(_key);
    return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
  }
  Future<void> clear() => SharedPreferenceService.instance.remove(_key);
}
```
- Write-through in `AuthRepositoryImpl`: save `model.toJson()` right before returning
  in `signUp`/`signIn`/`checkEmailVerified` (non-null result) and `updateProfile`.
- Cache-first read in the profile feature's repository (leave its bloc/screen
  untouched — the live fetch stays the cold-cache fallback):
  ```dart
  Future<Either<Failure, ProfileEntity>> getProfile() => handleRequest(() async {
    final cached = UserProfileCacheService.instance.read();
    if (cached != null) return right(ProfileModel.fromJson(cached).toEntity());
    final model = await _dataSource.getProfile();
    await UserProfileCacheService.instance.save(model.toJson());
    return right(model.toEntity());
  });
  ```
- Clear on sign-out, alongside `FirebaseAuthService.signOut()` and the pending-flag
  reset (Step 6) — otherwise a different account on the same device inherits stale
  cached data.
- If the profile feature's `*Model` uses different field names, add a `@JsonKey`
  mapping so it can parse the same JSON blob the auth side wrote — no separate cache
  shape needed.

## Step 9 — Edit Profile (optional, needs Step 4)

Second dual-write, reusing `_saveUserProfile`:
```dart
Future<UserModel> updateProfile({required String name, required String mobile}) async {
  await FirebaseAuthService.instance.updateDisplayName(name);
  final idToken = await FirebaseAuthService.instance.idToken();
  return _saveUserProfile(idToken: idToken!, name: name, mobile: mobile);
}
```
Give the edit screen its own thin bloc (`initial/saving/success/error`,
`submitted({name, mobile})`) calling `UpdateProfileUseCase` — never call
`sl<UseCase>()` directly from a screen. On success, save into the cache and pop.

**Email should be read-only** in this form. Firebase's `updateEmail()` is deprecated;
`verifyBeforeUpdateEmail` sends its own confirmation link and is a separate, bigger
feature — don't fold it into a plain profile edit.

## Step 10 — Web safety (required)

Guard every Firebase Auth entry point:
```dart
if (kIsWeb) {
  emit(const AuthState.error(message: ValueConst.authWebUnsupportedMessage));
  return;
}
```
Apps preview as Flutter Web where `Firebase.initializeApp()` is never called — block
auth outright with a friendly message rather than letting the call throw. Adding real
web auth later is an intentional, separate upgrade (web platform in
`flutterfire configure`, handle JS SDK popup/redirect flows).

## Verify

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # new Freezed models/bloc files
flutter analyze apps/{app}
flutter test
```

## Forbidden / gotchas

- Never add `firebase_auth` to `core`.
- Never register `FirebaseAuthService` / `UserProfileCacheService` in GetIt.
- Never trust a client-supplied uid on the backend — only `adminAuth.verifyIdToken`'s
  decoded claims.
- Never let `FirebaseAuthService.currentUser` throw — guard with `on FirebaseException`.
- Poll timer lifecycle belongs entirely to the bloc — start it, cancel it on success,
  cancel it in `close()`.
- Don't skip the pending-verification pref key — without it, a kill-and-relaunch
  mid-verification drops the user on Home instead of resuming the sheet.
- Don't forget to clear both the cache and the pending-verification flag on sign-out.
- Auth/sheet copy is app copy → `ValueConst`, never inline literals.
