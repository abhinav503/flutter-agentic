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

const HOST = '127.0.0.1'; // localhost only — never bind to a public interface
const PORT = Number(process.env.PORT || 3000);

// Per-startup secret required on the WebSocket. A fresh random token each boot
// means a leaked token from a previous run can't be replayed.
const TOKEN = process.env.TERMINAL_TOKEN || crypto.randomBytes(16).toString('hex');

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

// The only Host header values accepted — the core DNS-rebinding defense.
const ALLOWED_HOSTS = new Set([`127.0.0.1:${PORT}`, `localhost:${PORT}`]);

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
  PTY,
});
