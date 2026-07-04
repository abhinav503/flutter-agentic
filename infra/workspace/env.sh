#!/usr/bin/env bash
# Shared config for the workspace deploy scripts. Override any value via env.
# One-time GCP setup (Artifact Registry repo + firewall rule):
#   docs/how-to/deploy-workspace-gcp.md

PROJECT="${PROJECT:-$(gcloud config get-value project 2>/dev/null)}"
REGION="${REGION:-us-central1}"
ZONE="${ZONE:-us-central1-a}"
AR_REPO="${AR_REPO:-workspaces}"
IMAGE="${IMAGE:-${REGION}-docker.pkg.dev/${PROJECT}/${AR_REPO}/flutteragentic-workspace}"
MACHINE_TYPE="${MACHINE_TYPE:-e2-standard-4}"
NETWORK_TAG="${NETWORK_TAG:-flutteragentic-workspace}"

if [ -z "$PROJECT" ]; then
  echo "No GCP project — run 'gcloud config set project <id>' or export PROJECT=…" >&2
  exit 1
fi
