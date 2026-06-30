'use strict';

/**
 * Lists the run targets the UI offers — the same set VS Code's device picker
 * shows, from two Flutter commands:
 *   - `flutter devices`   → what's connected/booted right now (`kind: 'device'`).
 *   - `flutter emulators` → installed simulators/AVDs that are NOT running yet
 *                           (`kind: 'emulator'`); selecting one boots it first.
 * Plus the always-present synthetic "Web preview" (`kind: 'web'`) that embeds in
 * the iframe with zero setup.
 *
 * `platform` is the UI's coarse category (web / ios / android / other); the UI
 * branches on it (embed vs. native launch) and on `kind` (run directly vs. boot
 * the emulator first).
 */

const { execFile } = require('child_process');
const { FLUTTER_BIN } = require('./config');

// fvm and Homebrew tools live here; match app-runner.js so `fvm flutter`
// resolves even when the bridge was launched from a GUI shell.
const EXTRA_PATH = ['/opt/homebrew/bin', '/usr/local/bin'];

const WEB_PREVIEW = Object.freeze({
  id: 'web-server',
  name: 'Web preview',
  platform: 'web',
  kind: 'web',
  isEmulator: false,
});

function runEnv() {
  return { ...process.env, PATH: [...EXTRA_PATH, process.env.PATH || ''].join(':') };
}

function flutter(args, { timeout = 25000 } = {}) {
  const [cmd, ...baseArgs] = FLUTTER_BIN.split(' ').filter(Boolean);
  return new Promise((resolve) => {
    execFile(
      cmd,
      [...baseArgs, ...args],
      { timeout, env: runEnv() },
      (err, stdout) => resolve({ err, out: (stdout || '').toString() }),
    );
  });
}

// Flutter's targetPlatform ('ios', 'android-arm64', 'web-javascript', 'darwin')
// → the UI's coarse category.
function categorize(targetPlatform, id) {
  const t = String(targetPlatform || '');
  if (t.startsWith('web') || id === 'chrome' || id === 'web-server') return 'web';
  if (t.startsWith('ios')) return 'ios';
  if (t.startsWith('android')) return 'android';
  return 'other';
}

// `flutter devices --machine` → connected/booted devices (raw, with emulatorId).
async function rawDevices() {
  const { out } = await flutter(['devices', '--machine']);
  try {
    return (JSON.parse(out || '[]') || []).map((d) => ({
      id: String(d.id || ''),
      name: String(d.name || d.id || 'device'),
      platform: categorize(d.targetPlatform, d.id),
      isEmulator: !!d.emulator,
      emulatorId: d.emulatorId ? String(d.emulatorId) : null,
    }));
  } catch {
    return [];
  }
}

// `flutter emulators` prints a `Id • Name • Manufacturer • Platform` table (no
// --machine flag exists) → parse it to the launchable catalog.
async function rawEmulators() {
  const { out } = await flutter(['emulators']);
  const rows = [];
  for (const line of out.split('\n')) {
    if (!line.includes('•')) continue;
    const cols = line.split('•').map((s) => s.trim());
    if (cols.length < 4 || cols[0] === 'Id' || !cols[0]) continue;
    rows.push({ id: cols[0], name: cols[1], platform: cols[3].toLowerCase() });
  }
  return rows;
}

/**
 * `[{ id, name, platform, kind, isEmulator }]`: web preview, then connected
 * devices, then offline emulators. A booted emulator is shown once (as a
 * connected device) — its catalog entry is dropped via `emulatorId`. Real
 * `chrome`/`web-server` device rows are dropped (web preview already covers it).
 */
async function listDevices() {
  const [devices, emulators] = await Promise.all([rawDevices(), rawEmulators()]);

  const connected = devices
    .filter((d) => d.platform !== 'web')
    .map((d) => ({
      id: d.id,
      name: d.name,
      platform: d.platform,
      kind: 'device',
      isEmulator: d.isEmulator,
    }));

  const bootedEmulatorIds = new Set(
    devices.map((d) => d.emulatorId).filter(Boolean),
  );
  const offline = emulators
    .filter((e) => !bootedEmulatorIds.has(e.id))
    .map((e) => ({
      id: e.id,
      name: e.name,
      platform: e.platform === 'ios' ? 'ios' : e.platform === 'android' ? 'android' : 'other',
      kind: 'emulator',
      isEmulator: true,
    }));

  return [WEB_PREVIEW, ...connected, ...offline];
}

const delay = (ms) => new Promise((r) => setTimeout(r, ms));

/**
 * Boot an offline emulator and resolve the device id it comes up as (so we can
 * `flutter run -d <deviceId>` on it). Resolves null on timeout/cancel. Cold
 * Android boots are slow, hence the generous window.
 */
async function bootEmulator(emulatorId, platform, isCancelled) {
  const before = new Set((await rawDevices()).map((d) => d.id));
  await flutter(['emulators', '--launch', emulatorId], { timeout: 30000 });

  for (let i = 0; i < 60; i++) {
    if (isCancelled && isCancelled()) return null;
    await delay(2000);
    const fresh = (await rawDevices()).find(
      (d) => !before.has(d.id) && (d.platform === platform || platform === 'other'),
    );
    if (fresh) return fresh.id;
  }
  return null;
}

module.exports = { listDevices, WEB_PREVIEW, bootEmulator };
