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

/** A directory (relative to APPS_DIR) is an app when it holds a pubspec.yaml. */
function isApp(relName) {
  return fs.existsSync(path.join(APPS_DIR, relName, 'pubspec.yaml'));
}

/**
 * App names one level under `apps/`, e.g. `jokes`. A directory that is
 * itself not an app (e.g. `ecommerce`, a category grouping several style
 * packs) is expanded one level deeper into `category/app` names — this is
 * how `apps/ecommerce/gravia` is discovered.
 */
function collectNames() {
  const names = [];
  for (const d of fs.readdirSync(APPS_DIR, { withFileTypes: true })) {
    if (!d.isDirectory() || EXCLUDED.has(d.name)) continue;
    if (isApp(d.name)) {
      names.push(d.name);
      continue;
    }
    const subDir = path.join(APPS_DIR, d.name);
    for (const sub of fs.readdirSync(subDir, { withFileTypes: true })) {
      const relName = `${d.name}/${sub.name}`;
      if (sub.isDirectory() && isApp(relName)) names.push(relName);
    }
  }
  return names.sort();
}

/**
 * `[{ name, path, previewPort }]`, sorted by name. Returns `[]` when `apps/`
 * is absent rather than throwing, so the endpoint degrades gracefully.
 */
function listApps() {
  if (!fs.existsSync(APPS_DIR)) return [];
  const names = collectNames();

  return names.map((name, index) => ({
    name,
    path: path.join(APPS_DIR, name),
    previewPort: PREVIEW_PORT_BASE + index,
  }));
}

module.exports = { listApps, APPS_DIR, PREVIEW_PORT_BASE };
