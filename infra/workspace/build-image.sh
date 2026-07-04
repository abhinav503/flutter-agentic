#!/usr/bin/env bash
# Build the workspace image on Cloud Build (native amd64 — required for e2 VMs)
# and push it to Artifact Registry. Run from anywhere; builds from the repo root.
#
# Apple-silicon note: if you build locally instead, you MUST cross-compile —
#   docker buildx build --platform linux/amd64 -t "$IMAGE:latest" --push .
# An arm64 image will not run on e2 machines.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "Building $IMAGE:latest via Cloud Build (project $PROJECT)…"
gcloud builds submit "$REPO_ROOT" \
  --project "$PROJECT" \
  --tag "$IMAGE:latest" \
  --timeout 1800s

echo "Pushed $IMAGE:latest"
