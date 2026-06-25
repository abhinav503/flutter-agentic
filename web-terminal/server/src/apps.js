'use strict';

/**
 * Lists the Flutter apps under `apps/` so the web UI can offer them as preview
 * targets. Read-only for now; Phase 2 adds run/stop, Phase 3 adds create.
 *
 * Each app gets a deterministic `previewPort` (sorted by name, from a fixed
 * base) so the same app always previews on the same port — the address the
 * caller runs `flutter run -d web-server --web-port=<previewPort>` on, and the
 * port the Phase 2 runner will spawn it on.
 */

const fs = require('fs');
const path = require('path');
const { PROJECT_DIR } = require('./config');

const APPS_DIR = path.join(PROJECT_DIR, 'apps');

// First preview port; subsequent apps get base + index (sorted by name).
const PREVIEW_PORT_BASE = 8080;

// The terminal host itself is not a preview target.
const EXCLUDED = new Set(['web_terminal']);

/** A directory is an app when it holds a pubspec.yaml. */
function isApp(name) {
  return (
    !EXCLUDED.has(name) &&
    fs.existsSync(path.join(APPS_DIR, name, 'pubspec.yaml'))
  );
}

/**
 * `[{ name, path, previewPort }]`, sorted by name. Returns `[]` when `apps/`
 * is absent rather than throwing, so the endpoint degrades gracefully.
 */
function listApps() {
  if (!fs.existsSync(APPS_DIR)) return [];
  const names = fs
    .readdirSync(APPS_DIR, { withFileTypes: true })
    .filter((d) => d.isDirectory() && isApp(d.name))
    .map((d) => d.name)
    .sort();

  return names.map((name, index) => ({
    name,
    path: path.join(APPS_DIR, name),
    previewPort: PREVIEW_PORT_BASE + index,
  }));
}

module.exports = { listApps, APPS_DIR, PREVIEW_PORT_BASE };
