---
name: change-app-id
description: >
  Change the application ID / bundle identifier on Android and iOS for an app
  in the monorepo. Covers build.gradle.kts, MainActivity.kt package path, and
  the iOS project.pbxproj, with Xcode and provisioning notes.
  Invoke with $change-app-id or ask to change the app ID / bundle identifier.
---

If the new application ID was not provided, ask:
"What is the new application ID? Use reverse-domain notation, e.g. `com.company.appname`"

> **Monorepo note:** application IDs are per app. All paths below are relative to the target app folder `apps/{app}/` (e.g. `apps/doc_scanner/android/app/build.gradle.kts`). Ask which app under `apps/{app}/` to change if ambiguous. `core` has no application ID. Run verification commands from inside that app folder.

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

Any hits must also be updated.

---

## iOS

Update every `PRODUCT_BUNDLE_IDENTIFIER` line in `ios/Runner.xcodeproj/project.pbxproj`:

| Target | Value |
|---|---|
| Runner (3 entries: Debug, Release, Profile) | `{NEW_ID}` |
| RunnerTests (3 entries) | `{NEW_ID}.RunnerTests` |

Do a find-and-replace across the whole file — 6 lines total.

Verify:
```bash
grep "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj
```

### If the user prefers Xcode

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** project → **Runner** target → **General** tab.
3. Update **Bundle Identifier** to `{NEW_ID}`.
4. Repeat for **RunnerTests** target (`{NEW_ID}.RunnerTests`).

> **Note:** If Push Notifications, Sign in with Apple, or other capabilities are registered against the old bundle ID in the Apple Developer portal, create a new App ID there and re-download provisioning profiles. Xcode handles this automatically with automatic signing enabled.

---

## After Both Platforms

```bash
flutter analyze
```

Zero warnings required before reporting done.
