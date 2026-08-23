# Programmable store publishing — Catalog API → MCP → CLI → platform imports

> Status: Phase 0 done (tasks 1–7; task 8 open), Phase 1 live (2026-08-23). Target sellers: developers/agencies and merchants with an existing catalog. Kirana/small grocers are not a focus.

## Context

Today a store is published only by a human clicking through the admin console. Exploration of `admin/` shows why every "faster" channel is currently impossible:

- **Catalog writes have no server route.** Products, categories, brands, coupons, banners are written from the browser with the Firebase client SDK (`admin/src/lib/{products,categories,brands,coupons,banners}.ts`), gated by `firestore.rules`. The CSV importer is also browser-only (`admin/src/lib/import/*`, `import-csv-dialog.tsx`, 500-row batches).
- **No machine-caller auth exists.** Every `app/api/*` route wants a Firebase ID token (`admin/src/lib/api/admin-guard.ts`); the only bearer secret is `CRON_SECRET` on `/api/devices/prune`. A coding agent, a CLI, or a Shopify sync job has no way to act on a store.
- No Shopify/WooCommerce/any-platform importer; no MCP server; the only CLIs are ops scripts in `admin/scripts/`.

Target sellers (user decision, 2026-08-23): **developers/agencies building stores for clients, and merchants who already have a catalog** — Shopify/WooCommerce exports, warehouse/ERP/supermarket CSVs, WhatsApp-catalog exports. Kirana/small grocers are explicitly *not* a focus. A hosted chat agent is **deferred**: with an MCP server, a merchant's developer brings their own agent (Claude Code, Cursor, ChatGPT desktop) and gets the "talk to it, hand it a CSV" experience at zero LLM cost to us.

Outcome: `npx cordelia login && cordelia import shopify products_export.csv && cordelia publish` — or the same three steps issued by any coding agent over MCP — takes a merchant from export to submit-for-review in minutes, with no console round-trips.

## Decisions locked (2026-08-23 discussion)

| # | Decision |
|---|---|
| 1 | CLI login = **localhost-callback**: `cordelia login` opens the console's `/cli/auth?port=…`, which mints a Firebase **custom token** via `POST /api/v1/cli/session`; CLI exchanges it (`signInWithCustomToken`) and stores the refresh token in `~/.cordelia/credentials.json`. Headless code flow later. Long-lived secrets only as **store tokens** (`cord_live_…`/`cord_test_…`, hashed) — never a long-lived account token. |
| 2 | Scopes stay tiny: `catalog:write`, `store:publish`, `orders:read`. Payment keys are console-only. |
| 3 | `externalId` on Product, Variant, Category, Brand. Upsert key = `id ?? externalId ?? name`. |
| 4 | `/import` is **dry-run by default** — returns a plan `{create, update, skipped, errors[]}`; `?commit=true` applies. Console dialog, CLI and MCP all consume the same plan. |
| 5 | Variants modelled properly (not collapsed) — **general v2 product model** below. |
| 6 | `image_url`s are fetched and **rehosted** into Storage on import (async per row, `imageStatus`). |
| 7 | Console **cutover** inside Phase 0: forms + import dialog call the routes; client write rules for catalog collections removed from `firestore.rules`. |
| 8 | Limits: 2,000 rows/request (chunked server-side into 500-doc batches), per-token rate limit. |
| 9 | New routes under `/api/v1/…`. Existing shopper routes stay unversioned. |
| 10 | Shopify mapping: `Type` → category (nested under `Product category`'s leaf when present), `Tags` offered as opt-in categories in the dry-run plan; `Vendor` → brand (auto-create); `Status != active` skipped and reported; `Option1 Name = "Title"/"Default Title"` = simple product; leading `'` stripped from barcodes; both header dialects (legacy `Variant Price`/`Image Src` and 2024+ `Price`/`Product image URL`) accepted. Sample fixtures: shopifypartners `apparel.csv`, `home-and-garden.csv`, `snowdevil.csv` (278 products / 636 variants, two-axis). |
| 11 | Flutter option pickers (dailymart/grofast) ship as Phase 0's **last** task; until then the app renders the first option axis on the existing size row. |

## General product model v2 (additive, read-time upgraded, no backfill)

Grocery-specific today: `unitValue`/`unitType` (g|ml|pcs, required), `sizeVariants[].value: number`, `prepTime`, single `imageUrl`, flat categories with `groupName`.

```
Product  + images: string[]            (imageUrl ≡ images[0], derived)
         + externalId?, sku?, barcode?
         + optionNames: string[]       ([] = simple product)
         + variants: Variant[]         ([] = simple product)
         + attributes: Record<string,string>   (spec list; never read by checkout)
           price / originalPrice / stock become DERIVED (min price, sum stock) when variants exist
Variant    id, externalId?, sku?, barcode?, options: string[], price, originalPrice,
           stock, sellWhenOutOfStock, imageUrl?
Category + parentId?, externalId?      (groupName derived for packs that render it)
Brand    + externalId?
```
Read-time upgrade: `sizeVariants` → `optionNames:["Size"]` + one variant per size (option value `"500 g"`), `unitValue/unitType` → `attributes["Pack size"]`, `prepTime` → `attributes["Prep time"]`; a doc with none = one implicit variant. Cart/order lines carry `variantId` (accept `sizeValue` during cutover); stock checks/decrements per variant. Linear pack-size price inference removed. Not modelled (recorded as deviations): weight/dims, tax class, cost, SEO, metafields, gift cards, fulfilment, Google Shopping — kept in `attributes` if present.

## Phase 0 task sequence (each task: implement → test steps → user confirms → next)

1. **Schema v2 + read-time upgrade** — `admin/src/lib/types.ts`, `products.ts` (`resolveLinePricing` → variant), `serializers.ts`, `categories.ts`, `brands.ts`; Flutter models/entities gain the new fields (optional, defaulted). Console product form: variant editor replaces the size editor; category form gains parent. Tests: `verify:*` + unit tests for the upgrade function.
2. **Checkout/cart/orders per variant** — `cart/route.ts`, `checkout-quote.ts`, `orders.ts` (stock per variant, sum on product), coupon engine, orphaned-payment path; Flutter cart/order entities carry `variantId`.
3. **Store tokens + guard** — `stores/{id}/private/tokens`, `requireStoreAccess(req, storeId, scope)` in `admin-guard.ts`, Settings → Developers tab.
4. **Catalog write routes `/api/v1`** — products/categories/brands/coupons/banners CRUD + bulk upsert; restricted-terms + variant validation server-side; rate limit.
5. **`/api/v1/stores/{id}/import`** — dry-run/commit over the moved `csv-core` + entity specs; generic v2 CSV columns; `images` rehost route.
6. **Console cutover** — forms + dialog → routes; `firestore.rules` tightened.
7. **Publish via token** — `submit` accepts `store:publish`; `readiness` alias; live payment-key validation on save.
8. **Flutter option pickers** — dailymart/grofast Product Details, attribute spec list in all three packs.

## Status (2026-08-23)

- **Phase 0** — done except task 8 (Flutter option pickers): v2 product model with per-variant stock through checkout, store tokens, v1 catalog API, CSV + Shopify import, console cutover (rules tightened), live payment-key validation, publish/readiness by token.
- **Phase 1** — live: remote MCP server at `https://cordeliaapps.com/api/mcp` with an OAuth 2.1 server in the console (verified from a claude.ai custom connector), telemetry (log lines + `apiUsage` tallies + Developers tab panel), docs category "AI assistants & API", `/llms.txt`, `/developers`. Decisions: stdio wrapper **dropped** (chat hosts are the audience); Claude Code plugin only if the repo goes public.
- **Launch-day todo (deliberately unpublished until the store is live)**:
  1. MCP Registry — DNS TXT is already on the apex (verified 2026-08-23); run the publish in `admin/mcp-registry/README.md`.
  2. Free directories: mcpmarket.com, claudemarketplaces.com, skillsclaude.org, lobehub.com/skills, glama.ai — same copy as `server.json`.
  3. Optional: Anthropic Connectors directory (needs a Team/Enterprise Claude org + review) and the official Claude Code plugin marketplace.
  4. Attach a Vercel log drain (Axiom / Better Stack free tier) if log history beyond Firestore tallies is wanted.
  5. `/api/mcp` for humans: a friendlier 401 body naming the connect guide, and a redirect to `/mcp` when the request is a browser (`Accept: text/html`, no bearer) — hosts always send `application/json, text/event-stream`, so the protocol is untouched.
  6. Release the app (`1.0.4+6` → `1.0.5+7`): per-variant cart rows and the option pickers only exist in the tree until then.

## Recommended approach (in dependency order)

### Phase 0 — Server-side catalog write API + store-scoped API tokens (the foundation)

Everything else is a thin client over this. Two pieces:

**A. Store API tokens.** New collection `stores/{id}/private/tokens` (hashed, like payment secrets are encrypted via `admin/src/lib/crypto.ts`). Token format `cord_live_<random>` / `cord_test_<random>`; stored as SHA-256 hash + prefix + label + `createdAt` + `lastUsedAt` + scopes (`catalog:write`, `store:publish`, `orders:read`). Add `requireStoreAccess(req, storeId, scope)` to `admin-guard.ts` that accepts **either** a Firebase ID token (existing owner path) **or** `Authorization: Bearer cord_…` resolved to a store. Console UI: Settings → new **Developers** tab (create / revoke, show once). Reuse the pattern `CRON_SECRET` already sets: unset/unknown token is a closed door, 401.

**B. Catalog write routes** (owner-or-token guarded), mirroring the existing public `GET`s:

| Route | Methods |
|---|---|
| `/api/stores/[storeId]/products` | `POST` (create), `PUT` (bulk upsert, the import primitive) |
| `/api/stores/[storeId]/products/[productId]` | `PATCH`, `DELETE` |
| `/api/stores/[storeId]/categories`, `/brands`, `/coupons`, `/banners` | same shape |
| `/api/stores/[storeId]/import` | `POST` multipart/JSON: `{ format, entity, rows }` → dry-run plan or commit |
| `/api/stores/[storeId]/readiness` | `GET` — today's `GET …/publish` already returns this; alias it |
| `/api/stores/[storeId]/images` | `POST` signed-upload URL or server-side fetch-and-rehost of a `https` image (closes the "CSV carries a URL nobody validates" gap) |

Implementation reuses what exists rather than re-deriving it:
- Validation/normalisation: move the pure `csv-core.ts` + `product-csv.ts`/`category-csv.ts`/`banner-csv.ts`/`coupon-csv.ts` specs to be callable server-side (they are already pure — `verify:import-csv` proves it). The browser dialog becomes a client of `/import` instead of writing Firestore itself.
- Writer: `import-rows.ts` logic (merge-on-update to protect `ratingAverage`/`reviewCount`/`usedCount`/`createdAt`, 500-row chunks) ported to `firebase-admin` batches.
- Restricted-terms check (`restricted-products.ts`) runs server-side on every write, so a token caller can't bypass the alcohol/tobacco ban.
- Publish: `POST …/publish {action: submit}` gains token acceptance (scope `store:publish`); approve/reject stay superadmin-only.
- Payments stay console-only (secrets should never transit a CLI), **but** add live key validation on save (today only the prefix is checked, so a typo passes readiness and fails at a shopper's first payment).

Also: `firestore.rules` can drop client write access to catalog collections once the console has moved to the routes — one write path, one validator.

### Phase 1 — MCP server (`@cordelia/mcp`) — the "AI agent" channel, BYO model

Small Node package (stdio + streamable-HTTP) exposing tools over Phase 0: `list_stores`, `get_readiness`, `import_catalog(format, file|rows, dryRun)`, `upsert_products`, `upsert_categories`, `upload_image`, `submit_for_review`, `get_orders`. Auth = store token from env. A developer adds it to Claude Code / Cursor / ChatGPT and says "here's my Shopify export, get this store ready to publish" — the agent runs dry-run → fix → commit → readiness → submit. This *is* the conversational path the user described, without us hosting a chat product. Ship with a `SKILL.md`/prompt describing the import contract (columns, `|`-separated categories, categories-and-brands-must-exist rule → agent creates them first).

### Phase 2 — CLI (`npx cordelia`) — same client, human ergonomics

Shares one `@cordelia/sdk` (typed fetch client generated from the route table) with the MCP server. Commands: `login` (device-code flow against Firebase, or paste a store token), `stores list/use`, `import <format> <file> [--dry-run]`, `products|categories|brands|coupons|banners list/upsert`, `images push <dir>`, `readiness`, `publish` (= submit), `orders list`. Non-interactive by design (`--json`, exit codes) so CI and agents can drive it. Vercel/Firebase-style `cordelia link` writes `.cordelia/project.json` with the store id.

### Phase 3 — Platform import presets (the merchant channel)

Format adapters are pure row mappers on top of the `import` route — each is ~1 file under `admin/src/lib/import/formats/`:
- **Shopify** `products_export.csv` (Handle/Title/Body (HTML)/Vendor/Product Category/Type/Tags/Variant Price/Compare At Price/Variant Inventory Qty/Image Src/Status). Variant rows share a Handle → collapse to one product (schema has no variants; record the deviation; Tags→categories, Vendor→brand, auto-create both).
- **WooCommerce** product export CSV (ID/Type/SKU/Name/Regular price/Sale price/Stock/Categories/Images/Brands).
- **WhatsApp Business catalog / Meta Commerce** CSV (id, title, description, availability, price "123.00 INR", link, image_link, brand).
- **Generic / ERP**: interactive column mapping saved as a named preset per store (`stores/{id}/private/importPresets`), so a supermarket's weekly warehouse dump imports with one command.
- Brands get a CSV importer (they are the only entity without one).
- Console: Import dialog gains a "Source" picker; CLI/MCP take `--format shopify`.

### Deferred (explicitly not now)
- Hosted in-console chat agent (needs our LLM spend, billing, abuse controls). Revisit once MCP usage shows the prompts merchants actually send.
- Live Shopify/Woo API sync (OAuth apps) — CSV covers the one-time migration that converts; sync is a retention feature.
- Reservations, variants schema — unrelated.

## Critical files
- `admin/src/lib/api/admin-guard.ts` — add token path + scopes
- `admin/src/lib/crypto.ts` — reuse for token hashing pattern
- `admin/src/lib/import/{csv-core,product-csv,category-csv,banner-csv,coupon-csv,import-rows}.ts` — become the server validator/writer
- `admin/src/components/import-csv-dialog.tsx` — switch to calling `/import`
- `admin/src/app/api/stores/[storeId]/publish/route.ts`, `store-readiness.ts` — token-aware submit
- `admin/src/lib/restricted-products.ts` — enforce on server writes
- `admin/src/app/dashboard/settings/page.tsx` — Developers tab
- `firestore.rules` — tighten catalog writes after cutover
- New: `admin/src/app/api/stores/[storeId]/{import,images,tokens}/…`, `packages-js/{sdk,mcp,cli}` (or `admin/packages/…`), `admin/src/lib/import/formats/*`
- Docs: `docs/how-to/publish-store-programmatically.md`, update `superapp-ecommerce-plan.md` (target-seller decision + open items 7/8 closed), `admin` landing/pricing copy ("Import from Shopify/WooCommerce", "CLI + MCP")

## Verification
- `npm run verify:import-csv` extended with Shopify/Woo/WhatsApp fixture CSVs → expected plans (new/updated/errors).
- Route tests with `firebase-admin` against the emulator: token 401/403/scope, restricted-term refusal, merge-protect of rating fields, >500 rows chunking, dry-run writes nothing.
- End-to-end: create a store in the console → `cordelia login` → `cordelia import shopify fixtures/shopify.csv` → `cordelia readiness` shows only `payments` failing → connect keys in console → `cordelia publish` → store appears in superadmin review queue → approve → visible in the Flutter app across all three templates.
- MCP: run the server in Claude Code with a test-store token; prompt "import this Shopify export and submit the store"; confirm the same end state.
