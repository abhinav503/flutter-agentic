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
  listAppsWithState,
  disposeAllApps,
} = require('./src/app-runner');
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
function readJsonBody(req) {
  return new Promise((resolve) => {
    let raw = '';
    req.on('data', (chunk) => {
      raw += chunk;
      if (raw.length > 4096) req.destroy(); // tiny payload; reject anything large
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

server.listen(config.PORT, config.HOST, printBanner);
