# Connect an App to Firebase

When the user asks to connect an app to Firebase, follow every step below.

> **Monorepo note:** Firebase config is **per app**. All paths are relative to `apps/{app}/`.
> Each app lists its **own** `firebase_core` dependency — never add it to `core`.

---

## Step 1 — Pick the app and read its ids

Ask which app under `apps/` to connect if not specified. Read and note:

- Android `applicationId` — `apps/{app}/android/app/build.gradle.kts`
- iOS `PRODUCT_BUNDLE_IDENTIFIER` — `apps/{app}/ios/Runner.xcodeproj/project.pbxproj`

If either is still `com.example.{app}`, warn and suggest changing the app ID first — Firebase registers by bundle id, and changing it later means re-registering.

---

## Step 2 — Check both CLIs

```bash
firebase --version 2>/dev/null || echo "NOT_FOUND"
export PATH="$PATH":"$HOME/.pub-cache/bin" && flutterfire --version 2>/dev/null || echo "NOT_FOUND"
```

**Firebase missing or "bad CPU type"** → install via npm and fix PATH:
```bash
npm install -g firebase-tools
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
firebase --version
firebase login   # opens browser — user must run this
```

**FlutterFire missing** → activate directly:
```bash
dart pub global activate flutterfire_cli
```

---

## Step 3 — Run `flutterfire configure`

Ask the user for their Firebase project ID (find it at https://console.firebase.google.com). Then run:

```bash
export PATH="$(npm config get prefix)/bin:$HOME/.pub-cache/bin:$PATH"
cd apps/{app} && flutterfire configure \
  --project=<firebase-project-id> \
  --platforms=android,ios \
  --ios-bundle-id=<ios-bundle-id> \
  --android-package-name=<android-application-id> \
  --yes
```

Verify config files were generated (use absolute paths — relative `ls` can miss them):
```bash
find /absolute/path/to/apps/{app} -name "firebase_options.dart" \
  -o -name "google-services.json" -o -name "GoogleService-Info.plist"
```

---

## Step 4 — Add `firebase_core` and initialize (agent)

### `apps/{app}/pubspec.yaml`

```yaml
  # Firebase
  firebase_core: ^4.1.1
```

Run from repo root: `flutter pub get`

### `apps/{app}/lib/main.dart`

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web-safe: firebase_options.dart throws on web unless web is configured, and
  // apps are previewed as Flutter Web. Guard so the preview boots; device
  // behaviour is unchanged.
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

---

## Step 5 — Android Gradle (verify, add only if missing)

`flutterfire configure` usually adds these automatically. Confirm; add by hand only if absent.

`apps/{app}/android/settings.gradle.kts` — inside `plugins { }`:
```kotlin
id("com.google.gms.google-services") version "4.4.3" apply false
```

`apps/{app}/android/app/build.gradle.kts` — inside `plugins { }`:
```kotlin
id("com.google.gms.google-services")
```

---

## Step 6 — iOS deployment target (always check)

Firebase iOS SDK (SPM) requires **iOS 15.0+**. Check and bump if needed:

```bash
grep "IPHONEOS_DEPLOYMENT_TARGET" apps/{app}/ios/Runner.xcodeproj/project.pbxproj
```

If any value is below `15.0`:
```bash
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = 13.0/IPHONEOS_DEPLOYMENT_TARGET = 15.0/g' \
  apps/{app}/ios/Runner.xcodeproj/project.pbxproj
```

---

## Step 7 — iOS plist Xcode registration

`flutterfire configure` on macOS registers the plist in Xcode automatically. Check first:

```bash
grep -c "GoogleService-Info.plist" apps/{app}/ios/Runner.xcodeproj/project.pbxproj
```

- **≥ 1** → already registered, no manual step needed.
- **0** → must add through Xcode (a file only on disk is NOT bundled):
  1. `open apps/{app}/ios/Runner.xcworkspace`
  2. Right-click **Runner** group → **Add Files to "Runner"…**
  3. Select `ios/Runner/GoogleService-Info.plist`
  4. **Do NOT check "Copy items if needed"** — file is already in the right place
  5. Tick **Runner** target → **Add**
  6. Confirm exactly one entry under **Runner ▸ Build Phases ▸ Copy Bundle Resources**

> **Two plist entries?** Click **`–`** next to one duplicate in Copy Bundle Resources.

---

## Step 8 — Verify

```bash
flutter pub get        # repo root
flutter analyze apps/{app}
```

Run on each platform and confirm no `[firebase_core]` exception on launch.

---

## Common failures

| Symptom | Fix |
|---|---|
| `firebase: bad CPU type` | `npm i -g firebase-tools` + fix PATH in `~/.zshrc` |
| `flutterfire: command not found` | `dart pub global activate flutterfire_cli` |
| iOS: "no configuration file found" | Plist not in Runner target — redo Step 7 |
| "requires minimum platform version 15.0" | Update `IPHONEOS_DEPLOYMENT_TARGET` — see Step 6 |
| `Default FirebaseApp is not initialized` | `Firebase.initializeApp` missing/after `runApp` — see Step 4 |
