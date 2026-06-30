---
name: connect-firebase
description: >
  Connect one app under apps/{app}/ to a Firebase project. Covers checking/installing
  the Firebase + FlutterFire CLIs, running flutterfire configure, per-app firebase_core,
  main.dart init, the Android Gradle plugin, the iOS 15.0+ deployment target, and the
  Xcode GoogleService-Info.plist registration check.
  Invoke with $connect-firebase or ask to connect an app to Firebase.
---

Connects one app under `apps/{app}/` to a Firebase project: registers the iOS/Android
(and optionally web) apps, drops in the platform config files, generates
`lib/firebase_options.dart`, and initializes Firebase at startup.

> **Monorepo note:** Firebase config is **per app**. Every path below is relative to the
> target app folder `apps/{app}/`. Each app lists its **own** `firebase_core` dependency —
> **never add `firebase_core` to `core`.**

> **Scope:** this connects the app to Firebase (`firebase_core` only). Feature SDKs (Auth,
> Firestore, Storage, Messaging) are a follow-up — add each as its own dependency later.

Some steps are interactive (browser login, project picker) or need Xcode — the **user**
runs those (suggest the `! <command>` prefix so output lands in the session). The agent
does the deterministic file edits.

---

## 1. Pick the app and read its ids

If the app was not passed as an argument, list `apps/` and ask which app to connect.

Read and note:
- Android `applicationId` — `apps/{app}/android/app/build.gradle.kts`
- iOS `PRODUCT_BUNDLE_IDENTIFIER` — `apps/{app}/ios/Runner.xcodeproj/project.pbxproj`

```bash
grep applicationId apps/{app}/android/app/build.gradle.kts
grep PRODUCT_BUNDLE_IDENTIFIER apps/{app}/ios/Runner.xcodeproj/project.pbxproj | head -1
```

If either is still `com.example.{app}`, warn and suggest `$change-app-id` **first** —
Firebase registers apps by bundle id, so changing it later means re-registering.

---

## 2. Check both CLIs before asking the user to do anything

Run these yourself:

```bash
firebase --version 2>/dev/null || echo "NOT_FOUND"
export PATH="$PATH":"$HOME/.pub-cache/bin" && flutterfire --version 2>/dev/null || echo "NOT_FOUND"
```

- **Firebase missing/broken** (`not found` or `bad CPU type` — e.g. an x86 binary on Apple
  Silicon) → have the user install the npm/Homebrew build and fix PATH, then confirm
  `firebase --version` works before continuing:
  ```bash
  npm install -g firebase-tools        # or: brew install firebase-cli
  echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
  ```
  > Don't hardcode the Node version in the path — use `$(npm config get prefix)/bin`.
- **Firebase not logged in** → user runs `! firebase login` (opens a browser).
- **FlutterFire missing** → install it yourself: `dart pub global activate flutterfire_cli`
  (binary lands at `~/.pub-cache/bin/flutterfire`; ensure that dir is on PATH in `~/.zshrc`).

---

## 3. Run `flutterfire configure`

Ask the user for their Firebase project id, then run from the app folder:

```bash
export PATH="$(npm config get prefix)/bin:$HOME/.pub-cache/bin:$PATH"
cd apps/{app} && flutterfire configure \
  --project=<firebase-project-id> \
  --platforms=android,ios \
  --ios-bundle-id=<ios-bundle-id> \
  --android-package-name=<android-application-id> \
  --yes
```

(Add `web` to `--platforms` if the app runs on web. Drop the flags to use interactive
pickers — in that case the user runs it with `!`.) This single command:

- creates **`lib/firebase_options.dart`** (`DefaultFirebaseOptions.currentPlatform`),
- writes **`android/app/google-services.json`**,
- writes **`ios/Runner/GoogleService-Info.plist`** and adds it to the Runner target,
- registers each platform app in the Firebase project.

Verify the config files exist (use absolute paths — relative `ls` can miss them):

```bash
find /absolute/path/to/apps/{app} -name "firebase_options.dart" \
  -o -name "google-services.json" -o -name "GoogleService-Info.plist"
```

---

## 4. Add `firebase_core` and initialize (agent)

### `apps/{app}/pubspec.yaml` — under `dependencies:` (this app's direct dep, not `core`)

```yaml
  # Firebase
  firebase_core: ^4.1.1
```

Then resolve from the **repo root**: `flutter pub get`.

### `apps/{app}/lib/main.dart` — init before DI and `runApp`

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ...existing theme-config load + initDependencies()...
  runApp(App(/* ... */));
}
```

---

## 5. Android Gradle (verify; add only if missing)

`flutterfire configure` usually adds the Google Services plugin. Verify and add by hand
only if absent.

- `apps/{app}/android/settings.gradle.kts` → `plugins { }`:
  ```kotlin
  id("com.google.gms.google-services") version "4.4.3" apply false
  ```
- `apps/{app}/android/app/build.gradle.kts` → `plugins { }`:
  ```kotlin
  id("com.google.gms.google-services")
  ```

> `firebase_core` needs Android **21+** (Auth/Firestore **23+**). Bump `minSdk` only if a
> build error asks for it.

---

## 6. Check the Xcode plist registration

On macOS `flutterfire configure` registers the plist in Xcode automatically. Check before
telling the user to do it manually (doing it again creates a duplicate):

```bash
grep -c "GoogleService-Info.plist" apps/{app}/ios/Runner.xcodeproj/project.pbxproj
```

- **Count ≥ 1** → already registered; just confirm it appears once under **Runner ▸ Build
  Phases ▸ Copy Bundle Resources**. Skip the manual step.
- **Count = 0** → on disk but not bundled. The user must add it **through Xcode** (a file
  only on disk is not bundled → runtime "no configuration file found"):
  1. `open apps/{app}/ios/Runner.xcworkspace`
  2. Right-click the **Runner** group → **Add Files to "Runner"…**
  3. Select `ios/Runner/GoogleService-Info.plist`.
  4. **Do NOT check "Copy items if needed"** (the file is already in place; copying makes a
     duplicate entry).
  5. Tick the **Runner** target → **Add**.
  6. Confirm exactly **one** entry in Copy Bundle Resources.

> **Duplicate plist entries** in Copy Bundle Resources → click **`–`** next to one duplicate.

---

## 7. iOS deployment target — always check and bump

The Firebase iOS SDK (via Swift Package Manager) requires iOS **15.0+**. Always verify:

```bash
grep "IPHONEOS_DEPLOYMENT_TARGET" apps/{app}/ios/Runner.xcodeproj/project.pbxproj
```

If any value is below `15.0`, update **all** occurrences:

```bash
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = 13.0/IPHONEOS_DEPLOYMENT_TARGET = 15.0/g' \
  apps/{app}/ios/Runner.xcodeproj/project.pbxproj
```

---

## 8. Verify

```bash
flutter pub get                      # repo root
flutter analyze apps/{app}
```

Then run on each configured platform and confirm no `[firebase_core]` init error:

```bash
cd apps/{app}
flutter run -d <ios-device>          # proves the plist is bundled
flutter run -d <android-device>      # proves google-services.json is read
flutter run -d chrome                # web (if configured)
```

A clean launch with no Firebase exception means the connection works.

---

## Common failures

| Symptom | Fix |
|---|---|
| `firebase: bad CPU type` | Reinstall via `npm i -g firebase-tools` / `brew install firebase-cli` |
| `flutterfire: command not found` | `dart pub global activate flutterfire_cli`; add `~/.pub-cache/bin` to PATH |
| iOS "no configuration file found" at runtime | Plist not in the Runner target — redo step 6 through Xcode |
| Android `google-services.json is missing` | Must be at `android/app/google-services.json`; re-run `flutterfire configure` |
| `Default FirebaseApp is not initialized` | `Firebase.initializeApp` missing/after `runApp` — see step 4 |
