# Gravia

The `gravia` style-pack reference app under `apps/ecommerce/` — FlutterAgentic's
ecommerce/grocery/retail exemplar. Built on the shared `packages/core` Clean
Architecture template (see the repo root `CLAUDE.md` and
`docs/reference/architecture.md`); design tokens come from the `gravia` theme
preset, sourced from the UI8 "Gravia — Grocery Shop App UI Kit" (RL Studio) —
see `docs/ai-rules/design.md` for the full style-pack profile.

`apps/ecommerce/` is a category folder, not an app itself — more ecommerce
style packs can land as siblings of `gravia` here later.

Gravia is the storefront half of a two-app system: this Flutter app is what
shoppers use; the **admin console** (`admin/`, Next.js) is where a store owner
manages catalog, orders, and payments. They share one Firebase project
(`corderlia-ecom`) and the admin app also serves gravia's REST API. See
`docs/explanation/superapp-ecommerce-plan.md` for the platform picture.

## What's implemented

- **Theme** — `assets/theme/theme_config.json` selects the `gravia` preset,
  wired through `AppTheme.fromConfig`. Light/dark both supported (AppBar toggle).
- **App identity** — launcher icon + native boot splash generated from the brand
  mark in `branding/`. Android/iOS id: `com.flutteragentic.gravia`.
- **Nav shell** (`feature/shell/`) — the five-tab bottom nav (Home, Categories,
  Favourite, Orders, Profile) per the tabbed-app pattern in
  `docs/reference/architecture.md`; frequently-revisited tabs warm-start from a
  `BlocCache` (`docs/how-to/design-tab-flow.md`).
- **Storefront** — product grid/home, categories + details, product details,
  search + recent searches, favourites — all wired end-to-end (BLoC → screen →
  nav) against the deployed API, on the `core/ui/blocks/` catalog.
- **Cart & checkout** (`feature/cart/`) — persistent per-store cart; "Proceed to
  Checkout" runs through `CheckoutBloc` (create payment intent → native Razorpay
  checkout → server-verified order write), confirmed via the order-placed sheet.
  On web (no native SDK) it takes a test-mode payment-less path so checkout stays
  exercisable in the preview.
- **Orders** (`feature/orders/`) — order history with Upcoming/Past tabs +
  filter; **cancel** (pre-dispatch) with optimistic update and automatic
  **refund**; per-order refund status. `IN_PROCESS` shows as "On the way".
- **Auth** (`feature/auth/`) — Firebase email/password signup/login, persistent
  email-verification sheet with poll + resume-on-relaunch, forgot/reset
  password, session-expired guard; profile is dual-written to Firestore behind a
  token-verifying API. See `docs/how-to/add-firebase-auth.md`.
- **Profile & address** — profile view/edit, change password, address CRUD +
  select-at-checkout, notifications, legal.

## Payments, checkout & refunds

Money is **provider-agnostic in the app** and **per-store on the backend**:

- The orders feature has **two repositories** — `OrdersRepository` (own backend)
  and `PaymentGatewayRepository` (the PSP, seen only as "take this intent →
  verifiable result"). "Razorpay" appears in exactly one file
  (`data/data_source/razorpay_gateway_data_source_impl.dart`); swapping PSPs is a
  data-source-impl change.
- Each **store** settles into its **own** Razorpay account. The server prices the
  cart, creates the Razorpay order with the store's secret, and **verifies the
  payment signature** before writing the order. A store's key prefix
  (`rzp_test_`/`rzp_live_`) gates the test-mode payment-less path.
- **Cancel → refund**: a shopper self-cancels a pre-dispatch order (or the admin
  cancels it); the server restocks and issues a full Razorpay refund. Refund is a
  separate axis (`RefundStatus`: `none/pending/processed/failed`) shown on the
  order card. Refund settlement is idempotent (never double-refunds); an admin
  can complete/retry a stuck refund from the dashboard.

The full backend flow (per-store credentials, encryption, signature/refund
verification, the webhook) lives in the admin app — see `admin/README.md` and
`docs/explanation/superapp-ecommerce-plan.md`.

### Refund webhook + verification test (admin side)

A per-store Razorpay webhook (`POST /api/stores/{storeId}/webhooks/razorpay`, in
the admin app) auto-settles refunds — a refund Razorpay accepts as *pending*
flips the order to `PROCESSED` on `refund.processed`, with no admin click. It's
signature-verified against the store's own **webhook secret** (set on the admin
Settings page; distinct from the API key secret).

To add the webhook in Razorpay: **Dashboard → Settings → Webhooks → Add** →
paste the URL shown on the admin **Settings → Razorpay → Webhook** card → set a
secret (paste the same value back into that card) → subscribe to
`refund.processed` and `refund.failed`. (Razorpay must reach a public URL — use
`ngrok` locally, or the deployed admin domain.)

Verify the webhook end-to-end with the signature test — it signs sample payloads
like Razorpay does and asserts valid signatures are accepted and tampered/
wrong-secret/missing ones are rejected:

```bash
cd admin
npm run dev                                   # server on http://localhost:4100
# in another shell, using the same secret you configured on the Settings page:
WEBHOOK_SECRET=whsec_xxx npm run test:webhook
# optional — assert a REAL cancelled+paid order actually flips to PROCESSED
# (⚠ mutates that order's refund state):
WEBHOOK_SECRET=whsec_xxx PAYMENT_ID=pay_realOrder npm run test:webhook
```

The default run is non-destructive (synthetic payment id → the route acks it, no
order is modified). Overridable env: `ADMIN_BASE_URL`, `STORE_ID`.

## Run

```bash
make run-gravia   # from the repo root
# or
cd apps/ecommerce/gravia && flutter run
```

## Test

```bash
cd apps/ecommerce/gravia && flutter test
```
