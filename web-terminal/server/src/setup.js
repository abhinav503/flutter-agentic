'use strict';

/**
 * Detects which local dev prerequisites are installed and returns, for each,
 * the copy-paste commands to install it (mirrors docs/how-to/local-setup.md).
 *
 * The UI renders this as a checklist in the right pane; the user runs the steps
 * one at a time in the terminal. We deliberately do NOT run installs here —
 * they're long, interactive (Apple ID, sudo, GUI wizards) and would hang an
 * automated runner. Detection only.
 *
 * Checks run in the user's LOGIN shell (`$SHELL -lc`) so PATH includes Homebrew,
 * fvm, etc. — exactly what an interactive terminal would see. `mac`-only items
 * (Xcode, iOS Simulator, CocoaPods) are dropped on Linux.
 */

const { execFile } = require('child_process');
const os = require('os');
const { SHELL, PROJECT_DIR, FLUTTER_BIN } = require('./config');

const isMac = os.platform() === 'darwin';
// When FLUTTER_BIN is a bare `flutter` (e.g. the cloud image, where the SDK is
// preinstalled), fvm isn't part of the toolchain and its checklist row would
// sit permanently red.
const usesFvm = FLUTTER_BIN.startsWith('fvm');

// Run a shell snippet in a login shell; resolve { ok, out } (never rejects).
function run(snippet) {
  return new Promise((resolve) => {
    execFile(
      SHELL,
      ['-lc', snippet],
      { timeout: 12000, cwd: PROJECT_DIR },
      (err, stdout) => resolve({ ok: !err, out: (stdout || '').toString().trim() }),
    );
  });
}

function firstLine(s) {
  return (s.split('\n')[0] || '').trim();
}

// Installed when the probe command exits 0; detail is its first line of output.
async function probe(snippet) {
  const { ok, out } = await run(snippet);
  return { installed: ok, detail: ok ? firstLine(out) : '' };
}

// label + command → a runnable step; label + note (manual: true) → a step the
// user does in the GUI (App Store, IDE wizard) that can't be a shell command.
const cmd = (label, command) => ({ label, command });
const manual = (label, note) => ({ label, note, manual: true });

const ITEMS = [
  {
    id: 'homebrew',
    name: 'Homebrew',
    description: 'macOS package manager — the installer behind everything below.',
    mac: true,
    detect: () => probe('command -v brew >/dev/null && brew --version'),
    steps: [
      cmd(
        'Install Homebrew',
        '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"',
      ),
      cmd(
        'Add brew to your shell (Apple Silicon)',
        'echo \'eval "$(/opt/homebrew/bin/brew shellenv)"\' >> ~/.zprofile && eval "$(/opt/homebrew/bin/brew shellenv)"',
      ),
    ],
  },

  // ── Minimum to run + generate: after these, `make web-terminal` works ───────
  {
    id: 'node',
    name: 'Node.js',
    description: 'JavaScript runtime — runs this terminal bridge itself.',
    detect: () => probe('command -v node >/dev/null && node --version'),
    steps: [
      cmd('Install Node', 'brew install node'),
      cmd('Install watchman (faster reloads)', 'brew install watchman'),
    ],
  },
  {
    id: 'fvm',
    name: 'fvm',
    description: 'Flutter version manager — pins the exact SDK this repo uses.',
    fvm: true,
    detect: () => probe('command -v fvm >/dev/null && fvm --version'),
    steps: [cmd('Install fvm', 'brew install fvm')],
  },
  {
    id: 'flutter',
    name: 'Flutter',
    description: 'The Flutter SDK, at the version pinned in .fvm.',
    detect: () =>
      probe('(fvm flutter --version 2>/dev/null || flutter --version 2>/dev/null) | head -1'),
    steps: [
      cmd('Install the pinned Flutter', 'fvm install'),
      cmd('Accept Android licences', 'fvm flutter doctor --android-licenses'),
      cmd('Verify the whole toolchain', 'fvm flutter doctor -v'),
    ],
  },
  {
    id: 'agent',
    name: 'Claude Code',
    description: 'The AI coding agent the terminal launches to generate apps.',
    detect: () => probe('command -v claude >/dev/null && claude --version'),
    steps: [
      cmd('Install Claude Code', 'npm install -g @anthropic-ai/claude-code'),
      cmd('Sign in (opens your browser)', 'claude'),
    ],
  },

  // ── Native device preview (iPhone / Android) — only for on-device runs ──────
  {
    id: 'xcode',
    name: 'Xcode',
    description: 'iOS build tools — required to run apps on an iPhone Simulator.',
    mac: true,
    detect: () => probe('[ -d "/Applications/Xcode.app" ] && xcode-select -p'),
    steps: [
      cmd('Install command-line tools', 'xcode-select --install'),
      manual(
        'Install Xcode',
        'Open the App Store, search "Xcode", and click Get/Install (~15 GB). Or run: brew install xcodes && xcodes install --latest',
      ),
      cmd('Finish first launch', 'sudo xcodebuild -runFirstLaunch'),
      cmd('Accept the licence', 'sudo xcodebuild -license accept'),
    ],
  },
  {
    id: 'ios-simulator',
    name: 'iPhone Simulator',
    description: 'The iOS simulator runtime the preview pane runs apps on.',
    mac: true,
    detect: () =>
      probe(
        'xcrun simctl list devices available 2>/dev/null | grep -q iPhone && echo "iPhone simulator available"',
      ),
    steps: [
      cmd('Download the iOS runtime', 'xcodebuild -downloadPlatform iOS'),
      cmd('Open the Simulator', 'open -a Simulator'),
    ],
  },
  {
    id: 'cocoapods',
    name: 'CocoaPods',
    description: 'iOS dependency manager — needed to build any iOS app.',
    mac: true,
    detect: () => probe('command -v pod >/dev/null && pod --version'),
    steps: [cmd('Install CocoaPods', 'brew install cocoapods')],
  },
  {
    id: 'accessibility',
    name: 'Window tiling (Accessibility)',
    description:
      'Lets the bridge place the device window beside the terminal on a native run.',
    mac: true,
    // A no-op keystroke only succeeds when the launching app (Terminal / VS Code)
    // has Accessibility — the same trust the window-tiler needs.
    detect: () =>
      probe(
        'osascript -e \'tell application "System Events" to keystroke ""\' >/dev/null 2>&1 && echo "Accessibility granted"',
      ),
    steps: [
      manual(
        'Grant Accessibility',
        'Open System Settings → Privacy & Security → Accessibility and enable your terminal app (Terminal, iTerm, or VS Code) — the one you launched this bridge from. Then re-check.',
      ),
    ],
  },
  {
    id: 'android-studio',
    name: 'Android Studio',
    description: 'Android SDK + IDE — for running apps on Android.',
    detect: () =>
      isMac
        ? probe('[ -d "/Applications/Android Studio.app" ] && echo "Android Studio installed"')
        : probe('command -v studio.sh >/dev/null && echo "Android Studio installed"'),
    steps: [
      cmd('Install Android Studio', 'brew install --cask android-studio'),
      manual(
        'Run the Setup Wizard',
        "Open Android Studio once and click through the Standard setup — it downloads the SDK, platform-tools, and an emulator image. This GUI step can't be scripted.",
      ),
      cmd(
        'Point your shell at the SDK',
        'echo \'export ANDROID_HOME="$HOME/Library/Android/sdk"\' >> ~/.zprofile && echo \'export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"\' >> ~/.zprofile && source ~/.zprofile',
      ),
    ],
  },
  {
    id: 'android-emulator',
    name: 'Android emulator',
    description: 'At least one Android Virtual Device to preview on.',
    detect: () =>
      probe(
        '"$HOME/Library/Android/sdk/emulator/emulator" -list-avds 2>/dev/null | grep -q . && echo "AVD found"',
      ),
    steps: [
      cmd('Create an emulator', 'fvm flutter emulators --create --name pixel'),
      cmd('Launch it', 'fvm flutter emulators --launch pixel'),
    ],
  },
];

/** `{ platform, items: [{ id, name, description, installed, detail, steps }] }`. */
async function getSetupStatus() {
  const items = ITEMS.filter((i) => (!i.mac || isMac) && (!i.fvm || usesFvm));
  const results = await Promise.all(
    items.map(async (i) => {
      let installed = false;
      let detail = '';
      try {
        const r = await i.detect();
        installed = r.installed;
        detail = r.detail || '';
      } catch {
        /* detection failed → treat as not installed */
      }
      return {
        id: i.id,
        name: i.name,
        description: i.description,
        installed,
        detail,
        steps: i.steps,
      };
    }),
  );
  return { platform: os.platform(), items: results };
}

module.exports = { getSetupStatus };
