'use strict';

/**
 * Read/search/write access to an app's source files for the console's code
 * view and visual-edit mode.
 *
 * The code view shows the same bundle as `scripts/export-app-code.sh` — "all
 * the code for an app" is the app itself PLUS the shared `packages/core` it
 * imports and the monorepo configs — not just `apps/<name>/`. So everything is
 * rooted at the repo (`PROJECT_DIR`) but scoped to that bundle: every path is
 * validated to fall inside the selected app, inside `packages/core`, or to be
 * one of the whitelisted config files. The console can reach core and the
 * configs, but never another app or arbitrary repo files.
 *
 * Paths handed to/from the client are repo-relative (e.g. `apps/jokes/lib/…`,
 * `packages/core/lib/…`, `pubspec.yaml`).
 */

const fs = require('fs');
const path = require('path');
const { listApps } = require('./apps');
const { PROJECT_DIR } = require('./config');

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

// Shared code + monorepo configs every app's export carries alongside it —
// mirrors scripts/export-app-code.sh so the code view and the export agree.
const SHARED_DIRS = ['packages/core'];
const CONFIG_FILES = [
  'pubspec.yaml',
  'melos.yaml',
  'Makefile',
  'analysis_options.yaml',
];

const MAX_FILE_BYTES = 1024 * 1024; // 1 MB — plenty for source files
const MAX_SEARCH_HITS = 50;

// Repo-relative POSIX path of the app folder (e.g. `apps/jokes`), or null.
function appRel(name) {
  const app = listApps().find((a) => a.name === name);
  return app
    ? path.relative(PROJECT_DIR, app.path).split(path.sep).join('/')
    : null;
}

/**
 * The export bundle for one app: the dirs and files the code view may reach.
 * `dirs` is ordered app-first (then core) so the tree opens on the app.
 */
function appScope(name) {
  const rel = appRel(name);
  if (!rel) return null;
  return { appRel: rel, dirs: [rel, ...SHARED_DIRS], files: CONFIG_FILES };
}

// Resolve a client-supplied repo-relative path, but only inside the app's
// export scope (its folder, packages/core, or a config file). null if it
// escapes the repo or falls outside the scope.
function safeResolve(scope, relPath) {
  if (!scope || !relPath) return null;
  const abs = path.resolve(PROJECT_DIR, relPath);
  if (abs !== PROJECT_DIR && !abs.startsWith(PROJECT_DIR + path.sep)) return null;
  const rel = path.relative(PROJECT_DIR, abs).split(path.sep).join('/');
  const inDir = scope.dirs.some((d) => rel === d || rel.startsWith(`${d}/`));
  const isConfig = scope.files.includes(rel);
  return inDir || isConfig ? abs : null;
}

/** Recursive file tree: [{ name, path, type: 'file'|'dir', children? }]. */
function fileTree(appName) {
  const scope = appScope(appName);
  if (!scope) return null;

  // `rel` is the repo-relative path of `dir`, so every node path the client
  // receives is repo-rooted and round-trips through readFile/writeFile.
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
      const childRel = `${rel}/${d.name}`;
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

  const tree = [];
  // App folder + packages/core as top-level branches (labelled by their
  // repo-relative path so `apps/jokes` and `packages/core` read unambiguously).
  for (const rel of scope.dirs) {
    const abs = path.join(PROJECT_DIR, rel);
    if (fs.existsSync(abs) && fs.statSync(abs).isDirectory()) {
      tree.push({ name: rel, path: rel, type: 'dir', children: walk(abs, rel) });
    }
  }
  // Monorepo config files at the repo root.
  for (const rel of scope.files) {
    const abs = path.join(PROJECT_DIR, rel);
    if (fs.existsSync(abs) && fs.statSync(abs).isFile()) {
      tree.push({ name: rel, path: rel, type: 'file' });
    }
  }
  return tree;
}

/** { path, content } or null (missing/too big/outside the scope). */
function readFile(appName, relPath) {
  const abs = safeResolve(appScope(appName), relPath);
  if (!abs || !fs.existsSync(abs) || !fs.statSync(abs).isFile()) return null;
  if (fs.statSync(abs).size > MAX_FILE_BYTES) return null;
  return { path: relPath, content: fs.readFileSync(abs, 'utf8') };
}

/** Overwrite one file inside the scope. Only existing files — no creation. */
function writeFile(appName, relPath, content) {
  const abs = safeResolve(appScope(appName), relPath);
  if (!abs || !fs.existsSync(abs) || !fs.statSync(abs).isFile()) return false;
  fs.writeFileSync(abs, content, 'utf8');
  return true;
}

// A line that declares/assigns a value (e.g. `static const foo = '...'`) — a
// constant *definition* rather than a widget *usage*.
const DECL_RE = /\b(static\s+)?(const|final|var)\b[^=]*=/;

/**
 * Literal substring search over the app's own text files: [{ path, line,
 * preview }]. Scoped to the app folder (where editable copy lives) — the
 * visual-edit flow targets app constants, not core.
 *
 * `prefer` picks the ranking:
 *   - default: constants first (where app copy is defined) — right for the
 *     text-*replace* flow, which should edit the constant at its source.
 *   - `'usage'`: widget usages in app code first, constant *definitions* last —
 *     right for jump-to-*code*, which wants the widget, not the string literal.
 */
function searchFiles(appName, query, prefer) {
  const scope = appScope(appName);
  if (!scope || !query) return null;

  const libDir = `${scope.appRel}/lib/`;
  const constDir = `${scope.appRel}/lib/constants/`;

  const hits = [];
  function walk(dir, rel) {
    if (hits.length >= MAX_SEARCH_HITS) return;
    for (const d of fs.readdirSync(dir, { withFileTypes: true })) {
      if (hits.length >= MAX_SEARCH_HITS) return;
      if (d.name.startsWith('.') || SKIP_DIRS.has(d.name)) continue;
      const childRel = `${rel}/${d.name}`;
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
  walk(path.join(PROJECT_DIR, scope.appRel), scope.appRel);

  const rank =
    prefer === 'usage'
      ? (h) => {
          const inAppCode =
            h.path.startsWith(libDir) && !h.path.startsWith(constDir);
          const isDecl =
            h.path.startsWith(constDir) || DECL_RE.test(h.preview);
          if (inAppCode && !isDecl) return 0; // widget usage — best
          if (inAppCode) return 1;
          if (h.path.startsWith(libDir)) return 2; // constant definitions, etc.
          return 3;
        }
      : (h) =>
          h.path.startsWith(constDir)
            ? 0
            : h.path.startsWith(libDir)
              ? 1
              : 2;
  hits.sort((a, b) => rank(a) - rank(b));
  return hits;
}

module.exports = { fileTree, readFile, writeFile, searchFiles };
