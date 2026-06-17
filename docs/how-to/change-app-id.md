# How to Change the Application ID

Covers Android and iOS. Replace `{OLD_ID}` and `{NEW_ID}` with the actual values throughout.

> **Monorepo note:** application IDs are **per app**. All paths below are relative to the target app folder, `apps/{app}/` (e.g. `apps/doc_scanner/android/app/build.gradle.kts`). Run the verification commands from inside that app folder, or prefix the paths with `apps/{app}/`.

---

## Android

### 1. `android/app/build.gradle.kts`

Update both occurrences:

```kotlin
namespace = "{NEW_ID}"          // was {OLD_ID}
applicationId = "{NEW_ID}"      // was {OLD_ID}
```

### 2. `MainActivity.kt` — package declaration

File is at:
```
android/app/src/main/kotlin/{OLD_ID_AS_PATH}/MainActivity.kt
```
where `{OLD_ID_AS_PATH}` is the old ID with `.` replaced by `/`  
(e.g. `com.example.flutter_agentic` → `com/example/flutter_agentic`).

Steps:
1. Create the new directory: `android/app/src/main/kotlin/{NEW_ID_AS_PATH}/`
2. Copy `MainActivity.kt` to the new path.
3. Update the first line: `package {NEW_ID}`
4. Delete the old directory tree under the old path.

### 3. Verify no remaining references

```bash
grep -r "{OLD_ID}" android/ --include="*.kt" --include="*.java" --include="*.xml" --include="*.gradle" --include="*.kts"
```

Any hits must also be updated.

---

## iOS

The iOS bundle identifier is stored in `ios/Runner.xcodeproj/project.pbxproj`.  
Update every `PRODUCT_BUNDLE_IDENTIFIER` line:

| Target | Old value | New value |
|---|---|---|
| Runner (3 entries: Debug, Release, Profile) | `{OLD_ID}` | `{NEW_ID}` |
| RunnerTests (3 entries) | `{OLD_ID}.RunnerTests` | `{NEW_ID}.RunnerTests` |

Do a find-and-replace across the whole file — there are typically 6 lines total.

### Verify

```bash
grep "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj
```

All 6 lines should show `{NEW_ID}` or `{NEW_ID}.RunnerTests`.

### If you prefer Xcode

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** project in the navigator.
3. Select the **Runner** target → **General** tab.
4. Update **Bundle Identifier** to `{NEW_ID}`.
5. Repeat for the **RunnerTests** target (set to `{NEW_ID}.RunnerTests`).

> **Note:** If your app uses Push Notifications, Sign in with Apple, or any other capability registered against the old bundle ID in the Apple Developer portal, you must also create a new App ID there and re-download the provisioning profiles. Xcode can auto-manage this under **Signing & Capabilities** if you have automatic signing enabled.

---

## After Both Platforms

```bash
flutter analyze
```

Zero warnings required before committing.
