# Cloud Workspace — Dockerized web-terminal on GCP

> Status: approved plan, implemented on branch `web_app`. Companion how-to: `docs/how-to/deploy-workspace-gcp.md`. Cost background: `docs/explanation/rocket-cost-model.md`. Market model: `docs/explanation/end-goal.md` §Market Research (Rocket.new teardown).

## Context

The vibe-coding workspace (Node PTY bridge `web-terminal/server` on :3000 + Next.js console `web-terminal/console` on :4000) originally ran only on the developer's Mac — the bridge deliberately binds `127.0.0.1`, allows only localhost origins/hosts, and uses the local fvm Flutter toolchain. Goal (the Rocket.new model): package the whole setup into **one Docker image** so any remote user gets **their own isolated cloud workspace** — browser console → web terminal running `claude`/`codex` → agent edits the baked-in FlutterAgentic monorepo → `flutter run -d web-server` → live preview in a device-framed iframe.

**Decisions:**
- **GCP target: one GCE spot VM per user workspace** (single-tenant; the VM boundary is the isolation; spot e2-standard-4 ≈ $0.067/hr, per-session, never always-on).
- **Scope: Dockerfile + docker-compose (local parity) + bridge/console cloud-readiness fixes + Artifact Registry push + scripted `gcloud` create/delete-workspace flow.** Remote user receives URL + token. No orchestrator/idle-reaper in v1.
- **Agent auth: user logs in to `claude` inside the web terminal** (their subscription; OAuth in the PTY). Login state persists via volume. No API keys handled or baked.

## What runs where

Nothing installs on the remote user's system — they need only a browser. The React console is **hosted inside the container** and its JS executes in the browser; the container hosts everything else:

| Piece | Hosted | Executes |
|---|---|---|
| React console (Next.js) | in the image, served at `/` | browser (xterm, Monaco, preview UI) |
| PTY bridge | in the image, behind `/bridge` | container |
| Flutter SDK + monorepo template + claude/codex CLIs | in the image | container |
| `flutter run -d web-server` (:8080+) | container | compiled app runs in the browser iframe |
| Caddy (TLS + auth) | container — the only public listener | container |

The console is bundled (not deployed separately) so everything shares **one origin**: no CORS, and the preview iframe stays same-origin so the visual-edit overlay works remotely. The console's `/preview-proxy` route must also run on the same machine as the Flutter dev server it fetches.

## Target architecture

```
Browser ──https──► Caddy :443 (basic auth dev/<TOKEN>, auto-TLS via <ip>.sslip.io)
                    ├── /             → console (Next standalone, 127.0.0.1:4000)
                    ├── /bridge/*     → bridge (strip prefix → 127.0.0.1:3000; REST + WS)
                    │     /bridge/ws exempt from basic auth — bridge's own token auths the WS
                    └── /preview-proxy* → console route → server-side fetch → flutter :8080+
Container: tini → start.sh → { caddy (root), bridge + console (node user) }
Persistence: /workspace, /home/node/.claude, /home/node/.codex → VM host-path mounts
```

Why this shape: bridge + console **keep binding 127.0.0.1** (the loopback security posture survives; Caddy is the only public listener); single origin ⇒ no CORS in prod and the edit overlay keeps working; the console uses a relative `/bridge` base so the baked `NEXT_PUBLIC_*` value is host-agnostic; Caddy rewrites the upstream `Host` to `127.0.0.1:3000` so the bridge's stock `ALLOWED_HOSTS` passes. TLS is mandatory (the Claude OAuth code travels over the terminal WS) — Caddy auto-HTTPS with an sslip.io hostname, no DNS setup. Supervisor: tini + a small `start.sh` with `wait -n`.

## Implementation summary

1. **Bridge** (`web-terminal/server/src/`): `BIND_HOST` env override for `HOST`; comma-separated `ALLOWED_HOSTS` / `ALLOWED_ORIGINS` env extensions; refuse to start non-loopback without `TERMINAL_TOKEN`; `isAllowedOrigin()` in `security.js`.
2. **Console** (`web-terminal/console/`): path-relative `NEXT_PUBLIC_BRIDGE_ORIGIN` (image bakes `/bridge`); `resolveWsUrl()` derives `wss://<page-host>/bridge/ws` when the base is relative; preview iframe always routed through `/preview-proxy` (`toSameOrigin`); env-gated `output: "standalone"` in `next.config.ts`.
3. **Image** (`Dockerfile`, Debian multi-stage): console built standalone; runtime = node:22-bookworm-slim + Flutter 3.44.0 at `/opt/flutter` (`precache --web`), caddy binary, claude/codex CLIs, bridge with prod deps, repo baked to `/opt/workspace-template` (fresh `git init`, pub cache pre-warmed). `.dockerignore` keeps `.env` (real PAT!), `.git`, build artifacts out.
4. **Container boot** (`infra/workspace/start.sh` + `Caddyfile`): require token, seed `/workspace` from template, chown mounts, hash token for basic auth, run bridge/console as `node`, caddy as root, `wait -n` fate-sharing.
5. **Local parity**: `docker-compose.yml` → `http://localhost:8080`, auth `dev`/`devtoken`, named volumes.
6. **GCP** (`infra/workspace/*.sh`): build via Cloud Build (amd64), create-workspace = reserve static IP → `<ip-dashes>.sslip.io` → `create-with-container` on COS (spot, STOP on preemption, host-path mounts for /workspace + agent config), delete-workspace releases everything.
7. **Docs**: `docs/how-to/deploy-workspace-gcp.md`, README cloud section, end-goal progress update.

## Env vars (container)

| Var | Local default | Cloud value | Consumer |
|---|---|---|---|
| `TERMINAL_TOKEN` | random | generated by script — required by start.sh | bridge WS + Caddy basic-auth password |
| `WORKSPACE_HOST` | unset → HTTP :80 | `<ip-dashes>.sslip.io` | Caddy auto-HTTPS |
| `BIND_HOST` | `127.0.0.1` | unchanged (Caddy fronts) | bridge |
| `FLUTTER_BIN` / `PROJECT_DIR` | `fvm flutter` / repo root | `flutter` / `/workspace` (image ENV) | bridge |
| `ALLOWED_HOSTS` / `ALLOWED_ORIGINS` | empty | empty (escape hatch) | bridge |
| `NEXT_PUBLIC_BRIDGE_ORIGIN` | `http://localhost:3000` | `/bridge` (baked at build) | console |

## Verification

1. **Local regression (no Docker)**: `make terminal-bridge` + `make console` → terminal connects, run `jokes`, preview loads via `/preview-proxy?port=8080` (the one visible local change), edit overlay + hot restart work.
2. **Local compose**: `docker compose up --build` → `http://localhost:8080` → basic auth → terminal (bash, cwd `/workspace`) → `claude --version` → run `jokes` → device-framed preview → edit + hot restart → container restart preserves files + `claude` login → `/bridge/apps` 401s without auth, `/bridge/ws` rejects a bad token.
3. **GCP smoke test**: build-image → create-workspace → open printed https URL from another network → valid cert, full flow over wss → VM stop/start → data + login intact → delete-workspace cleans instance + IP.

## Risks / gotchas

- **Next 16 standalone**: `.next/static` + `public/` must be copied beside the standalone server; `HOSTNAME=127.0.0.1` or it binds 0.0.0.0.
- **Inspector/DWDS remotely**: preview + hot restart work through the GET proxy; the debug back-channel may degrade — edit overlay has a text-search fallback.
- **Spot preemption**: VM STOPs (not deleted); `gcloud compute instances start` resumes with data intact; no auto-restart in v1.
- **Image size** ~5–7 GB — first VM pull takes minutes; Artifact Registry storage is pennies.
- **Follow-ups (out of scope v1)**: idle reaping, MIG auto-restart, orchestrator/control-plane API, non-root Caddy via setcap, multi-session.
