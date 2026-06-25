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
const logger = require('./logger');

// name -> { child, port, status: 'starting' | 'running' }
const running = new Map();

// flutter prints this once the web dev server is actually serving.
const READY_RE = /is being served at|Serving at/i;

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
  return {
    name,
    path: app ? app.path : '',
    previewPort: app ? app.previewPort : null,
    running: !!r,
    status: r ? r.status : 'stopped',
  };
}

/** Each app under apps/ with its current run state. */
function listAppsWithState() {
  return listApps().map((a) => describe(a.name));
}

/** Start an app (idempotent — returns the current state if already running). */
function runApp(name) {
  const app = findApp(name);
  if (!app) throw new Error(`unknown app: ${name}`);
  if (running.get(name)) return describe(name);

  // FLUTTER_BIN is "fvm flutter" by default — split into command + base args.
  const [cmd, ...baseArgs] = FLUTTER_BIN.split(' ').filter(Boolean);
  const child = spawn(
    cmd,
    [
      ...baseArgs,
      'run',
      '-d',
      'web-server',
      '--web-hostname',
      'localhost',
      '--web-port',
      String(app.previewPort),
    ],
    { cwd: app.path, env: runEnv(), detached: true },
  );

  const entry = { child, port: app.previewPort, status: 'starting' };
  running.set(name, entry);
  logger.info('run', `${name} starting on :${app.previewPort} (pid ${child.pid})`);

  child.stdout.on('data', (buf) => {
    if (entry.status === 'starting' && READY_RE.test(buf.toString())) {
      entry.status = 'running';
      logger.info('run', `${name} ready on :${app.previewPort}`);
    }
  });
  child.stderr.on('data', (buf) =>
    logger.warn('run', `${name}: ${buf.toString().trim()}`),
  );
  child.on('error', (err) => {
    logger.error('run', `${name} failed to spawn: ${err.message}`);
    running.delete(name);
  });
  child.on('exit', (code) => {
    logger.info('run', `${name} exited (code ${code})`);
    running.delete(name);
  });

  return describe(name);
}

/** Kill an app's process group (idempotent). */
function stopApp(name) {
  const entry = running.get(name);
  if (entry) {
    killGroup(entry.child);
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
  for (const entry of running.values()) killGroup(entry.child);
  running.clear();
}

module.exports = { runApp, stopApp, describe, listAppsWithState, disposeAllApps };
