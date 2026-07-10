'use strict';

/**
 * Single source of truth for runtime configuration.
 *
 * Everything env-derived is resolved once, here, so the rest of the codebase
 * imports a frozen object instead of reaching into `process.env` ad hoc.
 * Overridable via env vars: PORT, TERMINAL_TOKEN, SHELL.
 */

const os = require('os');
const path = require('path');
const crypto = require('crypto');

// Loopback by default — never bind a public interface on a dev machine. In the
// cloud container a reverse proxy (Caddy) is the only public listener and the
// bridge stays on loopback inside the container's network namespace, so
// BIND_HOST is only for setups that genuinely need a different interface.
const HOST = process.env.BIND_HOST || '127.0.0.1';
const PORT = Number(process.env.PORT || 3000);

// Per-startup secret required on the WebSocket. A fresh random token each boot
// means a leaked token from a previous run can't be replayed.
const TOKEN = process.env.TERMINAL_TOKEN || crypto.randomBytes(16).toString('hex');

// A random token is only safe when it can't be reached: it is printed to the
// local console. On a non-loopback bind that log line is not a secret channel,
// so an explicit TERMINAL_TOKEN is mandatory there.
if (HOST !== '127.0.0.1' && HOST !== 'localhost' && !process.env.TERMINAL_TOKEN) {
  console.error(
    `Refusing to bind ${HOST} without TERMINAL_TOKEN — set an explicit token to expose the bridge beyond loopback.`,
  );
  process.exit(1);
}

// Prefer the user's login shell ($SHELL is set on both macOS and Linux). Fall
// back to the platform default: zsh is the macOS default; bash is present on
// virtually every Linux distro, whereas /bin/zsh often is not.
const SHELL =
  process.env.SHELL || (os.platform() === 'darwin' ? '/bin/zsh' : '/bin/bash');

// Command the app-runner uses to launch apps for preview. This repo is
// fvm-pinned (a prerequisite), so default to `fvm flutter` — that resolves the
// version in .fvm regardless of what a bare `flutter` on PATH points at.
// Override with FLUTTER_BIN (e.g. "flutter") for a non-fvm checkout.
const FLUTTER_BIN = process.env.FLUTTER_BIN || 'fvm flutter';

// Directory of the built Flutter web app (`flutter build web`). When present,
// the bridge serves the UI on the same port. Resolved from this file's
// location: src -> server -> web-terminal -> repo root -> apps/web_terminal/...
const WEB_DIR = path.resolve(
  __dirname,
  '..',
  '..',
  '..',
  'apps',
  'web_terminal',
  'build',
  'web',
);

// Directory the shell starts in. Defaults to the repo root, resolved from this
// file's location (src -> server -> web-terminal -> repo root) so it follows the
// checkout instead of a hardcoded path. Override with PROJECT_DIR.
const PROJECT_DIR =
  process.env.PROJECT_DIR || path.resolve(__dirname, '..', '..', '..');

// Comma-separated env lists → trimmed, empty entries dropped.
const envList = (name) =>
  (process.env[name] || '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);

// The only Host header values accepted — the core DNS-rebinding defense.
// ALLOWED_HOSTS extends the set with extra `host[:port]` values for deployments
// where the bridge is addressed by something other than loopback.
const ALLOWED_HOSTS = new Set([
  `127.0.0.1:${PORT}`,
  `localhost:${PORT}`,
  ...envList('ALLOWED_HOSTS'),
]);

// Extra origins (beyond localhost) allowed to read CORS responses — escape
// hatch for a console served from a different origin than the bridge. Empty by
// default; the cloud image doesn't need it (same-origin behind the proxy).
const ALLOWED_ORIGINS = new Set(envList('ALLOWED_ORIGINS'));

// Initial PTY geometry; the client sends a `resize` as soon as it knows its grid.
const PTY = Object.freeze({ name: 'xterm-256color', cols: 80, rows: 24 });

module.exports = Object.freeze({
  HOST,
  PORT,
  TOKEN,
  SHELL,
  FLUTTER_BIN,
  WEB_DIR,
  PROJECT_DIR,
  ALLOWED_HOSTS,
  ALLOWED_ORIGINS,
  PTY,
});
