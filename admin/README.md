# Admin console

The store-owner web console for the `gravia` ecommerce app (Next.js App Router).
Two jobs in one app:

1. **Dashboard** (`/dashboard/*`) — a signed-in store owner manages catalog
   (categories/products + image upload), orders, and Razorpay payment settings.
2. **REST API** (`/api/*`) — the backend gravia (and any storefront) calls:
   catalog reads, cart, orders, payments, refunds, addresses, favourites, search.
   All shopper routes are Firebase-ID-token verified.

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

See `.env.local.example` for the full list.

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

## Scripts

| Script | What it does |
|---|---|
| `npm run dev` | Dev server on :4100 |
| `npm run build` | Production build |
| `npm run start` | Serve the production build |
| `npm run lint` | ESLint |
| `npm run test:webhook` | Verify the Razorpay refund webhook (above) |
