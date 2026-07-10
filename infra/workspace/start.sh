#!/usr/bin/env bash
# Container entrypoint: seed the workspace, then supervise the three processes
# (bridge, console, caddy). Runs as root so it can chown host-path mounts and
# let Caddy bind 80/443; everything user-facing runs as `node`.
set -euo pipefail

: "${TERMINAL_TOKEN:?TERMINAL_TOKEN must be set — it is the workspace password}"

# First boot on an empty volume: copy the baked template in. Subsequent boots
# keep whatever the user built.
if [ -z "$(ls -A /workspace 2>/dev/null)" ]; then
  echo "Seeding /workspace from template…"
  cp -a /opt/workspace-template/. /workspace/
fi

# Host-path mounts (GCE/COS) arrive root-owned; hand them to the workspace user.
mkdir -p /home/node/.claude /home/node/.codex /data
chown -R node:node /workspace /home/node/.claude /home/node/.codex

# Caddy's basic-auth password is the same workspace token as the bridge WS.
BASIC_AUTH_HASH="$(caddy hash-password --plaintext "$TERMINAL_TOKEN")"
export BASIC_AUTH_HASH

run_as_node() {
  runuser -u node -- env HOME=/home/node PATH="$PATH" "$@"
}

run_as_node env \
  PORT=3000 \
  TERMINAL_TOKEN="$TERMINAL_TOKEN" \
  FLUTTER_BIN="${FLUTTER_BIN:-flutter}" \
  PROJECT_DIR="${PROJECT_DIR:-/workspace}" \
  SHELL="${SHELL:-/bin/bash}" \
  CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-/home/node/.claude}" \
  CODEX_HOME="${CODEX_HOME:-/home/node/.codex}" \
  node /opt/app/bridge/server.js &

# HOSTNAME pins the standalone server to loopback (Caddy is the public face).
run_as_node env PORT=4000 HOSTNAME=127.0.0.1 node /opt/app/console/server.js &

caddy run --config /opt/app/Caddyfile --adapter caddyfile &

# Fate-sharing: if any process dies, exit so the restart policy recovers all.
wait -n
exit 1
