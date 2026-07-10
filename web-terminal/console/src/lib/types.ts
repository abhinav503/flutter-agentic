// Domain types shared across the console. Mirrors the enums/entities of the
// Flutter web_terminal app and the JSON shapes served by the Node PTY bridge.

export type TerminalStatus = "connecting" | "connected" | "exited" | "error";

export type TerminalAgent = "terminal" | "claude" | "codex";

export type DevicePlatform = "web" | "android" | "ios" | "other";

export type DeviceKind = "web" | "device" | "emulator";

export type AppRunStatus = "stopped" | "starting" | "running" | "failed";

// --- WebSocket frames (see web-terminal/server/src/terminal-session.js) ---

export type TerminalClientMessage =
  | { type: "input"; data: string }
  | { type: "resize"; cols: number; rows: number };

export type TerminalServerMessage =
  | { type: "output"; data: string }
  | { type: "exit"; code: number };

// --- HTTP payloads ---

export interface BridgeConfig {
  wsPort: number;
  token: string;
}

export interface AppState {
  name: string;
  path: string;
  previewPort: number | null;
  running: boolean;
  status: AppRunStatus;
  message: string | null;
  deviceId: string | null;
  platform: DevicePlatform | null;
  target: "web" | "native" | null;
}

export interface DeviceInfo {
  id: string;
  name: string;
  platform: DevicePlatform;
  kind: DeviceKind;
  isEmulator: boolean;
}

export interface SetupStep {
  label: string;
  command?: string;
  note?: string;
  manual?: boolean;
}

export interface SetupItem {
  id: string;
  name: string;
  description: string;
  installed: boolean;
  detail: string;
  steps: SetupStep[];
}

export interface RunAppInput {
  name: string;
  deviceId: string;
  platform: string;
  kind: string;
}

// --- Code view + visual edit (see web-terminal/server/src/files.js) ---

export interface FileNode {
  name: string;
  path: string;
  type: "file" | "dir";
  children?: FileNode[];
}

export interface SearchHit {
  path: string;
  line: number;
  preview: string;
}

export interface SourceTarget {
  path: string;
  line: number;
  column?: number;
  name?: string | null;
}

export const isWebDevice = (device: DeviceInfo): boolean =>
  device.kind === "web";
