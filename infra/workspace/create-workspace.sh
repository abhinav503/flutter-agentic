#!/usr/bin/env bash
# Spin up one isolated cloud workspace: a spot GCE VM running the workspace
# container, reachable at https://<ip-dashes>.sslip.io with basic auth
# dev/<token>. Prints the URL + token at the end — hand those to the user.
#
#   ./create-workspace.sh <user>
#
# Persistence: /var/{workspace,claude-config,codex-config,caddy-data} on the
# VM's boot disk. Container restarts and VM stop/start keep everything;
# deleting the VM deletes the workspace (git push is the escape hatch).
# Spot preemption STOPs the VM (data intact) — restart with:
#   gcloud compute instances start ws-<user> --zone <zone>
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"

USER_NAME="${1:?usage: create-workspace.sh <user>}"
NAME="ws-${USER_NAME}"
TOKEN="$(openssl rand -hex 16)"

# Reserve the IP first: the container needs its sslip.io hostname at boot so
# Caddy can request the right TLS certificate.
echo "Reserving static IP ${NAME}-ip…"
gcloud compute addresses create "${NAME}-ip" \
  --project "$PROJECT" --region "$REGION" --quiet
IP="$(gcloud compute addresses describe "${NAME}-ip" \
  --project "$PROJECT" --region "$REGION" --format='value(address)')"
HOST="${IP//./-}.sslip.io"

echo "Creating $NAME ($MACHINE_TYPE spot) at $IP…"
gcloud compute instances create-with-container "$NAME" \
  --project "$PROJECT" \
  --zone "$ZONE" \
  --machine-type "$MACHINE_TYPE" \
  --provisioning-model SPOT \
  --instance-termination-action STOP \
  --address "$IP" \
  --tags "$NETWORK_TAG" \
  --boot-disk-size 60GB \
  --image-family cos-stable \
  --image-project cos-cloud \
  --container-image "$IMAGE:latest" \
  --container-restart-policy always \
  --container-env "TERMINAL_TOKEN=${TOKEN},WORKSPACE_HOST=${HOST}" \
  --container-mount-host-path mount-path=/workspace,host-path=/var/workspace,mode=rw \
  --container-mount-host-path mount-path=/home/node/.claude,host-path=/var/claude-config,mode=rw \
  --container-mount-host-path mount-path=/home/node/.codex,host-path=/var/codex-config,mode=rw \
  --container-mount-host-path mount-path=/data,host-path=/var/caddy-data,mode=rw

cat <<EOF

Workspace ready (first boot pulls the image — allow a few minutes):

  URL:      https://${HOST}
  Login:    dev
  Password: ${TOKEN}

First step inside the web terminal: run \`claude\` and complete the sign-in
once — the login persists across restarts.
EOF
