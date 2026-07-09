# Monorepo workspace targets.
# A single `flutter pub get` at the root resolves every package (Dart pub
# workspace), and edits to packages/core are picked up live by any running app.

# All Flutter/Dart commands go through fvm — a prerequisite here, since the SDK
# version is pinned in .fvm. Override for a non-fvm setup, e.g.
# `make FLUTTER=flutter DART=dart run-jokes`.
FLUTTER ?= fvm flutter
DART ?= fvm dart

APPS = apps/jokes apps/doc_scanner apps/ai_chat apps/ecommerce
GEN_PACKAGES = packages/core apps/jokes apps/doc_scanner apps/ai_chat

# web-terminal collides with the web-terminal/ directory, so targets must be
# declared phony or make treats them as up-to-date files.
.PHONY: setup run-jokes run-doc-scanner run-ai-chat run-design-gallery \
        run-ecommerce web-jokes web-doc-scanner web-ai-chat web-design-gallery \
        web-ecommerce console terminal-bridge dev-web-terminal analyze test gen \
        clean docker-build docker-up ws-image ws-create ws-delete

setup:
	git config core.hooksPath .githooks
	$(FLUTTER) pub get

# --- run a specific app ---
run-jokes:
	cd apps/jokes && $(FLUTTER) run

run-doc-scanner:
	cd apps/doc_scanner && $(FLUTTER) run

run-ai-chat:
	cd apps/ai_chat && $(FLUTTER) run

# design_gallery is a dev tool (Widgetbook), not a shipping app — runs best on
# Chrome so the theme/viewport toolbar is easy to reach.
run-design-gallery:
	cd apps/design_gallery && $(FLUTTER) run

# ecommerce is the Gravia app — the design-quality exemplar (gravia style pack).
run-ecommerce:
	cd apps/ecommerce && $(FLUTTER) run

web-jokes:
	cd apps/jokes && $(FLUTTER) run -d chrome

web-doc-scanner:
	cd apps/doc_scanner && $(FLUTTER) run -d chrome

web-ai-chat:
	cd apps/ai_chat && $(FLUTTER) run -d chrome

web-design-gallery:
	cd apps/design_gallery && $(FLUTTER) run -d chrome

web-ecommerce:
	cd apps/ecommerce && $(FLUTTER) run -d chrome

# --- web-terminal console: React/Next.js UI + local Node PTY bridge ---
# The console (web-terminal/console) is a Next.js app that streams a real shell
# from the Node bridge (web-terminal/server). The bridge holds your local
# permissions. Two servers, two shells: bridge on :3000, console on :4000.

# Shell 1 — the PTY bridge on :3000.
terminal-bridge:
	cd web-terminal/server && npm install && npm start

# Shell 2 — the React console on :4000, talking to the bridge on :3000.
# Run `make terminal-bridge` in another shell first.
console:
	cd web-terminal/console && npm install && npm run dev

# Backwards-compatible alias for the console dev server.
dev-web-terminal: console

# --- cloud workspace: the whole stack (console + bridge + Flutter + agents) in
# one Docker image, deployable as a per-user GCE spot VM.
# Full flow: docs/how-to/deploy-workspace-gcp.md

# Build the workspace image locally.
docker-build:
	docker compose build

# Run the workspace locally: http://localhost:8080, basic auth dev/devtoken.
docker-up:
	docker compose up --build

# Build + push the image to Artifact Registry via Cloud Build (amd64).
ws-image:
	./infra/workspace/build-image.sh

# Spin up / tear down one user's workspace VM: make ws-create WS_USER=alice
# (WS_USER, not USER — the shell already owns $USER.)
ws-create:
	./infra/workspace/create-workspace.sh $(WS_USER)

ws-delete:
	./infra/workspace/delete-workspace.sh $(WS_USER)

# --- workspace-wide ---
analyze:
	$(FLUTTER) analyze --no-pub

test:
	@for app in $(APPS); do \
		echo "== test: $$app =="; \
		(cd $$app && $(FLUTTER) test) || exit 1; \
	done

gen:
	@for pkg in $(GEN_PACKAGES); do \
		echo "== gen: $$pkg =="; \
		(cd $$pkg && $(DART) run build_runner build --delete-conflicting-outputs) || exit 1; \
	done

# Clean every package's build output, then re-resolve the whole workspace.
clean:
	@for pkg in packages/core $(APPS); do \
		echo "== clean: $$pkg =="; \
		(cd $$pkg && $(FLUTTER) clean); \
	done
	$(FLUTTER) pub get
