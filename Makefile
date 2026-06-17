# Monorepo workspace targets.
# A single `flutter pub get` at the root resolves every package (Dart pub
# workspace), and edits to packages/core are picked up live by any running app.

APPS = apps/jokes apps/doc_scanner
GEN_PACKAGES = packages/core apps/jokes apps/doc_scanner

setup:
	git config core.hooksPath .githooks
	flutter pub get

# --- run a specific app ---
run-jokes:
	cd apps/jokes && flutter run

run-doc-scanner:
	cd apps/doc_scanner && flutter run

web-jokes:
	cd apps/jokes && flutter run -d chrome

web-doc-scanner:
	cd apps/doc_scanner && flutter run -d chrome

# --- workspace-wide ---
analyze:
	flutter analyze --no-pub

test:
	@for app in $(APPS); do \
		echo "== test: $$app =="; \
		(cd $$app && flutter test) || exit 1; \
	done

gen:
	@for pkg in $(GEN_PACKAGES); do \
		echo "== gen: $$pkg =="; \
		(cd $$pkg && dart run build_runner build --delete-conflicting-outputs) || exit 1; \
	done

# Clean every package's build output, then re-resolve the whole workspace.
clean:
	@for pkg in packages/core $(APPS); do \
		echo "== clean: $$pkg =="; \
		(cd $$pkg && flutter clean); \
	done
	flutter pub get
