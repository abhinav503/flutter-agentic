# Add Firebase Email/Password Auth to an App

When the user asks to add email/password login/signup to an app, follow every step
below. This wires **Firebase Authentication (email/password)** into one app under
`apps/{app}/` as a full Clean-Architecture `feature/auth/`: sign up, sign in, sign
out, a **persistent email-verification bottom sheet** (non-dismissible, 3-second
poll, resumes correctly across app relaunches), and an optional **backend profile
sync** (dual-write: Firebase Auth's own record + a Firestore `users/{uid}` doc via a
server API that verifies the Firebase ID token). Proven pattern from
`apps/ecommerce/gravia`.

> **Monorepo note:** `firebase_auth` is this app's own dependency — **never** add it
> to `core`. This builds on the connect-firebase flow; the app must already be
> connected.

> **Scope:** email/password only. Google/Apple buttons render as UI stubs
> ("coming soon" snackbar) — real OAuth wiring is separate, larger work.

---

## Step 0 — Prerequisite + backend decision

Verify Firebase is already connected:
```bash
ls apps/{app}/lib/firebase_options.dart
grep -n "firebase_core" apps/{app}/pubspec.yaml
grep -n "Firebase.initializeApp" apps/{app}/lib/main.dart
```
Missing any → stop, run connect-firebase first.

Tell the user: enable **Email/Password** under Firebase Console → Authentication →
Sign-in method — nothing here does it automatically.

Ask if there's a backend to sync `name`/`mobile` to (Firebase Auth alone has no place
to store them). If yes, build the server-side dual-write (Step 3) before the Flutter
data source. If no, skip it — the data source builds `UserModel` straight from
`FirebaseAuthService` fields.

## Step 1 — Dependencies + native requirements

```bash
cd apps/{app} && flutter pub add firebase_auth
```
Let pub match the app's `firebase_core` major — don't hardcode a version.

Auth needs Android **minSdk 23+** (higher than `firebase_core`'s 21+) — verify, don't
assume:
```bash
grep -n "minSdk" apps/{app}/android/app/build.gradle.kts
```
If it reads `flutter.minSdkVersion`, no edit needed. No new native config files —
Auth reuses what connect-firebase already wrote (no APNs-style extra credential like
push notifications need).

## Step 2 — `FirebaseAuthService`

Static singleton in `lib/services/firebase_auth_service.dart`, **never registered in
GetIt**, called via `.instance`:

- `currentUser` getter — **must never throw**: wrap in
  `try { return FirebaseAuth.instance.currentUser; } on FirebaseException { return null; }`.
  Apps preview as Flutter Web where `Firebase.initializeApp()` is never called, and
  widget tests mount auth-aware screens without a Firebase test app — either path
  must return `null`, not crash.
- `signUp`/`signIn`/`signOut`/`sendEmailVerification`/`updateDisplayName` — thin
  wrappers over `FirebaseAuth.instance`.
- `reloadAndCheckVerified()` — reloads and returns the fresh `emailVerified` flag,
  never throws (returns `false` if no user).
- `idToken({forceRefresh})` — `forceRefresh: true` mints a token carrying the fresh
  `email_verified` claim, needed right after verification since a previously-issued
  token is stale until refreshed.
- An `extension on FirebaseAuthException` mapping error codes (`email-already-in-use`,
  `weak-password`, `invalid-email`, `user-not-found`/`wrong-password`/
  `invalid-credential`, `too-many-requests`, `network-request-failed`) to
  human-readable copy — `e.message` alone is often terse or missing.

## Step 3 — Backend dual-write (skip if no backend)

Server guard verifies the **ID token**, never a client-supplied uid:
```ts
export async function requireAuthedUser(request: Request) {
  const match = (request.headers.get("authorization") ?? "").match(/^Bearer (.+)$/);
  if (!match) throw new UnauthorizedError("Missing bearer token");
  const decoded = await adminAuth.verifyIdToken(match[1]); // throws → catch → 401
  return { uid: decoded.uid, email: decoded.email ?? "", emailVerified: decoded.email_verified ?? false };
}
```
`POST /api/users` upserts `users/{uid}` with `uid`/`email`/`emailVerified` always
from the verified token; `name`/`mobile` optional body fields, so the same endpoint
can re-sync just `emailVerified` after the verification poll without wiping the rest
of the profile (`{ merge: true }` set, `createdAt` stamped only on first write).

**Vercel + Next.js + `firebase-admin` gotcha:** a `jose`/ESM Turbopack bundling bug
causes a 500 on any route calling `verifyIdToken`/`adminDb`, production-only. Fix:
`serverExternalPackages: ["firebase-admin"]` in `next.config.ts`, `"build": "next
build --webpack"`, `"overrides": { "jose": "^5" }`. Verify locally with
`next build && next start` + `curl` before redeploying.

## Step 4 — `feature/auth/` Clean Architecture

**Thin repository, fat data source.** All orchestration (Firebase SDK calls + backend
sync) lives in `AuthRemoteDataSourceImpl`; `AuthRepositoryImpl` only calls the data
source and converts Model→Entity — this keeps the data source swappable without
touching the repository. Every repository method calling Firebase wraps in
`on FirebaseAuthException catch (e) => left(Failure.unexpected(message: e.readableMessage))`,
layered on top of (not instead of) `BaseRepository.handleRequest`.

Data source methods: `signUp` (Firebase createUser → sendEmailVerification → sync
profile with name/mobile), `signIn` (Firebase sign-in → sync with **no** name/mobile,
self-healing a missing doc and re-syncing `emailVerified` without overwriting
existing fields), `signOut`, `resendVerificationEmail`, `checkEmailVerified` (reload +
check → if verified, force-refresh token → sync → return the model; if not, return
`null`). A private `_saveUserProfile({idToken, name?, mobile?})` helper POSTs to the
backend and is shared by every method above.

Register in `injection_container.dart` in the standard order: data source →
repository → use cases (`SignUpUseCase`, `SignInUseCase`, `SignOutUseCase`,
`ResendVerificationEmailUseCase`, `CheckEmailVerifiedUseCase`, and
`UpdateProfileUseCase` if doing Step 8).

## Step 5 — `AuthBloc`: states, poll, relaunch resume

States: `initial, loading, awaitingVerification({email}), authenticated({user}),
unauthenticated, error({message})`.

- `AuthStarted` (dispatched once per bloc creation, from every screen that can resume
  a session — Login, Signup, and the app's shell/home): reads
  `FirebaseAuthService.currentUser` **and** a persisted pending-verification flag.
  Session + pending → re-enter `awaitingVerification` (reopens the sheet). This is
  what makes kill-and-relaunch mid-verification resume correctly instead of falling
  through to Home.
- Sign-up success → `awaitingVerification` + start
  `Timer.periodic(Duration(seconds: 3))` dispatching a tick event.
- Login → already-verified goes straight to `authenticated`; unverified also enters
  `awaitingVerification`.
- Tick handler → calls `checkEmailVerified`; a `null`/unverified result is a no-op
  (sheet stays open); a real result flips to `authenticated` and cancels the timer.
- Module-level `const kPendingEmailVerificationPrefKey = 'pending_email_verification';`
  in `SharedPreferenceService` — `true` entering `awaitingVerification`, `false` on
  verified success **and** on sign-out.
- `close()` must cancel the timer.

## Step 6 — Persistent verify-email sheet

Top-level function (not a screen-state extension — it's opened from two different
state shapes: Login/Signup's screen state, and the app shell's page state):
`showModalBottomSheet` with `isDismissible: false, enableDrag: false`; its content
additionally wrapped in `PopScope(canPop: false, ...)` to block the Android back
gesture too. Only action: "Resend email" with a client-side 30s cooldown (its own
`Timer.periodic`, no bloc involved). Wire open/close at the shell level via
`BlocListener<AuthBloc, AuthState>` reacting to `AuthAwaitingVerification`/
`AuthAuthenticated`, tracking a bool to avoid stacking a duplicate sheet.

## Step 7 — Local profile cache (skip the loader flash)

`UserProfileCacheService` — static singleton wrapping `SharedPreferenceService`
(`save`/`read`/`clear`, JSON-encoded). Write-through: `AuthRepositoryImpl` saves
`model.toJson()` right before returning in `signUp`/`signIn`/`checkEmailVerified`
(non-null) and `updateProfile`. Cache-first read: the profile feature's repository
checks the cache before its own data source call, leaving that feature's bloc/screen
untouched (the live fetch stays the cold-cache fallback). Clear the cache **and** the
pending-verification flag on sign-out, alongside `FirebaseAuthService.signOut()` —
otherwise a different account on the same device inherits stale state.

## Step 8 — Edit Profile (optional, needs Step 3)

A second dual-write reusing `_saveUserProfile`: `updateDisplayName` on Firebase Auth,
then sync name/mobile to the backend. Give the edit screen its own thin bloc
(`initial/saving/success/error`) — never call a use case directly from a screen.
**Email stays read-only** in this form; Firebase's real email-change API
(`verifyBeforeUpdateEmail`) is its own separate confirmation-link flow, out of scope.

## Step 9 — Web safety (required)

Guard every Firebase Auth entry point with `kIsWeb` and emit a friendly
`ValueConst`-backed error instead of letting the call throw — apps preview as Flutter
Web, where `Firebase.initializeApp()` is never called.

## Verify

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze apps/{app}
flutter test
```

## Forbidden / gotchas

- Never add `firebase_auth` to `core`.
- Never register `FirebaseAuthService` / `UserProfileCacheService` in GetIt.
- Never trust a client-supplied uid on the backend — only verified-token claims.
- Never let `currentUser` throw.
- Poll timer lifecycle belongs entirely to the bloc.
- Don't skip the pending-verification pref key or the sign-out cache/flag clear.
- Auth/sheet copy → `ValueConst`, never inline literals.
