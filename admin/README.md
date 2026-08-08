# Admin console

The store-owner web console behind the **`cordelia` multi-tenant storefront**
(Next.js App Router). One deployment serves every store; a shopper opens any of
them in the same app. Two jobs in one codebase:

1. **Dashboard** (`/dashboard/*`) — a signed-in owner manages their store's
   catalog (categories, products, brands, banners, coupons), orders, reviews,
   store profile, and Razorpay settings.
2. **REST API** (`/api/*`) — the backend every storefront calls: catalog reads,
   cart, orders, payments, refunds, addresses, favourites, reviews, search, and
   the `/api/geo/*` proxy. All shopper routes are Firebase-ID-token verified.

There is also a public marketing landing page at `/`, crawlable and sharing the
dashboard's palette.

Backing services: Firebase (`corderlia-ecom`) — Firestore (multi-tenant
catalog/orders), Auth, Storage. Deployed on Vercel. See
`docs/explanation/superapp-ecommerce-plan.md` for the full platform plan.

## Getting started

```bash
cd admin
npm install
npm run dev        # http://localhost:4100
```

### Environment (`admin/.env.local`)

- `FIREBASE_ADMIN_PROJECT_ID` / `FIREBASE_ADMIN_CLIENT_EMAIL` / `FIREBASE_ADMIN_PRIVATE_KEY`
  — service-account creds for the Admin SDK (trusted server path).
- `NEXT_PUBLIC_FIREBASE_*` — client SDK config (browser auth + dashboard reads).
- `PAYMENTS_ENC_KEY` — 64 hex chars; AES-256-GCM key that encrypts store
  payment/webhook secrets at rest (`src/lib/crypto.ts`). Never ships to a client.
- `OLA_MAPS_API_KEY` — Ola Maps key behind the `/api/geo/*` proxy routes
  (reverse geocode + autocomplete for the shopper address form;
  `src/lib/geo.ts`). Never ships to a client.
- `CRON_SECRET` — **TODO, not set yet.** What Vercel Cron sends as
  `Authorization: Bearer …` when it calls `/api/devices/prune` (the weekly
  sweep of FCM device rows nobody has refreshed in 270 days, scheduled in
  `vercel.json`). Until it is set the schedule can't authenticate and the
  prune is effectively off — deliberately, since an open prune endpoint would
  delete every shopper's device registrations. A superadmin can still run it
  by hand meanwhile.

See `.env.local.example` for the full list.

## A store's identity: template, language, currency

Three independent axes on the store doc, all set on **`/dashboard/settings`**.

**Template** (`template_id`) — `gravia` | `dailymart` | `grofast`. Picks which
UI the storefront renders for this store, at runtime. See
`docs/how-to/add-storefront-template.md`.

**Language** (`language`) — the storefront's UI language:
`en`, `de`, `fr`, `es`, `it`, `hi`. Hindi is deliberately last in every
picklist. This translates **chrome only** — catalog content is single-valued
plain text, so a German store seeded from the India catalog shows German
buttons around Indian product names. Seed the matching market instead (below).
Adding a language: `docs/how-to/add-language-pack.md`.

**Currency** (`currency`) — `INR`, `EUR`, `GBP`, `USD`. What prices are *in*,
which is a separate question from what language they're *read in*: a shopper
browsing a UK store in German still pays in £.

Everything money-shaped in the dashboard renders through `src/lib/money.ts` —
`formatMoney` / `currencySymbol` / `compactMoney` — reading `storeCurrency`
from `useStore()`. There are no currency literals in components; a hardcoded
`₹` is a bug, and was one in 21 places before this was centralized. The
storefront half is core's `AppFormat`.

## Generate sample data

**Settings → Sample data → Generate sample data** writes a realistic grocery
catalog into the store in one atomic `writeBatch`. Seven markets, each written in its own
language with its own local brands and shelf prices:

| Market | Currency | Brands you'd recognize |
|---|---|---|
| India | ₹ | Amul, Britannia, Tata, Maggi |
| Germany | € | Kerrygold, Dr. Oetker, Ritter Sport, Haribo |
| France | € | Président, Bonne Maman, LU, Evian |
| Spain | € | Central Lechera Asturiana, Carbonell, Gullón |
| Italy | € | Barilla, Mulino Bianco, Galbani, Lavazza |
| UK | £ | Warburtons, Heinz, Cathedral City, Cadbury |
| US | $ | Cheerios, Kraft, Chobani, DiGiorno |

~100 products each (719 total, 918 image URLs). The store's currency
pre-selects a market (`defaultSeedMarketForCurrency`: INR → india, GBP → uk,
USD → us, EUR → germany, with the owner free to override).

One catalog per market rather than one catalog rescaled — a market's brands,
aisle names and shelf prices are all local, and the storefront's price-filter
bands are per currency, so a euro store seeded from the rupee catalog breaks
the filter as well as the copy.

Photos come from Open Food Facts (CC-BY-SA, attributed in the dialog), banners
from Unsplash, brand logos from verified favicons or DiceBear monograms.

### Adding a market

Add `<market>-seed-data.ts`, register it in `seed-markets.ts` — **and add the
filename to all four gate scripts**, which each hold their own list:

| Gate | Checks |
|---|---|
| `npm run verify:seed-images` | every image URL resolves (retries; distinguishes a real 404 from CDN throttling) |
| `npm run verify:seed-bands` | no price-filter band is empty for that currency, so no chip returns nothing |
| `npm run verify:seed-refs` | every product's category/brand slug exists in the same seed |
| `scripts/patch-seed-images.mjs` | retrofits already-seeded stores when URLs change |

A gate catches an *empty* band; a nearly empty one (a chip returning one item)
still needs a human to look.

## Payments (per-store Razorpay)

Each store connects its **own** Razorpay account — payments settle directly into
it (SaaS model, no marketplace/split layer). Store owners set this up on
**`/dashboard/settings`**:

- **API keys** — `keyId` (public) + `keySecret` (encrypted at rest). The key
  prefix (`rzp_test_`/`rzp_live_`) decides test-vs-live: a live store always
  requires a verified payment before an order is written; a test store may place
  a payment-less order (the web-preview path).
- **Webhook secret** — for the refund webhook below (distinct from the key
  secret).

Credentials live in `stores/{id}/private/payment` (a `private` subcollection
locked `read,write:if false`; only the Admin SDK reaches it). The checkout flow
verifies the Razorpay signature (`verifyPaymentSignature`) before `createOrder`.

### Cancel & refund

- A shopper self-cancels a pre-dispatch order, or the owner cancels from
  `/dashboard/orders`. Either way the server (`POST /orders/{id}/cancel`,
  dual-role) restocks the items and issues a full Razorpay refund.
- Refund settlement is one idempotent helper (`src/lib/refunds.ts`
  `settleRefund`) — it looks up a payment's existing refunds before creating one
  (`getExistingRefund`), so a retry can't double-refund; a provider failure
  leaves the order cancelled with a retriable refund, never a 500.
- Owner recourse for a stuck refund: **"Complete refund" / "Retry refund"** on
  the order (`POST /orders/{id}/refund`).

### Refund webhook

`POST /api/stores/{storeId}/webhooks/razorpay` auto-settles refunds: a refund
Razorpay accepts as *pending* settles asynchronously, and `refund.processed` /
`refund.failed` flip the order's `refundStatus` with no admin click. It's
HMAC-verified against the store's webhook secret over the raw body.

**Add it in Razorpay** (per store, in that store's Razorpay dashboard):

1. **Dashboard → Settings → Webhooks → Add New Webhook**.
2. **URL** — paste the value shown on the console's **Settings → Razorpay →
   Webhook** card: `https://<admin-domain>/api/stores/<storeId>/webhooks/razorpay`.
3. **Secret** — enter a strong random string; paste the same value back into the
   Settings → Webhook field and save.
4. **Active events** — `refund.processed` and `refund.failed`.

Razorpay must reach a public HTTPS URL — deployed admin domain, or `ngrok` for
local testing (test- and live-mode webhooks are configured separately). Without
the webhook nothing breaks; refunds just stay "processing" until an owner clicks
"Complete refund".

### Verifying the webhook (`npm run test:webhook`)

`scripts/test-refund-webhook.mjs` verifies the webhook's signature handshake
against the running server — it signs sample payloads the way Razorpay does and
asserts valid signatures are accepted and every tampered/wrong-secret/missing
case is rejected (401).

```bash
npm run dev                                    # http://localhost:4100
# in another shell, using the SAME secret you set on the Settings page:
WEBHOOK_SECRET=whsec_xxx npm run test:webhook
# optional — assert a REAL cancelled+paid order flips to PROCESSED
# (⚠ mutates that order's refund state):
WEBHOOK_SECRET=whsec_xxx PAYMENT_ID=pay_realOrder npm run test:webhook
```

Default run is non-destructive (synthetic payment id → the route acks it, no
order changes). Overridable env: `ADMIN_BASE_URL` (default `http://localhost:4100`),
`STORE_ID` (default the seeded "Gravia" store). Checks 1–3 & 5 need the webhook
secret configured on the dashboard first; the route returns `400 "not
configured"` otherwise and the script says so.

## Error responses the client re-writes

Most API errors are shown to the shopper as-is. One is not: an under-minimum
coupon names an *amount*, and only the client knows both the store's currency
and the shopper's language. So `CouponError` (`src/lib/coupon-engine.ts`) also
carries a machine-readable `code` plus the bare number, serialized by
`couponErrorBody()`, and the storefront writes the sentence. The server's own
`message` stays a currency-neutral English fallback.

The rule generalizes: **a message that names money or a count can't be
authored server-side.** Send the operands and a code.

## Scripts

| Script | What it does |
|---|---|
| `npm run dev` | Dev server on :4100 |
| `npm run build` | Production build |
| `npm run start` | Serve the production build |
| `npm run lint` | ESLint |
| `npm run test:webhook` | Verify the Razorpay refund webhook (above) |
| `npm run seed:templates` | One-off: write the `templates` collection the create-store dropdown reads (idempotent; re-run after adding a template) |
| `npm run verify:seed-images` | Every seed image URL resolves |
| `npm run verify:seed-bands` | No price-filter band is empty in any seed |
| `npm run verify:seed-refs` | Every seed product's category/brand slug exists |
