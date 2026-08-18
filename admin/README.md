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
3. **Public site** (`/`, `/docs/*`, legal pages) — the marketing landing page,
   the store-owner documentation, and the policy pages Google Play links to.
   Crawlable, statically prerendered, sharing the dashboard's palette. See
   "The public site" below.

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

## The public site

Everything outside `/dashboard` and `/api` is public, statically prerendered and
meant to be found by search. Three groups:

| Route | What it is |
|---|---|
| `/` | The marketing landing page — `src/components/site/LandingPage.tsx` composed from `Hero`, `Templates`, `ShopperFeatures`, `AdminFeatures`, `HowItWorks`, `Pricing`, `Payments`, `Trust`, `Faq`, `FinalCta`. |
| `/docs`, `/docs/<category>`, `/docs/<category>/<slug>` | Store-owner documentation, from MDX files on disk (below). |
| `/privacy`, `/terms`, `/refunds`, `/app-privacy`, `/delete-account` | Policy pages. The last two are the URLs submitted to Google Play, so they must stay publicly reachable and indexable. |

### Documentation (`/docs`)

Guides are **MDX files in the repo** — `src/content/docs/<category>/<slug>.mdx`,
read at build time by `src/lib/docs.ts`. No CMS and no database: a doc change
ships in the same PR as the feature it documents and is reviewable as a diff.

Add an article:

1. Create `src/content/docs/<category>/<slug>.mdx` with frontmatter:

   ```yaml
   ---
   title: Products
   description: One sentence — it becomes the <meta description> and the search result.
   order: 3            # position within the category; ties fall back to the title
   sidebarTitle: ...   # optional, when the full title is too long for the rail
   ---
   ```

2. That's it. The sidebar, the ⌘K search index, `generateStaticParams`, the
   prev/next pager and `sitemap.ts` all read the directory, so nothing lists
   articles by hand.

A **new category** is the one thing that is declared, not inferred: add it to
`docCategories` in `src/lib/docs.ts` (slug, name, description, icon). The order
guides appear in is editorial — what a new merchant hits first — not
alphabetical, and a folder name can't carry a description or an icon. A category
with no `.mdx` files yet is skipped everywhere, including the sitemap, because
its route 404s.

Authoring components available in MDX (`src/components/docs/mdx/`): `Callout`,
`Steps`, `Tabs`, `Cards`, `Accordion`, plus GFM tables and highlighted code
fences. `##`/`###` headings are extracted into the right-hand table of contents;
the anchor slug comes from `slugifyHeading`, shared by the TOC and the heading
components so a TOC link can't dead-scroll.

### SEO surface

Owned in code, not in a plugin — the full plan and its open items are in
`docs/explanation/seo-plan.md`.

| Concern | Where |
|---|---|
| `metadataBase`, so every route resolves absolute canonicals | `src/app/layout.tsx` |
| Per-page `<title>`, description and **self-canonical** | each `page.tsx` / `generateMetadata` |
| `robots.txt` — allows `/`, disallows `/dashboard/` and `/api/`, declares the sitemap | `src/app/robots.ts` |
| `sitemap.xml` — the public pages plus the whole docs tree enumerated off disk. No `lastModified`: this is a cached route, so `new Date()` would claim every page changed on every deploy | `src/app/sitemap.ts` |
| Social share card — a 1200×630 PNG generated by `next/og` from the brand palette and vendored Manrope. At the `app/` root, so **every** route inherits it | `src/app/opengraph-image.tsx`, `twitter-image.tsx` |
| JSON-LD — `Organization`, `SoftwareApplication` (zero-price `Offer`), `FAQPage` on `/`; `CollectionPage` on `/docs`; `TechArticle` per guide | `src/components/site/structured-data.tsx`, `src/app/docs/**` |
| One shared origin const (never hardcode the domain) | `src/lib/site.ts` → `SITE_URL` |

Two rules that have already been broken once each:

- **Never hand-declare `openGraph.images`** in a `page.tsx`. A literal `images`
  array *overrides* the `opengraph-image.tsx` file convention — that is what
  pointed every share at a 404 before it was removed.
- **Never add a URL to `sitemap.ts` that sets `robots: { index: false }`**, and
  never leave a real page out of it. The sitemap is a statement about what
  should rank, not an inventory of routes.

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

## Performance and caching

**Functions run in `bom1` (Mumbai), pinned in `vercel.json`.** That is not a
preference — Firestore for this project is `asia-south1`, also Mumbai, and
Vercel's default `iad1` (Washington DC) put every function two intercontinental
round trips from its own database. It cost a flat ~0.70s per call regardless of
payload; warm calls are now ~0.20s. **If the Firestore region ever moves, move
this with it** — see the note in `src/lib/firebase-admin.ts`.

Cold starts are ~1–2.5s and are module boot, not distance, so they are the same
in any region. Accepted as-is for now (2026-08-18). The fix, when wanted, is CDN
caching rather than faster boots.

### Before adding cache headers — read this

Catalog staleness is safe: price and stock are re-read live inside the order
transaction (`src/lib/orders.ts`), so a stale catalog is cosmetic — the shopper
is charged the live price, and a stale in-stock surfaces as an "Insufficient
stock" refusal at checkout, never an oversell.

**Two routes vary by `Authorization` header and must never be given a shared
cache. This is a data leak, not staleness:**

| Route | Why |
|---|---|
| `GET /api/stores` | Returns extra rows when a store owner's token is present. A shared cache warmed by an owner would serve **their unpublished draft stores to every anonymous shopper.** |
| `GET /api/stores/{id}/search` **without `q`** | Returns `recent_searches` keyed to the caller's uid — one shopper's history served to the next. With `q` it is pure catalog and safe. |

Safe to cache: `categories`, `banners`, `products/popular`, `brands`,
`products/{id}`, and `search` **only when `q` is present**. Never cache:
`stores`, `search` without `q`, `cart`, `orders`, `favourites`, `notifications`,
`users`.

Caching discovery is possible but needs the anonymous and authenticated
responses split, or a cache key on the auth header — a design change, not a
header. Full analysis and measurements:
`docs/explanation/superapp-ecommerce-plan.md` → "API latency — region move +
discovery query DONE, CDN caching deferred".

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
