# Web Terminal

A browser-based terminal that runs a **real local shell** with your own
permissions — open `http://localhost:4000` and run `claude` (or anything else)
from the web page.

A top-bar **agent switcher** launches `claude` or `codex` for you, and a
side-by-side **preview pane** runs any Flutter app under `apps/` (Run/Stop its
`flutter run` dev server) and renders it live in an embedded frame.

> This folder is the **Node PTY bridge (`server/`)**. The browser UI is the
> React/Next.js console in [`console/`](./console/README.md), which supersedes
> the earlier Flutter `apps/web_terminal` prototype.

## Why two pieces

A browser is sandboxed: a web page can never spawn a shell or touch your
filesystem directly. So this is split in two:

```
Browser (localhost:4000)                 Your machine (local process)
┌─────────────────────────┐   WebSocket  ┌──────────────────────────┐
│ web-terminal/console    │ ───────────► │ web-terminal/server       │
│  Next.js + xterm.js     │ ◄─────────── │  Node + node-pty + ws     │
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
- **`web-terminal/console`** — the React/Next.js console. It streams keystrokes
  to the bridge and paints the output with
  [`@xterm/xterm`](https://www.npmjs.com/package/@xterm/xterm), plus the agent
  switcher and the preview pane. See its [README](./console/README.md).

## Run it

Two servers, two shells, from the repo root:

```bash
make terminal-bridge   # shell 1 — PTY bridge on :3000
make console           # shell 2 — React console on :4000 with hot reload
```

Then open **http://localhost:4000**. The bridge prints a token on startup; the
console fetches it automatically from `/config.json`. In dev the console runs
cross-origin (`:4000` → `:3000`); the bridge echoes CORS **only** for localhost
origins.

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
are natural next steps — the console already cancels and restarts the session
cleanly on reconnect.
