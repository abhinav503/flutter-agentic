'use strict';

/**
 * Local PTY bridge for the Flutter web terminal — entrypoint.
 *
 * Holds your real local permissions: spawns your login shell as YOU and streams
 * it over a WebSocket. The browser never touches the shell directly — it only
 * sends keystrokes/resize events and renders the output it gets back.
 *
 * Security model (this is a remote shell to your Mac, so it matters):
 *   1. Binds to 127.0.0.1 only — never reachable from the network.
 *   2. Validates the Host header on every HTTP request and WS upgrade so a
 *      malicious page can't reach it via DNS-rebinding.
 *   3. Requires a per-startup token (printed below + served at /config.json)
 *      on the WebSocket query string.
 *
 * Composition only — the real work lives in ./src/* modules.
 */

const http = require('http');
const { WebSocketServer } = require('ws');

const config = require('./src/config');
const logger = require('./src/logger');
const { isHostAllowed, isLocalhostOrigin } = require('./src/security');
const { serveStatic, MIME } = require('./src/static-server');
const { createTerminalSession } = require('./src/terminal-session');
const {
  runApp,
  stopApp,
  hotRestart,
  listAppsWithState,
  disposeAllApps,
  freeStaleAppPorts,
} = require('./src/app-runner');
const { fileTree, readFile, writeFile, searchFiles } = require('./src/files');
const { setInspectorEnabled, selectedWidgetSource } = require('./src/inspector');
const { getSetupStatus } = require('./src/setup');
const { listDevices } = require('./src/devices');

// ── HTTP ────────────────────────────────────────────────────────────────────

// The Flutter app fetches this to learn the WS url + token. Same-origin in
// production; in dev (flutter run on another port) it's cross-origin, so we
// echo CORS ONLY for localhost origins. A public page (Origin https://evil.com)
// gets no allow-origin header and the browser blocks it from reading the token.
// Write a JSON body, echoing CORS only for localhost origins (same token-safety
// rule as /config.json): a public page can't read these responses cross-origin.
function sendJson(req, res, payload) {
  const origin = req.headers.origin || '';
  const headers = { 'content-type': MIME['.json'], 'cache-control': 'no-store' };
  if (isLocalhostOrigin(origin)) {
    headers['access-control-allow-origin'] = origin;
    headers['vary'] = 'Origin';
  }
  res.writeHead(200, headers);
  res.end(JSON.stringify(payload));
}

// CORS preflight for the app-management POSTs from a cross-origin dev page
// (flutter run on :4000 → bridge on :3000). Localhost origins only.
function handlePreflight(req, res) {
  const origin = req.headers.origin || '';
  const headers = {};
  if (isLocalhostOrigin(origin)) {
    headers['access-control-allow-origin'] = origin;
    headers['access-control-allow-methods'] = 'GET, POST, OPTIONS';
    headers['access-control-allow-headers'] = 'content-type';
    headers['vary'] = 'Origin';
  }
  res.writeHead(204, headers).end();
}

// Collect a small JSON request body; resolve {} on empty/invalid (the run
// target is optional — no body means the default web-server target).
function readJsonBody(req, limit = 4096) {
  return new Promise((resolve) => {
    let raw = '';
    req.on('data', (chunk) => {
      raw += chunk;
      if (raw.length > limit) req.destroy(); // reject anything over the cap
    });
    req.on('end', () => {
      try {
        resolve(raw ? JSON.parse(raw) : {});
      } catch {
        resolve({});
      }
    });
    req.on('error', () => resolve({}));
  });
}

// POST /apps/:name/run|stop — start or stop a managed `flutter run` process. run
// takes an optional `{ deviceId, platform }` body to pick the run target.
async function handleAppAction(req, res, name, action) {
  try {
    let app;
    if (action === 'run') {
      const { deviceId, platform, kind } = await readJsonBody(req);
      app = runApp(name, { deviceId, platform, kind });
    } else {
      app = stopApp(name);
    }
    sendJson(req, res, { app });
  } catch (e) {
    res
      .writeHead(400, { 'content-type': 'text/plain' })
      .end(String(e && e.message ? e.message : e));
  }
}

// GET  /apps/:name/files            → { tree }
// GET  /apps/:name/file?path=rel    → { path, content }
// POST /apps/:name/file             → { ok }        body: { path, content }
// GET  /apps/:name/search?q=text[&prefer=usage]  → { hits }
// POST /apps/:name/reload           → { ok, message? }  (hot restart)
// POST /apps/:name/inspect          → { ok, message? }  body: { enabled }
// GET  /apps/:name/inspect/selected → { source }        (widget under selection)
async function handleFilesRoute(req, res, name, kind) {
  const url = new URL(req.url, `http://${req.headers.host}`);
  const fail = (code, msg) =>
    res.writeHead(code, { 'content-type': 'text/plain' }).end(msg);

  if (kind === 'files' && req.method === 'GET') {
    const tree = fileTree(name);
    return tree ? sendJson(req, res, { tree }) : fail(404, 'unknown app');
  }
  if (kind === 'file' && req.method === 'GET') {
    const file = readFile(name, url.searchParams.get('path') || '');
    return file ? sendJson(req, res, file) : fail(404, 'file not found');
  }
  if (kind === 'file' && req.method === 'POST') {
    const { path: relPath, content } = await readJsonBody(req, 2 * 1024 * 1024);
    const ok =
      typeof relPath === 'string' && typeof content === 'string'
        ? writeFile(name, relPath, content)
        : false;
    return ok ? sendJson(req, res, { ok: true }) : fail(400, 'write failed');
  }
  if (kind === 'search' && req.method === 'GET') {
    const hits = searchFiles(
      name,
      url.searchParams.get('q') || '',
      url.searchParams.get('prefer') || undefined,
    );
    return hits ? sendJson(req, res, { hits }) : fail(404, 'unknown app');
  }
  if (kind === 'reload' && req.method === 'POST') {
    const result = await hotRestart(name);
    return sendJson(req, res, result);
  }
  // Inspector calls can throw/time out (VM service not up yet); always resolve
  // to JSON so the overlay's fallback path — not a 500 — handles unavailability.
  if (kind === 'inspect' && req.method === 'POST') {
    const { enabled } = await readJsonBody(req);
    const result = await setInspectorEnabled(name, !!enabled).catch((e) => ({
      ok: false,
      message: e.message,
    }));
    return sendJson(req, res, result);
  }
  if (kind === 'inspect/selected' && req.method === 'GET') {
    const source = await selectedWidgetSource(name).catch(() => null);
    return sendJson(req, res, { source });
  }
  fail(405, 'method not allowed');
}

const server = http.createServer((req, res) => {
  if (!isHostAllowed(req)) {
    res.writeHead(403, { 'content-type': 'text/plain' }).end('host not allowed');
    return;
  }
  if (req.method === 'OPTIONS') {
    handlePreflight(req, res);
    return;
  }
  const route = (req.url || '').split('?')[0];
  if (route === '/config.json') {
    sendJson(req, res, { wsPort: config.PORT, token: config.TOKEN });
    return;
  }
  // Lists the apps under apps/ with their live run state (status + port).
  if (route === '/apps' && req.method === 'GET') {
    sendJson(req, res, { apps: listAppsWithState() });
    return;
  }
  // Run targets: the synthetic "Web preview" plus whatever `flutter devices`
  // reports (simulators, emulators, phones).
  if (route === '/devices' && req.method === 'GET') {
    listDevices().then((devices) => sendJson(req, res, { devices }));
    return;
  }
  // Detects which local dev prerequisites are installed + their install steps.
  if (route === '/setup' && req.method === 'GET') {
    getSetupStatus().then((status) => sendJson(req, res, status));
    return;
  }
  const action = route.match(/^\/apps\/([A-Za-z0-9_]+)\/(run|stop)$/);
  if (action && req.method === 'POST') {
    handleAppAction(req, res, action[1], action[2]);
    return;
  }
  // Source-file access for the code view + visual edit (rooted at the app dir).
  const filesRoute = route.match(
    /^\/apps\/([A-Za-z0-9_]+)\/(files|file|search|reload|inspect|inspect\/selected)$/,
  );
  if (filesRoute) {
    handleFilesRoute(req, res, filesRoute[1], filesRoute[2]);
    return;
  }
  serveStatic(req, res);
});

// ── WebSocket ─────────────────────────────────────────────────────────────--

const wss = new WebSocketServer({ noServer: true });
const sessions = new Set(); // live sessions, so we can tear them down on shutdown

server.on('upgrade', (req, socket, head) => {
  if (!isHostAllowed(req)) {
    socket.write('HTTP/1.1 403 Forbidden\r\n\r\n');
    socket.destroy();
    return;
  }
  const url = new URL(req.url, `http://${req.headers.host}`);
  if (url.pathname !== '/ws' || url.searchParams.get('token') !== config.TOKEN) {
    socket.write('HTTP/1.1 401 Unauthorized\r\n\r\n');
    socket.destroy();
    return;
  }
  wss.handleUpgrade(req, socket, head, (ws) => wss.emit('connection', ws, req));
});

wss.on('connection', (ws) => {
  const session = createTerminalSession(ws);
  sessions.add(session);
  ws.on('close', () => sessions.delete(session));
});

// ── Lifecycle ─────────────────────────────────────────────────────────────--

function printBanner() {
  console.log('───────────────────────────────────────────────');
  console.log(' Local terminal bridge is running');
  console.log(` URL    : http://localhost:${config.PORT}`);
  console.log(` Shell  : ${config.SHELL}`);
  console.log(` Token  : ${config.TOKEN}`);
  console.log(' Bound to 127.0.0.1 only — not reachable from the network.');
  console.log('───────────────────────────────────────────────');
}

let shuttingDown = false;
function shutdown(signal) {
  if (shuttingDown) return;
  shuttingDown = true;
  logger.info('server', `received ${signal}, shutting down (${sessions.size} session(s))`);

  for (const session of sessions) session.dispose();
  sessions.clear();
  disposeAllApps(); // kill every managed `flutter run` process tree
  wss.close();
  server.close(() => {
    logger.info('server', 'closed cleanly');
    process.exit(0);
  });

  // Don't hang forever if a socket refuses to close.
  setTimeout(() => process.exit(1), 5000).unref();
}

server.on('error', (err) => {
  logger.error('server', `http server error: ${err.message}`);
  process.exit(1);
});
process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));

// Clear any flutter dev servers orphaned on app preview/VM-service ports by a
// previous bridge, so a fresh run can bind its fixed port.
freeStaleAppPorts();
server.listen(config.PORT, config.HOST, printBanner);
