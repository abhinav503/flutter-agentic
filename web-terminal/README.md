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

## Run it in the cloud

The whole stack also ships as **one Docker image** — console + bridge + Flutter
SDK + `claude`/`codex` CLIs behind a Caddy reverse proxy (TLS + basic auth) —
so a remote user gets their own isolated workspace on a per-user GCE spot VM
and needs nothing but a browser.

```bash
make docker-up                    # local parity: http://localhost:8080 (dev/devtoken)
make ws-image                     # build + push to Artifact Registry
make ws-create WS_USER=alice      # boot a workspace VM → prints URL + token
```

Inside the container the bridge and console still bind loopback; Caddy is the
only public listener, routing `/` → console, `/bridge/*` → bridge, and the
preview through the console's same-origin `/preview-proxy`. Full flow:
[`docs/how-to/deploy-workspace-gcp.md`](../docs/how-to/deploy-workspace-gcp.md);
architecture: [`docs/explanation/cloud-workspace-plan.md`](../docs/explanation/cloud-workspace-plan.md).

> **The `workspace` volume only seeds once.** `start.sh` copies the image's
> baked `/opt/workspace-template` into the `workspace` named volume **only
> when that volume is empty** (first boot). After that, `docker compose up
> --build` rebuilds the *image* but an existing volume keeps mounting its old
> contents on top — so new apps, moved folders, or other repo changes won't
> show up in the running container even though the image has them. If the
> app list (or anything else under `/workspace`) looks stale after a rebuild,
> reset the volume so it reseeds from the fresh image:
> ```bash
> docker compose down
> docker volume rm <project>_workspace   # find the exact name: docker volume ls
> make docker-up
> ```
> This only wipes `/workspace`; the `claude-config` / `codex-config` volumes
> (agent CLI logins) are untouched.

## Security

This is effectively a remote shell to your machine, so the bridge is
deliberately locked down:

1. **Binds to `127.0.0.1` only** — never reachable from the network.
2. **Host-header allowlist** on every request and WebSocket upgrade — blocks
   DNS-rebinding from a malicious page.
3. **Per-startup token** required on the WebSocket; `/config.json` (which serves
   the token) sends CORS headers to localhost origins only, so a public page
   can't read it.

In the cloud image these loopback guarantees hold *inside* the container:
Caddy is the only public listener, adding TLS and basic auth in front, and the
bridge refuses a non-loopback `BIND_HOST` without an explicit `TERMINAL_TOKEN`.

Override with env vars: `SHELL`, `TERMINAL_TOKEN`, `PORT`, `BIND_HOST`,
`ALLOWED_HOSTS`, `ALLOWED_ORIGINS` (the last three are cloud/proxy escape
hatches — local dev needs none of them).

## Scope

MVP is a single session. Multiple tabs and reconnect/persistence (tmux-style)
are natural next steps — the console already cancels and restarts the session
cleanly on reconnect.
