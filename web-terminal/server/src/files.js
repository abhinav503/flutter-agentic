'use strict';

/**
 * Read/search/write access to an app's source files for the console's code
 * view and visual-edit mode. Everything is rooted at the app folder and every
 * path is validated against it, so the console can never reach outside
 * `apps/<name>/`.
 */

const fs = require('fs');
const path = require('path');
const { listApps } = require('./apps');

// Junk and generated folders the tree/search never enters.
const SKIP_DIRS = new Set([
  '.git',
  '.dart_tool',
  '.idea',
  'build',
  'node_modules',
  '.gradle',
  'Pods',
]);

// Search stays inside these text extensions (the edit flow targets Dart
// sources and config).
const TEXT_EXTS = new Set([
  '.dart', '.yaml', '.yml', '.json', '.md', '.txt', '.html', '.css',
  '.js', '.ts', '.xml', '.gradle', '.kts', '.plist', '.arb',
]);

const MAX_FILE_BYTES = 1024 * 1024; // 1 MB — plenty for source files
const MAX_SEARCH_HITS = 50;

function appRoot(name) {
  const app = listApps().find((a) => a.name === name);
  return app ? app.path : null;
}

// Resolve a client-supplied relative path inside the app; null if it escapes.
function safeResolve(root, relPath) {
  const abs = path.resolve(root, relPath || '.');
  if (abs !== root && !abs.startsWith(root + path.sep)) return null;
  return abs;
}

/** Recursive file tree: [{ name, path, type: 'file'|'dir', children? }]. */
function fileTree(appName) {
  const root = appRoot(appName);
  if (!root) return null;

  function walk(dir, rel) {
    const entries = fs
      .readdirSync(dir, { withFileTypes: true })
      .filter((d) => !d.name.startsWith('.') && !SKIP_DIRS.has(d.name))
      .sort((a, b) =>
        // directories first, then case-insensitive by name
        a.isDirectory() === b.isDirectory()
          ? a.name.localeCompare(b.name)
          : a.isDirectory() ? -1 : 1,
      );
    return entries.map((d) => {
      const childRel = rel ? `${rel}/${d.name}` : d.name;
      return d.isDirectory()
        ? {
            name: d.name,
            path: childRel,
            type: 'dir',
            children: walk(path.join(dir, d.name), childRel),
          }
        : { name: d.name, path: childRel, type: 'file' };
    });
  }
  return walk(root, '');
}

/** { path, content } or null (missing/too big/outside the app). */
function readFile(appName, relPath) {
  const root = appRoot(appName);
  if (!root) return null;
  const abs = safeResolve(root, relPath);
  if (!abs || !fs.existsSync(abs) || !fs.statSync(abs).isFile()) return null;
  if (fs.statSync(abs).size > MAX_FILE_BYTES) return null;
  return { path: relPath, content: fs.readFileSync(abs, 'utf8') };
}

/** Overwrite one file inside the app. Only existing files — no creation. */
function writeFile(appName, relPath, content) {
  const root = appRoot(appName);
  if (!root) return false;
  const abs = safeResolve(root, relPath);
  if (!abs || !fs.existsSync(abs) || !fs.statSync(abs).isFile()) return false;
  fs.writeFileSync(abs, content, 'utf8');
  return true;
}

// A line that declares/assigns a value (e.g. `static const foo = '...'`) — a
// constant *definition* rather than a widget *usage*.
const DECL_RE = /\b(static\s+)?(const|final|var)\b[^=]*=/;

/**
 * Literal substring search over the app's text files: [{ path, line, preview }].
 *
 * `prefer` picks the ranking:
 *   - default: constants first (where app copy is defined) — right for the
 *     text-*replace* flow, which should edit the constant at its source.
 *   - `'usage'`: widget usages in app code first, constant *definitions* last —
 *     right for jump-to-*code*, which wants the widget, not the string literal.
 */
function searchFiles(appName, query, prefer) {
  const root = appRoot(appName);
  if (!root || !query) return null;

  const hits = [];
  function walk(dir, rel) {
    if (hits.length >= MAX_SEARCH_HITS) return;
    for (const d of fs.readdirSync(dir, { withFileTypes: true })) {
      if (hits.length >= MAX_SEARCH_HITS) return;
      if (d.name.startsWith('.') || SKIP_DIRS.has(d.name)) continue;
      const childRel = rel ? `${rel}/${d.name}` : d.name;
      const abs = path.join(dir, d.name);
      if (d.isDirectory()) {
        walk(abs, childRel);
      } else if (TEXT_EXTS.has(path.extname(d.name))) {
        if (fs.statSync(abs).size > MAX_FILE_BYTES) continue;
        const lines = fs.readFileSync(abs, 'utf8').split('\n');
        lines.forEach((text, i) => {
          if (hits.length < MAX_SEARCH_HITS && text.includes(query)) {
            hits.push({ path: childRel, line: i + 1, preview: text.trim() });
          }
        });
      }
    }
  }
  walk(root, '');

  const rank =
    prefer === 'usage'
      ? (h) => {
          const inAppCode =
            h.path.startsWith('lib/') && !h.path.startsWith('lib/constants/');
          const isDecl =
            h.path.startsWith('lib/constants/') || DECL_RE.test(h.preview);
          if (inAppCode && !isDecl) return 0; // widget usage — best
          if (inAppCode) return 1;
          if (h.path.startsWith('lib/')) return 2; // constant definitions, etc.
          return 3;
        }
      : (h) =>
          h.path.startsWith('lib/constants/')
            ? 0
            : h.path.startsWith('lib/')
              ? 1
              : 2;
  hits.sort((a, b) => rank(a) - rank(b));
  return hits;
}

module.exports = { fileTree, readFile, writeFile, searchFiles };
