#!/usr/bin/env bash
# Export everything needed to read/review one app in a single folder:
# the app itself, the shared core package, and the monorepo/melos configs.
#
#   ./scripts/export-app-code.sh <app> [dest-dir]
#   ./scripts/export-app-code.sh ai_chat            → ./code-export/ai_chat/
#   ./scripts/export-app-code.sh jokes ~/Desktop/rv → ~/Desktop/rv/
#
# Generated files (.freezed.dart/.g.dart), build output, native scaffolding,
# and tool caches are skipped — the export is the reviewable source only.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

APP="${1:-}"
if [ -z "$APP" ] || [ ! -d "$REPO_ROOT/apps/$APP" ]; then
  echo "Usage: $0 <app> [dest-dir]" >&2
  echo "Apps: $(ls "$REPO_ROOT/apps" | tr '\n' ' ')" >&2
  exit 1
fi

DEST="${2:-$REPO_ROOT/code-export/$APP}"
rm -rf "$DEST"
mkdir -p "$DEST"

# Reviewable source only — no generated, built, or native-scaffold files.
EXCLUDES=(
  --exclude 'build/'
  --exclude '.dart_tool/'
  --exclude '.idea/'
  --exclude '*.iml'
  --exclude '*.freezed.dart'
  --exclude '*.g.dart'
  --exclude 'android/' --exclude 'ios/' --exclude 'web/'
  --exclude 'macos/' --exclude 'windows/' --exclude 'linux/'
)

rsync -a "${EXCLUDES[@]}" "$REPO_ROOT/apps/$APP/"      "$DEST/apps/$APP/"
rsync -a "${EXCLUDES[@]}" "$REPO_ROOT/packages/core/"  "$DEST/packages/core/"

# Monorepo configs: workspace root + task runner + shared lints.
cp "$REPO_ROOT/pubspec.yaml"          "$DEST/pubspec.yaml"
cp "$REPO_ROOT/melos.yaml"            "$DEST/melos.yaml"
cp "$REPO_ROOT/Makefile"              "$DEST/Makefile"
cp "$REPO_ROOT/analysis_options.yaml" "$DEST/analysis_options.yaml"

echo "Exported to $DEST"
find "$DEST" -type f | wc -l | xargs echo "Files:"
