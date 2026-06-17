# How to Rename the App

Use this guide when you need to change an app's display name and Dart package name across all platform files, AI rules, and test imports.

> **Monorepo note:** each app lives under `apps/{app}/` (e.g. `apps/jokes`, `apps/doc_scanner`). All paths below are relative to that app folder. Renaming the package name also changes its `package:{app}/…` imports — update them within that app. `core` is never renamed.

You will need:

| Token | Form | Example |
|---|---|---|
| `{app}` | the app's folder under `apps/` | `doc_scanner` |
| `{OldPackage}` | snake_case — current `name:` in `apps/{app}/pubspec.yaml` | `doc_scanner` |
| `{NewPackage}` | snake_case — desired Dart package name | `my_app` |
| `{NewDisplay}` | PascalCase or branded string — shown to users | `MyApp` |
| `{NewBundleId}` | reverse-DNS — Android/iOS bundle identifier | `com.example.my_app` |

---

## 1. pubspec.yaml

**`apps/{app}/pubspec.yaml`**
```
name: {OldPackage}   →   name: {NewPackage}
```
Then update this app's own `package:{OldPackage}/…` imports → `package:{NewPackage}/…` across its `lib/` and `test/`.

If you also rename the **folder** (`apps/{app}` → `apps/{NewName}`), update the root **`pubspec.yaml`** `workspace:` list to point at the new path, then run `flutter pub get` at the root.

## 2. Dart source — app title

**`apps/{app}/lib/app.dart`**
```dart
title: '{OldDisplay}'   →   title: '{NewDisplay}'
```
If the app keeps a title constant, it lives in **`apps/{app}/lib/constants/value_const.dart`** (class `ValueConst`) — not in `core`.

## 3. Web

**`apps/{app}/web/index.html`**
- `<meta name="apple-mobile-web-app-title" content="...">` → `{NewDisplay}`
- `<title>...</title>` → `{NewDisplay}`

**`apps/{app}/web/manifest.json`**
- `"name"` and `"short_name"` → `{NewDisplay}`

## 4. iOS

**`apps/{app}/ios/Runner/Info.plist`**
- `CFBundleDisplayName` → `{NewDisplay}`
- `CFBundleName` → `{NewPackage}`

## 5. Android

**`apps/{app}/android/app/src/main/AndroidManifest.xml`**
- `android:label` → `{NewDisplay}`

**`apps/{app}/android/app/build.gradle.kts`**
- `namespace` → `{NewBundleId}`
- `applicationId` → `{NewBundleId}`

**`apps/{app}/android/app/src/main/kotlin/.../{OldPackage}/MainActivity.kt`**
1. Create directory: `apps/{app}/android/app/src/main/kotlin/com/example/{NewPackage}/`
2. Move `MainActivity.kt` into the new directory
3. Update the `package` declaration at the top of the file to `{NewBundleId}`
4. Delete the old directory

## 6. Test imports

Run a find-and-replace across all files under `apps/{app}/test/`:

```
package:{OldPackage}/   →   package:{NewPackage}/
```

## 7. VS Code launch config

**`.vscode/launch.json`** — this file holds a config trio (debug/profile/release) per app, keyed by the app folder name. Update the renamed app's three `name` strings and its `program`/`cwd` paths:
```
{app} (debug)    →   {NewName} (debug)      cwd: apps/{app}  →  apps/{NewName}
{app} (profile)  →   {NewName} (profile)
{app} (release)  →   {NewName} (release)
```

## 8. AI rules and docs

Run a global find-and-replace on these files:
- `CLAUDE.md`
- `AGENTS.md`
- `GEMINI.md`
- `.github/copilot-instructions.md`
- `.amazonq/rules/` (if present)
- `.cursor/rules/` (if present)
- `docs/` (all `.md` files)
- `.claude/skills/` (all `SKILL.md` files)
- `.codex/skills/` (all `SKILL.md` files)

Replace all three forms:
```
{OldDisplay}   →   {NewDisplay}
{OldPackage}   →   {NewPackage}
```

## 9. Verify

```bash
flutter pub get                       # at the repo root — re-resolves the workspace
flutter analyze --no-pub              # covers the whole workspace
cd apps/{NewName} && flutter test     # run the renamed app's tests
```

Zero issues = rename complete.
