// Static configuration for the console. Endpoint paths mirror
// apps/web_terminal/lib/constants/api_constants.dart.

export const ENDPOINTS = {
  config: "/config.json",
  ws: "/ws",
  apps: "/apps",
  devices: "/devices",
  setup: "/setup",
} as const;

export const DEFAULT_BRIDGE_ORIGIN = "http://localhost:3000";

export const DEFAULT_PREVIEW_URL = "http://localhost:8080";

// Below this width the right pane (preview / setup) collapses and only the
// terminal is shown — matches the Flutter _splitBreakpoint.
export const SPLIT_BREAKPOINT = 720;

// xterm scrollback, matching the Flutter Terminal(maxLines: 10000).
export const TERMINAL_SCROLLBACK = 10000;

export const WEB_DEVICE_ID = "web-server";
