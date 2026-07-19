# How to Add Firebase Email/Password Auth to an App

Wires **Firebase Authentication (email/password)** into one app under `apps/{app}/`
as a full Clean-Architecture `feature/auth/`: sign up, sign in, sign out, a
**persistent email-verification flow** (non-dismissible bottom sheet, 3-second poll,
resumes correctly across app relaunches), and an optional **backend profile sync**
(dual-write: Firebase Auth's own record + your Firestore `users/{uid}` doc via a
server API). This is the exact pattern built for `apps/ecommerce/gravia` — proven
end-to-end, not a sketch.

> **Monorepo note:** like Firebase itself, auth is **per app**. Every path below is
> relative to the target app folder `apps/{app}/`. `firebase_auth` is this app's own
> dependency — **never add it to `core`**.

> **Scope:** email/password only. Google/Apple sign-in buttons can be stubbed as
> "coming soon" in the UI (see Step 7) but wiring real OAuth providers is a separate,
> larger piece of work not covered here.

---

## Step 0 — Prerequisite: Firebase must already be connected

This skill **builds on** `/connect-firebase`. Verify the app is already connected:

```bash
ls apps/{app}/lib/firebase_options.dart
grep -n "firebase_core" apps/{app}/pubspec.yaml
grep -n "Firebase.initializeApp" apps/{app}/lib/main.dart
```

Any missing → **stop**, run `/connect-firebase` first, then come back here.

**Also required, one-time, in the Firebase Console (user):** Authentication →
**Sign-in method** → enable **Email/Password**. Nothing under `/connect-firebase`
turns this on by itself — sign-up/sign-in calls fail with
`operation-not-allowed` until it's enabled.

---

## Decide: is there a backend to dual-write to?

Firebase Auth alone gives you an authenticated user (uid, email, `emailVerified`)
but **no place to store `name`/`mobile`/other profile fields** — Auth only has a
`displayName`/`photoURL`. Two shapes:

| | No backend | With backend (this guide's default) |
|---|---|---|
| Profile fields (name, mobile, …) | Store on `updateDisplayName` only, or skip | Firestore `users/{uid}` doc |
| Who verifies the user is who they claim | N/A | Server verifies the **Firebase ID token** (`adminAuth.verifyIdToken`) — never trust a client-supplied uid |
| Complexity | Lower — skip Steps 4 and the data source's `_saveUserProfile` calls | One more endpoint, but the sync is one small helper |

If your app has (or will have) a server component (Next.js/Express/etc. with
`firebase-admin`), do the dual-write — it's what lets a shopper's name/mobile survive
a reinstall and lets other backend logic (order emails, admin dashboards) read the
same profile. If it's a pure local-only app, skip Step 4 and simplify
`AuthRemoteDataSourceImpl` to call `FirebaseAuthService` only.

---

## Step 1 — Dependencies (agent)

`firebase_auth`'s major version must match the app's existing `firebase_core` major
— don't hardcode versions, let pub resolve:

```bash
cd apps/{app} && flutter pub add firebase_auth
```

If you're doing the backend dual-write and the app doesn't already call your API,
also add `dio` (it almost certainly already does, via `HttpService` in `core`).

Then resolve from the **repo root**:

```bash
flutter pub get
```

---

## Step 2 — Native/version requirements (agent, verify)

`/connect-firebase` already bumps iOS to 15.0+ for `firebase_core`. Auth has one
**additional** requirement `connect-firebase` doesn't check:

- **Android `minSdk` must be 23+** (Firebase Auth's own floor, higher than
  `firebase_core`'s 21+). Most apps already inherit `flutter.minSdkVersion`, which is
  23+ on current stable Flutter — verify, don't assume:
  ```bash
  grep -n "minSdk" apps/{app}/android/app/build.gradle.kts
  ```
  If it's hardcoded below 23, bump it. If it reads `flutter.minSdkVersion`, it's
  already covered by the Flutter SDK's own floor — no edit needed.
- **No new native config files.** Auth reuses the same `google-services.json` /
  `GoogleService-Info.plist` / `firebase_options.dart` that `/connect-firebase`
  already wrote — there's nothing Auth-specific to add on the native side, unlike
  push notifications (APNs key) or Google Sign-In (SHA fingerprints, which you'd
  only need if you later add the Google button for real).

---

## Step 3 — `FirebaseAuthService` (agent)

A static singleton wrapping `FirebaseAuth.instance` — same pattern as
`HttpService`/`SharedPreferenceService`: private constructor, `static final
instance`, **never registered in GetIt**.

`apps/{app}/lib/services/firebase_auth_service.dart`:

```dart
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuthService._();
  static final FirebaseAuthService instance = FirebaseAuthService._();

  /// Read on every screen that resumes a session — including on web (where
  /// Firebase.initializeApp() is never called, per main.dart's kIsWeb guard)
  /// and in widget tests that mount those screens without a Firebase test
  /// app. Neither should throw: no initialized Firebase app honestly means
  /// no signed-in user, not a crash.
  User? get currentUser {
    try {
      return FirebaseAuth.instance.currentUser;
    } on FirebaseException {
      return null;
    }
  }

  Future<UserCredential> signUp({required String email, required String password}) =>
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signIn({required String email, required String password}) =>
      FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => FirebaseAuth.instance.signOut();

  Future<void> sendEmailVerification() async {
    await currentUser?.sendEmailVerification();
  }

  Future<void> updateDisplayName(String displayName) async {
    await currentUser?.updateDisplayName(displayName);
  }

  /// Reloads off Firebase and returns the fresh `emailVerified` flag — never
  /// throws, so a poller can call this unconditionally.
  Future<bool> reloadAndCheckVerified() async {
    final user = currentUser;
    if (user == null) return false;
    await user.reload();
    return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  }

  /// `forceRefresh: true` mints a token carrying the current `email_verified`
  /// claim — needed right after verification, since a previously-issued
  /// token is stale until refreshed.
  Future<String?> idToken({bool forceRefresh = false}) =>
      currentUser?.getIdToken(forceRefresh) ?? Future.value(null);
}

/// e.message alone is often terse ("The email address is badly formatted.")
/// or missing entirely — map codes to copy users can act on.
extension FirebaseAuthExceptionX on FirebaseAuthException {
  String get readableMessage => switch (code) {
    'email-already-in-use' => 'An account already exists with this email address.',
    'weak-password' => 'Password must be at least 6 characters.',
    'invalid-email' => 'Enter a valid email address.',
    'user-not-found' || 'wrong-password' || 'invalid-credential' =>
      'Incorrect email or password.',
    'too-many-requests' => 'Too many attempts. Please wait a moment and try again.',
    'network-request-failed' => 'Network error. Check your connection and try again.',
    _ => message ?? 'Something went wrong. Please try again.',
  };
}
```

> **Why `currentUser` swallows `FirebaseException`:** apps in this repo are
> **previewed as Flutter Web**, where `Firebase.initializeApp()` is deliberately
> never called (see `/connect-firebase`'s `kIsWeb` guard). Any code path that reads
> `currentUser` unconditionally — a bloc's `started()` handler, a splash screen — must
> not crash just because Firebase was never initialized. Same reasoning covers widget
> tests that mount an auth-aware screen without a Firebase test app.

---

## Step 4 — Backend dual-write (skip if no backend — see the decision above)

### Server: verify the ID token, never trust the client (agent, backend repo)

Add a guard that verifies the **Firebase ID token**, not any client-supplied uid —
identity claims only ever come from `adminAuth.verifyIdToken`'s decoded result:

```ts
// lib/api/admin-guard.ts
import { adminAuth } from "@/lib/firebase-admin";

export class UnauthorizedError extends Error {}

export async function requireAuthedUser(
  request: Request,
): Promise<{ uid: string; email: string; emailVerified: boolean }> {
  const authHeader = request.headers.get("authorization") ?? "";
  const match = authHeader.match(/^Bearer (.+)$/);
  if (!match) throw new UnauthorizedError("Missing bearer token");

  try {
    const decoded = await adminAuth.verifyIdToken(match[1]);
    return {
      uid: decoded.uid,
      email: decoded.email ?? "",
      emailVerified: decoded.email_verified ?? false, // only true post force-refresh
    };
  } catch {
    throw new UnauthorizedError("Invalid or expired token");
  }
}
```

### Server: upsert the profile doc, body fields optional (agent, backend repo)

`POST /api/users` — `uid`/`email`/`emailVerified` **always** come from the verified
token; `name`/`mobile` are optional body fields so the same endpoint can (a) set them
right after signup, and (b) re-sync just `emailVerified` after the verification poll
succeeds, without overwriting the rest of the profile:

```ts
// app/api/users/route.ts
export async function POST(request: Request) {
  const auth = await requireAuthedUser(request); // 401 on failure — see the guide's guard
  const body = await request.json().catch(() => ({}));
  const name = typeof body.name === "string" ? body.name : undefined;
  const mobile = typeof body.mobile === "string" ? body.mobile : undefined;

  const ref = adminDb.collection("users").doc(auth.uid);
  const existing = await ref.get();
  const now = new Date().toISOString();

  await ref.set(
    {
      uid: auth.uid,
      email: auth.email,
      emailVerified: auth.emailVerified,
      ...(name !== undefined ? { name } : {}),
      ...(mobile !== undefined ? { mobile } : {}),
      updatedAt: now,
      ...(existing.exists ? {} : { createdAt: now }),
    },
    { merge: true },
  );

  return NextResponse.json({ /* serialize uid/name/email/mobile/emailVerified */ });
}

export async function GET(request: Request) {
  const auth = await requireAuthedUser(request);
  const snap = await adminDb.collection("users").doc(auth.uid).get();
  if (!snap.exists) return NextResponse.json({ error: "Profile not found" }, { status: 404 });
  return NextResponse.json({ /* serialize snap.data() */ });
}
```

**If the backend is Next.js on Vercel + `firebase-admin`**, watch for the
`jose`/ESM Turbopack bundling bug: `serverExternalPackages: ["firebase-admin"]` in
`next.config.ts`, `"build": "next build --webpack"` in `package.json`, and
`"overrides": { "jose": "^5" }`. Symptom is a 500 on any route calling
`verifyIdToken`/`adminDb` in production only (works locally). Verify with a local
`next build && next start` + `curl` before redeploying.

---

## Step 5 — `feature/auth/` — Clean Architecture (agent)

Standard 3-layer shape (see `docs/reference/architecture.md`), one deliberate rule:
**the repository is a thin pass-through; all orchestration (Firebase SDK calls +
backend sync) lives in the data source.** The repository's only job is call data
source → convert Model→Entity → done. This keeps the data source swappable
(different backend, different Firebase config) without touching the repository.

```
feature/auth/
├── domain/
│   ├── entities/user_entity.dart          uid, name, email, mobile, emailVerified
│   ├── repository/auth_repository.dart    abstract interface
│   └── usecase/
│       ├── sign_up_usecase.dart
│       ├── sign_in_usecase.dart
│       ├── sign_out_usecase.dart
│       ├── resend_verification_email_usecase.dart
│       ├── check_email_verified_usecase.dart   returns UserEntity? (null = still unverified)
│       └── update_profile_usecase.dart          only if you built Step 4 + edit-profile
├── data/
│   ├── models/user_model.dart             @freezed + @JsonSerializable, fromEntity/toEntity
│   ├── data_source/
│   │   ├── auth_remote_data_source.dart       abstract interface
│   │   └── auth_remote_data_source_impl.dart  owns Firebase SDK + backend sync
│   └── repository_impl/auth_repository_impl.dart
└── presentation/
    ├── bloc/{auth_bloc,auth_event,auth_state}.dart
    ├── view/{login,signup}_{page,screen}.dart
    └── widgets/verify_email_sheet_content.dart
```

### The data source — where the dual-write actually happens

```dart
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl();

  @override
  Future<UserModel> signUp({required String name, required String email,
      required String mobile, required String password}) async {
    await FirebaseAuthService.instance.signUp(email: email, password: password);
    await FirebaseAuthService.instance.sendEmailVerification();
    final idToken = await FirebaseAuthService.instance.idToken();
    return _saveUserProfile(idToken: idToken!, name: name, mobile: mobile);
  }

  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    await FirebaseAuthService.instance.signIn(email: email, password: password);
    final idToken = await FirebaseAuthService.instance.idToken();
    // No name/mobile — self-heals a missing profile doc and re-syncs
    // emailVerified without overwriting the existing name/mobile.
    return _saveUserProfile(idToken: idToken!);
  }

  @override
  Future<UserModel?> checkEmailVerified() async {
    final verified = await FirebaseAuthService.instance.reloadAndCheckVerified();
    if (!verified) return null;
    final idToken = await FirebaseAuthService.instance.idToken(forceRefresh: true);
    if (idToken == null) return null;
    return _saveUserProfile(idToken: idToken);
  }

  /// name/mobile optional — omit both to just re-sync emailVerified.
  Future<UserModel> _saveUserProfile({required String idToken, String? name, String? mobile}) async {
    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.usersPath,
      data: {'name': ?name, 'mobile': ?mobile},
      headers: {'Authorization': 'Bearer $idToken'},
    );
    return UserModel.fromJson(response.data!);
  }
}
```

(No backend? Drop `_saveUserProfile`/`HttpService` entirely — each method just
returns a `UserModel` built from `FirebaseAuthService`'s `currentUser` fields.)

### The repository — thin, maps `FirebaseAuthException` → `Failure`

```dart
class AuthRepositoryImpl with BaseRepository implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UserEntity>> signUp({required String name, required String email,
      required String mobile, required String password}) => handleRequest(() async {
    try {
      final model = await _dataSource.signUp(name: name, email: email, mobile: mobile, password: password);
      return right(model.toEntity());
    } on FirebaseAuthException catch (e) {
      return left(Failure.unexpected(message: e.readableMessage));
    }
  });
  // signIn / checkEmailVerified / resendVerificationEmail / updateProfile: same shape
}
```

Every method needing Firebase calls is wrapped in `on FirebaseAuthException catch`
mapped through `readableMessage` — `handleRequest`'s own Dio-error mapping doesn't
know about `FirebaseAuthException`, so this is layered on top of it, not instead of
it.

Register in `injection_container.dart`, same order every feature uses (data source →
repository → use cases):

```dart
sl.registerLazySingleton<AuthRemoteDataSource>(() => const AuthRemoteDataSourceImpl());
sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
sl.registerLazySingleton(() => SignUpUseCase(sl()));
sl.registerLazySingleton(() => SignInUseCase(sl()));
sl.registerLazySingleton(() => SignOutUseCase(sl()));
sl.registerLazySingleton(() => ResendVerificationEmailUseCase(sl()));
sl.registerLazySingleton(() => CheckEmailVerifiedUseCase(sl()));
```

---

## Step 6 — `AuthBloc` — states, the verification poll, and relaunch resume

```dart
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.awaitingVerification({required String email}) = AuthAwaitingVerification;
  const factory AuthState.authenticated({required UserEntity user}) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  // Only `message` (shown via a snackbar) — Login/Signup are forms with
  // screen-local TextEditingControllers, so retry is "edit + tap again",
  // not an ErrorView-style auto-retry the bloc would need context for.
  const factory AuthState.error({required String message}) = AuthError;
}
```

Key behaviors, all inside `AuthBloc`:

- **`AuthStarted`** (dispatched once on bloc creation from every screen that can
  resume a session — Login, Signup, and the app shell): reads
  `FirebaseAuthService.currentUser` **and** a persisted "pending verification" flag.
  Session exists + still pending → re-enter `awaitingVerification` (re-opens the
  sheet). No session → `unauthenticated`. This is what makes killing the app mid
  verification, then relaunching, land back on the verify sheet instead of silently
  falling through to Home.
- **`AuthSignUpRequested`** → on success, enters `awaitingVerification` and starts a
  `Timer.periodic(Duration(seconds: 3))` dispatching `AuthVerificationTicked`.
- **`AuthLoginRequested`** → if the returned user's `emailVerified` is already true,
  goes straight to `authenticated`; otherwise also enters `awaitingVerification` (an
  unverified user logging back in gets the same sheet, not silent access).
- **`AuthVerificationTicked`** → calls `checkEmailVerified` every tick; a `null`
  result (still unverified) is a no-op — the sheet never closes on its own, only a
  real verified result flips to `authenticated` and cancels the timer.
- A module-level pref key persists the pending flag across relaunches:
  ```dart
  const kPendingEmailVerificationPrefKey = 'pending_email_verification';
  ```
  Set `true` on entering `awaitingVerification`, set `false` the moment verification
  succeeds (`AuthVerificationTicked`'s success branch) **and** on sign-out (see Step
  8) — a stale `true` would wrongly reopen the sheet for the next account on the same
  device.
- `close()` cancels the timer — a bloc with a live `Timer.periodic` that outlives its
  own disposal is a leak.

---

## Step 7 — The persistent verify-email sheet

Presented via a **top-level function**, not just a `BaseScreenState` extension —
it has two call sites outside any single screen's state: Login/Signup open it right
after signing up/in, and the app's shell (a `BasePageState`, not a
`BaseScreenState`) opens it on relaunch to resume a pending session.

```dart
Future<void> showVerifyEmailSheet({
  required BuildContext context,
  required String email,
  required VoidCallback onResend,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  isDismissible: false,   // no tap-outside dismiss
  enableDrag: false,      // no swipe dismiss
  backgroundColor: Colors.transparent,
  builder: (_) => VerifyEmailSheetContent(email: email, onResend: onResend),
);
```

Inside `VerifyEmailSheetContent`, wrap the content in `PopScope(canPop: false, ...)`
too — `isDismissible`/`enableDrag` block gesture dismissal, `PopScope` additionally
blocks the Android back button. There is genuinely no way out except the email
actually getting verified; "Resend email" (client-side 30s cooldown via its own
`Timer.periodic`, no bloc involvement needed) is the only action.

**Wiring at the shell level** — whatever your bottom-nav/home shell widget is,
provide an `AuthBloc` and listen for the two states that open/close the sheet:

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAwaitingVerification) _openVerifySheet(state.email);
    if (state is AuthAuthenticated) _closeVerifySheet();
  },
  child: child,
)
```

Track `_verifySheetOpen` as a bool to avoid stacking a second sheet if the bloc
re-emits `awaitingVerification`, and close by `Navigator.of(context).pop()` guarded
by `canPop()`.

**Google/Apple buttons**: render them, wire `onTap` to a "coming soon" snackbar —
real OAuth is out of scope for this pass, but the UI slot should exist from day one
so adding the real provider later is additive, not a redesign.

---

## Step 8 — Local profile cache (avoids a loader flash on every profile view)

Profile screens re-fetching from the network on every tab visit is a bad UX default
— you already have the user's data from the last auth call. A tiny cache-first read
fixes it entirely at the **data layer**, with zero changes to the profile feature's
bloc/screen:

```dart
// lib/services/user_profile_cache_service.dart — static singleton, same pattern
class UserProfileCacheService {
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

- **Write-through**: `AuthRepositoryImpl` calls `UserProfileCacheService.save(model.toJson())`
  right before returning `right(model.toEntity())` in `signUp`/`signIn`/
  `checkEmailVerified` (only when the model is non-null) and `updateProfile`.
- **Cache-first read**: the profile feature's repository checks the cache before
  calling its own data source/use case:
  ```dart
  Future<Either<Failure, ProfileEntity>> getProfile() => handleRequest(() async {
    final cached = UserProfileCacheService.instance.read();
    if (cached != null) return right(ProfileModel.fromJson(cached).toEntity());
    final model = await _dataSource.getProfile();
    await UserProfileCacheService.instance.save(model.toJson());
    return right(model.toEntity());
  });
  ```
  Keep the profile feature's live-fetch use case/bloc **untouched** — it's still the
  real path on a cold cache (fresh install, cleared storage) and stays available for
  an explicit refresh later.
- **Clear on sign-out**, alongside `FirebaseAuthService.signOut()` — otherwise a
  different account signing in later on the same device would see the previous
  user's cached profile:
  ```dart
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuthService.instance.signOut();
    await UserProfileCacheService.instance.clear();
    await SharedPreferenceService.instance.setBool(kPendingEmailVerificationPrefKey, false);
    if (context.mounted) context.go(AppRoutes.login);
  }
  ```
- The cached JSON is just `UserModel.toJson()`'s shape. If your profile feature's
  `*Model` uses different field names (e.g. `mobile` → `phone`), give it a
  `@JsonKey(name: 'mobile')` mapping so `ProfileModel.fromJson(cached)` reads the
  same blob the auth side wrote — no separate cache shape/converter needed.

---

## Step 9 — Edit Profile (optional, needs Step 4's backend)

If the app lets users edit their name/mobile, that's a **second dual-write** (not
just a read): Firebase Auth's `updateDisplayName` **and** the backend sync, reusing
the same `_saveUserProfile` helper from Step 5's data source:

```dart
Future<UserModel> updateProfile({required String name, required String mobile}) async {
  await FirebaseAuthService.instance.updateDisplayName(name);
  final idToken = await FirebaseAuthService.instance.idToken();
  return _saveUserProfile(idToken: idToken!, name: name, mobile: mobile);
}
```

Give the edit screen its own thin bloc (`initial/saving/success/error`) dispatching
one `submitted({name, mobile})` event into `UpdateProfileUseCase` — every use-case
call in this codebase happens inside a bloc, never `sl<UseCase>()` called directly
from a screen. On success, save the returned model into the cache (Step 8) and pop
back to the caller.

**Email should be read-only** in this form (render the field `enabled: false`).
Firebase's `updateEmail()` is deprecated; the live replacement
(`verifyBeforeUpdateEmail`) sends its own confirmation link and only applies once
clicked — a second async verification flow, materially bigger than a plain field
edit. Treat "let users change their email" as a separate feature, not part of this
one.

---

## Step 10 — Web safety (required — apps preview as Flutter Web)

Guard every entry point that starts a Firebase Auth call:

```dart
if (kIsWeb) {
  emit(const AuthState.error(message: ValueConst.authWebUnsupportedMessage));
  return;
}
```

This repo's convention is to **block auth outright on web** with a friendly message,
not attempt it — `Firebase.initializeApp()` is never called on web (`main.dart`'s
`kIsWeb` guard from `/connect-firebase`), so any Firebase Auth call there would throw
anyway. If your app genuinely needs web auth later, that's an intentional upgrade
(add web to `flutterfire configure --platforms`, remove these guards, and handle
Firebase JS SDK's popup/redirect quirks) — not something to half-support by accident.

---

## Step 11 — Session invalidation guard (required if you ever revoke sessions)

Anything that revokes this device's refresh token out-of-band — a password reset via
`sendPasswordResetEmail`'s emailed link, changing the password from another device,
admin-disabling the account — leaves `FirebaseAuth.instance.currentUser` looking
signed-in locally.
The device only discovers this the next time *some* authenticated call tries to mint a
fresh ID token and the refresh fails. Without a guard, that surfaces as whatever
generic error screen the feature that happened to make the call already has (e.g.
Profile's `ErrorView` + a Retry button that fails forever) — not a "please sign in
again," and not every authenticated screen necessarily hits this at the same time
(a screen backed by cached data, or a public endpoint like a storefront read, won't).

**Centralize in `FirebaseAuthService.idToken()`** — every authenticated data source
already calls it, so it's the one choke point:

```dart
static const _deadSessionCodes = {
  'user-token-expired',
  'invalid-user-token',
  'user-disabled',
  'user-not-found',
};

/// Fires exactly once whenever idToken() discovers a dead session — the
/// app-level SessionExpiredGuard listens here and redirects to Login.
final ValueNotifier<int> sessionExpired = ValueNotifier<int>(0);

Future<String?> idToken({bool forceRefresh = false}) async {
  final user = currentUser;
  if (user == null) return null;
  try {
    return await user.getIdToken(forceRefresh);
  } on FirebaseAuthException catch (e) {
    if (_deadSessionCodes.contains(e.code)) {
      await FirebaseAuth.instance.signOut();
      sessionExpired.value++;
    }
    rethrow;
  }
}
```

Keep `_deadSessionCodes` narrow — codes that mean the credential is permanently
invalid, not transient failures like `network-request-failed`, which must **not**
sign the user out.

**React app-wide, once, in `app.dart`** — a small guard above the router (via
`MaterialApp.router`'s `builder`) clears the profile cache + pending-verification
flag, shows a snackbar (via a `scaffoldMessengerKey`, since this level has no
`Scaffold` of its own), and redirects to Login:

```dart
final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class _SessionExpiredGuard extends StatefulWidget {
  final Widget? child;
  const _SessionExpiredGuard({required this.child});
  @override
  State<_SessionExpiredGuard> createState() => _SessionExpiredGuardState();
}

class _SessionExpiredGuardState extends State<_SessionExpiredGuard> {
  @override
  void initState() {
    super.initState();
    FirebaseAuthService.instance.sessionExpired.addListener(_handleExpired);
  }

  @override
  void dispose() {
    FirebaseAuthService.instance.sessionExpired.removeListener(_handleExpired);
    super.dispose();
  }

  Future<void> _handleExpired() async {
    await UserProfileCacheService.instance.clear();
    await SharedPreferenceService.instance.setBool(kPendingEmailVerificationPrefKey, false);
    _scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text(ValueConst.sessionExpiredMessage)),
    );
    _router.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) => widget.child ?? const SizedBox.shrink();
}

// in MaterialApp.router(...):
scaffoldMessengerKey: _scaffoldMessengerKey,
builder: (context, child) => _SessionExpiredGuard(child: child),
```

**Why not just listen to `authStateChanges()`?** It's the more commonly reached-for
API, but it only reliably fires on an explicit local sign-in/out call or the SDK's own
lazy background refresh (timing not guaranteed relative to *your* screen's fetch) —
it wouldn't catch the failure at the exact moment Profile's `getIdToken()` call hits
it. Reacting inside `idToken()`'s own catch block is synchronous with the actual
failure, and deliberately distinct from `authStateChanges()`/a manual "Logout" tap
(which already navigates itself) so nothing double-fires.

---

## Commands reference

```bash
cd apps/{app} && flutter pub add firebase_auth      # Step 1
flutter pub get                                     # repo root, after any pubspec edit
dart run build_runner build --delete-conflicting-outputs   # after adding UserModel/AuthState/AuthEvent (Freezed)
flutter analyze apps/{app}
flutter test                                        # from apps/{app}
```

---

## Forbidden / gotchas

- **Never** add `firebase_auth` to `core` — it's this app's own dependency.
- **Never** register `FirebaseAuthService` / `UserProfileCacheService` in GetIt —
  `static final instance` singletons, called via `.instance`.
- **Never** trust a client-supplied uid on the backend — always
  `adminAuth.verifyIdToken`, and read `uid`/`email`/`emailVerified` only from the
  decoded token, never the request body.
- **Never** let `FirebaseAuthService.currentUser` throw — wrap in
  `try { } on FirebaseException { return null; }` so web preview and Firebase-less
  widget tests don't crash on a bloc's `started()` handler.
- **Never** put the verification poll timer's lifecycle anywhere but the bloc that
  owns it — start in `_enterAwaitingVerification`, cancel both on success and in
  `close()`.
- **Don't** skip the pending-verification pref key — without it, killing the app
  mid-verification and relaunching drops the user straight onto Home instead of
  resuming the sheet.
- **Don't** forget to clear the cache (Step 8) *and* the pending-verification flag on
  sign-out — both are per-device state that must not leak into the next signed-in
  account.
- Auth error copy, sheet copy, and every other string here is app copy → `ValueConst`,
  not inline literals.
