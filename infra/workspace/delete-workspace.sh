#!/usr/bin/env bash
# Tear down a workspace VM and release its static IP.
# WARNING: the user's code on that VM is deleted with it — they should
# git-push anything they want to keep first.
#
#   ./delete-workspace.sh <user>
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"

USER_NAME="${1:?usage: delete-workspace.sh <user>}"
NAME="ws-${USER_NAME}"

echo "Deleting instance $NAME (workspace data goes with it)…"
gcloud compute instances delete "$NAME" \
  --project "$PROJECT" --zone "$ZONE" --quiet

echo "Releasing static IP ${NAME}-ip…"
gcloud compute addresses delete "${NAME}-ip" \
  --project "$PROJECT" --region "$REGION" --quiet

echo "Done."
