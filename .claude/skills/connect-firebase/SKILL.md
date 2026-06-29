# connect-firebase

Connects one app under `apps/{app}/` to a Firebase project. Follow every step in the
guide below. Notes on how this skill splits the work:

## 1. Pick the app and read its ids

If the app was not passed as an argument, list `apps/` and ask which app to connect.

Read and note:
- Android `applicationId` from `apps/{app}/android/app/build.gradle.kts`
- iOS `PRODUCT_BUNDLE_IDENTIFIER` from `apps/{app}/ios/Runner.xcodeproj/project.pbxproj`

If either is still `com.example.{app}`, warn and suggest `/change-app-id` first.

## 2. Check both CLIs before asking the user to do anything

Run these yourself:

```bash
firebase --version 2>/dev/null || echo "NOT_FOUND"
export PATH="$PATH":"$HOME/.pub-cache/bin" && flutterfire --version 2>/dev/null || echo "NOT_FOUND"
```

- **Firebase missing/broken** → give the user the npm install + `~/.zshrc` PATH fix from the guide. Wait for them to confirm `firebase --version` works before continuing.
- **Firebase not logged in** → print `! firebase login` for the user to run (opens browser).
- **FlutterFire missing** → install it yourself: `dart pub global activate flutterfire_cli`

## 3. Run `flutterfire configure` yourself (non-interactive)

Ask the user for their Firebase project ID, then run directly — no hand-off needed:

```bash
export PATH="$(npm config get prefix)/bin:$HOME/.pub-cache/bin:$PATH"
cd apps/{app} && flutterfire configure \
  --project=<firebase-project-id> \
  --platforms=android,ios \
  --ios-bundle-id=<ios-bundle-id> \
  --android-package-name=<android-application-id> \
  --yes
```

After it finishes, verify config files exist using absolute paths (relative `ls` can miss them):

```bash
find /absolute/path/to/apps/{app} -name "firebase_options.dart" \
  -o -name "google-services.json" -o -name "GoogleService-Info.plist"
```

## 4. Agent does the file edits

`pubspec.yaml`, `main.dart`, Gradle — follow the guide. Never add `firebase_core` to `core`.

## 5. Check the Xcode plist registration

`flutterfire configure` on macOS registers the plist in Xcode automatically. Check before
telling the user to do it manually (doing it again creates a duplicate):

```bash
grep -c "GoogleService-Info.plist" apps/{app}/ios/Runner.xcodeproj/project.pbxproj
```

Count ≥ 1 → already registered, skip the manual Xcode step.
Count = 0 → show the manual Xcode step from the guide.

If the user reports two plist entries in Copy Bundle Resources: in Build Phases, click
**`–`** next to one of the duplicates.

## 6. iOS deployment target — always check and bump

Firebase iOS SDK (SPM) requires iOS 15.0+. Always verify after wiring:

```bash
grep "IPHONEOS_DEPLOYMENT_TARGET" apps/{app}/ios/Runner.xcodeproj/project.pbxproj
```

If any value is below `15.0`, update all occurrences with the Edit tool (replace_all: true).

@docs/how-to/connect-firebase.md
