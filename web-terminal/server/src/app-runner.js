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

const { spawn, execFileSync } = require('child_process');
const { listApps } = require('./apps');
const { FLUTTER_BIN } = require('./config');
const { tileForNativeRun } = require('./window-tiler');
const { bootEmulator } = require('./devices');
const logger = require('./logger');

// name -> { child, port, status, deviceId, platform, target }
const running = new Map();

// flutter prints this once the web dev server is actually serving.
const READY_RE = /is being served at|Serving at/i;

// The Dart VM Service URL for a web run. flutter prints it only AFTER a browser
// (our preview iframe) loads the app and the injected DWDS client connects —
// so this is scanned continuously, not at the ready line. The "Debug service
// listening on ws://…/ws" form is already the ws URL the inspector wants; the
// "A Dart VM Service … is available at: http://…" form is the http fallback.
// The auth-code token in the path is required (‑‑disable-service-auth-codes is
// ignored on web), so we keep the whole URL verbatim.
const VM_SERVICE_RE =
  /(?:Debug service listening on|Dart VM Service.*is available at:)\s+((?:ws|http)s?:\/\/\S+)/i;

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
  // Deterministic VM-service port (previewPort + 10000) so the inspector has a
  // predictable target; the real URL is still parsed from stdout in case
  // flutter falls back to a random port when this one is busy.
  const vmPort = isWeb ? app.previewPort + 10000 : null;
  const runArgs = isWeb
    ? ['run', '-d', 'web-server', '--web-hostname', 'localhost',
       '--web-port', String(app.previewPort),
       '--vm-service-port', String(vmPort),
       // SSE, not WebSocket, for the injected debug client: the app only runs
       // main() after this connection, and behind the preview proxy
       // (Docker/cloud) only plain HTTP can be forwarded — the console's
       // /$dwdsSseHandler route relays it to this dev server.
       '--web-server-debug-injected-client-protocol', 'sse']
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
    const text = buf.toString();
    // The VM-service URL appears after the browser connects (independent of the
    // ready line), so scan every chunk until we've captured it.
    if (isWeb && !entry.vmServiceUrl) {
      const m = text.match(VM_SERVICE_RE);
      if (m) {
        entry.vmServiceUrl = m[1];
        logger.info('run', `${name} vm-service at ${entry.vmServiceUrl}`);
      }
    }
    if (entry.status === 'starting' && readyRe.test(text)) {
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

/**
 * Hot-restart a running app by writing `R` to the `flutter run` key-command
 * stdin, resolving once flutter reports the restart finished (so the caller
 * can reload the preview iframe and see the new build). Times out rather than
 * hanging if flutter never answers.
 */
function hotRestart(name, timeoutMs = 60000) {
  const entry = running.get(name);
  if (!entry || !entry.child || entry.status !== 'running') {
    return Promise.resolve({ ok: false, message: 'app is not running' });
  }
  const { child } = entry;
  return new Promise((resolve) => {
    const done = (result) => {
      child.stdout.removeListener('data', onData);
      clearTimeout(timer);
      resolve(result);
    };
    // Rolling buffer so a completion phrase split across stdout chunks still
    // matches.
    let tail = '';
    const onData = (buf) => {
      tail = (tail + buf.toString()).slice(-4096);
      if (/Restarted application|Recompile complete|Hot restart performed/i.test(tail)) {
        done({ ok: true });
      }
    };
    const timer = setTimeout(
      () => done({ ok: false, message: 'restart timed out' }),
      timeoutMs,
    );
    child.stdout.on('data', onData);
    try {
      // Newline matters: stdin is a pipe (not a TTY), so flutter reads key
      // commands line-buffered.
      child.stdin.write('R\n');
      logger.info('run', `${name} hot restart requested`);
    } catch (e) {
      done({ ok: false, message: `couldn't reach the process: ${e.message}` });
    }
  });
}

/**
 * The running app's VM-service WebSocket URL (`ws://…/ws`) for the inspector,
 * or null if not captured yet (build still in progress, or the preview iframe
 * hasn't loaded the app so DWDS hasn't printed it). Normalizes the parsed URL:
 * http→ws / https→wss, strips a trailing slash, ensures the `/ws` suffix.
 */
function vmServiceUrlFor(name) {
  const entry = running.get(name);
  const raw = entry && entry.vmServiceUrl;
  if (!raw) return null;
  let url = raw.trim().replace(/\/+$/, '').replace(/^http/, 'ws');
  if (!url.endsWith('/ws')) url += '/ws';
  return url;
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

/**
 * Kill anything squatting an app's preview or VM-service port. Run once at
 * bridge startup: a fresh bridge manages nothing yet, so any listener on these
 * ports is an orphan — typically a `flutter run` dev server left behind by a
 * previous bridge that died ungracefully (SIGKILL/crash), which would otherwise
 * make a fresh run fail to bind its fixed port. Ports come from apps.js, so the
 * list is always accurate. Best-effort: lsof/ps/kill failures are ignored.
 */
function freeStaleAppPorts() {
  const ports = listApps().flatMap((a) => [
    a.previewPort,
    a.previewPort + 10000, // VM-service port (see spawnRun)
  ]);
  for (const port of ports) {
    let pids;
    try {
      pids = execFileSync('lsof', ['-ti', `tcp:${port}`, '-sTCP:LISTEN'], {
        stdio: ['ignore', 'pipe', 'ignore'],
      })
        .toString()
        .trim()
        .split('\n')
        .filter(Boolean)
        .map(Number);
    } catch {
      continue; // nothing listening (or lsof unavailable)
    }
    for (const pid of pids) {
      let pgid = pid;
      try {
        pgid =
          Number(
            execFileSync('ps', ['-o', 'pgid=', '-p', String(pid)])
              .toString()
              .trim(),
          ) || pid;
      } catch {
        /* fall back to the pid itself */
      }
      try {
        process.kill(-pgid, 'SIGKILL'); // whole flutter → dart tree
      } catch {
        try {
          process.kill(pid, 'SIGKILL');
        } catch {
          /* already gone */
        }
      }
    }
    if (pids.length) {
      logger.info('run', `freed stale port ${port} (killed ${pids.join(', ')})`);
    }
  }
}

/** Tear every managed app down (called on server shutdown). */
function disposeAllApps() {
  for (const entry of running.values()) if (entry.child) killGroup(entry.child);
  running.clear();
}

module.exports = {
  runApp,
  stopApp,
  hotRestart,
  vmServiceUrlFor,
  freeStaleAppPorts,
  describe,
  listAppsWithState,
  disposeAllApps,
};
