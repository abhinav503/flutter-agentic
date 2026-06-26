/// Endpoints for the local PTY bridge (web-terminal/server). In production the
/// bridge serves this build, so `/config.json` and the WebSocket are
/// same-origin; in dev we fall back to its default address. The bridge echoes
/// CORS for localhost only, so the token stays unreadable to public pages.
class ApiConstants {
  const ApiConstants._();

  /// `{ "wsPort": int, "token": string }`.
  static const configPath = '/config.json';

  /// Dev fallback when the page isn't served by the bridge itself.
  static const defaultBridgeOrigin = 'http://localhost:3000';

  static const wsPath = '/ws';
  static const appsPath = '/apps';

  /// `{ platform, items: [...] }` — detected local dev prerequisites.
  static const setupPath = '/setup';

  /// A local dev server the user runs from the terminal — never the bridge's
  /// own origin (that would re-load the terminal itself). Address bar stays
  /// editable, so any port works.
  static const defaultPreviewUrl = 'http://localhost:8080';
}
