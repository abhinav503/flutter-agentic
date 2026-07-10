FROM node:22-bookworm-slim AS console-builder

WORKDIR /build
COPY web-terminal/console/package.json web-terminal/console/package-lock.json ./
# only install as per .lock file
RUN npm ci
COPY web-terminal/console/ ./
# /bridge = path-relative bridge base: Caddy forwards it to the bridge on the
# same origin, so one built bundle works on any hostname (see src/lib/bridge.ts).
ENV NEXT_TELEMETRY_DISABLED=1
RUN NEXT_OUTPUT=standalone NEXT_PUBLIC_BRIDGE_ORIGIN=/bridge npm run build

# ── Stage 2: runtime ────────────────────────────────────────────────────────
FROM node:22-bookworm-slim AS runtime

# lsof + procps: the bridge's stale-port reaper shells out to them.
# python3/make/g++: node-pty compile fallback if a prebuild is missing.
RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl ca-certificates unzip xz-utils zip lsof procps tini \
      python3 make g++ openssh-client \
    && rm -rf /var/lib/apt/lists/*

COPY --from=caddy:2 /usr/bin/caddy /usr/local/bin/caddy

# Flutter SDK — pinned to the repo's version (.fvm/fvm_config.json + CI).
ARG FLUTTER_VERSION=3.44.0
RUN curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
      | tar -xJ -C /opt \
    && chown -R node:node /opt/flutter
ENV PATH=/opt/flutter/bin:/usr/local/bin:$PATH

# Agent CLIs. Users authenticate themselves in the web terminal (claude → OAuth);
# no API keys are baked into or passed to the image.
RUN npm install -g @anthropic-ai/claude-code @openai/codex

# PTY bridge (postinstall chmods node-pty's spawn-helper)
COPY --chown=node:node web-terminal/server /opt/app/bridge
RUN cd /opt/app/bridge && npm ci --omit=dev

# Console — Next standalone output; static assets + public/ must ride along.
COPY --from=console-builder --chown=node:node /build/.next/standalone /opt/app/console
COPY --from=console-builder --chown=node:node /build/.next/static /opt/app/console/.next/static
COPY --from=console-builder --chown=node:node /build/public /opt/app/console/public

# The monorepo as the workspace template. .dockerignore strips .git/.env/build
# output; a fresh git history means no remotes or secrets ride along.
COPY --chown=node:node . /opt/workspace-template

USER node
RUN flutter config --enable-web --no-enable-linux-desktop --no-analytics \
    && flutter precache --web \
    && git config --global user.name "FlutterAgentic Workspace" \
    && git config --global user.email "workspace@flutteragentic.local" \
    && git config --global init.defaultBranch main \
    && cd /opt/workspace-template \
    && git init -q && git add -A && git commit -qm "chore: workspace template" \
    && flutter pub get
USER root

COPY infra/workspace/Caddyfile infra/workspace/start.sh /opt/app/
RUN chmod +x /opt/app/start.sh

# Defaults the bridge reads; SHELL feeds the PTY spawn.
ENV FLUTTER_BIN=flutter \
    PROJECT_DIR=/workspace \
    SHELL=/bin/bash \
    CLAUDE_CONFIG_DIR=/home/node/.claude \
    CODEX_HOME=/home/node/.codex \
    NEXT_TELEMETRY_DISABLED=1 \
    XDG_DATA_HOME=/data

EXPOSE 80 443
VOLUME ["/workspace"]

# Starts as root: chowns host-path mounts, binds 80/443, then drops to `node`
# for the bridge/console/shell. Non-root Caddy via setcap is a follow-up.
ENTRYPOINT ["tini", "--", "/opt/app/start.sh"]
