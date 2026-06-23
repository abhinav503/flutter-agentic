# macOS First-Start Checklist (dashboard: guide & verify)

> Companion to [local-ai-app-builder.md](./local-ai-app-builder.md), Section 11.
> Scope: **macOS only.** Approach is **guide + verify**, not silent auto-install. The first-start
> screen *detects* what's present, and for anything missing it shows a short instruction + a
> **"Check again"** button. The user installs the big tools themselves (Android Studio / Xcode /
> Flutter); the dashboard just checks state and tells them which devices are connected.

---

## Do we need permissions? (short answer: basically no)

For a **notarized, non-sandboxed** local app:

- **Running CLI commands needs no permission** — *as long as the control server spawns processes
  directly* (`flutter`, `adb`, `xcrun`). Don't script `Terminal.app` via AppleScript, or macOS
  shows an Automation prompt. Spawn subprocesses directly → silent.
- **Listing devices/emulators needs no permission:** `flutter devices`, `adb devices`,
  `xcrun simctl list`.
- **Two one-click prompts you may see once:** Gatekeeper ("open" the app — solved by notarizing)
  and the firewall ("accept incoming network connections" — because the server listens on a
  socket; harmless on `127.0.0.1`).

**Design rule:** notarize the app, spawn subprocesses directly, bind to `127.0.0.1`. No special
permissions, no admin password needed for normal running.

---

## First-start screen — the checklist

Three groups. **Common** is required. Then pick a track — **Android** and **iOS** are kept
separate so a user can ship to one without the other. Each item shows ✅ ready / ❌ missing, a
one-line what-to-do, and **Check again**.

### Common (needed for any app)

| # | Check | Detect | If missing, tell the user |
|---|---|---|---|
| 1 | **Flutter SDK on PATH** | `flutter --version` | Download Flutter, unzip, add `flutter/bin` to PATH (dashboard shows the exact line + which shell file). |
| 2 | **`flutter doctor` baseline** | `flutter doctor -v` | Mirror its checklist in the UI; the platform tracks below resolve each ❌. |
| 3 | **AI agent CLI + key** | `claude` / `codex` / `gemini` on PATH + a test call | Install the chosen CLI; paste API key (stored on-device). |
| 4 | **A connected device** | `flutter devices` | Shows what's connected; if none, point to the Android or iOS track to start one. |

### Android track

| # | Check | Detect | If missing, tell the user |
|---|---|---|---|
| A1 | **Android Studio + SDK** | SDK dir exists / `flutter doctor` Android line | Download & install **Android Studio** (bundles the SDK + emulator). |
| A2 | **SDK path known to Flutter** | `flutter doctor` finds the SDK | If not found: `flutter config --android-sdk <path>` (dashboard fills the usual path). |
| A3 | **Android licenses accepted** | `flutter doctor` license line | Run `flutter doctor --android-licenses` and accept. |
| A4 | **A virtual device exists** | `flutter emulators` / `emulator -list-avds` | Create one in Android Studio → Device Manager, or `flutter emulators --create`. |
| A5 | **Emulator running** | shows in `flutter devices` | One-click **Start emulator**; then it's the preview. |

### iOS track (macOS only — minimal, as you said)

| # | Check | Detect | If missing, tell the user |
|---|---|---|---|
| I1 | **Xcode installed** | `xcodebuild -version` | Install **Xcode** from the App Store. **The iOS Simulator ships with it** — nothing extra to install for simulator runs. |
| I2 | **Xcode license + path set** | `flutter doctor` Xcode line | Accept license (`sudo xcodebuild -license accept`) and `sudo xcode-select -s` to the Xcode app. |
| I3 | **CocoaPods** | `pod --version` | Install if the app uses plugins (most do, e.g. Firebase): `brew install cocoapods`. *(Skip if a plugin-free app.)* |
| I4 | **Simulator running** | shows in `flutter devices` | One-click **Open Simulator** (`open -a Simulator`); then it's the preview. |

> You're right that iOS is the lighter setup: **Xcode → Simulator is already there.** The only
> extra is CocoaPods, and only when the app uses native plugins. Steps I2/I3 are the two small
> gotchas worth surfacing.

### Done state

All Common ✅ + at least one track ✅ with a device showing in `flutter devices` → the **Run**
button unlocks. Scaffold from the template and run on the chosen device. That device *is* the
preview.

---

## What the dashboard does vs. what the user does

- **Dashboard:** detects each item, shows clear status, surfaces the exact command/instruction,
  re-checks on demand, lists connected devices, and one-click **starts an emulator/simulator** that
  already exists.
- **User (once):** installs the three big things — **Android Studio**, **Xcode**, **Flutter** —
  and sets PATHs. These are large App Store / website downloads we don't try to automate; we just
  guide and verify.

## Honest notes

- The big downloads (Android Studio, Xcode) are multi-GB and user-driven — set expectations with
  size + "this is a one-time setup."
- Keep **Android and iOS independent**: an Android-only user never touches Xcode, and ships faster.
- Test the whole checklist on a **fresh macOS account** to catch "I already had it installed"
  assumptions.

## Phasing

- **Dashboard v2:** Common + Android track (the fastest clean-Mac → running-app path).
- **Dashboard v3:** add the iOS track (Xcode + Simulator).
- **Later:** physical devices + store publishing (signing/keystores) via the publishing skills.
