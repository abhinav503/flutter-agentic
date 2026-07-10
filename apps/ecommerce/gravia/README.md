# Gravia

The `gravia` style-pack reference app under `apps/ecommerce/` — FlutterAgentic's
ecommerce/grocery/retail exemplar. Built on the shared `packages/core` Clean
Architecture template (see the repo root `CLAUDE.md` and
`docs/reference/architecture.md`); design tokens come from the `gravia` theme
preset, sourced from the UI8 "Gravia — Grocery Shop App UI Kit" (RL Studio) —
see `docs/ai-rules/design.md` for the full style-pack profile.

`apps/ecommerce/` is a category folder, not an app itself — more ecommerce
style packs can land as siblings of `gravia` here later.

## What's implemented

- **Theme** — `assets/theme/theme_config.json` selects the `gravia` preset
  (`packages/core/lib/core/theme/app_theme_presets.dart`), wired through
  `AppTheme.fromConfig`. Light/dark both supported, toggled from the AppBar.
- **App identity** — launcher icon and native boot splash generated from the
  brand mark in `branding/` via `flutter_launcher_icons` +
  `flutter_native_splash` (see their config blocks in `pubspec.yaml`).
  Android application ID / iOS bundle ID: `com.flutteragentic.gravia`.
- **Splash screen** (`feature/splash/`) — Flutter-side splash route showing the
  "GR[icon]VIA" wordmark over the brand SVG glyph, holds ~1.6s, then routes to
  `/home`. Complements (does not replace) the native boot splash.
- **Home shell** (`feature/home/`) — `HomePage` wires the kit's five-tab
  bottom nav: Home, Categories, Favourite, Orders, Profile. Only the tab
  index and app chrome (AppBar with theme toggle) are real; each tab body is
  currently an `EmptyState` placeholder pending its real feature.
- **Navigation** — `go_router` with two routes so far: `/` (splash) and
  `/home`.
- **DI** — `injection_container.dart` wires `initCoreDependencies()` only;
  no app-specific data sources/repositories/use cases exist yet.

## Not yet implemented

Product grid, categories, cart, checkout, favourites, orders, and profile are
all placeholder `EmptyState` screens — no domain/data layers exist yet for
any feature. Add one with `docs/how-to/add-feature-template.md`.

## Run

```bash
make run-gravia   # from the repo root
# or
cd apps/ecommerce/gravia && flutter run
```
