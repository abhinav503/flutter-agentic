# Monorepo workspace targets.
# A single `flutter pub get` at the root resolves every package (Dart pub
# workspace), and edits to packages/core are picked up live by any running app.

# All Flutter/Dart commands go through fvm — a prerequisite here, since the SDK
# version is pinned in .fvm. Override for a non-fvm setup, e.g.
# `make FLUTTER=flutter DART=dart run-jokes`.
FLUTTER ?= fvm flutter
DART ?= fvm dart

APPS = apps/jokes apps/doc_scanner apps/ai_chat apps/web_terminal
GEN_PACKAGES = packages/core apps/jokes apps/doc_scanner apps/ai_chat apps/web_terminal

# web-terminal collides with the web-terminal/ directory, so targets must be
# declared phony or make treats them as up-to-date files.
.PHONY: setup run-jokes run-doc-scanner run-ai-chat web-jokes web-doc-scanner \
        web-ai-chat web-terminal terminal-bridge dev-web-terminal analyze test \
        gen clean

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

web-jokes:
	cd apps/jokes && $(FLUTTER) run -d chrome

web-doc-scanner:
	cd apps/doc_scanner && $(FLUTTER) run -d chrome

web-ai-chat:
	cd apps/ai_chat && $(FLUTTER) run -d chrome

# --- web_terminal: Flutter web UI + local Node PTY bridge ---
# The Flutter app (apps/web_terminal) renders a real shell streamed from the
# Node bridge (web-terminal/server). The bridge holds your local permissions.

# One-port experience: build the web app, then the bridge serves it on :3000.
# Open http://localhost:3000 and run `claude` in the terminal.
web-terminal:
	cd apps/web_terminal && $(FLUTTER) build web
	cd web-terminal/server && npm install && npm start

# Just the PTY bridge on :3000 (run alongside `make dev-web-terminal`).
terminal-bridge:
	cd web-terminal/server && npm install && npm start

# Hot-reload dev: Flutter on :4000, talking to the bridge on :3000.
# Run `make terminal-bridge` in another shell first.
dev-web-terminal:
	cd apps/web_terminal && $(FLUTTER) run -d chrome --web-port 4000

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
