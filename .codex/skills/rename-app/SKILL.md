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

This is a monorepo — each app lives under `apps/{app}/` (e.g. `apps/jokes`, `apps/doc_scanner`). Ask which app to rename if ambiguous; all paths below are relative to `apps/{app}/`. `core` is never renamed.

Derive the old package name from the `name:` field in `apps/{app}/pubspec.yaml`.
Derive the old display name from the `title:` string in `apps/{app}/lib/app.dart`.

`{NewDisplay}` = the branded display name (e.g. `FlutterAgentic`)
`{NewPackage}` = snake_case Dart package name (e.g. `flutter_agentic`)
`{NewBundleId}` = `com.example.{NewPackage}` unless the user specifies a custom bundle ID

---

## Files to update

### 1. pubspec.yaml
In `apps/{app}/pubspec.yaml`, replace `name: {OldPackage}` with `name: {NewPackage}`, then update this app's `package:{OldPackage}/...` imports across its lib/ and test/

### 2. Dart source
- `apps/{app}/lib/app.dart` — `title:` string
- `apps/{app}/lib/constants/value_const.dart` — title constant, only if the app defines one (title usually lives inline in app.dart)

### 3. Web
- `apps/{app}/web/index.html` — `<title>` and `apple-mobile-web-app-title` meta
- `apps/{app}/web/manifest.json` — `name` and `short_name`

### 4. iOS
- `apps/{app}/ios/Runner/Info.plist` — `CFBundleDisplayName` (user-visible) and `CFBundleName` (snake_case)

### 5. Android
- `apps/{app}/android/app/src/main/AndroidManifest.xml` — `android:label`
- `apps/{app}/android/app/build.gradle.kts` — `namespace` and `applicationId`
- `apps/{app}/android/app/src/main/kotlin/com/example/{OldPackage}/MainActivity.kt`:
  1. Create `apps/{app}/android/app/src/main/kotlin/com/example/{NewPackage}/`
  2. Move `MainActivity.kt` into it
  3. Update the `package` declaration at the top
  4. Delete the old directory

### 6. Test imports
Find-and-replace across all `apps/{app}/test/` files:
`package:{OldPackage}/` → `package:{NewPackage}/`

### 7. VS Code
- `.vscode/launch.json` — the renamed app's config trio (debug/profile/release): `name` strings and `cwd` (apps/{app})

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
flutter pub get          # at repo root — re-resolves the workspace
flutter analyze --no-pub
cd apps/{NewPackage} && flutter test
```

Zero issues = rename complete. List any remaining references if found.
