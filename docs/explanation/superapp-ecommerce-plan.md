# Super App Ecommerce (FlutterAgenticEcommerce) — Platform Plan

> Status: **M1a done; catalog CRUD, read API, and gravia catalog wiring done;
> cart/order-creation/admin-order-management APIs done but not yet
> deployed** (last updated 2026-07-18). Turns the `gravia` exemplar into a
> multi-tenant "app of apps" ecommerce platform. See also
> `docs/explanation/end-goal.md`.

## Context

Today `gravia` is a polished but fully **mocked, single-store** Flutter ecommerce app:
data comes from bundled JSON assets, there is no auth, no Firebase, no `storeId`
anywhere, the cart is in-memory, checkout is a `comingSoon` stub, and orders are
read from static JSON (never created).

The goal is to turn it into **FlutterAgenticEcommerce — an "app of apps"**:
one shipped Flutter app that boots to a **store discovery/search** screen, lets a
user open any store's storefront in-place (store-scoped catalog + per-store
branding), with **platform-owned users** (Firebase Auth), **per-store products/
categories/orders** in Firestore, and a **web Admin console** where store owners
upload inventory (JSON/Excel), manage prices/discounts, link categories↔products,
add products+images, and manage orders.

## Decisions locked in (2026-07-18)

- **Monetization = SaaS**, not marketplace. Each store connects its **own** payment
  provider; the platform **never touches shopper money**. Revenue = store owners pay
  a **subscription** to host their store app + get the admin panel. This drops all
  marketplace complexity (no Stripe Connect payouts, KYC, commission splits, tax).
- **Shopper PSP = provider-agnostic for now** ("decide later"). Design the checkout →
  order-write boundary so a real PSP drops in behind a `PaymentService` interface;
  the store's chosen provider is configured per-store later.
- **Admin panel is a standalone Next.js app at top-level `admin/`** — *revised* from
  the original "inside web-terminal/console" idea. `web-terminal/console` is **per-user
  cloud workspace infra** (its PTY bridge + preview iframe get provisioned on a
  per-session GCE spot VM — see `docs/explanation/cloud-workspace-plan.md`), not a
  persistent multi-tenant surface. Store admins all need to log into **one shared,
  centrally-hosted** app, so it can't live inside per-user workspace infra. `admin/`
  sits alongside `apps/`, `packages/`, `web-terminal/` at repo root; it also hosts the
  Cloud Functions (the "Node BE") since they share one Firebase project.
- **Store-owner subscription billing** (how the platform gets paid) is its own later
  phase — it lives on the console/admin side (e.g. Stripe Billing for the store owner),
  separate from shopper checkout. Not in the first milestones.

## Backend recommendation (answers "our nodejs BE?")

**Go Firebase-native. Do NOT stand up a separate always-on Node API server.**
The existing "Node BE" (`web-terminal/server`) is just the terminal PTY bridge —
different purpose, not reusable here. Firebase collapses the whole stack into one console:

- **Firebase Auth** (email/password) = the "users owned by FlutterAgentic" model, free.
- **Cloud Firestore** = multi-tenant catalog/orders; document model fits store→products.
- **Cloud Storage** = product images (admin upload).
- **Cloud Functions (this IS the Node/TypeScript BE)** — reserve server-trust for only
  what must be trusted: PSP webhook, Excel/JSON bulk import, **server-side order write
  with price/stock validation**, custom-claim role assignment. Never trust the client
  for price or order totals.
- **Security Rules** = tenant isolation (shopper reads any catalog, writes only own
  cart/orders; store admin writes only its own store).

> Fork worth knowing: **Supabase (Postgres + RLS)** if SQL is preferred — the
> category↔product link is inherently relational. But Firestore is already the stated
> direction and the `connect-firebase` skill exists, so this plan assumes Firebase.

## Firestore data model (multi-tenant)

```
users/{uid}         shopper profile — name, email, phone, avatarUrl, createdAt
                    (every Firebase Auth account gets one; a store owner is also a user)
admins/{uid}        store-owner record — { storeIds: [], role } ; presence here + a
                    custom claim (role=storeAdmin) gates admin-console + store writes
stores/{storeId}    name, logoUrl, description, ownerUid, status, themeConfig
                    (drives AppTheme.fromConfig!), searchKeywords[], createdAt
stores/{storeId}/categories/{catId}  { name, imageUrl }
stores/{storeId}/products/{prodId}   ProductEntity fields + categoryIds[] + stock
users/{uid}/carts/{storeId}          persisted per-store cart (a user shops many stores)
orders/{orderId}                     { uid, storeId, items[], status, total, paymentRef, otp, placedAt }
```

- **Roles**: one Firebase Auth pool. A plain shopper has only `users/{uid}`. A store
  owner also has `admins/{uid}` + a custom claim `role: storeAdmin` (set by a Cloud
  Function) — the claim is what security rules trust for store writes; `admins.storeIds`
  lists the stores they manage (one owner → many stores).
- **category↔product link** = `categoryIds: []` array on each product (Firestore
  `array-contains` queries); the admin "connect categories and products" edits this array.
- No `payments/` collection in the SaaS model — the platform never records a shopper
  charge; the order carries only the store-PSP reference the store's own provider returns.

## Key gravia refactor: inject an "active store" context

The single biggest app change. Introduce an **active-store context** (storeId +
that store's `themeConfig`). Every existing data source stops reading `rootBundle`
JSON and instead queries Firestore **scoped by the active storeId**. The existing
screens (home grid, categories, product details, cart) render for whichever store is
active. Per-store re-skin reuses the existing `AppTheme.fromConfig` — a store's
branding JSON in Firestore drives the theme.

New `feature/discovery/` (store search/browse) becomes the app's first screen;
`feature/shell/` becomes the per-store storefront shell once a store is opened.

## Missing flows (fill these or explicitly defer)

1. **Store onboarding** — how a creator signs up, creates a store, becomes its admin (roles/claims).
2. **Auth depth** — password reset, email verification, session persistence, shopper-vs-admin roles.
3. **Persistent cart** — today in-memory; must persist per-user-per-store and merge on login.
4. **Checkout + payment** — biggest gap; real PSP, server-side order write, failure/refund states.
5. **Order lifecycle + admin order management** — who advances pending→…→delivered; OTP verify; cancel/refund.
6. **Inventory/stock** — no stock field today; decrement in a transaction to avoid oversell; out-of-stock UI.
7. **Image hosting** — Cloud Storage upload vs. image URLs in the Excel import.
8. **Import validation** — schema/column mapping, dedupe, upsert-vs-replace, error reporting.
9. **Search** — across-stores + within-store; Firestore text search is weak (searchKeywords[] for MVP, Algolia/Typesense later).
10. **Security rules** — multi-tenant isolation is critical and easy to get wrong.
11. ~~Marketplace settlement~~ — **dropped** under the SaaS decision (platform never collects shopper money). Replaced by **store-owner subscription billing** as a separate later console-side track.
12. **Delivery/serviceability** — addresses exist per-user; delivery fee, per-store serviceability.
13. **Order notifications** — reuse the existing FCM notification feature/skill.

## Milestone 1 — start here (Auth + core tables)

**Two login surfaces, one shared Firebase Auth project** — this is the key structure:

| Surface | Who | Where | SDK |
|---|---|---|---|
| **Admin / store-owner login** | store owners | top-level `admin/` (Next.js, standalone) | Firebase JS SDK |
| **Shopper login** | end customers | gravia Flutter app (`feature/auth/`) | `firebase_auth` |

Same Firebase project, same `users`/`admins`/`stores` collections, same
`firestore.rules`. **Build the admin side first** — a store owner must create a store
+ inventory before a shopper has anything to browse.

**M1a — Admin login + tenancy tables — DONE (2026-07-18):**
1. ✅ Scaffolded standalone `admin/` Next.js app at repo root (Next 16 / React 19 /
   Tailwind v4, matching `web-terminal/console`'s stack) with `firebase` JS SDK installed.
   Firebase project: **`corderlia-ecom`** (already existed — Android/iOS apps + Firestore
   native DB were pre-provisioned; a dedicated **Web app** `ecom-admin` was registered
   for this app). Config lives in `admin/.env.local` (gitignored; `.env.local.example`
   committed as the template). Email/Password sign-in was already enabled on the project.
2. ✅ **Store-owner email/password sign-up + login + sign-out** — `src/lib/auth-context.tsx`
   (`AuthProvider`/`useAuth`), pages at `/login`, `/signup`, `/dashboard` (protected,
   redirects unauthenticated → `/login`). Sign-up creates `admins/{uid}` client-side
   (`{ email, storeIds: [], role: 'storeAdmin', createdAt }`).
3. ⬜ **Not yet built** — Cloud Function to stamp the custom claim `role: storeAdmin`
   when `admins/{uid}` is created. Rules currently trust `stores.ownerUid` directly
   instead (see below); tighten to the claim once the function ships.
4. ✅ **`firestore.rules` deployed** to `corderlia-ecom` (repo root `firestore.rules` +
   `firebase.json` + `firestore.indexes.json`) — `admins/{uid}`: owner-only read/create,
   no client update/delete; `stores/{storeId}`: world-readable, create/update/delete only
   by `ownerUid`; `stores/*/categories`, `stores/*/products`: world-readable, store-owner
   write; `users/{uid}` + `users/{uid}/carts/{storeId}`: owner-only; `orders/{orderId}`:
   shopper creates/reads own, store owner reads/updates own. **Verified live** against the
   deployed rules via direct Identity Toolkit + Firestore REST calls (not just `tsc`): a
   real sign-up succeeded, the resulting user could write its own `admins/{uid}` (200),
   and was rejected (403) writing another uid's `admins` doc. Test user + doc cleaned up.

**Store creation + Categories/Products CRUD — DONE (2026-07-18, pulled forward from M5):**
Rather than leaving the dashboard a placeholder, built the actual catalog-management
surface store owners need — this closes the "still missing" gap above and completes a
chunk of M5 early:
- **shadcn/ui** initialized in `admin/` (matching `web-terminal/console`'s `radix`/`nova`
  preset) — `Table`, `Dialog`, `AlertDialog`, `Select`, `Checkbox`, `Card`, `Badge`,
  `sonner` toasts.
- **`src/lib/store-context.tsx`** (`StoreProvider`/`useStore`) — reads `admins/{uid}`
  reactively (`onSnapshot`), exposes the first `storeId` (MVP is single-store-per-owner;
  a switcher for `storeIds.length > 1` is later), and `createStore(name)`.
- **`src/app/dashboard/layout.tsx`** — now the real auth + store gate for all
  `/dashboard/*` routes: redirects unauthenticated → `/login`; if the owner has no
  store yet, shows a "Create your store" form instead of the sidebar; once a store
  exists, renders the sidebar (Overview / Categories / Products) + sign-out.
- **`src/lib/types.ts`** — `Category`/`Product` field names deliberately mirror
  `CategoryEntity`/`ProductEntity` in `apps/ecommerce/gravia` (including `unitType`
  using gravia's wire values `'g'|'ml'|'pcs'` so `ProductUnitTypeParse` can parse them
  directly) — this is the schema gravia's Firestore data source will read in M2.
  `discountPercentage` is **derived**, not admin-entered (`computeDiscountPercentage`
  in `src/lib/products.ts`), so it can never disagree with price/originalPrice.
- **`src/app/dashboard/categories/page.tsx`** — list/add/edit/delete
  `stores/{storeId}/categories/{catId}` (name, imageUrl).
- **`src/app/dashboard/products/page.tsx`** — list/add/edit/delete
  `stores/{storeId}/products/{prodId}` with a `categoryIds[]` checkbox multi-select
  against the store's existing categories (the actual category↔product link).
- **Rules fix required and deployed**: `createStore()` needs to `updateDoc` its own
  `admins/{uid}.storeIds` (`arrayUnion`), but the originally deployed rule had
  `allow update, delete: if false` on `admins/*`. Tightened instead of opened wide —
  the owner may now update **only** the `storeIds` field
  (`request.resource.data.diff(resource.data).affectedKeys().hasOnly(['storeIds'])`);
  `role`/`email` stay immutable client-side. Redeployed.
- **Verified live end-to-end**, not just compiled: a node script using the real
  `firebase/auth` + `firebase/firestore` client SDKs (same code path the browser runs)
  signed up → created `admins/{uid}` → created a store + linked it via `arrayUnion` →
  added a category → added a product with `categoryIds` referencing it → read both
  back world-readable (simulating an unauthenticated shopper) → deleted everything.
  Every step succeeded against the real deployed rules. (One instructive failure: the
  script's own cleanup couldn't `deleteDoc` the `admins/{uid}` doc — caught by the
  `allow delete: if false` rule exactly as intended; cleaned that one up via an
  IAM-authenticated call instead, same as the rules-negative-test pattern used earlier.)
- Also fixed an `eslint-plugin-react-hooks` `set-state-in-effect` violation in
  `store-context.tsx` by using React's documented "adjust state during render" pattern
  (comparing `uid` to a `lastUid` state) instead of resetting state synchronously
  inside the subscription effects.
- **Not yet built**: bulk Excel/JSON import; multi-store switcher UI.

**Cloud Storage image upload — DONE (2026-07-18):**
Add Category / Add Product forms now have a real "Upload from device" option
alongside the manual image-URL field.
- **`admin/src/lib/storage.ts`** — `uploadCatalogImage(storeId, kind, file)` writes to
  `{storeId}/categories/{uuid}.{ext}` or `{storeId}/products/{uuid}.{ext}` and returns
  the download URL.
- **`admin/src/components/image-upload-field.tsx`** — reusable field (thumbnail preview
  + URL input + file picker) used by both the category and product dialogs.
- **`storage.rules`** (repo root, new) deployed to the `corderlia-ecom.appspot.com`
  bucket — world-readable, write restricted to `isStoreOwner(storeId)` via a
  cross-service `firestore.get(/databases/(default)/documents/stores/$(storeId))`
  check, mirroring `firestore.rules`' ownerUid model exactly.
- **Checked before touching rules**: this bucket already holds pre-staged demo images
  gravia's mock JSON references (`gravia/categories/fresh.png` etc., via
  `firebasestorage.googleapis.com/v0/b/.../o/...?alt=media&token=...` URLs). Confirmed
  those download-token URLs bypass Security Rules entirely (Firebase's documented
  "shareable link" behavior) — tightening `allow read`/`write` on new paths does not
  affect them. Verified with a direct fetch before and after deploying (200 both times).
- **Real bug hit and fixed**: `firestore.get()` cross-service calls from Storage rules
  need the Storage service account to hold `roles/firebaserules.firestoreServiceAgent`
  on the project. `firebase deploy` normally prompts to grant this automatically on
  first deploy — that prompt is skipped in a non-interactive shell, so every write was
  silently rejected (`storage/unauthorized`) even for the correct store owner. Diagnosed
  by first deploying a plain `request.auth != null` rule (succeeded, proving the token
  was fine) to isolate the cross-service check as the culprit, then granted the role
  manually: `gcloud projects add-iam-policy-binding corderlia-ecom --member="serviceAccount:service-905460690574@gcp-sa-firebasestorage.iam.gserviceaccount.com" --role="roles/firebaserules.firestoreServiceAgent"`. Needed ~90s to propagate.
- **Verified live end-to-end** with the real `firebase/storage` client SDK (not just
  compiled): owner A signs up, creates a store, uploads a category image and a product
  image to `{storeId}/categories/**` and `{storeId}/products/**` — both succeed; the
  resulting download URL is publicly fetchable (200) with no auth; a second owner (B)
  attempting to write into A's store path is rejected (`storage/unauthorized`). All
  test data cleaned up afterward via IAM-authenticated calls (same pattern as the
  Firestore rules tests — Storage/Firestore security rules don't apply to
  IAM-authenticated requests, only to Firebase Auth-token requests).
- **Reference for future work**: if any *other* Storage bucket in this project
  (`corderlia-ecom`, `corderlia-ecom-svg`) ever needs rules deployed, grant the same
  IAM role for that bucket's writes if they also use `firestore.get()`/`firestore.exists()`.

**Gravia mock catalog imported into the real "Gravia" store — DONE (2026-07-18):**
The user had already created a real store (`stores/4116e313-a173-4f9f-b471-8bc92ab8437d`,
name "Gravia") via the admin UI. Imported gravia's bundled mock catalog into it as real
Firestore data — the first real content in the multi-tenant model, not test data.
- **Source**: `apps/ecommerce/gravia/assets/data/categories_page.json` (canonical
  16 categories, 2 groups: Snacks & Drinks, Grocery & Kitchen) and
  `product_details.json` (7 unique products — apple, grapes, tomato, cabbage, potato,
  capsicum, lady finger — reused for its richer per-product `description` field; the
  same 7 products are duplicated across every other mock JSON file for demo purposes).
  Image URLs reused as-is (gravia's existing `firebasestorage.googleapis.com` hosted
  images) rather than re-uploaded.
- **Confirmed gravia's mock data has no real category↔product relationships** —
  `category_details.json` is a single generic `"default"` product list shown for
  every category in the mock UI, not category-specific data. Per user direction, all
  7 products were linked to **Fresh**, with Apple and Grapes additionally linked to
  **Fruits** (multi-category via `categoryIds[]`) — a content decision, not derived
  from source data, flagged as such rather than presented as authoritative.
  `stock` (not present in the mock data at all) defaulted to `100` for all 7,
  editable in the Products page.
- **Written via the Firebase Admin path** (gcloud IAM-authenticated REST calls, same
  mechanism used for the earlier test cleanups) rather than signing in as the real
  store owner, since only the user holds those credentials — Firestore Security Rules
  govern Firebase Auth-token client requests only, not IAM-authenticated ones, so this
  is the correct tool for a one-off backend data load, not a rules bypass concern.
  One-off script, not part of the app: `import-gravia-catalog.mjs` (scratchpad, not
  committed) — a real repeatable **bulk import feature in the admin UI** (Excel/JSON
  upload, per the original spec) is still the "not yet built" item.
- Left the user's own pre-existing test category (name "gfgfgf", created while trying
  the UI themselves) untouched rather than deleting it unprompted.

**Known gap — no self-heal for a missing `admins/{uid}` doc.** `signUp()`
(`admin/src/lib/auth-context.tsx`) creates the Firebase Auth account, then writes
`admins/{uid}`, as two separate steps. `signIn()` never touches Firestore at all — a
returning user's login only re-authenticates, it does not re-check or recreate their
`admins/{uid}` doc. If the `setDoc` call fails right after account creation (network
blip, etc.), the user ends up with a valid Auth account but **no** `admins/{uid}`
doc — `/dashboard` still lets them in (it only gates on Auth state), but they'd have
no `storeIds` and nothing else in Firestore would recognize them as a store owner.
**Backlog for a later milestone**: add a self-heal check (e.g. on dashboard load,
create the doc if missing) rather than trusting the signup write to always succeed.

**M1b — Shopper login + profile (in gravia):**
5. **`connect-firebase` for gravia** — add `firebase_core` + `firebase_auth` +
   `cloud_firestore`, `firebase_options.dart`; guard `Firebase.initializeApp` per the
   web-boot rule.
6. **`feature/auth/`** (Clean Architecture, per `add-feature-template`): email/password
   sign-up + login + sign-out, `AuthRepository` over a `FirebaseAuthService` (core static
   singleton, like `HttpService`), BLoC auth state, GoRouter redirect (unauth → login).
   On sign-up create `users/{uid}`.
7. **`FirestoreService`** (core static singleton) with model↔entity pairs for
   `users`/`stores` reads the app needs.

Proves both front doors + the users/admins/stores tables end-to-end before any
storefront refactor. Everything below builds on it.

## Phased timeline after Milestone 1 (solo + Claude premium)

- **M1. Auth (both surfaces) + users/admins/stores tables + rules (START HERE, ~1 wk)** —
  M1a admin login in web-terminal + M1b shopper login in gravia, as above.
- **M2. Active-store context + swap catalog JSON→Firestore (1–1.5 wk)** — inject
  storeId into the data layer; home/categories/product-details read the active store's
  Firestore catalog; per-store theme via `AppTheme.fromConfig`.
- **M3. Store discovery landing + persistent cart (1 wk)** — new `feature/discovery/`
  first screen (search/list stores); cart persists per-user-per-store + merges on login.
- **M4. Checkout + order creation, provider-agnostic (1–1.5 wk)** — `PaymentService`
  interface (real PSP later), Cloud Function writes `orders/{id}` with server-side
  price/stock validation + stock-decrement transaction; order lifecycle states.
- **M5. Admin section in web-terminal/console (2–2.5 wk)** — Firebase Auth (storeAdmin
  role) gate; product/category CRUD + Cloud Storage image upload; **Excel/JSON import**
  (SheetJS parse + schema validation + upsert); price/discount edit; category↔product
  linking; order-management view.
- **M6. Store onboarding + search + notifications + polish (1 wk)** — create-store flow,
  claim assignment UX, `searchKeywords[]` (Algolia/Typesense later), reuse the existing
  FCM feature for order-status notifications, rule hardening.

**Realistic MVP: ~7–9 weeks solo** (SaaS trims the marketplace payout work). Store-owner
**subscription billing** (how the platform charges stores) is a separate later track on
the console side.

## Verification

- **M1a**: a store owner signs up in the web-terminal console → `admins/{uid}` doc appears,
  Cloud Function stamps the `storeAdmin` claim, they create a `stores/{storeId}` doc;
  rules unit test proves a plain user cannot write `stores/*`.
- **M1b**: sign up as a shopper on gravia web (`flutter run -d web-server`) → `users/{uid}`
  doc appears, GoRouter redirects unauthenticated users to login.
- **M2/M3**: discovery lists the seeded store; opening it loads its Firestore catalog and
  re-skins to its theme; cart survives reload.
- **M4**: a test checkout writes `orders/{id}` with correct `uid`+`storeId` and decrements stock.
- **M5**: import a sample Excel in the console → products land in Firestore → show live in the app.

## Admin deployed to Vercel — DONE (2026-07-18)

`admin/` is live at **https://admin-beryl-kappa-44.vercel.app** (Vercel project
`cordelia1/admin`, linked via `admin/.vercel/project.json`, gitignored). Gravia
(or any client) can now reach the read API over a real HTTPS URL instead of
localhost.

- All 7 `NEXT_PUBLIC_FIREBASE_*` values set in Vercel across
  production/preview/development (`vercel env add`, one call per var per
  environment — this CLI version doesn't accept multiple environments in one
  call despite some docs suggesting otherwise). These are Firebase's public web
  SDK config, not secrets — safe in a client bundle; security is enforced by
  `firestore.rules`/`storage.rules`, not by hiding this config.
- **Two real gaps caught and fixed post-deploy, not assumed fine:**
  - Firebase Auth's `authorizedDomains` didn't include the new Vercel domain —
    login/signup would have failed for real users hitting the deployed site
    even though local `localhost` testing worked. Added
    `admin-beryl-kappa-44.vercel.app` via the Identity Toolkit Admin API.
  - Checked the web API key for HTTP referrer restrictions (a separate
    mechanism from authorizedDomains that could also block a new origin) —
    confirmed `browserKeyRestrictions: {}` (none set), so nothing else blocks
    the new domain.
- **Verified live against production**, not just "deployment READY": curled the
  deployed `/login` page (200) and the categories/popular-products API routes
  against the real Firestore data — identical results to local testing (8+8+1
  grouped categories, 7 popular products).
- Deployment target chosen: Vercel (not Firebase App Hosting) — zero-config for
  a stock Next.js app with API routes; the tradeoff (a second hosting vendor
  alongside Firebase) was surfaced to the user before choosing.

## Read API for storefront frontends — DONE (2026-07-18, pulled forward from M2)

Per user direction, built as **Next.js API routes in `admin/`**, not a Flutter-side
Firestore data-source swap — the Flutter app (gravia) was explicitly left untouched
this pass. Routes under `admin/src/app/api/stores/[storeId]/`:

| Route | Response shape |
|---|---|
| `GET /categories` | `{ groups: [{ name, categories: [{id,name,image}] }] }` |
| `GET /products` | `{ products: [...] }` — full catalog |
| `GET /products/popular` | `{ popular_products: [...] }` — filtered on `isPopular` |
| `GET /categories/{categoryId}/products` | `{ products: [...] }` — `categoryIds array-contains` |
| `GET /products/{productId}` | `{ product, images, description, size_options, similar_products }` |
| `GET /search?q=` | with `q`: `{ products: [...] }` name-match; without: `{ recent_searches: [], popular_products: [...] }` |

- **Response JSON deliberately mirrors gravia's existing wire format** (`admin/src/lib/api/serializers.ts`)
  — snake_case (`original_price`, `discount_percentage`, `unit_value`, `unit_type`,
  `prep_time`, `is_favourite`), `image` not `imageUrl`, `popular_products`/`groups` keys
  — matching `*Model.fromJson()` in gravia's `data/models/` exactly. The intent: when
  gravia is eventually pointed at this API, it's a data-source-impl swap, not a model
  rewrite. `is_favourite` is always `false` (per-shopper state, not catalog data — no
  favorites model exists yet).
- **Two real schema gaps fixed to make this API correct, not fake:**
  - **`groupName` added to `Category`** — gravia's `CategoryGroupEntity` expects
    categories under named sections ("Snacks & Drinks", "Grocery & Kitchen"); the
    original import had flattened this away. Added the field, a group input (with a
    `<datalist>` of existing group names) to the admin category form, a "Group" column
    in the table, and backfilled the 16 already-imported categories with their correct
    group from the original import mapping.
  - **`isPopular` added to `Product`** — without a real curation flag, "popular
    products" would have had to fake it by returning the whole catalog. Added a
    checkbox to the product form, a "Popular" badge in the table, and backfilled all 7
    imported products to `true` (they were gravia's original `popular_products` list).
- **One-shot fetch layer added alongside the existing live-listener functions** —
  `src/lib/categories.ts`/`products.ts` had only `watchCategories`/`watchProducts`
  (`onSnapshot`, for the dashboard's reactive UI). API routes need one-time reads, so
  added `getCategories`, `getProducts`, `getPopularProducts`, `getProductsByCategory`,
  `getProduct` (`getDocs`/`getDoc`), sharing the same doc→type mapping functions as the
  watchers so there's one field-mapping source of truth, not two.
- **No auth needed for these routes** — every path they read
  (`stores/{id}/categories`, `stores/{id}/products`) is `allow read: if true` in
  `firestore.rules` already; the routes just use the existing client SDK
  (`src/lib/firebase.ts`) server-side rather than standing up `firebase-admin` (which
  would've needed service-account credentials/ADC that aren't configured in this
  environment).
- **Verified live against the real "Gravia" store data**, not just compiled: booted the
  dev server and curled every route — categories grouped correctly (8 + 8 + the user's
  own leftover test category falling into "Uncategorized"), all 7 products returned,
  all 7 popular, Fresh category returns all 7, Fruits returns exactly Apple + Grapes,
  product detail for the apple returns correct `similar_products` (other Fresh-category
  products), search `q=apple` matches only the apple, empty search returns the
  SearchEntity-shaped initial state, a nonexistent product ID returns a clean 404
  instead of crashing.
- **Not yet built**: no store-discovery/multi-store routing in these APIs (storeId is
  a path param the caller must already know — matches the single-store MVP scope
  elsewhere in this doc); no write endpoints (all read-only, writes still go through
  the admin dashboard's Firestore calls).

## Gravia wired to the deployed API (M2 catalog swap) — DONE (2026-07-18)

gravia's 5 catalog data sources now call the deployed Vercel API instead of bundled
JSON assets — `HomeRemoteDataSourceImpl`, `CategoriesRemoteDataSourceImpl`,
`CategoryDetailsRemoteDataSourceImpl`, `ProductDetailsRemoteDataSourceImpl`,
`SearchRemoteDataSourceImpl` all swapped from `rootBundle.loadString` +
`jsonDecode` to `HttpService.instance.get<Map>(...)` + `Model.fromJson(...)`. Orders,
profile, address, notifications intentionally untouched (out of scope).

- **New `lib/constants/api_constants.dart`** — `baseUrl` (the Vercel URL) + a
  **hardcoded `storeId`** constant (the one seeded "Gravia" store) with a comment
  pointing at this doc's store-discovery gap. This is the multi-tenant seam: M3
  replaces the constant with real store selection, nothing else in the data layer
  needs to change.
- **4 of 5 data sources are 1:1 swaps** — `getCategories()`, `getCategoryDetails(id)`,
  `getProductDetails(id)`, `getSearch()` each call exactly one endpoint and
  `Model.fromJson(response.data!)` directly, because the API's response shapes were
  deliberately built to match these models' existing wire format (see the "Read API"
  section above) — confirmed by reading every model's `fromJson` field mapping before
  writing a line of Flutter code, not assumed.
- **Home is the one real exception, per explicit user direction** — no dedicated
  `/home` endpoint. `HomeRemoteDataSourceImpl` calls `/categories` and
  `/products/popular` in parallel (`Future.wait`), flattens the grouped categories
  response into one list client-side, and constructs `HomeModel` directly (not via
  `fromJson`, since no single response matches its combined shape).
- **Two real platform gaps caught and fixed, not assumed fine:**
  - gravia's Android manifest had no `INTERNET` permission — never needed it before
    (100% local JSON until now). Added to `android/app/src/main/AndroidManifest.xml`.
    iOS needs no equivalent entry (plain HTTPS is allowed under App Transport
    Security by default).
  - The deployed API had no CORS headers — fine for curl/native mobile (not
    CORS-restricted) but would silently fail from Flutter Web's browser-based fetch.
    Learned Next.js 16 **renamed `middleware.ts` to `proxy.ts`** (confirmed by reading
    the bundled docs, not assumed from training data) — added `admin/src/proxy.ts`
    with a wildcard `Access-Control-Allow-Origin` (safe here: every route is an
    unauthenticated, world-readable catalog read, not a cookie-authenticated one),
    verified locally, then redeployed to production and reverified.
- **Verified live in a real browser, not just `flutter analyze`** — no browser
  automation was available this session, so verification used `flutter run -d chrome`
  (Flutter's own tooling drives a real Chrome instance directly; `-d web-server`
  alone doesn't execute the app without something loading the page) and watched the
  console. Home's BLoC auto-dispatched on load and the log showed real
  `[REQ] GET .../categories`, `[REQ] GET .../products/popular`, both
  `[RES] 200`, with no exception afterward — confirming the CORS fix works from an
  actual browser and the JSON parsed cleanly into `HomeModel`.
- **Not yet built**: the other 4 screens (Categories, Category Details, Product
  Details, Search) weren't individually click-verified in-browser this pass (no UI
  interaction available) — confidence there comes from `flutter analyze` passing
  clean, the identical verified `HttpService`/`fromJson` pattern, and each endpoint
  already being independently curl-verified against real data earlier.

## Cart, order creation, and admin order-management APIs — DONE (2026-07-18, pulled forward from M4/M5)

Per user direction, admin-side only this pass — gravia intentionally left
untouched, same scoping as the read API above. Adds the write surface the
read-only catalog API didn't cover: a persisted per-store cart, real order
creation, and store-owner order management.

**The identity/trust question, resolved for now:** gravia has no shopper auth
yet (M1b, still not built), so there's no ID token these routes can verify for
a shopper. Two ways through were weighed — relax `firestore.rules` for
`users/{uid}/carts/{storeId}` and `orders/{orderId}` and enforce everything in
route code, vs. stand up `firebase-admin` so writes bypass Security Rules
entirely (the architecturally-correct end state the "Backend recommendation"
section above already calls for). **Chose `firebase-admin`** — rules stay
untouched/tight, and it lets the *store-owner* endpoints get a real
cryptographic guard today (the admin console already has real Firebase Auth),
even though the *shopper* endpoints still can't be verified until M1b ships.
That split is deliberate, not an oversight:

- **Shopper-facing** (cart read/write, create order, own order history):
  accept a plain `userId` string, trusted as-is — the same gap M1b is already
  scoped to close. Once gravia sends a verified ID token, `userId` swaps from
  "read off the request" to "read off the verified token," no route signature
  change.
- **Store-owner-facing** (list all orders for a store, change order status):
  real guard — `src/lib/api/admin-guard.ts`'s `requireStoreOwner()` verifies
  the bearer token is a genuine Firebase ID token via `adminAuth.verifyIdToken()`
  (cryptographic, not guessable — and local signature checking, so no network
  cost per call), then checks the requested `storeId` against the token's
  `storeIds` **custom claim**. The claim is stamped server-side by
  `POST /api/stores` (store creation moved off the client for exactly this
  reason — a client can't grant itself a claim, and firestore.rules no longer
  lets it write `admins/{uid}.storeIds` either, which previously would have
  let any signed-in admin claim another store's id). Zero Firestore reads per
  guarded request; legacy admins without the claim fall back to one
  `admins/{uid}` read and get the claim backfilled. The status-update route
  fetches the order **before** checking ownership and 404s (not 403s) on a
  storeId mismatch, so a store owner probing another store's order IDs can't
  tell "wrong store" from "doesn't exist."

**New `admin/src/lib/`:**
- `firebase-admin.ts` — Admin SDK singleton (service account credentials via
  `FIREBASE_ADMIN_PROJECT_ID`/`FIREBASE_ADMIN_CLIENT_EMAIL`/`FIREBASE_ADMIN_PRIVATE_KEY`
  env vars, `admin/.env.local` locally, gitignored). **Real bug hit and fixed**:
  the Admin SDK's default Firestore transport is gRPC, which hung for 45–75s
  before failing with `Name resolution failed for target dns:firestore.googleapis.com:443`
  in this environment — a known flaky spot for `firebase-admin` in
  serverless/sandboxed runtimes generally, Vercel included, not unique to this
  session. Fixed with `adminDb.settings({ preferRest: true })`, forcing plain
  HTTPS — the same transport family the existing client SDK (`firebase.ts`)
  already uses successfully.
- `cart.ts` — `getCartItems`/`saveCartItems` against `users/{uid}/carts/{storeId}`,
  whole-doc replace (matches gravia's `CartCubit`, which always holds a full
  snapshot, never a diff).
- `orders.ts` — `createOrder` is the real logic: one Firestore transaction reads
  every requested product fresh, validates stock, **recomputes price/total
  server-side** (never trusts a client-submitted price — the plan's stated
  principle), decrements stock, writes the order, and clears that user's cart
  for the store, all atomically. `getOrdersForUser`/`getOrdersForStore`/
  `getOrderForStore`/`updateOrderStatus` round it out.
- `orders-dashboard.ts` — a **separate, client-SDK** version of the order
  reads/writes the dashboard's own Orders page uses (`firebase-admin` can't run
  in the browser). Deliberately does NOT go through the new REST API — it uses
  direct Firestore reads/writes gated by the *already-deployed*
  `isStoreOwner(storeId)` rule, the identical pattern Categories/Products
  already use. The REST API and the dashboard are two separate, intentional
  paths to the same data: REST serves callers that aren't an authenticated
  browser session (gravia, curl, future clients); the dashboard uses its own
  live Firebase Auth session directly.

**New routes** (`admin/src/app/api/stores/[storeId]/`):

| Route | Behavior |
|---|---|
| `GET/PUT /cart` | Shopper's cart, `PUT` replaces wholesale; `GET` joins stored `productId`s against **live** product data |
| `POST /orders` | Creates an order (see `createOrder` above); `409` on insufficient stock, `400` on unknown product |
| `GET /orders?userId=` | Shopper's own order history |
| `GET /orders` (no `userId`) | All orders for the store — admin-gated |
| `PATCH /orders/{orderId}` | Order status change — admin-gated |

**New dashboard page**: `/dashboard/orders` — table + a status `Select` per
row (Pending/In process/Delivered/Cancelled), added to the sidebar nav.

**New Firestore composite indexes** (`firestore.indexes.json`, deployed to
`corderlia-ecom` via `firebase deploy --only firestore:indexes` — indexes
only, rules untouched): `(storeId, uid, placedAt desc)` and
`(storeId, placedAt desc)` on `orders` — required because Firestore can't
serve an equality-filter-plus-sort query without one; the first live calls
correctly 500'd with `FAILED_PRECONDITION` while the index was still building,
confirming the requirement was real and not just theoretical.

**Verified live against the real "Gravia" store**, not just compiled: cart
round-trip; order creation with a real stock decrement (100→98, confirmed via
the live product-read API); insufficient-stock (`409`) and unknown-product
(`400`) rejections; cart auto-clears on checkout; shopper order history reads
back correctly. For the admin-only branches, signed up a throwaway test admin
via the real Identity Toolkit REST API, granted it `storeIds` for the Gravia
store, and exercised all four gate outcomes: no token → `401`, garbage token →
`401`, valid token + wrong store → `403`, valid token + correct store → `200`
(list) and successful status update. All test data (order, admin doc, cart
doc, auth user) deleted and the product's stock restored to 100 afterward —
same clean-up discipline as the earlier rules-negative-test passes.

**Real secret-hygiene catch mid-session**: an early, failed attempt at
generating the service-account key left a raw key JSON sitting in
`admin/.secrets/` — a path `admin/.gitignore`'s `.env*` rule doesn't cover.
Caught before it could be committed (that specific key was also independently
revoked via `gcloud iam service-accounts keys delete` once the leftover was
found) and the directory deleted. Also force-added `admin/.env.local.example`
to git (`git add -f`) — despite earlier docs in this file claiming it was
"committed as the template," it was never actually tracked (blocked by the
same `.env*` glob); it holds only empty placeholder keys, safe to commit, and
now includes the three new `FIREBASE_ADMIN_*` placeholders.

**Not yet deployed.** Local commit only (`e86dabd`) — pushing to GitHub and
adding `FIREBASE_ADMIN_PROJECT_ID`/`FIREBASE_ADMIN_CLIENT_EMAIL`/
`FIREBASE_ADMIN_PRIVATE_KEY` to Vercel were both requested, but this
environment currently cannot reach either GitHub or Vercel's API at the
network level (`connect ETIMEDOUT`, confirmed with plain `curl` too, and
unaffected by disabling the command sandbox — genuinely not sandbox-scoped).
`google.com` was reachable in the same check, so this looks like a
host/network-specific block rather than a general outage. Blocked until that
connectivity issue is resolved (or the push/env-var steps are run from a
network that can reach both).
