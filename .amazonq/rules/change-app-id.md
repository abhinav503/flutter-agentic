# Change Application ID

When the user asks to change the application ID, bundle identifier, or package name, follow every step below. If the new ID was not provided, ask: "What is the new application ID? Use reverse-domain notation, e.g. `com.company.appname`"

> **Monorepo note:** application IDs are per app. All paths below are relative to the target app folder `apps/{app}/` (e.g. `apps/doc_scanner/android/app/build.gradle.kts`). Run verification commands from inside that app folder.

Derive the old application ID from the `applicationId` field in `apps/{app}/android/app/build.gradle.kts`.

---

## Android

### 1. `android/app/build.gradle.kts`

Update both occurrences:

```kotlin
namespace = "{NEW_ID}"
applicationId = "{NEW_ID}"
```

### 2. `MainActivity.kt` — package declaration and directory

The file lives at `android/app/src/main/kotlin/{OLD_ID_AS_PATH}/MainActivity.kt`
(`{OLD_ID_AS_PATH}` = old ID with `.` replaced by `/`).

Steps:
1. Create `android/app/src/main/kotlin/{NEW_ID_AS_PATH}/`
2. Write `MainActivity.kt` with `package {NEW_ID}` as the first line.
3. Delete the old directory tree.

### 3. Verify no remaining references

```bash
grep -r "{OLD_ID}" android/ --include="*.kt" --include="*.java" --include="*.xml" --include="*.gradle" --include="*.kts"
```

---

## iOS

Update every `PRODUCT_BUNDLE_IDENTIFIER` line in `ios/Runner.xcodeproj/project.pbxproj`:

| Target | Value |
|---|---|
| Runner (3 entries: Debug, Release, Profile) | `{NEW_ID}` |
| RunnerTests (3 entries) | `{NEW_ID}.RunnerTests` |

Verify:
```bash
grep "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj
```

### Xcode alternative

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select **Runner** target → **General** tab → update **Bundle Identifier** to `{NEW_ID}`.
3. Repeat for **RunnerTests** target (`{NEW_ID}.RunnerTests`).

> **Note:** If Push Notifications, Sign in with Apple, or other capabilities are registered against the old bundle ID in the Apple Developer portal, create a new App ID there and re-download provisioning profiles.

---

## After Both Platforms

```bash
flutter analyze
```

Zero warnings required before reporting done.
