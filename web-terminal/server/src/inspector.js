'use strict';

/**
 * Minimal Flutter VM-service bridge for visual edit mode.
 *
 * Text edits can be located by searching source literals, but non-text widgets
 * such as Container, Icon, and custom widgets need Flutter's own inspector
 * hit-test/selection pipeline. This module toggles the inspector overlay and
 * reads the selected widget's creation location.
 */

const path = require('path');
const WebSocket = require('ws');
const { listApps } = require('./apps');
const { vmServiceUrlFor } = require('./app-runner');

const GROUP = 'console-edit';
const CLIENTS = new Map();

function appRoot(name) {
  const app = listApps().find((a) => a.name === name);
  return app ? app.path : null;
}

function sourcePathToRel(appName, file) {
  const root = appRoot(appName);
  if (!root || !file) return null;

  let abs = file;
  if (file.startsWith('file://')) {
    abs = new URL(file).pathname;
  }
  abs = path.resolve(abs);
  return abs === root || abs.startsWith(root + path.sep)
    ? path.relative(root, abs).split(path.sep).join('/')
    : null;
}

function decodeInspectorResult(value) {
  const result = value?.result ?? value;
  if (typeof result === 'string') {
    try {
      return JSON.parse(result);
    } catch {
      return null;
    }
  }
  return result ?? null;
}

class VmClient {
  constructor(url) {
    this.url = url;
    this.nextId = 1;
    this.pending = new Map();
    this.isolateId = null;
    this.ready = new Promise((resolve, reject) => {
      this.ws = new WebSocket(url);
      this.ws.once('open', resolve);
      this.ws.once('error', reject);
      this.ws.on('message', (raw) => this.onMessage(raw));
      this.ws.on('close', () => {
        for (const { reject: fail } of this.pending.values()) {
          fail(new Error('VM service disconnected'));
        }
        this.pending.clear();
      });
    });
  }

  onMessage(raw) {
    let msg;
    try {
      msg = JSON.parse(raw.toString());
    } catch {
      return;
    }
    if (!msg.id || !this.pending.has(msg.id)) return;
    const { resolve, reject } = this.pending.get(msg.id);
    this.pending.delete(msg.id);
    if (msg.error) {
      reject(new Error(msg.error.message || 'VM service error'));
    } else {
      resolve(msg.result);
    }
  }

  async call(method, params = {}) {
    await this.ready;
    const id = this.nextId++;
    this.ws.send(JSON.stringify({ jsonrpc: '2.0', id, method, params }));
    return new Promise((resolve, reject) => {
      this.pending.set(id, { resolve, reject });
      setTimeout(() => {
        if (!this.pending.has(id)) return;
        this.pending.delete(id);
        reject(new Error(`${method} timed out`));
      }, 5000);
    });
  }

  async isolate() {
    if (this.isolateId) return this.isolateId;
    const vm = await this.call('getVM');
    this.isolateId = vm?.isolates?.[0]?.id ?? null;
    if (!this.isolateId) throw new Error('No running Dart isolate found');
    return this.isolateId;
  }

  async extension(method, params = {}) {
    return this.call(method, {
      isolateId: await this.isolate(),
      ...params,
    });
  }
}

function clientFor(appName) {
  const url = vmServiceUrlFor(appName);
  if (!url) return null;
  const existing = CLIENTS.get(appName);
  // Reuse only a live client for the same URL; a closed/closing socket (app
  // restarted, new auth token) is dropped and rebuilt.
  if (existing && existing.url === url && existing.ws.readyState <= 1) {
    return existing;
  }
  if (existing) {
    try {
      existing.ws.close();
    } catch {
      /* already gone */
    }
  }
  const next = new VmClient(url);
  CLIENTS.set(appName, next);
  return next;
}

// Point the inspector at the app's source root so getSelectedSummaryWidget
// returns the user's widgets with resolvable creation locations (DevTools does
// the same). Once per client; tolerated if the extension is absent.
async function ensurePubRoots(client, appName) {
  if (client.pubRootsSet) return;
  const root = appRoot(appName);
  if (!root) return;
  try {
    await client.extension('ext.flutter.inspector.addPubRootDirectories', {
      arg0: root,
    });
    client.pubRootsSet = true;
  } catch {
    /* older Flutter without this extension — selection still works */
  }
}

async function setInspectorEnabled(appName, enabled) {
  const client = clientFor(appName);
  if (!client) return { ok: false, message: 'VM service is not available yet' };
  await client.extension('ext.flutter.inspector.show', {
    enabled: enabled ? 'true' : 'false',
  });
  return { ok: true };
}

async function selectedWidgetSource(appName) {
  const client = clientFor(appName);
  if (!client) return null;

  await ensurePubRoots(client, appName);
  const selected = decodeInspectorResult(
    await client.extension('ext.flutter.inspector.getSelectedSummaryWidget', {
      objectGroup: GROUP,
    }),
  );
  const location = selected?.creationLocation;
  const relPath = sourcePathToRel(appName, location?.file);
  if (!relPath) return null;
  return {
    path: relPath,
    line: location.line,
    column: location.column,
    // creationLocation carries no name; the widget type is on the node itself.
    name: selected?.description ?? selected?.widgetRuntimeType ?? null,
  };
}

module.exports = { setInspectorEnabled, selectedWidgetSource };
