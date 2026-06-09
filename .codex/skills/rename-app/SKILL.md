---
name: rename-app
description: >
  Rename the Flutter app across all platform files (iOS, Android, Web),
  Dart source, test imports, VS Code config, and all AI rules/docs.
  Invoke with $rename-app or ask to rename/rebrand the app.
---

If the new app name was not passed as an argument, ask:
"What should the new app name be? Provide two forms:
1. Display name (PascalCase or branded, shown to users) e.g. `MyApp`
2. Package name (snake_case, used in Dart imports) e.g. `my_app`"

Derive the old package name from the current `name:` field in `pubspec.yaml`.
Derive the old display name from `ValueConst.appTitle` in `lib/core/constants/value_const.dart`.

`{NewDisplay}` = the branded display name (e.g. `FlutterAgentic`)
`{NewPackage}` = snake_case Dart package name (e.g. `flutter_agentic`)
`{NewBundleId}` = `com.example.{NewPackage}` unless the user specifies a custom bundle ID

---

## Files to update

### 1. pubspec.yaml
Replace `name: {OldPackage}` with `name: {NewPackage}`

### 2. Dart source
- `lib/app.dart` — `title:` string
- `lib/core/constants/value_const.dart` — `appTitle` constant

### 3. Web
- `web/index.html` — `<title>` and `apple-mobile-web-app-title` meta
- `web/manifest.json` — `name` and `short_name`

### 4. iOS
- `ios/Runner/Info.plist` — `CFBundleDisplayName` (user-visible) and `CFBundleName` (snake_case)

### 5. Android
- `android/app/src/main/AndroidManifest.xml` — `android:label`
- `android/app/build.gradle.kts` — `namespace` and `applicationId`
- `android/app/src/main/kotlin/com/example/{OldPackage}/MainActivity.kt`:
  1. Create `android/app/src/main/kotlin/com/example/{NewPackage}/`
  2. Move `MainActivity.kt` into it
  3. Update the `package` declaration at the top
  4. Delete the old directory

### 6. Test imports
Find-and-replace across all `test/` files:
`package:{OldPackage}/` → `package:{NewPackage}/`

### 7. VS Code
- `.vscode/launch.json` — all three configuration `name` strings

### 8. AI rules and docs
Global find-and-replace on all of: `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`,
`.github/copilot-instructions.md`, `.amazonq/rules/`, `.cursor/rules/`,
all `.md` files under `docs/`, all `SKILL.md` files under `.claude/skills/`
and `.codex/skills/`.

Replace all three text forms:
- `{OldDisplay}` → `{NewDisplay}`
- `{OldPackage}` → `{NewPackage}`

---

## Finish
Run these commands in order and report the result:
```bash
flutter pub get
flutter analyze
flutter test
```

Zero issues = rename complete. List any remaining references if found.
