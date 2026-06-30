'use strict';

/**
 * Runs apps under `apps/` as managed `flutter run -d web-server` processes so the
 * UI can Run/Stop them and the preview pane can embed them. Each app runs on its
 * deterministic `previewPort` (from apps.js), so the preview URL is known before
 * the build finishes.
 *
 * Lifecycle states reported to the UI: `stopped` → `starting` (spawned, build in
 * progress) → `running` (dev server is serving). The process is spawned in its
 * own group (`detached`) so Stop / shutdown can kill the whole `flutter` →
 * `dart` → web-server tree, not just the wrapper.
 */

const { spawn } = require('child_process');
const { listApps } = require('./apps');
const { FLUTTER_BIN } = require('./config');
const { tileForNativeRun } = require('./window-tiler');
const { bootEmulator } = require('./devices');
const logger = require('./logger');

// name -> { child, port, status, deviceId, platform, target }
const running = new Map();

// flutter prints this once the web dev server is actually serving.
const READY_RE = /is being served at|Serving at/i;

// flutter prints one of these once a native run is installed and live on the
// device (the point at which the device window exists, so we can tile it).
const NATIVE_READY_RE =
  /Flutter run key commands|Dart VM Service .* is available|Syncing files to device/i;

// fvm and Homebrew tools live here; prepend them so the spawned `fvm flutter`
// is found even when the bridge was launched from a GUI/VS Code shell that
// didn't source a login profile.
const EXTRA_PATH = ['/opt/homebrew/bin', '/usr/local/bin'];

function runEnv() {
  return {
    ...process.env,
    PATH: [...EXTRA_PATH, process.env.PATH || ''].join(':'),
  };
}

function findApp(name) {
  return listApps().find((a) => a.name === name) || null;
}

/** Uniform shape returned everywhere: static app info + live run state. */
function describe(name) {
  const app = findApp(name);
  const r = running.get(name);
  // previewPort is meaningful (and iframe-embeddable) only for a web target.
  const isWeb = !r || r.target === 'web';
  return {
    name,
    path: app ? app.path : '',
    previewPort: isWeb && app ? app.previewPort : null,
    running: !!r && r.status === 'running',
    status: r ? r.status : 'stopped',
    message: r && r.message ? r.message : null,
    deviceId: r ? r.deviceId : null,
    platform: r ? r.platform : null,
    target: r ? r.target : null,
  };
}

/** Each app under apps/ with its current run state. */
function listAppsWithState() {
  return listApps().map((a) => describe(a.name));
}

/**
 * Start an app on a run target (idempotent — returns the current state if
 * already running). Defaults to the `web-server` target so an empty body keeps
 * the original embedded-iframe behaviour. `kind`:
 *   - `web`      → run on web-server, embed in the iframe.
 *   - `device`   → run on the already-connected device, then tile.
 *   - `emulator` → boot the offline emulator first, then run on it + tile.
 */
function runApp(name, { deviceId = 'web-server', platform = 'web', kind = 'web' } = {}) {
  const app = findApp(name);
  if (!app) throw new Error(`unknown app: ${name}`);
  // A `failed` entry lingers only to report the error — a fresh Run clears it.
  const existing = running.get(name);
  if (existing && existing.status !== 'failed') return describe(name);
  if (existing) running.delete(name);

  const isWeb = kind === 'web' || platform === 'web' || deviceId === 'web-server';

  // Offline emulator: hold `starting` while it boots (no flutter child yet), then
  // run on whatever device id it comes up as.
  if (kind === 'emulator' && !isWeb) {
    const entry = {
      child: null,
      port: null,
      status: 'starting',
      deviceId: null,
      platform,
      target: 'native',
      emulatorId: deviceId,
    };
    running.set(name, entry);
    logger.info('run', `${name} booting emulator ${deviceId}`);
    startEmulatorRun(name, app, deviceId, platform, entry);
    return describe(name);
  }

  const entry = {
    child: null,
    port: isWeb ? app.previewPort : null,
    status: 'starting',
    deviceId: isWeb ? null : deviceId,
    platform,
    target: isWeb ? 'web' : 'native',
  };
  running.set(name, entry);
  spawnRun(name, app, { deviceId, isWeb, entry });
  return describe(name);
}

// Spawn `flutter run` for an app on a target and wire its lifecycle into `entry`.
// Native runs tile the windows once the device is live.
function spawnRun(name, app, { deviceId, isWeb, entry }) {
  const [cmd, ...baseArgs] = FLUTTER_BIN.split(' ').filter(Boolean);
  const runArgs = isWeb
    ? ['run', '-d', 'web-server', '--web-hostname', 'localhost',
       '--web-port', String(app.previewPort)]
    : ['run', '-d', deviceId];
  const child = spawn(cmd, [...baseArgs, ...runArgs], {
    cwd: app.path,
    env: runEnv(),
    detached: true,
  });
  entry.child = child;
  entry.deviceId = isWeb ? null : deviceId;

  const where = isWeb ? `:${app.previewPort}` : deviceId;
  logger.info('run', `${name} starting on ${where} (pid ${child.pid})`);

  const readyRe = isWeb ? READY_RE : NATIVE_READY_RE;
  child.stdout.on('data', (buf) => {
    if (entry.status === 'starting' && readyRe.test(buf.toString())) {
      entry.status = 'running';
      logger.info('run', `${name} ready on ${where}`);
      if (!isWeb) tileForNativeRun();
    }
  });
  child.stderr.on('data', (buf) =>
    logger.warn('run', `${name}: ${buf.toString().trim()}`),
  );
  child.on('error', (err) => {
    logger.error('run', `${name} failed to spawn: ${err.message}`);
    entry.status = 'failed';
    entry.message = `Failed to start: ${err.message}`;
  });
  child.on('exit', (code) => {
    logger.info('run', `${name} exited (code ${code})`);
    // Exiting before it ever became ready is a launch failure worth surfacing;
    // a clean exit after running (or a Stop) just clears the entry.
    if (entry.status === 'starting') {
      entry.status = 'failed';
      entry.message = `Stopped before it could start (exit ${code}).`;
    } else if (running.get(name) === entry) {
      running.delete(name);
    }
  });
}

// Boot an offline emulator, then run on the device it becomes. A Stop during the
// boot (entry swapped/removed) cancels before any flutter process is spawned.
async function startEmulatorRun(name, app, emulatorId, platform, entry) {
  const isCancelled = () => running.get(name) !== entry;
  try {
    const deviceId = await bootEmulator(emulatorId, platform, isCancelled);
    if (isCancelled()) return;
    if (!deviceId) {
      logger.warn('run', `${name}: emulator ${emulatorId} did not come online`);
      entry.status = 'failed';
      entry.message = 'The emulator did not come online in time. Try starting it first.';
      return;
    }
    logger.info('run', `${name}: emulator up as ${deviceId}`);
    spawnRun(name, app, { deviceId, isWeb: false, entry });
  } catch (e) {
    logger.error('run', `${name}: emulator boot failed: ${e.message}`);
    if (!isCancelled()) {
      entry.status = 'failed';
      entry.message = `Couldn't boot the emulator: ${e.message}`;
    }
  }
}

/** Stop an app's run (idempotent). Leaves a booted emulator running. */
function stopApp(name) {
  const entry = running.get(name);
  if (entry) {
    if (entry.child) killGroup(entry.child);
    running.delete(name);
    logger.info('run', `${name} stopped`);
  }
  return describe(name);
}

function killGroup(child) {
  try {
    process.kill(-child.pid, 'SIGTERM'); // negative pid = the whole group
  } catch {
    try {
      child.kill('SIGTERM');
    } catch {
      /* already gone */
    }
  }
}

/** Tear every managed app down (called on server shutdown). */
function disposeAllApps() {
  for (const entry of running.values()) if (entry.child) killGroup(entry.child);
  running.clear();
}

module.exports = { runApp, stopApp, describe, listAppsWithState, disposeAllApps };
