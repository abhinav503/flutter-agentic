// HTTP + WebSocket client for the Node PTY bridge. Port of
// network/bridge_client.dart + the *_remote_data_source_impl.dart files.
//
// Two deployment shapes, selected by NEXT_PUBLIC_BRIDGE_ORIGIN:
// - absolute origin (local dev default http://localhost:3000): the bridge is a
//   separate port and echoes CORS for localhost origins — cross-origin, no proxy.
// - path prefix (cloud image bakes "/bridge"): a reverse proxy in front of the
//   console forwards the prefix to the bridge — same-origin, host-agnostic, so
//   one built image works on any hostname.

import { DEFAULT_BRIDGE_ORIGIN, ENDPOINTS } from "@/lib/config";
import type {
  AppState,
  BridgeConfig,
  DeviceInfo,
  FileNode,
  RunAppInput,
  SearchHit,
  SourceTarget,
  SetupItem,
} from "@/lib/types";

// Absolute origin or a path prefix like "/bridge" (see header note). Fetches
// resolve either form against the page origin, so callers just prepend it.
export function bridgeBase(): string {
  const fromEnv = process.env.NEXT_PUBLIC_BRIDGE_ORIGIN?.trim();
  return fromEnv && fromEnv.length > 0 ? fromEnv : DEFAULT_BRIDGE_ORIGIN;
}

async function getJson<T>(path: string): Promise<T> {
  const res = await fetch(`${bridgeBase()}${path}`, {
    headers: { accept: "application/json" },
    cache: "no-store",
  });
  if (!res.ok) throw new Error(`${path} failed: ${res.status}`);
  return (await res.json()) as T;
}

async function postJson<T>(path: string, body?: unknown): Promise<T> {
  const res = await fetch(`${bridgeBase()}${path}`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: body ? JSON.stringify(body) : undefined,
  });
  if (!res.ok) {
    const detail = await res.text().catch(() => "");
    throw new Error(detail || `${path} failed: ${res.status}`);
  }
  return (await res.json()) as T;
}

// Builds the authenticated WebSocket URL from /config.json (which returns
// { wsPort, token }). With a path-prefix base the proxy owns the public port,
// so the URL derives from the page location (ws/wss follows http/https) and
// wsPort is ignored; with an absolute base the scheme/host/wsPort come from it.
export async function resolveWsUrl(): Promise<string> {
  const config = await getJson<BridgeConfig>(ENDPOINTS.config);
  const base = bridgeBase();
  if (base.startsWith("/")) {
    const { protocol, host } = window.location;
    const scheme = protocol === "https:" ? "wss" : "ws";
    return `${scheme}://${host}${base}${ENDPOINTS.ws}?token=${config.token}`;
  }
  const origin = new URL(base);
  const scheme = origin.protocol === "https:" ? "wss" : "ws";
  return `${scheme}://${origin.hostname}:${config.wsPort}${ENDPOINTS.ws}?token=${config.token}`;
}

export async function getApps(): Promise<AppState[]> {
  const { apps } = await getJson<{ apps: AppState[] }>(ENDPOINTS.apps);
  return apps;
}

export async function runApp(input: RunAppInput): Promise<AppState> {
  const { app } = await postJson<{ app: AppState }>(
    `${ENDPOINTS.apps}/${encodeURIComponent(input.name)}/run`,
    { deviceId: input.deviceId, platform: input.platform, kind: input.kind },
  );
  return app;
}

export async function stopApp(name: string): Promise<AppState> {
  const { app } = await postJson<{ app: AppState }>(
    `${ENDPOINTS.apps}/${encodeURIComponent(name)}/stop`,
  );
  return app;
}

export async function getDevices(): Promise<DeviceInfo[]> {
  const { devices } = await getJson<{ devices: DeviceInfo[] }>(
    ENDPOINTS.devices,
  );
  return devices;
}

export async function getSetup(): Promise<SetupItem[]> {
  const { items } = await getJson<{ items: SetupItem[] }>(ENDPOINTS.setup);
  return items;
}

// --- Source files (code view + visual edit) ---

const appPath = (app: string, kind: string) =>
  `${ENDPOINTS.apps}/${encodeURIComponent(app)}/${kind}`;

export async function getFileTree(app: string): Promise<FileNode[]> {
  const { tree } = await getJson<{ tree: FileNode[] }>(appPath(app, "files"));
  return tree;
}

export async function getFile(
  app: string,
  path: string,
): Promise<{ path: string; content: string }> {
  return getJson(`${appPath(app, "file")}?path=${encodeURIComponent(path)}`);
}

export async function saveFile(
  app: string,
  path: string,
  content: string,
): Promise<void> {
  await postJson<{ ok: boolean }>(appPath(app, "file"), { path, content });
}

// `prefer: "usage"` ranks widget usages above constant definitions — right for
// jump-to-code. Omit it for the text-replace flow, which edits the constant.
export async function searchApp(
  app: string,
  query: string,
  prefer?: "usage",
): Promise<SearchHit[]> {
  const suffix = prefer ? `&prefer=${prefer}` : "";
  const { hits } = await getJson<{ hits: SearchHit[] }>(
    `${appPath(app, "search")}?q=${encodeURIComponent(query)}${suffix}`,
  );
  return hits;
}

// Buffered output of the app's `flutter run` process (capped server-side).
// `seq` bumps on every appended chunk, so equal seqs mean nothing new.
export async function getAppLogs(
  app: string,
): Promise<{ seq: number; text: string }> {
  return getJson(appPath(app, "logs"));
}

// Hot-restarts the running `flutter run` process; resolves when the new build
// is being served (so the caller can reload the iframe).
export async function reloadApp(
  app: string,
): Promise<{ ok: boolean; message?: string }> {
  return postJson(appPath(app, "reload"));
}

export async function setInspectorEnabled(
  app: string,
  enabled: boolean,
): Promise<{ ok: boolean; message?: string }> {
  return postJson(appPath(app, "inspect"), { enabled });
}

export async function getSelectedWidgetSource(
  app: string,
): Promise<SourceTarget | null> {
  const { source } = await getJson<{ source: SourceTarget | null }>(
    appPath(app, "inspect/selected"),
  );
  return source;
}
