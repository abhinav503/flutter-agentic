# How to Rename the App

Use this guide when you need to change the app's display name and Dart package name across all platform files, AI rules, and test imports.

You will need two values:

| Token | Form | Example |
|---|---|---|
| `{OldPackage}` | snake_case — current `name:` in `pubspec.yaml` | `flutter_agentic` |
| `{NewPackage}` | snake_case — desired Dart package name | `my_app` |
| `{NewDisplay}` | PascalCase or branded string — shown to users | `MyApp` |
| `{NewBundleId}` | reverse-DNS — Android/iOS bundle identifier | `com.example.my_app` |

---

## 1. pubspec.yaml

```
name: {OldPackage}   →   name: {NewPackage}
```

## 2. Dart source — app title

**`lib/app.dart`**
```dart
title: '{OldDisplay}'   →   title: '{NewDisplay}'
```

**`lib/core/constants/value_const.dart`**
```dart
static const appTitle = '{OldDisplay}';   →   static const appTitle = '{NewDisplay}';
```

## 3. Web

**`web/index.html`**
- `<meta name="apple-mobile-web-app-title" content="...">` → `{NewDisplay}`
- `<title>...</title>` → `{NewDisplay}`

**`web/manifest.json`**
- `"name"` and `"short_name"` → `{NewDisplay}`

## 4. iOS

**`ios/Runner/Info.plist`**
- `CFBundleDisplayName` → `{NewDisplay}`
- `CFBundleName` → `{NewPackage}`

## 5. Android

**`android/app/src/main/AndroidManifest.xml`**
- `android:label` → `{NewDisplay}`

**`android/app/build.gradle.kts`**
- `namespace` → `{NewBundleId}`
- `applicationId` → `{NewBundleId}`

**`android/app/src/main/kotlin/.../{OldPackage}/MainActivity.kt`**
1. Create directory: `android/app/src/main/kotlin/com/example/{NewPackage}/`
2. Move `MainActivity.kt` into the new directory
3. Update the `package` declaration at the top of the file to `{NewBundleId}`
4. Delete the old directory

## 6. Test imports

Run a find-and-replace across all files under `test/`:

```
package:{OldPackage}/   →   package:{NewPackage}/
```

## 7. VS Code launch config

**`.vscode/launch.json`** — update the three `name` strings:
```
{OldDisplay} (debug)    →   {NewDisplay} (debug)
{OldDisplay} (profile)  →   {NewDisplay} (profile)
{OldDisplay} (release)  →   {NewDisplay} (release)
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
flutter pub get
flutter analyze
flutter test
```

Zero issues = rename complete.
