# web_terminal

The **Flutter web** half of Web Terminal: a browser UI that renders a real local
shell streamed from the Node PTY bridge over a WebSocket, with a live preview
pane for whatever app you run from that shell.

It's a pure renderer — it streams keystrokes/resize to the bridge and paints the
output with [`xterm`](https://pub.dev/packages/xterm). The shell itself lives in
`web-terminal/server`. For the full system (the bridge, the security model, why
it's split in two), see the [top-level README](../../web-terminal/README.md).

Built on the monorepo template: Clean Architecture + BLoC, reusing
`packages/core`.

## Run it

From the repo root:

```bash
make web-terminal      # builds the web app, then the bridge serves it on :3000
```

Open **http://localhost:3000**. The page fetches the bridge's port + per-startup
token automatically from `/config.json` (same origin), then dials the WebSocket.

Hot-reload dev (two shells — Flutter on :4000 reaches the bridge cross-origin):

```bash
make terminal-bridge       # shell 1 — PTY bridge on :3000
make dev-web-terminal      # shell 2 — Flutter with hot reload
```

## What's on screen

- **Console** (left) — the live shell via `xterm`. Output streams straight into
  the terminal controller; arrow-menu TUIs (claude, codex, vim…) work, including
  mouse-wheel scrolling.
- **Agent switcher** (top bar) — run a plain shell, `claude`, or `codex`;
  selecting one writes its launch command to the PTY. `claude` is the default.
- **Apps bar + Preview** (right, web only) — pick a Flutter app under `apps/`,
  Run/Stop its `flutter run` dev server, and preview it in an embedded `<iframe>`
  that auto-reloads once the app is serving. Below 720px wide the preview is
  dropped and the terminal goes full-width.

## Structure

Two feature slices under `lib/feature/`:

| Feature | Concern | Transport | State |
|---|---|---|---|
| `home` | The terminal session | `/ws` WebSocket (duplex PTY stream) | `TerminalBloc` |
| `apps` | Discover + run/stop previewable apps | `/apps`, `/apps/{name}/run\|stop` (HTTP) | `AppsCubit` |

`apps` is headless (no page of its own) — `home`'s view composes both: the apps
bar and preview read `AppsCubit`, the console and status bar read `TerminalBloc`.

Each slice follows the template's `data / domain / presentation` layering. See
[`docs/reference/architecture.md`](../../docs/reference/architecture.md) for the
conventions.

## Platform support

Ships to **web** only — the preview pane needs an `<iframe>`, reached through a
conditional import (`preview/preview_platform.dart`) so non-web targets compile
against a no-op stub. The bridge runs on macOS and Linux; Windows is not
supported.
