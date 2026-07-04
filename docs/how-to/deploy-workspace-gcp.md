# Deploy a cloud workspace on GCP

Give a remote user their own isolated vibe-coding workspace: one Docker image
(console + PTY bridge + Flutter SDK + `claude`/`codex` CLIs + Caddy) running on
one spot GCE VM per user. The user needs only a browser — they get a URL and a
token.

> Architecture and rationale: `docs/explanation/cloud-workspace-plan.md`.
> Cost model (why per-session spot VMs, never always-on): `docs/explanation/rocket-cost-model.md`.

## What a workspace is

```
Browser ──https──► Caddy :443 (basic auth dev/<token>, auto-TLS via <ip>.sslip.io)
                    ├── /             → Next.js console (loopback :4000)
                    ├── /bridge/*     → PTY bridge (loopback :3000; REST + WS)
                    └── /preview-proxy* → console → flutter run -d web-server (:8080+)
```

Everything runs inside the container; Caddy is the only public listener. The
bridge and console still bind loopback — the same security posture as local
dev, with the VM boundary as user isolation.

## Prerequisites (one-time per GCP project)

```bash
gcloud auth login
gcloud config set project <project-id>
gcloud services enable compute.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com

# Image repository
gcloud artifacts repositories create workspaces \
  --repository-format=docker --location=us-central1

# Let the internet reach workspace VMs (only tagged VMs, only 80/443)
gcloud compute firewall-rules create allow-flutteragentic-workspace \
  --allow=tcp:80,tcp:443 --target-tags=flutteragentic-workspace
```

## 1. Smoke-test locally

```bash
make docker-up          # or: docker compose up --build
```

Open `http://localhost:8080` (basic auth `dev` / `devtoken`). Check: terminal
attaches (bash, cwd `/workspace`), `claude --version` works, Run an app → the
preview renders in the device frame, edit overlay + hot restart work, and a
`docker compose restart` keeps your files and `claude` login.

## 2. Build and push the image

```bash
make ws-image           # gcloud builds submit → Artifact Registry (amd64)
```

Building locally on an Apple-silicon Mac instead? You **must** cross-compile —
an arm64 image will not start on e2 VMs:

```bash
docker buildx build --platform linux/amd64 \
  -t us-central1-docker.pkg.dev/<project>/workspaces/flutteragentic-workspace:latest --push .
```

## 3. Create a workspace for a user

```bash
make ws-create WS_USER=alice
```

The script reserves a static IP, derives the TLS hostname
(`<ip-dashes>.sslip.io` — resolves to the VM without any DNS setup), boots a
spot `e2-standard-4` COS VM running the container, and prints:

```
URL:      https://34-10-2-3.sslip.io
Login:    dev
Password: <generated token>
```

Hand that to the user. Their first step in the web terminal: run `claude` and
complete the sign-in once (their own subscription — no API keys on our side);
the login persists across restarts.

## 4. Tear down

```bash
make ws-delete WS_USER=alice    # deletes the VM AND the user's code on it
```

The user should `git push` anything they want to keep first — the terminal has
`git` and `ssh` available.

## Persistence model

| Event | User code (`/workspace`) | `claude` login | TLS cert |
|---|---|---|---|
| Container restart | ✅ kept | ✅ kept | ✅ kept |
| VM stop → start | ✅ kept | ✅ kept | ✅ kept |
| Spot preemption | ✅ kept (VM STOPs, not deleted) | ✅ kept | ✅ kept |
| `ws-delete` | ❌ gone | ❌ gone | ❌ gone |

State lives in host paths on the VM's boot disk (`/var/workspace`,
`/var/claude-config`, `/var/codex-config`, `/var/caddy-data`). After a spot
preemption, resume with:

```bash
gcloud compute instances start ws-alice --zone us-central1-a
```

## Environment variables (container)

| Var | Local default | Cloud value | Consumer |
|---|---|---|---|
| `TERMINAL_TOKEN` | — (compose sets `devtoken`) | generated per workspace — **required** | bridge WS auth + Caddy basic-auth password |
| `WORKSPACE_HOST` | unset → plain HTTP :80 | `<ip-dashes>.sslip.io` | Caddy (auto-HTTPS) |
| `BIND_HOST` | `127.0.0.1` | unchanged — Caddy fronts it | bridge |
| `FLUTTER_BIN` | `fvm flutter` | `flutter` (image ENV) | bridge |
| `PROJECT_DIR` | repo root | `/workspace` (image ENV) | bridge |
| `ALLOWED_HOSTS` / `ALLOWED_ORIGINS` | empty | empty (escape hatch for split-origin setups) | bridge |
| `NEXT_PUBLIC_BRIDGE_ORIGIN` | `http://localhost:3000` | `/bridge` (baked at image build) | console |

## Security model

- **Caddy is the only public listener** — bridge, console, and Flutter dev
  servers all stay on loopback inside the container.
- **TLS everywhere remotely** (the Claude OAuth flow travels over the terminal
  WebSocket): Caddy auto-provisions Let's Encrypt certs for the sslip.io name.
- **Two locks, one key**: HTTP basic auth (`dev` / token) on the whole origin,
  and the bridge's own token check on the WebSocket (`/bridge/ws` skips basic
  auth because browsers can't attach credentials to a WS upgrade).
- The bridge refuses to start on a non-loopback `BIND_HOST` without an explicit
  `TERMINAL_TOKEN`.
- The image contains no secrets: `.dockerignore` excludes `.env`, and the
  workspace template gets a fresh `git init` (no history, no remotes).

## Known limitations (v1)

- **Single session per workspace** — one terminal at a time (matches the local
  MVP).
- **Web preview only** — no Android emulator / iOS simulator in the container;
  native runs remain a local-macOS feature.
- **No idle reaping yet** — a running VM bills until stopped (spot
  ≈ $0.067/hr). Stop idle workspaces: `gcloud compute instances stop ws-<user>`.
- **No auto-restart after preemption** — needs a MIG or a tiny watcher
  (follow-up).
- Cloud cost per active workspace-hour is small; the real per-user cost is LLM
  tokens — see `docs/explanation/rocket-cost-model.md`.
