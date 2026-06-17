---
name: setup-project
description: >
  Check all prerequisites needed to run this Flutter project locally.
  Verifies Flutter SDK, Dart, dependencies, generated files, git hooks,
  available run targets, and static analysis. Auto-fixes missing dependencies
  and generated files. For platform tools (Android Studio, Xcode), shows
  flutter doctor output only — no install or configuration commands.
  Invoke with $setup-project or ask about project setup.
---

Check every prerequisite needed to run this Flutter project locally, then show the user a checklist with the status of each item.

> **Monorepo note:** this is a Dart pub-workspace monorepo (`packages/core` + `apps/*`). One `flutter pub get` **at the repo root** resolves every package; `make` targets are run from the root. After cloning, the canonical first-time setup is `make setup` (installs git hooks + root `flutter pub get`). The root has no runnable app — apps live under `apps/<app>/`.

## What to check

Run these checks using terminal/shell tools. Never assume — always verify the actual state.

### 1. Flutter SDK
- Run `flutter --version` — capture the version string
- Check that the Flutter version meets the `environment.sdk` constraint in the root `pubspec.yaml`
- If Flutter is not installed or the wrong version: ❌ — tell the user to install Flutter from https://docs.flutter.dev/get-started/install

### 2. Dart SDK
- Confirm Dart version from `dart --version`
- Cross-check against `environment.sdk` in the root `pubspec.yaml`

### 3. Dependencies
- Check if `pubspec.lock` exists at the repo root
- If missing: **automatically run `flutter pub get` at the repo root** (resolves the whole workspace — never run it inside an app folder) and report it as fixed, not as an error
- Show ✅ after it completes successfully, ❌ if it fails

### 4. Code generation
- Scan `packages/core/lib/` **and** every `apps/*/lib/` for `part '*.freezed.dart'` and `part '*.g.dart'` declarations whose target files don't exist on disk
- If any are missing: **automatically run `make gen`** (regenerates `core` + each app) and report it as fixed
- Show ✅ after it completes successfully, ❌ if it fails
- Do not ask the user — just run it and report the outcome

### 5. Git hooks
- Check if `git config core.hooksPath` is set to `.githooks` (set up by `make setup`)
- Check if `.githooks/pre-commit` is executable (`-x` permission)

### 6. Available run targets
- Run `flutter devices` — list all currently visible targets
- Report each device/simulator/emulator found as ✅
- If no Android target is found: ⚠️ — "No Android emulator detected"
- If on macOS and no iOS target found: ⚠️ — "No iOS simulator detected"
- If no targets at all: ❌

### 7. flutter doctor (platform tools)
- Run `flutter doctor` — show its output as-is for the Android and iOS/Xcode sections only
- Do **not** attempt to install, configure, or fix anything in Android Studio, Xcode, or SDKs — that is the user's responsibility
- The flutter doctor output is informational only

### 8. Theme config (per app)
- For each app under `apps/<app>/`, confirm `apps/<app>/assets/theme/theme_config.json` exists
- Confirm it is listed under `flutter > assets` in that app's `apps/<app>/pubspec.yaml`
- Parse and show each app's current `activeTheme` value

### 9. Static analysis
- Run `make analyze` (covers the whole workspace in one pass)
- Report pass or list issues

---

## Output format

Show a single checklist. Each item must have:
- ✅ passing
- ✅ *(auto-fixed)* — was missing but was fixed automatically during this check
- ❌ failing — one-line reason (requires manual action)
- ⚠️ warning / optional

After the checklist, show a **"What to do"** section listing only items that still require manual action.

For platform tool issues (Android Studio, Xcode, simulators), always direct the user to the `flutter doctor` output — never provide install commands for those tools.

Dependencies and generated files are **auto-fixed silently** — run the commands, then show the result. Never ask the user first.

---

## Example output

```
## Project Setup Checklist

✅ Flutter 3.x.x (stable) — meets SDK constraint ^3.x.x
✅ Dart 3.x.x
✅ Dependencies fetched *(auto-fixed — ran flutter pub get at root)*
✅ Generated files *(auto-fixed — ran make gen)*
✅ Git hooks active (.githooks/pre-commit executable)
⚠️ Android — no emulator detected
⚠️ iOS — no simulator detected
✅ Theme config — jokes: "dadJokes", doc_scanner: "oceanBreeze"
✅ make analyze — no issues

## flutter doctor (platform tools)

[paste relevant Android / Xcode sections from flutter doctor output here]

## What to do

⚠️ No run targets found — see flutter doctor output above to set up Android Studio or Xcode
```

Keep output concise. Do not explain items that are already passing.
