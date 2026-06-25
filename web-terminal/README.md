# Web Terminal

A browser-based terminal that runs a **real local shell** with your own
permissions — open `http://localhost:3000` and run `claude` (or anything else)
from the web page.

A top-bar **agent switcher** launches `claude` or `codex` for you, and a
side-by-side **preview pane** runs any Flutter app under `apps/` (Run/Stop its
`flutter run` dev server) and renders it live in an embedded frame.

## Why two pieces

A browser is sandboxed: a web page can never spawn a shell or touch your
filesystem directly. So this is split in two:

```
Browser (localhost:3000)                 Your machine (local process)
┌─────────────────────────┐   WebSocket  ┌──────────────────────────┐
│ apps/web_terminal       │ ───────────► │ web-terminal/server       │
│  Flutter web + xterm    │ ◄─────────── │  Node + node-pty + ws     │
│  (renders, sends keys)  │   output     │  spawns your $SHELL as YOU │
│                         │   HTTP /apps │  runs apps/ via flutter   │
│  preview pane (iframe)  │ ◄──────────► │  run, reports run state   │
└─────────────────────────┘              └──────────────────────────┘
```

Runs on **macOS and Linux** (Ubuntu, etc.). The bridge spawns your login shell
via a PTY: it uses `$SHELL` when set, otherwise defaults to `/bin/zsh` on macOS
and `/bin/bash` on Linux. Windows is not supported.

- **`web-terminal/server`** — the Node PTY bridge. It runs as you, so the shell
  inside it has exactly your local permissions. This is the only part that
  touches the OS. It also lists the apps under `apps/` and runs/stops a managed
  `flutter run` dev server for each (for the preview pane).
- **`apps/web_terminal`** — the Flutter web app (Clean Architecture + BLoC,
  reuses `packages/core`). It streams keystrokes to the bridge and paints the
  output with [`xterm`](https://pub.dev/packages/xterm), plus the agent switcher
  and the preview pane. See its [README](../apps/web_terminal/README.md).

## Run it

From the repo root:

```bash
make web-terminal      # builds the web app, then the bridge serves it on :3000
```

Then open **http://localhost:3000**. The bridge prints a token on startup; the
page fetches it automatically from `/config.json` (same origin).

### Hot-reload dev

```bash
make terminal-bridge       # shell 1 — PTY bridge on :3000
make dev-web-terminal      # shell 2 — Flutter on :4000 with hot reload
```

In dev the Flutter app runs on a different port and reaches the bridge
cross-origin; the bridge echoes CORS **only** for localhost origins.

## Security

This is effectively a remote shell to your machine, so the bridge is
deliberately locked down:

1. **Binds to `127.0.0.1` only** — never reachable from the network.
2. **Host-header allowlist** on every request and WebSocket upgrade — blocks
   DNS-rebinding from a malicious page.
3. **Per-startup token** required on the WebSocket; `/config.json` (which serves
   the token) sends CORS headers to localhost origins only, so a public page
   can't read it.

Override the shell or token with env vars: `SHELL`, `TERMINAL_TOKEN`, `PORT`.

## Scope

MVP is a single session. Multiple tabs and reconnect/persistence (tmux-style)
are natural next steps — the BLoC already cancels and restarts the session
cleanly via a `restartable()` connect event.
