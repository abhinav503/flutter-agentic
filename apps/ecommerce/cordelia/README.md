# CordeliaApps

The multi-store super app under `apps/ecommerce/` — a shared entry point (splash,
onboarding, Firebase auth, store discovery) for CordeliaApps' ecommerce stores.
Built on the shared `packages/core` Clean Architecture template (see the repo
root `CLAUDE.md` and `docs/reference/architecture.md`).

CordeliaApps is a **sibling** to `gravia` (`apps/ecommerce/gravia`), not a
replacement — gravia remains the single-store style-pack exemplar; this app is
the "app of apps" shell a shopper opens first, picks a store from, and (later)
lands inside that store's own storefront experience. They share one Firebase
project (`corderlia-ecom`) and one shopper identity, and both call the same
admin backend (`admin/`, Next.js) — see
`docs/explanation/superapp-ecommerce-plan.md` for the platform picture.

Splash/onboarding/auth were ported from gravia's already-working
implementation rather than rebuilt — see that plan doc and this app's git
history for what changed versus gravia's originals (mainly: brand assets,
dropping cart/favourites/orders/address/profile references, and moving the
persistent email-verification sheet from a bottom-nav shell onto the
discovery/home screen, since this app has no tabs).

## What's implemented

- **Theme** — `assets/theme/theme_config.json` holds CordeliaApps' own brand
  palette, a green scale derived from the brand mark's gradient stops
  (`#007A60` → `#2DA987`). Shape and typography are still the gravia kit's —
  those metrics are pack-neutral and CordeliaApps has no kit of its own.
- **App identity** — launcher icon + native boot splash generated from the
  CordeliaApps brand mark in `branding/`. Android/iOS id:
  `com.cordeliaapps.superapp`.
- **Auth** (`feature/auth/`) — Firebase email/password signup/login, persistent
  email-verification sheet with poll + resume-on-relaunch, forgot/reset
  password, session-expired guard.
- **Store discovery** (`feature/home/`) — search/list stores from the
  platform-wide `GET /api/stores` endpoint; the app's entry point after auth.
- **Storefront stub** (`feature/storefront/`) — placeholder screen shown after
  picking a store; real per-store catalog/cart/checkout is not wired yet.

## Deferred (not in this pass)

- Profile (view/edit/change-password), legal pages, logout UI — gravia's
  underlying local-cache services are ported and ready, but no screen
  surfaces them yet.
- Real per-store catalog/cart/checkout inside the storefront screen.

## Run

```bash
make run-cordelia   # from the repo root
# or
cd apps/ecommerce/cordelia && flutter run
```

## Test

```bash
cd apps/ecommerce/cordelia && flutter test
```
