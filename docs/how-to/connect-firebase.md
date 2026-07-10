# How to Connect an App to Firebase

Wires one app under `apps/{app}/` to a Firebase project: registers the iOS/Android
(and optionally web) apps, drops in the platform config files, generates
`lib/firebase_options.dart`, and initializes Firebase at startup.

> **Monorepo note:** Firebase config is **per app**. Every path below is relative to
> the target app folder, `apps/{app}/` (e.g. `apps/jokes/android/app/google-services.json`).
> Each app lists its **own** `firebase_core` dependency — never add it to `core`.

> **Scope:** this connects the app to Firebase (`firebase_core` only). Feature SDKs
> (Auth, Firestore, Storage, Messaging) are a follow-up — add each as its own
> dependency once connected.

---

## Who does what

Some steps **must** be run by you in your own terminal — they are interactive
(browser login, project picker) or require Xcode. In Claude Code, run those with the
`!` prefix so the output lands in the session. The agent does the file edits.

| Step | Who | Why |
|---|---|---|
| Install/login Firebase + FlutterFire CLIs | **You** (`!`) | Opens a browser to authenticate |
| `flutterfire configure` | **You** (`!`) | Interactive project + platform picker |
| Add `firebase_core`, init in `main.dart`, Gradle edits | **Agent** | Deterministic file edits |
| Add `GoogleService-Info.plist` to the Xcode target | **You** (Xcode) | Must be added through Xcode, not the filesystem |
| Verify (`flutter pub get`, `analyze`, run) | **Agent** + **You** | — |

---

## Prerequisites

### 1. Firebase CLI

```bash
firebase --version
```

- **"bad CPU type in executable"** or **not found** → the standalone binary is broken
  (e.g. an x86 build on Apple Silicon). Install the npm/Homebrew build instead:
  ```bash
  npm install -g firebase-tools        # or: brew install firebase-cli
  ```
- After the npm install, the npm global bin is often **not on PATH** yet — the shell
  will still find the old broken binary. Add it permanently and apply immediately:
  ```bash
  echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc
  firebase --version   # should now print a version number
  ```
  > **Avoid hardcoding the Node version** in the path (e.g. `/opt/homebrew/Cellar/node/26.4.0/bin`) — it breaks on Node upgrades. Use `$(npm config get prefix)/bin` instead.
- Then log in (opens a browser — run it yourself):
  ```bash
  firebase login
  ```

### 2. FlutterFire CLI

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
flutterfire --version
```

- **Not found** → activate it (the agent can do this directly):
  ```bash
  dart pub global activate flutterfire_cli
  ```
- The binary lands at `~/.pub-cache/bin/flutterfire`. Make sure that directory is on
  PATH permanently (add to `~/.zshrc`):
  ```bash
  echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
  source ~/.zshrc
  flutterfire --version   # should now print a version number
  ```

### 3. A Firebase project

Create one at <https://console.firebase.google.com> (or `firebase projects:create my-id`).
Have its **project id** ready for the next step.

---

## Step 1 — Pick the app and read its ids

Choose the target app under `apps/`. The agent reads the identifiers it will register:

- **Android** `applicationId` — `apps/{app}/android/app/build.gradle.kts`
- **iOS** `PRODUCT_BUNDLE_IDENTIFIER` — `apps/{app}/ios/Runner.xcodeproj/project.pbxproj`

```bash
grep applicationId apps/{app}/android/app/build.gradle.kts
grep PRODUCT_BUNDLE_IDENTIFIER apps/{app}/ios/Runner.xcodeproj/project.pbxproj | head -1
```

> Templated apps ship with `com.example.{app}`. If you haven't set a real bundle id,
> run `/change-app-id` **first** — Firebase registers apps by bundle id, and changing
> it later means re-registering.

---

## Step 2 — Run `flutterfire configure` (you, interactive)

From the app folder, so the config lands in the right project:

```bash
cd apps/{app}
flutterfire configure \
  --project=<your-firebase-project-id> \
  --platforms=android,ios \
  --ios-bundle-id=<ios-bundle-id> \
  --android-package-name=<android-application-id>
```

(Drop the flags to use the interactive pickers; add `web` to `--platforms` if the app
runs on web — `web_terminal` does.)

This single command:

- creates **`lib/firebase_options.dart`** (`DefaultFirebaseOptions.currentPlatform`),
- writes **`android/app/google-services.json`**,
- writes **`ios/Runner/GoogleService-Info.plist`** and adds it to the Runner target,
- registers each platform app in the Firebase project.

> If it can't write the iOS plist into the Xcode project (common off-macOS or with
> custom projects), it still downloads the file — finish it manually in **Step 5**.

---

## Step 3 — Add `firebase_core` and initialize (agent)

### `apps/{app}/pubspec.yaml`

Add under `dependencies:` (this app's direct dep — not `core`):

```yaml
  # Firebase
  firebase_core: ^4.1.1
```

Then resolve from the **repo root**:

```bash
flutter pub get
```

### `apps/{app}/lib/main.dart`

Initialize Firebase before DI and `runApp`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web-safe by default: firebase_options.dart throws on web unless web is
  // configured, and apps are previewed as Flutter Web. Guard so the preview
  // boots; on device this runs exactly as before.
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  final config = await _loadThemeConfig();
  await initDependencies();

  runApp(App(themeConfig: config));
}
```

> **Web-safe rule:** never let native init throw on web (see Forbidden Patterns in `docs/ai-rules/conventions.md`). If you later run `flutterfire configure` and add the **web** platform, the guard still holds — remove it only when web Firebase is intentionally supported.

---

## Step 4 — Android Gradle (agent, verify)

`flutterfire configure` usually adds the Google Services plugin automatically. Verify;
add it by hand only if missing.

### `apps/{app}/android/settings.gradle.kts` — `plugins { }`

```kotlin
id("com.google.gms.google-services") version "4.4.3" apply false
```

### `apps/{app}/android/app/build.gradle.kts` — `plugins { }`

```kotlin
id("com.google.gms.google-services")
```

> **minSdk:** `firebase_core` needs Android **21+** (Auth/Firestore need **23+**). These
> apps inherit `flutter.minSdkVersion`; bump `minSdk` in `android/app/build.gradle.kts`
> only if a build error asks for it.

---

## Step 5 — iOS: add the plist in Xcode (you, manual)

⚠️ **`GoogleService-Info.plist` must be added through Xcode**, not by dropping it in the
folder. A file only on disk is **not** bundled into the app, so Firebase fails at runtime
with "no configuration file found."

**First, check if `flutterfire configure` already registered it** (on macOS it usually does):

```bash
grep -c "GoogleService-Info.plist" apps/{app}/ios/Runner.xcodeproj/project.pbxproj
```

- **≥ 1** → already registered. Just verify it appears once in **Runner ▸ Build Phases ▸
  Copy Bundle Resources** and move on — no manual add needed.
- **0** → on disk but not registered; follow the steps below.

If you need to add it manually:

1. Open the workspace: `open apps/{app}/ios/Runner.xcworkspace`
2. In the navigator, right-click the **Runner** group → **Add Files to "Runner"…**
3. Select `ios/Runner/GoogleService-Info.plist`.
4. **Do NOT check "Copy items if needed"** — the file is already in the right place;
   checking it copies a duplicate and creates two entries in Copy Bundle Resources.
5. Tick the **Runner** target, then **Add**.
6. Confirm exactly **one** entry under **Runner ▸ Build Phases ▸ Copy Bundle Resources**.

> **Duplicate plist entries?** If you see `GoogleService-Info.plist` listed twice in
> Copy Bundle Resources, you added it when `flutterfire` had already registered it. Fix:
> click **`–`** next to one of the duplicate entries in that Build Phases panel.

> **iOS minimum version:** the Firebase iOS SDK (via Swift Package Manager) needs **iOS 15+**.
> If Xcode shows "requires minimum platform version 15.0 but this target supports 13.0",
> update all three `IPHONEOS_DEPLOYMENT_TARGET` entries in
> `apps/{app}/ios/Runner.xcodeproj/project.pbxproj` from `13.0` to `15.0`:
> ```bash
> sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = 13.0/IPHONEOS_DEPLOYMENT_TARGET = 15.0/g' \
>   apps/{app}/ios/Runner.xcodeproj/project.pbxproj
> ```

---

## Step 6 — Verify

```bash
flutter pub get                      # repo root
flutter analyze apps/{app}
```

Then run on each platform you configured and confirm no Firebase init error:

```bash
cd apps/{app}
flutter run -d <ios-device>          # iOS: proves the plist is bundled
flutter run -d <android-device>      # Android: proves google-services.json is read
flutter run -d chrome                # web (if configured)
```

A clean launch with no `[firebase_core]` exception means the connection works.

---

## What gets committed

- ✅ `lib/firebase_options.dart`, `android/app/google-services.json`,
  `ios/Runner/GoogleService-Info.plist`, the pubspec/Gradle/main.dart edits.
- These hold Firebase **client** keys, which are safe to commit (security is enforced by
  Firebase Security Rules, not by hiding these). Lock down access with rules before
  shipping. If your org policy forbids committing them, gitignore the three config files
  and document how teammates regenerate them with `flutterfire configure`.

---

## Common failures

| Symptom | Fix |
|---|---|
| `firebase: bad CPU type` | Reinstall via `npm i -g firebase-tools` / `brew install firebase-cli` |
| `flutterfire: command not found` | `dart pub global activate flutterfire_cli`; add `~/.pub-cache/bin` to PATH |
| iOS: "no configuration file found" at runtime | Plist not in the Runner target — redo **Step 5** through Xcode |
| Android: `google-services.json is missing` | File must be at `android/app/google-services.json`; re-run `flutterfire configure` |
| `Default FirebaseApp is not initialized` | `Firebase.initializeApp` missing/after `runApp` — see **Step 3** |
