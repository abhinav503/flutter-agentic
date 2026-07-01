// HTTP + WebSocket client for the Node PTY bridge. Port of
// network/bridge_client.dart + the *_remote_data_source_impl.dart files.
//
// The bridge listens on 127.0.0.1:3000 and echoes CORS for localhost origins,
// so the console (served on :4000) talks to it cross-origin without a proxy.

import { DEFAULT_BRIDGE_ORIGIN, ENDPOINTS } from "@/lib/config";
import type {
  AppState,
  BridgeConfig,
  DeviceInfo,
  RunAppInput,
  SetupItem,
} from "@/lib/types";

export function bridgeOrigin(): string {
  const fromEnv = process.env.NEXT_PUBLIC_BRIDGE_ORIGIN?.trim();
  return fromEnv && fromEnv.length > 0 ? fromEnv : DEFAULT_BRIDGE_ORIGIN;
}

async function getJson<T>(path: string): Promise<T> {
  const res = await fetch(`${bridgeOrigin()}${path}`, {
    headers: { accept: "application/json" },
    cache: "no-store",
  });
  if (!res.ok) throw new Error(`${path} failed: ${res.status}`);
  return (await res.json()) as T;
}

async function postJson<T>(path: string, body?: unknown): Promise<T> {
  const res = await fetch(`${bridgeOrigin()}${path}`, {
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

// Builds the authenticated WebSocket URL from /config.json. The bridge returns
// { wsPort, token }; the scheme follows the origin (ws/wss).
export async function resolveWsUrl(): Promise<string> {
  const config = await getJson<BridgeConfig>(ENDPOINTS.config);
  const base = new URL(bridgeOrigin());
  const scheme = base.protocol === "https:" ? "wss" : "ws";
  return `${scheme}://${base.hostname}:${config.wsPort}${ENDPOINTS.ws}?token=${config.token}`;
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
