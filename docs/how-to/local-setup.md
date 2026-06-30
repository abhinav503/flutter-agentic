# Local Setup — from a blank Mac to generating Flutter apps

This guide turns a **fresh macOS machine** (even one that has never done any
development) into a full Flutter workstation: Flutter, the AI agent, and — for
on-device preview — Xcode + iPhone Simulator and Android Studio + emulator.

It's ordered so the **essentials come first**: after Homebrew → Node → fvm →
Flutter you can already run the Web Terminal itself. The heavier native-device
toolchain (Xcode, Android) comes after, and is only needed to preview apps on a
real simulator/emulator.

Run the commands **one block at a time, top to bottom.** Each block is
independent: paste it into the terminal, wait for it to finish, then move to the
next. Steps marked ⚠️ need a click or a password — they can't be automated, so
don't skip them.

> **Before you start**
> - **macOS only** for the full set — iPhone Simulator and Xcode exist only on
>   Mac. On Linux you can do everything *except* the Xcode/iOS section (Android
>   only). Windows is not supported by the Web Terminal bridge.
> - **An Apple ID** — required to download Xcode (free to create at
>   [appleid.apple.com](https://appleid.apple.com)).
> - **~40 GB free disk** and **1–2 hours** if you install everything, almost all
>   of it unattended downloading. The run-it essentials (steps 1–4) are a small
>   fraction of that.
> - **Your Mac password** — several steps prompt for it (that's normal; the
>   terminal won't show characters as you type it).

---

## 1. Homebrew — the package manager everything else uses

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

⚠️ It will ask for your Mac password and pause on `Press RETURN to continue`.

On **Apple Silicon (M1/M2/M3/M4)** Macs, add Homebrew to your shell so the
`brew` command is found in new terminals:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
```

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

---

## 2. Node.js — runs the Web Terminal bridge

```bash
brew install node
```

Recommended file-watcher (Flutter uses it for fast reloads):

```bash
brew install watchman
```

---

## 3. fvm + Flutter — installed at the version this repo is pinned to

This repo pins Flutter with **fvm** (currently `3.44.0`), so everyone runs the
exact same SDK. Install fvm:

```bash
brew install fvm
```

Move into the project folder (adjust the path if you cloned it elsewhere):

```bash
cd ~/Desktop/CordeliaBase
```

Install the pinned Flutter version (reads `.fvm/fvm_config.json`):

```bash
fvm install
```

> If fvm reports no pinned version, run `fvm use 3.44.0` once, then `fvm install`.

---

## ✅ Checkpoint — you can run the Web Terminal now

With Homebrew, Node, fvm, and Flutter in place, the app runs. Wire the workspace
and launch it:

```bash
make setup
```

```bash
make web-terminal
```

Open **http://localhost:3000**. The terminal works, and the **Setup** button in
the top bar shows this same checklist live — green for what's installed, with the
remaining steps below.

Everything past this point is for **previewing apps on a real device**. Install
the agent next, then the iOS/Android toolchains only if you want on-device runs.

---

## 4. The AI coding agent

The Web Terminal's agent switcher launches **`claude`** (or `codex`). Install
Claude Code:

```bash
npm install -g @anthropic-ai/claude-code
```

Sign in once (opens your browser):

```bash
claude
```

> Codex is optional — `npm install -g @openai/codex` if you want the second
> switcher entry too.

---

## 5. Xcode + iPhone Simulator  *(macOS only — skip on Linux)*

First the lightweight command-line tools:

```bash
xcode-select --install
```

⚠️ A dialog appears — click **Install** and wait for it to finish.

Now the full Xcode. **Simplest path (recommended for non-developers):** open the
**App Store**, search **Xcode**, click **Get / Install**, and wait (~15 GB).

<details>
<summary>Command-line alternative (pins a specific version)</summary>

```bash
brew install xcodes
```

```bash
xcodes install --latest
```

⚠️ `xcodes` asks for your **Apple ID email and password** to download from Apple.
</details>

Once Xcode is installed, finish its first-time setup and accept the licence:

```bash
sudo xcodebuild -runFirstLaunch
```

```bash
sudo xcodebuild -license accept
```

Download the iOS Simulator runtime (recent Xcode ships it separately):

```bash
xcodebuild -downloadPlatform iOS
```

CocoaPods is needed to build iOS apps:

```bash
brew install cocoapods
```

Verify a simulator exists, then open it:

```bash
xcrun simctl list devices available | grep iPhone
```

```bash
open -a Simulator
```

---

## 6. Android Studio + Android emulator

Install the IDE:

```bash
brew install --cask android-studio
```

⚠️ **Open Android Studio once** (from Launchpad/Applications). The first-launch
**Setup Wizard** downloads the Android SDK, platform-tools, and an emulator
system image — click through it with the **Standard** option and let it finish.
This GUI step can't be scripted, and the steps below depend on it.

After the wizard completes, point your shell at the Android SDK:

```bash
echo 'export ANDROID_HOME="$HOME/Library/Android/sdk"' >> ~/.zprofile
echo 'export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"' >> ~/.zprofile
```

```bash
source ~/.zprofile
```

Accept the Android SDK licences (type `y` at each prompt):

```bash
fvm flutter doctor --android-licenses
```

Create and launch an Android emulator:

```bash
fvm flutter emulators --create --name pixel
```

```bash
fvm flutter emulators --launch pixel
```

---

## 7. Verify the whole toolchain

The single check that confirms everything:

```bash
fvm flutter doctor -v
```

You want **✓** for *Flutter*, *Android toolchain*, *Xcode*, and at least one
device under *Connected devices* with a simulator/emulator running. A red ✗ tells
you which section above to revisit.

---

## Quick reference — what each tool is for

| Tool | Installs | Why you need it |
|---|---|---|
| **Homebrew** | everything below | macOS package manager; the one installer behind the rest |
| **Node + watchman** | JS runtime, file watcher | runs the Web Terminal bridge; fast Flutter reloads |
| **fvm** | the pinned Flutter SDK | everyone runs the exact same Flutter version |
| **Flutter** | the SDK | builds and runs the apps (and the Web Terminal itself) |
| **Claude / codex** | the AI coding agent | generates the Flutter code from the UI |
| **Xcode** | iOS Simulator, build tools | run/preview apps on an iPhone simulator (macOS only) |
| **CocoaPods** | iOS dependency manager | building any iOS app |
| **Android Studio** | Android SDK + emulator | run/preview apps on Android |

> **Why one-at-a-time, not auto-run:** these installs are long, interactive
> (Apple ID, passwords, GUI wizards) and download tens of GB. An agent that tries
> to orchestrate them stalls waiting on prompts it can't answer. Running each
> block yourself is deterministic and never gets stuck.
