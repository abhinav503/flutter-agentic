# Super App Ecommerce (FlutterAgenticEcommerce) — Platform Plan

> Status: **three complete storefront templates (`gravia`, `dailymart`,
> `grofast` — every surface, no fall-throughs) over one shared
> domain/data layer; checkout + per-store Razorpay + cancel/refund live;
> catalog depth (brands + per-size-priced size variants) and coupons
> (store/category/product-scoped, server-priced) shipped end-to-end
> admin→API→all three templates — coupons verified working, brands await a
> data-seeded verification pass; back-button headers pinned in
> dailymart/grofast. Product-facing scope contract: `docs/PRODUCT_SPEC.md`.
> Latest admin/API code not yet deployed to Vercel** (last updated
> 2026-08-04). Turns the `gravia` exemplar into a multi-tenant "app of
> apps" ecommerce platform. See also `docs/explanation/end-goal.md`.
>
> **Note (2026-07-25): the multi-tenant runtime moved to `cordelia`, and
> per-store identity became a full swappable template, not just a
> `ColorScheme`.** `apps/ecommerce/cordelia` (the store-discovery "app of
> apps" shell — splash/onboarding/shared Firebase auth/discovery — already
> exists as a sibling app to `gravia`) is where the multi-tenant storefront
> now lives, not `gravia` itself. The "Key gravia refactor" section below is
> **superseded** by "Multi-template storefront in `cordelia`" further down:
> home/cart/orders/profile `domain`+`data` are ported into `cordelia` once,
> shared by every store, while each store's screens (Home layout, bottom
> nav, etc.) come from a swappable `presentation/templates/<name>/` — of
> which `AppTheme.fromConfig` color/shape config is only one input, not the
> whole story. `gravia` the app remains the frozen single-store exemplar the
> first template (`gravia`) was ported from; it is not itself the
> multi-tenant runtime going forward. **Planned, not yet implemented** — see
> that section for the concrete plan.
>
> **Note (2026-07-22):** much of M1b (shopper Firebase auth in gravia) shipped
> in gravia between the 07-18 entries below and now — `feature/auth/` (login/
> signup, persistent email-verification sheet + poll, session-expired guard,
> forgot/reset password), plus cart/orders/address/favourites/search all wired
> to the deployed API. `users/{uid}` is created server-side via the token-authed
> `POST /api/users` route (no `cloud_firestore` in the client — cleaner than a
> direct client write). Several 07-18 entries below that say "gravia
> intentionally left untouched" predate that and are stale.

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

- **Not a marketplace.** Each store connects its **own** payment provider; the platform
  **never touches shopper money**. This drops all marketplace complexity (no Stripe
  Connect payouts, KYC, commission splits, tax) and is what keeps us out of
  payment-aggregator classification — it remains load-bearing for every payments
  decision in this doc.
- **Monetization — OUT OF SCOPE (2026-08-07).** This bullet previously read "Revenue =
  store owners pay a subscription to host their store app + get the admin panel."
  That is no longer the plan for what ships: **v1 is free for every store, in India and
  outside it, with no commission on any order.** Charging belongs to v2 (per-store
  branded apps), where App Store guideline 4.2.6 imposes a real per-merchant cost floor
  — see "Competitive landscape" below. Nothing in the current milestones bills anyone.
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
- **Store-owner subscription billing — OUT OF SCOPE (2026-08-07).** Superseded by the
  bullet above: there is no subscription to build. If it returns with v2 it lives on the
  console/admin side, separate from shopper checkout, and is a fresh decision rather than
  a deferred one.

## Competitive landscape (surveyed 2026-08-07)

Who else sells a store owner a shopping app, and where `cordelia` actually differs.
Recorded because the answer moved the roadmap: it is the reason v1 stays free and the
reason v2 cannot.

**1. Indian SMB store builders — the direct rivals.**

| Player | What it is | The gap we exploit |
|---|---|---|
| **Dukaan** | Bengaluru, 2020, mobile-first, explicitly targets kiranas and solo sellers. The closest analog to this product. | Charges **1.99–4.99% per order on every plan**. We charge zero and never touch shopper money |
| **Bikayi** | WhatsApp-first store builder for Indian SMBs; web storefront with a mobile admin | Web-led; no native shopper app |
| **DotPe** | Digital storefronts + payments, strong in restaurants and retail | Payments-led — they sit *in* the funds flow, we deliberately don't |
| **Instamojo** | Online store bolted onto a payments product | Same: payments-first |
| **Zopping** | Grocery-specific store builder | Tightest vertical overlap. Verify their app story before positioning against them |
| **StoreHippo** | Indian mobile-first commerce — **does ship native apps**, so treat as a category-3 rival, not a storefront builder | Closer to us than the others in this row |

**2. Global storefront platforms** — Shopify (~$29+/mo), WooCommerce, BigCommerce, Wix,
Ecwid, Square Online. All web-first. A merchant on any of them needs a *separate*
product to get a mobile app, which is category 3. They are the reference point people
name, not the competitor.

**3. Branded mobile-app builders** — what we most resemble functionally, and the
expensive end: **Tapcart** ($250–$1,000+/mo, mid-market/enterprise DTC), **Superfans**
(formerly Vajro, pivoted to community/live commerce), **MageNative**, **Appmaker.xyz**,
**Shopney**, **AppBrew**, **Plobal** (entry level from ~$49/mo). Every one of them
*requires an existing Shopify or WooCommerce store* — they are a bolt-on. We are the
whole stack, which is the real advantage for a kirana with no storefront at all.

**4. What actually competes for a kirana's attention** — **WhatsApp Business + a UPI QR
code**. Free, already installed, zero learning curve. A harder competitor than Dukaan.
**ONDC** is the structural wildcard: government-backed open network, actively onboarding
kiranas.

### Why this shapes v1 vs v2

**App Store Review Guideline 4.2.6** rejects apps built from a commercialized template
"unless they are submitted directly by the provider of the app's content" — but it
names an acceptable alternative outright: a **single binary hosting all client content
in an aggregated or "picker" model** (Apple's own example is a restaurant finder with a
customized entry per client restaurant).

That is exactly what `cordelia` is. The one-app/many-templates architecture is not a
stepping stone to the real product — it is **the pattern Apple sanctions**, and it is
why this shipped through Play cleanly.

The planned v2 (each store gets its own branded app) lands on the other side of the same
guideline, and the cost is per-merchant and non-amortisable:

```
per merchant, per year:
  Apple Developer account   $99/yr   — their account; Apple forbids us submitting for them
  Google Play               $25      one-time
  + review cycles, listing assets, and rejections we cannot fix unilaterally
```

Roughly **$10/month per merchant before earning anything**, scaling linearly. This is
precisely why Tapcart charges what it charges. **v2 is where pricing has to exist**, and
it cannot be free — while v1, which costs us nothing per merchant, can be.

### Where we're differentiated

- **Zero commission, free** against Dukaan's 1.99–4.99% per order — a sharp wedge, but a
  wedge, not a moat: Dukaan is funded and could zero-rate a tier to match.
- **Store keeps its own PSP account** — money never passes through us, which is also what
  keeps us out of payment-aggregator classification (see the Razorpay per-store design).
- **Per-store language packs** — the most defensible item on the list and the least
  obvious. Competitors above are English-first; ~710 keys per language with CLDR plural
  handling and per-language typography is slow to copy. Against Dukaan, lead with this
  plus zero commission, not with a feature checklist everyone matches.

> Sourced from vendor sites and 2026 market write-ups, not from each vendor's live
> pricing page. This space churns — re-verify Dukaan's and Zopping's current plans
> before using any number in marketing copy.

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
orders/{orderId}                     { uid, storeId, items[], deliveryAddress, status, total,
                                       razorpayPaymentId, razorpayOrderId, refundStatus, refundId,
                                       deliveryOtp, placedAt }
                                     auto-id, NOT composed from storeId/uid — a shopper places many
                                     orders at one store, so a composed id isn't unique, and the
                                     pairing is already indexed as fields (see firestore.indexes.json)
```

- **Roles**: one Firebase Auth pool. A plain shopper has only `users/{uid}`. A store
  owner also has `admins/{uid}` + a custom claim `role: storeAdmin` (set by a Cloud
  Function) — the claim is what security rules trust for store writes; `admins.storeIds`
  lists the stores they manage (one owner → many stores).
- **category↔product link** = `categoryIds: []` array on each product (Firestore
  `array-contains` queries); the admin "connect categories and products" edits this array.
- No `payments/` collection in the SaaS model — the platform never records a shopper
  charge; the order carries only the store-PSP reference the store's own provider returns.

## Key gravia refactor: inject an "active store" context — SUPERSEDED (2026-07-25)

*Original plan, kept for history:* introduce an active-store context
(storeId + that store's `themeConfig`); every gravia data source stops
reading `rootBundle` JSON and queries Firestore scoped by the active
storeId; the *existing* gravia screens (home grid, categories, product
details, cart) render for whichever store is active, re-skinned only via
`AppTheme.fromConfig`; `feature/discovery/` becomes the app's first screen
and `feature/shell/` the per-store shell, both inside gravia.

This assumed **one** screen set, re-themed by color/shape alone. That's no
longer the plan — see "Multi-template storefront in `cordelia`" below for
the actual direction: a different runtime app (`cordelia`, not `gravia`),
and per-store identity as a full swappable presentation template, not just
a palette swap.

## Multi-template storefront in `cordelia` — the plan; SHIPPED (2026-07-25)

> **Built, and then some.** This is the design as written before any of it
> existed, kept because the reasoning below is still the architecture. The
> build is recorded in the sections that follow: Phase 1 (Home slice) on
> 07-27, the full storefront port on 07-28, and three complete templates
> (`gravia`, `dailymart`, `grofast`) by 08-03. Present-tense claims here —
> "today a genuine stub" — describe 2026-07-25, not now.

`cordelia` (`apps/ecommerce/cordelia`) is already the store-discovery
"app of apps" shell: splash → onboarding → shared Firebase auth →
`feature/home` (discovery, lists stores via `GET /api/stores`) → tap a store
→ `feature/storefront` (today a genuine stub — `EmptyState`, no
data/domain). This section is where that stub becomes real, as a
**multi-template** storefront rather than a single re-skinned screen set.

**Why a template, not just a theme.** A store's screens can now differ in
*layout*, not just color — different Home composition, different bottom
nav — while `repository`/data-source code stays identical across stores.
Flutter ships one binary, so this can't be "load a different app at
runtime"; it has to be **one app (`cordelia`) with multiple swappable
presentation implementations**, selected per store. Confirmed by exploring
gravia's code: its `presentation/` layers are the *only* place
branding/styling leaks in (`Gravia*`-prefixed classes live exclusively
under `presentation/view`/`presentation/widgets`, zero hits in any
`data/`/`domain/` folder) — so `domain`+`data` are already reusable
as-is across templates.

**Shared domain/data, per-template presentation.** For each storefront
feature, `domain`/`data` are written once in `cordelia`, ported from
gravia's theme-agnostic layers; only `presentation` forks per template
under `presentation/templates/<name>/`:

```
feature/storefront/
  active_store/            # ActiveStoreEntity {storeId, storeName, templateId}
                            # + ActiveStoreCubit, provided once the shell mounts
  template/                # enum StorefrontTemplate { gravia } + string<->enum
                            # extension (per CLAUDE.md enum convention)
  shell/presentation/templates/gravia/    # ported gravia ShellPage; tabs
                                           # Home + Orders + Profile; cart
                                           # stays a docked bar, not a tab
  home/     data/ domain/ (storeId-scoped) + presentation/{bloc/, templates/gravia/}
  cart/     data/ domain/                 + presentation/{cubit/, templates/gravia/}
  orders/   data/ domain/ (orders only, no payment-gateway this pass)
                                           + presentation/{bloc/, templates/gravia/}

feature/profile/           # top-level, sibling to feature/auth — store-agnostic,
                            # so NOT nested under storefront
  data/ domain/             # only the GET-fetch (ApiConstants.usersPath) gravia's
                             # own slim feature/profile already isolates
  presentation/{bloc/, templates/gravia/}
```

This nests storefront's sub-features under `feature/storefront/` as a
deliberate, explicit exception to "one feature = one top-level folder" (the
same kind of case `docs/reference/architecture.md` already documents for
the shell/tabbed-app split) — specifically to avoid colliding with
`cordelia`'s existing `feature/home/`, which means *store discovery*, not a
per-store product home. **Adding template #2 later = one new
`presentation/templates/<name>/` folder per feature + one new enum case +
one new admin dropdown option — no `domain`/`data` changes.**

**Removing the hardcoded-storeId seam.** gravia's `ApiConstants.storeId` is
a compile-time constant baked into every endpoint path — the concrete gap
this section closes. Since `core`'s forbidden-pattern list requires data
sources to stay const/no-arg (infra reached only via `.instance`
singletons), `storeId` becomes a **call parameter** threaded the normal
Clean-Architecture way (data-source method args → repository method args →
use-case `Params` → BLoC event field), read once from `ActiveStoreCubit`
when the storefront shell provisions each BLoC — not a constructor
parameter and not a global constant.

**Auth stays super-app-level, not per-store.** Login/signup/verify-email/
forgot-password/change-password/update-profile already live in `cordelia`'s
existing `feature/auth/` (all 8 use cases already ported and DI-registered).
A shopper signs in once, before discovery; opening a store's storefront
reuses that session — no per-store re-login, no auth porting needed. The
only new piece is a **Profile screen**: `cordelia`'s auth can mutate a
profile but has no GET-fetch of it, so `feature/profile/` ports gravia's
slim fetch-only `ProfileRepository`/`GetProfileUseCase`; edit-profile and
change-password screens call `cordelia`'s **existing** auth use cases
(matching how gravia's own `EditProfileBloc`/`ChangePasswordBloc` already
call into its `feature/auth`, not a forked copy).

**Admin `templateId`.** `stores/{storeId}.themeConfig` was always
aspirational (zero references in `admin/src`); `templateId` will be the
first field wired end-to-end: `admin/src/lib/types.ts` (`Store.templateId`),
`POST /api/stores` (accept + default `'gravia'`), `serializeStore()`
(`template_id`), `mapStoreDoc` (default `'gravia'`), plus a small dropdown
UI (new dashboard section or page) behind a `PUT` sub-route, following the
existing `payment-config` route's pattern.

## Multi-template storefront in `cordelia` — Phase 1 (Home slice) DONE (2026-07-27)

The proof-of-concept slice described in the section above is now built:
`feature/storefront/` in `cordelia` renders a real, storeId-scoped Home for
the seeded "Gravia" store, with the runtime theme swap working. Confirms the
whole mechanism the section above only proposed. No `ShellPage`/bottom nav
yet — deliberately deferred, see "Not built this pass" below.

- **`active_store/`** — `ActiveStoreEntity {storeId, storeName, templateId}`
  + `ActiveStoreCubit`, seeded once per `StorefrontPage` mount (not
  app-wide).
- **`template/`** — `enum StorefrontTemplate { gravia }` + wire-value/parse
  extensions, tolerant default `gravia` (the admin backend still doesn't
  send `template_id` — confirmed live: `GET /api/stores` returns no such
  field today, and the tolerant default is what actually resolves it).
- **`home/`** — `data`/`domain` ported from gravia's own `feature/home`
  near-verbatim, with `storeId` threaded as a call parameter at every layer
  (`getHome({required storeId})` → `GetHomeParams` → `HomeEvent.started
  ({required storeId})`), never a constructor/global constant. The
  categories-groups response is parsed inline in
  `HomeRemoteDataSourceImpl` rather than depending on the not-yet-ported
  Categories feature's own model. `presentation/templates/gravia/` holds a
  trimmed screen (category rail + popular-products rail, built entirely
  from `core` blocks — `CategoryTile`, `ProductCard`, `HeroHeader.page`,
  `ShimmerBox` — not gravia's own app-local widgets) with cart/favourite/
  address/notification/search/category-tap/product-tap all no-ops this
  phase, since those features aren't ported yet.
- **`BlocCache` cross-store guard** — added a `static String? _cachedStoreId`
  beside `HomeBloc`'s existing `BlocCache`, since (unlike gravia, one store
  forever) opening store A then store B behind the same static cache would
  otherwise flash A's stale catalog before B's fetch resolves.
- **Runtime theme swap** — `cordelia`'s `App`/`_AppState` gained a new
  `ActiveThemeController`/`ActiveThemeScope` (`lib/theme/`, mirroring
  `core`'s `ThemeModeController`/`ThemeModeScope` shape but kept app-local
  for now), driving `MaterialApp.router`'s `theme`/`darkTheme` alongside the
  existing `_themeMode` `ValueListenableBuilder`. `StorefrontPage` applies
  the `gravia` template's bundled theme config
  (`assets/theme/templates/gravia_theme_config.json`, i.e. the *real* shared
  `gravia` preset — emerald `#027A60` — not CordeliaApps' own purple-brand
  override at `assets/theme/theme_config.json`) on mount and restores the
  app default on dispose. Per-store Firestore theming
  (`stores/{id}.themeConfig`) is still explicitly deferred — this proves the
  swap *mechanism*, not per-store colors; only `templateId` is wired
  end-to-end, matching this doc's own stated near-term priority.
- **DI** — new `HomeRemoteDataSource`/`HomeRepository`/`GetHomeUseCase`
  bindings in `cordelia`'s `injection_container.dart`. `ActiveStoreCubit` is
  not GetIt-registered (constructed directly from route data, matching how
  every other Cubit/Bloc in both apps is wired).

**Verified**: `flutter analyze` clean on `cordelia`; curled the live seeded
"Gravia" store's `/categories` and `/products/popular` responses directly
and confirmed their shapes match `CategoryModel`/`ProductModel`'s
`fromJson` mapping exactly (including the `groups[].categories[]` nesting
`HomeRemoteDataSourceImpl` flattens, and every `snake_case` `@JsonKey`). The
user then click-verified the real path live in Chrome: Discovery →
`GET /stores` (200) → tapped the seeded "Gravia" store → real
`[REQ]`/`[RES]` logs for `.../stores/4116e313.../categories` and
`.../products/popular` (both 200, correct storeId in the URL, not a
hardcoded constant) → Home rendered.

**Bug found + fixed (2026-07-27) — dispose-time crash on navigating back.**
Popping Storefront → Discovery threw `setState() or markNeedsBuild() called
when widget tree was locked`: `_StorefrontPageState.dispose()` called
`ActiveThemeController.resetToAppDefault()` synchronously, which
`notifyListeners()`s a still-mounted ancestor's `ValueListenableBuilder`
while the framework was mid-unmount (`BuildOwner.finalizeTree`, tree
locked) — a widget must not trigger a still-mounted ancestor's rebuild from
its own `dispose()`. Fixed by deferring the reset to
`WidgetsBinding.instance.addPostFrameCallback` in `dispose()`
(`storefront_page.dart`), so the ancestor rebuild happens on the next frame
instead of during the locked pass. Verify the fix on a real back-navigation
(not yet re-confirmed live at time of writing this note).

**Not built this pass** — *superseded; everything in this list has since
shipped, see the next section*: `ShellPage`/bottom nav + a second tab
(Profile recommended next), Categories, Cart, Orders, Favourites, Search,
Checkout/Razorpay, and the admin `templateId` field.

## Full storefront port + dailymart seams + admin template management — DONE (2026-07-28)

**The storefront is no longer a slice.** Every gravia feature is ported into
`cordelia`'s `feature/storefront/` with shared `data`/`domain` and
presentation under `templates/gravia/` (`view/` + `widgets/`, consistent
across all features): home, categories, category_details, product_details,
cart (+ `CheckoutBloc` with the full payments flow — `POST /payments` →
native Razorpay via `lib/services/razorpay/` → verified `POST /orders`, with
the `kIsWeb` payment-less test-mode path), orders (incl. cancel), address,
favourites, search, notifications, profile (edit/change-password), and
`shell/` (5 tabs: Home/Categories/Favourite/Orders/Profile, cart as a docked
bar). All DI-registered and routed; `flutter analyze` clean; cordelia is now
a strict superset of gravia's feature set. Remaining `comingSoon` stubs:
cart coupon-apply; Orders' Track Order/View Details/Write Review; login's
social buttons — same set as gravia.

**Pre-dailymart bug sweep (all fixed + verified):**
- *Missing asset*: notifications loaded `assets/data/notifications.json`,
  which didn't exist in cordelia — copied from gravia + pubspec entry.
- *Orphaned storefront splash* (`feature/storefront/splash/`, referenced by
  nothing, would have crashed on `context.go(home)`) — deleted.
- *Duplicate `termsAndConditions`/`privacyPolicy` routes* in `app.dart` —
  dead second pair removed.
- **`/home` route crash cluster** — the big one: every
  `context.go(AppRoutes.home)` (post-login/signup, Profile "My Orders",
  Home "see all", Cart "Track Your Order") landed on a bare `ShellPage`
  with no `ActiveStoreCubit` → guaranteed `ProviderNotFoundException`; the
  route was ported from gravia where the shell was the root. Fix:
  `ActiveStoreCubit` hoisted app-level (nullable state, seeded/cleared per
  `StorefrontPage` mount — same rationale as the app-level `CartCubit`);
  `/home` route deleted; storefront route nested as
  `/discovery/storefront` so `go()` tab-jumps rebuild the stack with
  Discovery beneath; new `StorefrontRouteArgs {store, initialTab}` used by
  all former callers; login/signup now land on Discovery.
- *Back-nav theme reset* verified by a new widget test
  (`test/widget/feature/storefront/storefront_page_test.dart`) that pops a
  real `StorefrontPage` over a rebuilding ancestor — it also caught (and
  the fix now covers) an unsafe `context.read` in `dispose()`.

**dailymart template seams open.** `StorefrontTemplate { gravia, dailymart }`
with wire/parse arms (`"dailymart"` no longer silently parses to gravia);
dispatch + theme-asset switches in `storefront_page.dart` have dailymart
arms — dailymart currently renders the gravia screens under its own
placeholder theme (`assets/theme/templates/dailymart_theme_config.json`,
`rocketWarm` preset) until `presentation/templates/dailymart/` is forked,
which is the actual dailymart build. The four gravia-named app-level
widgets were neutralized (`Cordelia{FormField,PrimaryButton,GlassIconButton,
HeroHeader}` in `lib/widgets/`) so auth/legal/discovery no longer import
gravia-branded chrome; they still read `Gravia*Const` styling internally —
revisit when dailymart's design pack exists.

**Admin-side template management.**
- `POST /api/stores` now **validates** `templateId` against the seeded
  `templates` collection (400 with the valid-id list) instead of trusting
  the dropdown — a hand-backfilled `"dialymart"` typo on the live "Daily
  Mart" store (silently falling back to gravia client-side) is exactly what
  this prevents; the live doc was also corrected to `dailymart`.
- New `admin/src/app/api/stores/[storeId]/route.ts` — public GET (single
  store, 404 on missing/inactive) + owner-gated PUT (partial update of
  name/description/logoUrl/searchKeywords/templateId, template validated).
  Live-verified the full matrix (401/403/400/200 + create→rename→retemplate
  →public-read) with a throwaway user, cleaned up after.
- `/dashboard/settings` gained a **Store profile card** (name, description,
  logo upload, search keywords, template dropdown) saving through the PUT
  route. Logo uploads use a new owner-gated `{storeId}/store/**` prefix in
  `storage.rules` — **already deployed** to `corderlia-ecom`.
- Two junk store docs (unrelated "blissBestGrocery" demo data with empty
  names + `your-bucket` logos leaking into public discovery) deleted after
  inspection. `stores/be01f080…` ("Storage Test Store") deliberately left —
  named/active, user's call whether to remove.
- Latent `firebase-admin` dev bug fixed: `adminDb.settings()` is once-only
  per Firestore instance and threw when a second `next dev` route chunk
  re-evaluated the singleton module — now guarded.

**Remaining before/alongside the dailymart build**: commit + push + redeploy
admin (env vars are already in Vercel — the "needs `PAYMENTS_ENC_KEY` +
`FIREBASE_ADMIN_*`" blocker below is stale; the deployed build still serves
no `template_id`, and admin + Flutter clients must cut over together);
fork `presentation/templates/dailymart/` per feature (the template's actual
screens); sample dailymart's real design pack (replace the `rocketWarm`
placeholder); the `comingSoon` stubs above; and the platform-level items in
"Missing flows".

## dailymart template build — Home + Notifications DONE (2026-07-29)

**The second template is real now.** `dailymart`'s design pack was sampled
from its UI8 kit (Figma `kSTxkipKGeY8FrqWqibDLH`) into
`docs/ai-rules/style-packs/dailymart.md` + the `dailyMart` core preset,
replacing the `rocketWarm` placeholder. Built on it, under
`presentation/templates/dailymart/`:

- **Shell** — 4 tabs in the kit's own order (Home/Wishlist/Cart/Profile —
  the cart is a tab here, unlike gravia's docked bar), stacked
  `BottomNavBar`, coming-soon `EmptyState`s for the three unported tabs.
- **Home** — mint full-bleed canvas (no app bar, nothing pinned), header
  with avatar/address/bell + search bar, centred peeking promo carousel
  (rests on page 1 when 2+ banners; skeleton is a real non-scrollable
  `PageView` sharing the carousel's geometry + dot row), category rail,
  2-column product grid with the kit's static `4.9 (345)` rating row
  (placeholder — `ProductEntity` has no rating; documented in the pack
  constants).
- **Notifications** — pack header row (`DailyMartHeaderRow`), dated
  sections, kit `Icon / solid /` glyphs (discount/card/profile recomposed
  from Figma MCP layer fragments), per-kind tinting.

**Per-template infrastructure this forced, reusable for template #3:**
- `StorefrontTemplateSwitch` — pushed routes (Notifications today; Cart/
  Search/details when their dailymart screens land) dispatch per template
  off `ActiveStoreCubit` with `read` (not `watch`); shells keep dispatching
  in `StorefrontPage.buildBody`.
- Per-template assets keyed by `wireValue`: mock data moved to
  `assets/data/templates/<id>/notifications.json` (template threaded as a
  use-case call param, like `storeId`), theme-config path now derived the
  same way (switch deleted). Notification mock rewritten per pack; shared
  data carries semantic `NotificationKind`, each template maps kinds to its
  own glyphs — the old asset-path-in-JSON approach was also silently 404ing
  in gravia and is gone.

**Two teardown races found live and fixed (regression-tested):**
- "Track Your Order" crash-looped (`state!` null in the shell every frame):
  `StorefrontPage`'s deferred dispose teardown ran *after* the replacement
  storefront had mounted and cleared its freshly-opened store. Fixed with a
  session token from `ActiveStoreCubit.open()`; teardown no-ops if another
  session has opened since (`storefront_tab_jump_test.dart`, verified
  failing without the fix).
- Gravia Home's duplicate `Hero` tag: the `AnimatedSwitcher` built
  `HomeHeroHeader` in both loading and loaded branches, so both copies were
  mounted mid-crossfade — hard framework error. Header hoisted outside the
  switcher (only the body swaps now); the search-field tag is additionally
  **per-store** (`SearchFieldBar.heroTagFor(storeId)`, required) so two
  same-template storefronts can't pair their bars across a tab jump.

**Cross-template extractions promoted to core** (each with a design_gallery
entry): `IconInfoRow` (notification-row silhouette), `ShimmerListRow` +
`ShimmerSectionHeader` (skeleton silhouettes; `ShimmerBox` gained colour
overrides), and `BaseScreenState.overlayStyle` (all 15 hand-rolled
`AnnotatedRegion` wrappers replaced; new forbidden-pattern rule synced to
every agent surface).

**Remaining for dailymart parity** *(updated 2026-07-30)*: the Wishlist tab
(designed coming-soon state today); dailymart's own Category Details and
Address Form (those routes still open gravia screens);
My Orders (no Orders tab and no Orders screen in this template — the Profile
row says so instead of opening gravia's); per-store notifications from the
backend (bundled per-template mock today). Search, Product Details, Cart,
Profile, Edit Profile, Change Password, Checkout, Select Address and the legal
document shipped.

## Template reusability sweep + dailymart polish — DONE (2026-07-30)

A full duplication/violation audit across both templates (per
`docs/how-to/review-code.md`), then everything actioned with zero visual
change. Workspace `flutter analyze` clean; cordelia + core tests green.

**dailymart product decisions:**
- **Filter removed from Search** — filtering belongs to Category Details
  (unbuilt); Search's floating slot now docks the cart status pill in both
  browse and results modes. The pill's dimens, the filter/sort copy, and
  `DailyMartRadioSheetContent` are kept for that future screen (spec sheet
  §10 records the decision).
- **Filled favourite heart** — `heart_filled.svg` hand-derived from the
  outline's exact path (same silhouette, no toggle jump). Favourited state
  tints `cs.primary` (brand green) on the product card, Product Details'
  header disc, and the Wishlist tab's active glyph.

**Promoted to core** (each with a design_gallery entry): `SectionRail`
(header + left-gutter-only horizontal rail — 4 hand-rolled copies deleted),
`PriceBreakdown` + `PriceLine` (`blocks/ecommerce/` — both carts' totals
panels and their byte-identical `_SummaryRow`s), `AppIconCircle`
(non-interactive tinted disc; 5 sites incl. inside core's own
`AppMenuTile`), `AppSwitcher` (standard 300ms fade with `curve`/`topAligned`
— 11 raw `AnimatedSwitcher`s converted; `DailyMartTopSwitcher` is now a thin
preset), `ShimmerCircleTile`, an extended `IconInfoRow`
(`onTap`/`trailing`/optional subtitle — its 4 private forks deleted),
`num_extensions.dart` (`asPrice`/`asPercent`/`plural` — fixed gravia's
"0 item" cart label as a side effect), and a `context.appColors` accessor
(34 hand-typed `Theme.of(context).extension<…>()!` lookups migrated).

**Shared within cordelia:** `StorefrontShellPage` + `StorefrontShellState`
(both shells' byte-identical tab state, `didUpdateWidget` reaction, and
cart/favourites hydration; `svgNavIcon` helper), `QuantitySelection` mixin
(floor-of-1 stepper state — Product Details + both add-to-cart sheets),
`CartItemEntity.lineTotal`, `HeroSearchFieldFlight` (both packs' search-bar
hero mechanics — rect tween + inert shuttle copy — with a `shuttleWrapper`
slot for gravia's painted canvas), per-pack product grids
(`GraviaProductGrid`, `DailyMartProductGrid`, `DailyMartProductGridSkeleton`
— 7 inline grid recipes deleted), `DailyMartPill` (3 hand-rolled label
pills), and 3 private re-implementations of `DailyMartIconDisc` deleted.

**Structural fixes:** the four gravia-coupled widgets in the app-level
`lib/widgets/` (`CordeliaHeroHeader`, `CordeliaPrimaryButton`,
`CordeliaGlassIconButton`, `CordeliaFormField`) moved to
`lib/templates/gravia/widgets/` as `Gravia*` — only `CordeliaAvatarImage`
(genuinely both-pack) and `HeroSearchFieldFlight` stay app-level.
`GraviaDimenConst` gained named header-height tiers (18 `initialHeaderHeight`
literals), `detailImageHeight` (the carousel/skeleton duplicated 300), the
grid-skeleton card height, and `hairlineWidth`; the `filterDateLabel`
name collision resolved (`DateTime` formatter → `asFilterDate`).

## dailymart Profile slice — DONE (2026-07-30)

Four kit frames ported into the `dailymart` template: `42 My Account`,
`43 Personal Data`, `50 Privacy & Policy`, and `30 Checkout - Shipping
Address`. Per the brief, **the row set is gravia's** (same titles, same
actions) and only the UI is the kit's — the kit's own list offers Security /
Language / Help & Support, none of which this app has.

**Screens** (`feature/*/presentation/templates/dailymart/`):
- **Profile** — now the shell's 4th tab instead of a coming-soon state.
  Identity row (64 avatar + 18/700 name + email), then General and
  Preferences groups of bordered 52 px rows. Reads the shell-level
  `ProfileBloc`, so switching tabs never re-fetches.
- **Edit Profile** — 140 px avatar with the kit's green pencil badge, Name /
  Email (disabled) / Phone, floating Save Changes over the pack's bottom
  fade. The kit's Date of Birth and Gender fields are **not** reproduced:
  `ProfileEntity` carries neither, and inventing storage for two fields the
  backend never returns would put dead controls on a live form.
- **Privacy & Policy / Terms** — the app-level `LegalDocumentContent`
  rendered in this pack: bold effective-date line, section heading + body,
  and a permanently-visible `RawScrollbar` with a green thumb (the kit draws
  the scrollbar as page furniture, not an overlay). The legal feature was
  restructured into `presentation/templates/<id>/view/` to match every other
  templated screen.
- **Select Address** — tinted radius-16 cards with a trailing selection
  disc. **Selecting is committing**: the kit gives this screen one CTA (Add
  New Address) and no confirm button, so a tap persists the choice and pops
  the chosen `AddressEntity` — the same contract the checkout gate awaits,
  reached in one tap instead of two. Per-card Edit/Delete aren't drawn (the
  kit's frame has neither yet).

**New pack wrappers:** `DailyMartMenuTile` (bordered strip; takes `asset`
**or** `icon`, plus a `trailing` slot for the Dark Mode switch),
`DailyMartFormField` (56 px at radius 12), `DailyMartOutlineButton`,
`DailyMartActionPair`, `showDailyMartConfirmSheet` +
`DailyMartConfirmSheetContent` (the roster's declared confirm sheet, now
shipped for Logout). Eight kit SVGs added to the pack's icon folder; three
rows the kit never draws (My Orders, Dark Mode, Terms) take a `_outlined`
Material fallback, visible at the call site.

**Structural fix:** the two `selected_address_*` pref keys moved out of
gravia's `address_page.dart` into `address/presentation/address_pref_keys.dart`
— the shared `AddressBloc` and `SelectedAddressLabelState` mixin were both
importing a *template* file for them, and dailymart's screen would have been
the third.

**Routing:** `selectAddress`, `editProfile`, `privacyPolicy` and
`termsAndConditions` now dispatch through `StorefrontTemplateSwitch`. The
two legal routes are also reachable from Signup, i.e. outside any
storefront, where the switch's documented `null` fallback lands on gravia —
the same default an unknown `template_id` takes.

## Template audit — violations fixed + cross-pack promotions — DONE (2026-07-31)

With both templates complete end-to-end, a four-track audit (duplication /
forbidden patterns / shared-layer template-agnosticism / dispatch coverage)
ran over cordelia, and everything it found was fixed in one sweep.
`flutter analyze` clean workspace-wide; all tests pass except two
pre-existing failures outside cordelia (doc_scanner's boot widget test and
gravia-standalone's shell test, which makes real network calls).

**Shared layers de-templated:**
- `lib/enums/` no longer imports the gravia pack — order/refund/filter-period
  `label` extensions moved to `templates/gravia/extensions/gravia_order_labels.dart`
  (dailymart already had its own wording); sort/price-filter copy moved to the
  app-wide `ValueConst`. The shared orders stack (entity → model → bloc) is
  template-neutral again.
- **Auth keeps the gravia look by design** (only kit available when it was
  built) but no longer imports `templates/gravia/`: the widgets it uses are
  now app-level `CordeliaFormField` / `CordeliaPrimaryButton` /
  `CordeliaGlassIconButton` (`lib/widgets/`) with `CordeliaTextStyleConst` /
  `CordeliaDimenConst` / `CordeliaColorConst` (`lib/constants/`); the gravia
  pack consumes them via `typedef GraviaFormField = CordeliaFormField;`-style
  aliases — zero gravia template churn, one implementation.
- `StorefrontPage._applyTemplateTheme` is now session-guarded like `dispose`:
  a visit replaced mid-asset-load (tab jump to another store) can no longer
  stamp its theme onto its successor.

**Cross-template duplication promoted** (the `QuantitySelection` shape):
`EditProfileForm`, `ChangePasswordForm`, `AddressFormFields` (which also
fixed gravia's address form accepting a 3-digit phone — both packs now run
`validateName`/`validateMobile`), `signOutAndReturnToLogin`, one
`AvatarSource` enum, `CordeliaAvatarImage.pickedBytes` (both avatar pickers
stopped composing throwaway entities).

**Dailymart layout promoted:** `DailyMartScreenBody` replaced seven private
`_Page` copies and eight hand-built floating-CTA stacks;
`floatingActionScrollInset` became a context method derived from the device
inset (the static 100 ran ~2 px short on notched phones);
`DailyMartSearchFieldBar` now composes `DailyMartSearchInput` (`bare` mode).

**Core additions:** `context.appShapes` accessor (23 hand-typed
`extension<AppShapes>()` lookups with three fallback spellings swept,
including core atoms and gravia-standalone); `AppBottomSheet` chromeless mode
(`showHeader: false` — the order-placed sheet and dailymart's confirm sheet
ride it instead of raw `showModalBottomSheet`, and the hand-drawn drag handle
recipe died); `HeroSearchFieldFlight` promoted to `core/ui/blocks/` with a
Widgetbook entry; the missing `AppRadioRow` gallery entry; one
pop-then-report contract across both packs' radio sheets.

**Violations fixed:** all nine `state is X` checks → exhaustive switches;
bottom insets on every state branch (ten screens' loading/error/empty
branches, plus three pushed routes with none at all: signup, gravia legal,
gravia search); gravia Profile + Notifications got skeleton bodies mirroring
their loaded layouts (spinners deleted) and Discovery a store-list skeleton;
`EditProfileBloc` got the `kIsWeb` short-circuit its siblings had;
`EditProfileError`/`NotificationsError` now carry retry context;
`OrdersBloc` no longer resets tab/filter/search when a warm-start refresh
lands; header-height literals became tokens
(`CordeliaDimenConst.authHeaderHeight*`, legal's `headerHeightCompact`).

**New skill (2026-08-01):** `/add-storefront-template`
(`docs/how-to/add-storefront-template.md`, both skill trees + Amazon Q) —
the whole dailymart-proven process as a repeatable recipe: Figma-MCP kit
sampling → theme preset + pack constants + spec-sheet contracts, frame
inventory against the implemented surface table (discard-and-record for
frames with no feature behind them), full end-to-end implementation over the
unchanged shared layers, the review + cross-pack promotion sweep, and the
doc/progress updates.

## grofast — third storefront template, first built by the skill — DONE (2026-08-03)

`/add-storefront-template` run end-to-end against the UI8 **GROFAST**
eCommerce Grocery kit (Figma `bpUABss9li4hSRt7NGPRN3`), producing cordelia's
third template over **zero** changes to the shared `domain`/`data`/`bloc`
layers. Full contract: `docs/ai-rules/style-packs/grofast.md`.

**Contracts first (Phase 1).** The `'grofast'` preset (light measured off the
Home / Product Detail / Bag / Search-Option frames, dark authored by dropping
the same forest ink to a canvas), `assets/theme/templates/grofast_theme_config.json`,
and the five `lib/templates/grofast/constants/` files. Two things make the
pack: `onSurface` is the kit's Dark-Green `#194B38` rather than a neutral, and
every affirmative control is one gradient (`#26AD71 → #32CB4B`) instead of a
flat `cs.primary`. It also pairs two families — Raleway from the preset,
Montserrat resolved at the call site for prices and numerics (cordelia gained
a direct `google_fonts` dep for that half).

**The four signature shapes** the kit is built on, all reproduced from
measured geometry rather than eyeballed: the **domed sheet** (top edge an arc
peaking 22 above its edges, the drag handle floating on the scrim above it —
one `ShapeBorder` so `AppBottomSheet` fills and clips both); the **domed
nav** (the bar's top edge lifting into a Ø82 dome with the active Ø64 gradient
disc concentric in it, animating as one movement); the **corner add button**
(53 × 41 welded into the product card's bottom-right, inheriting the card's 28
radius on that corner); and the **staggered grid** (two independent columns
where only the *first* card is short, which offsets the right column for the
rest of the scroll).

**Surfaces (Phases 2–3).** Every storefront surface ships: shell (Home /
Categories / Bag / Account), Home, All Categories, Category Details + filter
sheet, Search, Product Details (the dome flipped onto the hero's bottom edge),
Bag, Checkout + the domed "Success!" sheet, My Orders, Track Order with a
dated timeline, Select/Add/Edit Address, Profile, Edit Profile, Change
Password, Wishlist, Notifications, Privacy + Terms. No screen falls through to
another pack. Wishlist is this template's one **routed** surface where the
others give it a tab — `AppRoutes.wishlist` — because the kit reaches it from
Profile; the orders/track/checkout routes gained a real
`StorefrontTemplateSwitch` (gravia's branch maps to dailymart's page, which it
never reaches).

**Promoted to core**, both defaulted to prior behaviour and shipped with the
design-gallery entry: `AppButton.gradient` (a `ColorScheme` role holds one
colour; a pack whose CTAs are all one gradient can't express that) and
`AppBottomSheet.shape` (a sheet silhouette that isn't rounded corners —
`ShapeDecoration` when supplied, `BoxDecoration` otherwise), with
`showAppBottomSheet` forwarding `showHeader`/`shape`. Also `AppNetworkImage`
now dispatches an `.svg` URL to `AppSvgImage.network`, and
`ProductUnitTypeX.pricePerLabel` derives a price suffix from `format`.

**Deviations** — 18 kit details discarded for want of a feature or data
behind them (Scan tab, view toggle, vouchers, maps, saved payment cards, a
six-step delivery pipeline, product ratings, category item counts, …), each
recorded with its reasoning in the spec sheet §11 alongside the six surfaces
the kit has no frame for and which were composed from the pack's own recipes.

`flutter analyze` clean at the repo root; core/cordelia/jokes/ai_chat tests
pass (gravia's network-dependent widget tests and doc_scanner's
Firebase-init widget test fail identically with these changes stashed —
pre-existing, unrelated).

**Nav bar corrected against the kit's vector (2026-08-03).** The first pass
read the kit's boolean as a *subtraction* — a Ø82 hole cut through the bar
with the disc dropped into it. It is a **union**: the bar's top edge lifts
into a dome and the disc sits in it. Three things followed from re-measuring
the kit's own path (sampled over Figma MCP, then fitted against its rendered
alpha to 0.3px):

- **Tangent shoulders.** Neither the old cut nor a plain union gives them —
  the circle's tangent is vertical where it crosses the flat edge, so both
  leave a cusp. `GrofastNavBarClipper` now lifts the edge at 60.5 from the
  centre and runs a quadratic Bézier to the circle's tangent at 59°, control
  point at `r / sin(59°)`, which is tangent-continuous at both handovers.
- **Something behind it, and a shadow.** A white bulge on a white canvas has
  no silhouette, so neither shape was ever visible. Two fixes: the shell's
  `Scaffold` now runs `extendBody` (a new `BasePage.extendBody` hook in core,
  default `false`) so the tab's content passes behind the dome, with each tab
  paying `navScrollInset` re-derived from the nav height the body's
  `MediaQuery` now reports; and the bar carries its own shadow
  (`GrofastElevation.navBar`) so it separates from the canvas even where no
  content happens to be behind it. That shadow is painted, not elevated —
  `GrofastNavBarSurface` draws two blurred layers of the pack's green ink and
  then the fill from one path. Material `elevation` was tried first and
  doesn't work here twice over: a `ClipPath` can't cast a shadow, and
  `PhysicalShape` paints nothing at all without a child (its render object
  returns early), while the alpha `Canvas.drawShadow` derives is far too faint
  for white-on-white at this scale — the kit's own separation is a wide wash
  (~10% of the ink at the bar's edge, gone ~230 above it), not a lift.
- **One animation driver, and a centred label.** The dome, the disc and the
  label all read one `TweenAnimationBuilder` value instead of a tween plus a
  separate `AnimatedPositioned`. The label had been placed with an
  `Alignment` computed from the tab's centre, which positions a child by its
  *edges* — exact only for a zero-width child, so every real label sat short
  of its tab, pulled toward the bar's middle. It now centres in a fixed slot.

**Promo banner rebuilt as a split card, with a store-picked colour
(2026-08-03).** grofast's banner printed the copy over the artwork behind a
scrim, following the kit — but the kit's illustration is drawn *around* its
words and an uploaded photograph isn't, so the scrim muddied every store's
image and forced white copy. The card is now a 40/60 split: copy column, then
the photo. Three parts:

- **A new banner field, end to end** — `backgroundColor` (`"#RRGGBB"`, `""`
  for unset) on the Firestore banner doc, written from a colour picker in the
  admin's banner dialog (`ColorPickerField`, native `<input type="color">` +
  hex, no new dependency, with the swatch shown in the banners table),
  serialized as `background_color`, and parsed in `BannerModel.toEntity` into
  `BannerEntity.backgroundArgb` — an `int`, so `domain` stays free of
  `dart:ui`. Core gained the parser pair behind it (`String.hexColorArgb` /
  `int.asHexColor`), and `AppThemeConfig` now shares the same parse instead of
  keeping its own copy. Templates that print copy *over* the photo (gravia,
  dailymart) ignore the field; grofast falls back to `surfaceContainerLow`.
- **The carousel's geometry** — the first card sat inset well past the 30
  gutter, out of line with every other row on Home. Cause: the gutter was
  padding on each *page*, on top of `PageView` centring pages when
  `viewportFraction < 1`. The gutter now belongs to the viewport
  (`padEnds: false`, the whole `PageView` padded left), the gap belongs
  inside the page, and the page fraction is derived per width
  (`promoPageFraction`) because one absolute inset among proportional widths
  can't be a constant. Reproduces the kit exactly: card at x=30, 291 wide,
  next card at 339.
- **Type** — the banner's two lines are 800 weights, one per family
  (`promoTitle` Raleway 14/800, `promoAmount` Montserrat 28/800), both on
  `cs.onSurface`, which *is* the `#194B38` the kit specifies. Home's greeting
  is the pack's other 800 (`welcomeBold`, the kit's own `Text/Welcome Text`
  component rather than the `Text/Reguler/Big` token behind every screen
  title).

**Font weights were never real cuts — `TextStyle.atWeight` in core
(2026-08-04).** Bumping the greeting to 800 changed nothing on screen, and the
reason is systemic rather than grofast's: google_fonts binds a style to one
font **file** when the family resolves, and `AppTheme` resolves the preset's
family across the M3 scale, so each role arrives pinned to *its own* weight
(`headlineMedium` at w400). Every pack's tokens then did
`tt.<role>!.copyWith(fontWeight: w700)`, which changes the field but keeps the
regular file — the rasterizer fake-bolds it, and every weight above the role's
renders identically. Core now ships `TextStyle.atWeight`, which recovers the
plain family name google_fonts leaves in `fontFamilyFallback` and re-resolves
the real cut (falling back to `copyWith` for a bundled font, which carries its
own weights). grofast's Raleway tokens are converted; four tests in
`packages/core/test/extensions/` pin the behaviour, including the
copyWith-keeps-the-regular-cut case that is the actual bug.

**`dailymart` and `gravia` converted too (same day)** — every token in
`DailyMartTextStyleConst` and `CordeliaTextStyleConst` (which `gravia` aliases,
and which the app's own auth/discovery chrome also renders) now goes through
`atWeight`. The regular-weight tokens pass their role's *existing* weight
explicitly (`labelMedium` is w500, not w400) so nothing shifted except the
bolds, which now use the real cuts. All three spec sheets carry the rule in
§4.

**Product card corrections (2026-08-04).** Three, all from re-reading the
kit's own card against a real catalog:

- **The favourite heart is two circles, and the outer one is a state.** Not
  saved is a plain white Ø20 disc with an `error` glyph; saved fills that disc
  with `error`, flips the glyph white, and grows a detached `error` ring at
  Ø25 — at 15% alpha, which is the ink the kit's hairline actually lays down
  (measured on both card variants, `Card/Product/Tall` and
  `-favorite-disabled`). Before this the Ø25 was an opaque white disc in both
  states, so the unsaved heart was 25 wide instead of 20 and the ring never
  appeared at all.
- **The image well needed the padding the kit hides in its assets.** The kit's
  well is edge-to-edge because its artwork is a cut-out on transparency
  carrying ~20 of margin in the file; a store's rectangular photograph has
  none, so `contain` ran it to the card's edges. `productImageInset` (20) adds
  it back.
- **`/g` was a 500× lie.** `unitLabel` took the last word of the formatted
  pack size and dropped the amount, so a 500 g pack at $1.80 rendered
  "$1.80/g" — a per-gram price. `pricePerLabel` keeps the whole pack unless it
  is exactly one unit: `1000 g → /kg`, `1 pc → /pc`, but `500 g → /500 g`.

**grofast Bag rebuilt against kit frame `119:650` (2026-08-04).** Six
corrections, all from the kit's own Bag frame:

- **"3 items" moved onto the "My Bag" line**, where the kit puts it — it was a
  header-row trailing control, which read as something tappable.
- **The row's top-right control is the favourite heart, not a delete disc.**
  The kit's wide card carries the same heart the product card does (at 20),
  with its ring hidden in the unsaved variant — independent confirmation of
  the heart's two states. Deleting is now a **swipe** (`Dismissible` over an
  `error` panel with the trash glyph), matching `Card/Product/Wide+Delete`.
  The destructive action being the deliberate one is the point. The swipe is
  built the way dailymart's cart row already was — panel as a layer under the
  row inside one `ClipRRect`, `Dismissible.background` empty — since a panel
  passed to `background` is sized to the row and squares off outside the clip.
  Two templates shared that shape without sharing code until the extraction
  landed: core's `SwipeToDeleteRow` molecule now owns it (panel painted by
  its own Stack, `background` empty, `onDelete` for the optimistic commit or
  `confirmDismiss` for the deliberate one), and grofast's Bag row, dailymart's
  cart row and dailymart's address card all sit on it.
- **Every line that makes the total**, on core's `PriceBreakdown` with the
  coupon row in its `leading` slot — the same block Checkout already used. The
  Bag had shown a lone "Total" figure.
- **Coupon row**: `surfaceContainerLow` fill behind its dashed outline, which
  is now the ink at 20% (`#194B3833`) rather than `cs.outline`.
- **Apply pill radius 15**, the pack's one non-pill button — a full pill
  inside the rounded coupon row echoed the row's own curve at half the size.
- **Stepper buttons are white rounded squares (radius 8)**, not tinted discs.

**grofast's second radius (2026-08-04).** The kit softens by 5 for the two
surfaces that frame an image rather than being a card — the category tile's
tinted well and the cart / checkout / order line-item row — so
`GrofastDimenConst.tileRadius` (23) joins the theme's `cardRadius` (28), which
everything card-sized keeps. `GrofastCardSkeleton` gained a `radius` param and
the category skeletons pass it, so a loading state can't round differently
from what replaces it.

**grofast correction sweep, second round (2026-08-04).** Screen-by-screen
fixes against the kit's own frames, each fed back into the
`add-storefront-template` skill's Kit-fidelity rules (all three agent-surface
copies) so the next port ships them first-go:

- **Profile** — Dark Mode row (`GrofastMenuTile.trailing` + `AppSwitch` over
  `ThemeModeScope`); menu rows + quick tiles re-radiused to `tileRadius` 23.
- **Product Details** — corner-welded gradient dock (no safe area on the
  panel, opaque band, `GrofastBottomFade.overDock`), fractional hero
  (465/812), favourite inside the well, kit bag glyph + live cart dot,
  rating + category badges (`GrofastBadge`; `category` added to the product
  detail API end-to-end), `.large` stepper with `gradientEnd` glyphs.
- **Promo** — copy pinned to `promoInk` (#194B38) in both modes.
- **Addresses** — the kit's Select Location **sheet** (`showGrofastAddressPicker`,
  own `AddressBloc`, warm-cache instant) for all mid-flow picking (Bag,
  Checkout, Home's pill); the routed page is Profile's management surface on
  the same `GrofastAddressTile` (map placeholders cycled from
  `ImageConst.addressPlaceholders`), edit via an **authored** `edit.svg`
  (kit ships no pencil), delete by swipe on core's `SwipeToDeleteRow` with a
  static selection-ring overlay so only the contents slide.
- **Chips** — two species (`GrofastChip` 28 sheet pill vs `.big`
  `Button-Text/Big`, pinned 35 tall at `tileRadius`, Medium-Green
  `chipActiveInk`); every chip row a horizontal `GrofastChipRow`, never Wrap.
- **My Orders** — the Notification frame's layout (search → big chips →
  100-tall cards with the delivery line off `deliveryAddress`), a **date
  filter** square beside search (sheet on the shared `OrdersFilter`, active
  glyph while in force) — now a Phase-2 mandate for future packs.
- **Notifications** — the Orders layout minus search; chips = All + section
  titles; the same card with a kind-glyph disc in the image slot.
- **Header title** — the kit's `Header/Back and Text` is quiet Montserrat
  12/400 Dark-Grey (`cs.headerInk` computed role), not a bold title.
- **Track Order** — rebuilt to its three frames minus the map: the
  Status/Purchase-Date field pair (33h r13; Delivered = **brand gradient**),
  copy actions on order/payment id, the feed-style timeline (newest event on
  the tinted `Track/New` card, reached-only bullets on a rail whose indent
  is derived from the card's glyph geometry), kit Total row
  (`totalPriceScale`), neutral outlined Cancel over an opaque backing.
- **Forms pack-wide** — `fieldLabelInset` (9) applied inside
  `GrofastFormField`/`GrofastDropdownField` so every form inherits it.
- **Core** — `SwipeToDeleteRow` molecule (grofast Bag + dailymart cart +
  dailymart address card all sit on it, gallery entry shipped) and
  `GrofastBagAction` de-duplicating three header bag controls.

## Three-template utils/reuse sweep — DONE (2026-08-04)

The review that follows a third pack landing. Defects, de-templating,
consolidation, then a docs pass so the next port can *find* what now exists.

**Defects fixed.** grofast Product Details was the one screen with no pack
switcher and a skeleton that didn't mirror its loaded `Stack` — it jumped on
load and left the dock's device inset unpaid while loading; rebuilt on
`GrofastSwitcher` with a dock-silhouette skeleton. The nav Bag dot was
`showDot: true` in a `static const` tab list, so it was lit with an empty bag
— the list is now a method reading `CartCubit`. gravia rebuilt `ProfileBloc`
per Profile-tab visit (it sat in `buildBody`); hoisted to
`buildBlocProviders` like the other two packs.

**De-templating.** Notifications' `domain`/`data` took a
`StorefrontTemplate` through five files; they now take `storeId` + the
store's `template_id` wire string, so no feature holds the presentation
enum. `HomeBloc` took `storeId` twice (constructor *and* event) and stored
neither — it now holds it as a field like every sibling, and its three error
views retry with a parameterless re-dispatch instead of reaching back into
`ActiveStoreCubit`.

**Consolidation.** 12 `*_bloc_provider.dart` factories adopted at every call
site (~25 pages); `ChromelessStorefrontPage` mixin across 28 pages; a shared
`OrdersDateFilterState` mixin behind dailymart's and grofast's filter sheets;
`GraviaSwitcher`/`DailyMartSwitcher` so each pack's swap tier is one place;
grofast's 5 inline `_*SkeletonBody` classes moved to `widgets/` as public
pack-prefixed files; both `formattedPrice` wrappers deleted for `.asPrice`;
`IconInfoRow` and `AppButton` reclaimed two grofast forks.

**Then two follow-ups the sweep surfaced.** grofast's dark `secondary` had
been inverted to a near-white chip, making the promo row's Apply pill the
brightest thing on a dark Bag — pinned to the kit's Dark-Green `#194B38` in
both modes (its only consumer is that pill). And grofast shipped with **no**
`Hero` on its search field at all, despite `grofast.md`'s motion table
promising a `HeroSearchFieldFlight` Home ↔ Search flight — now wired, tagged
per store, with an inert shuttle and deliberately no tag on Category Details.

**Docs pass — the part that keeps this from recurring.** The sweep created a
lot of shared API that no agent-facing doc knew about, which is how the next
port re-hand-rolls it. Closed: `ScopedBlocCache` documented in
`design-tab-flow.md` (it existed in code but in zero docs — including *when*
to pick it over `BlocCache`); `architecture.md`'s core tree updated with ~20
missing files (the atoms/molecules added across the last three ports plus
`date_time_extensions`, `text_style_extensions`, `app_shadows_extension`);
`design.md` §2's catalog gained `AppSurfaceCard`, `BottomFade`,
`AppPickerField`, `ConfirmSheetBody`/`ActionSheetBody`, `ScreenBody`,
`ActionPair`, `HeroSearchFieldFlight`, `AppInlineTextLink`,
`LabeledDivider`; and `/add-storefront-template`'s three reuse shelves were
rewritten around what a template must now *provide* rather than build
(factories, mixins, scoped cache), plus a new Phase-4 **contract audit** —
grep every mechanism the spec sheet names, since Phase 1 writes contracts
before the screens exist and an unimplemented row fails nothing. All four
skill surfaces synced.

## Missing flows (fill these or explicitly defer)

> **Mostly closed — written in the first week (2026-07-18) and kept for the
> reasoning, not the status.** Of these 13, only #9 (search) and parts of
> #1/#2 are still open; the ✅ marks below were added later and some items
> closed without ever being marked. For what actually remains, read
> "Consolidated open items" at the end of this document instead of this list.

1. **Store onboarding** — how a creator signs up, creates a store, becomes its admin (roles/claims).
2. **Auth depth** — password reset, email verification, session persistence, shopper-vs-admin roles.
3. **Persistent cart** — today in-memory; must persist per-user-per-store and merge on login.
4. ✅ **Checkout + payment** — **DONE** (per-store Razorpay, server-side verified order write, test-mode web path). See "Checkout, per-store payments, and cancel/refund — DONE (2026-07-24)".
5. ✅ **Order lifecycle + cancel/refund** — **DONE** (status advance via admin dashboard; shopper + admin cancel with restock + auto-refund; admin manual refund). OTP is issued/displayed but agent-side verify isn't wired. Same section.
6. **Inventory/stock** — no stock field today; decrement in a transaction to avoid oversell; out-of-stock UI.
7. **Image hosting** — Cloud Storage upload vs. image URLs in the Excel import.
8. **Import validation** — schema/column mapping, dedupe, upsert-vs-replace, error reporting.
9. **Search** — across-stores + within-store; Firestore text search is weak (searchKeywords[] for MVP, Algolia/Typesense later).
10. **Security rules** — multi-tenant isolation is critical and easy to get wrong.
11. ~~Marketplace settlement~~ — **dropped** under the SaaS decision (platform never collects shopper money). It was replaced at the time by **store-owner subscription billing** as a later console-side track; that has since been **dropped too** (see "Decisions locked in" above, 2026-08-07). The platform charges stores nothing, and the public pricing page now says so — so there is no billing work pending, only a decision already made.
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

**Realistic MVP: ~7–9 weeks solo** (SaaS trims the marketplace payout work).

> **Superseded (2026-08-07).** This paragraph originally ended by naming
> store-owner **subscription billing** as a separate later console-side track.
> There is no such track: the platform charges stores nothing, the landing
> page's pricing section commits to that publicly, and if billing ever returns
> it is a fresh decision rather than a deferred one.

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
| `GET /search?q=` | with `q`: `{ products: [...], categories: [...] }` name-match on both; without: `{ recent_searches: [...], popular_products: [...] }` — recents read per `userId` from `users/{uid}/recentSearches/{storeId}` (empty when no `userId`) |
| `POST /search/recent` | `{ userId, item: {id,name,type} }` — records a tapped result (`type`: `product`\|`category`); server prepends, dedupes by (type,id), caps at 10; returns `{ recent_searches: [...] }` |
| `DELETE /search/recent?userId=&id=&type=` | removes one recent; returns the updated `{ recent_searches: [...] }` |
| `GET /api/users/addresses` *(store-agnostic, token-authed)* | `{ addresses: [...] }` — the verified shopper's saved addresses, snake_case matching gravia's `AddressModel` |
| `POST /api/users/addresses` | creates from `{name, phone, address_line1, address_line2?, landmark?, city, country, postal_code, tag, is_default?}`; server assigns the id and forces the shopper's **first** address to `is_default: true`; returns `{ address }` (201) |
| `PUT /api/users/addresses/{addressId}` | whole-address replace (the form always submits every field); 404 on unknown id; returns `{ address }` |

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

## Shopper-auth trust gap closed — all shopper routes token-verified — DONE (2026-07-22)

The cart/order/favourites/search routes above accepted a plain `userId`
string, "trusted as-is" — the deliberate placeholder for M1b. Now that gravia
has real Firebase auth (see the 07-22 note at the top), that gap is closed on
**both** sides: every per-user shopper route derives the uid from a verified
Firebase ID token, and gravia sends `Authorization: Bearer <idToken>` instead
of a `userId` param. **No route reads `userId` off the request anymore** — one
shopper can no longer read or overwrite another's cart, orders, favourites, or
recent searches by passing a different id.

- **`admin/src/lib/api/admin-guard.ts`** — two helpers added beside the
  existing `requireAuthedUser`/`requireStoreOwner`:
  - `verifyIdToken(request)` → `{ uid, storeIds }` — verifies the token and
    returns its `storeIds` custom claim **without** the legacy-admin Firestore
    backfill `requireStoreOwner` does. Used by the dual-mode order-list route so
    a plain shopper reading their own history never gets an empty `storeIds`
    claim silently stamped onto their token.
  - `optionalAuthedUser(request)` → `uid | null` — soft variant that returns
    null for an anonymous caller instead of throwing, for the Search screen's
    recents (a signed-out shopper still sees popular products, just no recents).
- **Routes swapped** (`admin/src/app/api/stores/[storeId]/`): `cart` (GET/PUT),
  `favourites` (GET/POST/DELETE), `orders` (GET/POST), `search` (recents branch,
  optional), `search/recent` (POST/DELETE). Missing/invalid token → 401 on the
  hard routes; the `orders` GET now distinguishes store-owner (all orders) from
  shopper (own orders) by the **verified token's role**, not a client flag —
  the un-spoofable version of the old `userId`-presence branch. The admin-only
  `orders/[orderId]` PATCH already used `requireStoreOwner` and was untouched.
- **gravia data sources** (`cart`, `orders`, `favourites`, `search`) now send
  the bearer token — matching the address/profile pattern already in the app —
  and dropped the `userId` param/body field. The signed-out degrade is
  preserved (null token → empty cart/orders/favourites, recents no-op).
- **Verified live**, not just compiled: `flutter analyze` clean on gravia,
  `tsc`+`eslint` clean on admin, then a Node script signed up **two** throwaway
  Firebase shoppers via the real Identity Toolkit REST API, booted the admin
  dev server, and ran 19 checks against the real "Gravia" store — every auth
  gate (no token / garbage token → 401; POST without token → 401; the anonymous
  search still 200s with empty recents) **and cross-user isolation** (A writes a
  cart/favourite/recent; B with a different token sees none of them; A re-reads
  and its own data persists). All 19 passed; both throwaway users and A's test
  data deleted afterward (same clean-up discipline as the earlier rules tests).

**Still not deployed** — same blocker as the section above: the admin changes
ride on the un-pushed `e86dabd` work and need the `FIREBASE_ADMIN_*` env vars
in Vercel to run in production. Deploy the admin API and ship gravia together:
old gravia (sending `userId`, no token) would 401 against the new routes, so
they must not go live independently. gravia isn't store-published, so its
running instance always tracks latest — the ordering only matters for the
production API cutover.

## Checkout, per-store payments, and cancel/refund — DONE (2026-07-24)

Closes **Missing flow #4 (Checkout + payment)** and **#5 (order lifecycle,
cancel/refund)**. The end-to-end money path now works: shopper pays into the
**store's own** Razorpay account, the server verifies the payment before
writing the order, and both the shopper and the store owner can cancel with a
refund.

**Per-store Razorpay (the SaaS monetization model, made real).** Each store
holds its own credentials — `stores/{id}/private/payment` (a `private`
subcollection locked `read,write:if false`, reachable only by the Admin SDK).
The `keyId` is public (ships to the checkout sheet); the `keySecret` is
**encrypted at rest** (`admin/src/lib/crypto.ts`, AES via `PAYMENTS_ENC_KEY`)
and only ever decrypted server-side to sign order-creation and verify/refund
calls. Owners set keys on `/dashboard/settings` (`payment-config` API). The key
**prefix** (`rzp_test_` vs `rzp_live_`) is the source of truth for test-vs-live:
a live store must present a verified payment before an order is placed; a test
store may place a **payment-less** order — the web-preview path, which can't run
the native checkout SDK.

**Checkout flow (gravia).** `CheckoutBloc` (in `feature/cart/`, since it's a
cart CTA) orchestrates: `POST /payments` (server prices the cart from the live
catalog and creates the Razorpay order with the store secret) → native Razorpay
checkout via `RazorpayService` → `POST /orders` with the `razorpayOrderId/
PaymentId/Signature`, which the server **verifies** (`verifyPaymentSignature`,
constant-time HMAC) before writing. On web (`kIsWeb`) it skips straight to a
test-mode payment-less order. Provider-agnostic by construction: the orders
feature has **two** repositories — `OrdersRepository` (own backend) and
`PaymentGatewayRepository` (the PSP, seen only as "take this intent → verifiable
result"). "Razorpay" appears in exactly one file
(`razorpay_gateway_data_source_impl.dart`); swapping PSPs is a data-source-impl
change.

**Order lifecycle + refund axis.** Status stays `PENDING → IN_PROCESS →
DELIVERED` + `CANCELLED` (wire values unchanged); `IN_PROCESS` is **relabelled
"On the way"** in both UIs. Refund is a **separate axis** — `refundStatus`
(`NONE|PENDING|PROCESSED|FAILED`) + `refundId` on the order — so a cancelled
order records separately whether its money was returned. `RefundStatus` mirrors
across `admin/src/lib/types.ts` and gravia's `enums/order_status.dart`.

**Cancel + refund.**
- *Shopper self-cancel* (pre-dispatch only — `PENDING`/`IN_PROCESS`): gravia
  `OrdersBloc` cancels **optimistically** (card flips to Cancelled, refund
  shown pending) then reconciles with the server order, or rolls back + toasts
  on failure. Server route `POST /orders/{id}/cancel` is **dual-role** (the
  order's own shopper *or* the store owner), runs a transaction that sets
  `CANCELLED` and **restocks** every line item, then settles the refund.
- *Admin cancel*: the dashboard `/dashboard/orders` Cancelled selection routes
  through the same server path (a client `updateDoc` can't refund — needs the
  secret), behind a confirm dialog.
- *Refund settlement* is one idempotent, never-throwing helper
  (`admin/src/lib/refunds.ts` `settleRefund`): creates a Razorpay refund only
  when none exists (`refundId` empty), otherwise **refreshes** the existing
  one's status — so it can't double-refund; on provider failure it returns
  `FAILED` (retriable) instead of 500ing and stranding the order in `PENDING`.
- *Admin manual refund*: `POST /orders/{id}/refund` (owner-only) + a
  **"Complete refund"/"Retry refund"** button on the dashboard for any
  cancelled order whose refund is `PENDING`/`FAILED` — the recourse when the
  auto-refund didn't settle.

**Verified**: `flutter analyze` clean on gravia; `tsc`+`eslint` clean on admin;
gravia orders BLoC tests 7/7 (incl. optimistic-reconcile and rollback cases).

**Refund webhook + idempotency — DONE (2026-07-24, same track).**
- **Per-store webhook** `POST /api/stores/{storeId}/webhooks/razorpay` —
  signature-verified against the store's own **webhook secret** (a new
  encrypted field on `stores/{id}/private/payment`, set on `/dashboard/settings`
  alongside the keys via `setStoreWebhookSecret`; `verifyWebhookSignature` HMACs
  the raw body). Handles `refund.processed`/`refund.failed`: finds the order by
  `razorpayPaymentId` (`getOrderByPaymentId`) and flips `refundStatus` — so a
  refund Razorpay accepts as pending settles to PROCESSED **automatically**, no
  admin click. Irrelevant events + unknown payments are acked 200 (no retries).
- **Refund idempotency** — `settleRefund` now calls `getExistingRefund`
  (`GET /payments/{id}/refunds`) before creating: if Razorpay already has a
  refund for the payment (e.g. a create that succeeded before we persisted its
  id), it **adopts** it instead of creating a second. Closes the double-refund
  window (the Refund create API has no idempotency-key header, so existing-
  refund lookup is the correct guard).
- **Webhook verification test** — `admin/scripts/test-refund-webhook.mjs`
  (`npm run test:webhook`) signs sample `refund.processed` payloads the way
  Razorpay does and POSTs them to the live route, asserting valid signatures are
  accepted and tampered/wrong-secret/missing ones are rejected (401). Default
  run is non-destructive (synthetic payment id → acked, no writes); pass
  `PAYMENT_ID=<real cancelled order>` to assert an actual flip to PROCESSED.

**Remaining on this track:**
- **Deploy** — *(update 2026-07-28: `PAYMENTS_ENC_KEY` + `FIREBASE_ADMIN_*`
  are now confirmed set in Vercel — `.env.local` was produced by
  `vercel env pull` and carries all of them — so the blocker is only the
  un-pushed work + prod cutover itself)*; the
  `stores/{id}/private/payment` rule (`read,write:if false`) still needs its
  deploy checked alongside. Webhook delivery
  needs the admin API live (Razorpay must reach a public URL).
- **Return/refund after delivery** — today refund is only wired to cancel;
  a post-delivery return flow (often partial) isn't built.

## PRODUCT_SPEC + catalog depth (brands, size variants) — admin side DONE (2026-08-04)

**`docs/PRODUCT_SPEC.md`** now exists — the store-owner-facing scope contract
(pitch: no commission, instant publish inside the already-listed Cordelia app,
template choice; capability matrix of every shopper + admin surface marked
✅/🚧/🗓; committed roadmap order: catalog depth → coupons → reviews →
per-store notifications). New feature work should update its matrix in the
same commit.

**Catalog depth — admin half shipped** (storefront half deliberately not
started; the wire format already carries everything it will need):

- **Brands** — `stores/{id}/brands` subcollection (`name`, `logoUrl`),
  world-readable / owner-writable in `firestore.rules`, logo uploads under
  `{storeId}/brands/**` in `storage.rules` (both **need a rules deploy**).
  `lib/brands.ts` mirrors categories; new `/dashboard/brands` page (table +
  dialog, delete warns about dangling references); products carry **`brandId`
  only** — name/logo resolve at read time (Banner-`targetId` rationale: a
  rename can't leave stale copies). Product form gains a brand `Select`
  (`"none"` sentinel ↔ `""`), products table a resolved Brand column. API:
  public `GET /api/stores/{id}/brands` (`serializeBrand`, id/name/`image`
  shape), `serializeProduct` adds `brand_id`, and the product-details route
  resolves a full `brand` object (null when unbranded/dangling) beside
  `category`.
- **Size variants** — `sizeOptions: number[]` (values only, price implied
  linear) grew into `sizeVariants: [{value, price, originalPrice}]` as the
  form's source of truth; `sizeOptions` is **derived from it on every save**
  so pre-variant storefront readers keep working unchanged. Legacy docs
  upgrade on read: `scalePriceToSize` (base price × size/unitValue, 2-dp)
  synthesizes variants, persisted next save. The form's comma-separated
  input became a variant editor — per-row size/price/original with the
  scaled suggestion as placeholder (empty field = charge the suggestion),
  per-row derived discount %, rows sorted ascending on save. Stock stays
  product-level until order lines carry a variant. API: product-details adds
  `size_variants` (`serializeSizeVariant`, discount via the shared
  `computeDiscountPercentage`) alongside the legacy `size_options`.

**Next on this track (storefront half):** `BrandModel`/`SizeVariant` in
cordelia's shared data layer, brand label on cards/details + brand search
facet, "Select QTY" chips driving price from the selected variant, cart lines
carrying `sizeValue`, and server-side order creation re-resolving variant
prices (client never dictates totals) — then per-variant stock becomes
worth modelling.

## Catalog depth — storefront half DONE (2026-08-04)

The size-variant + brand data the admin half (previous section) started
writing now flows end-to-end through `cordelia` and the order pipeline. All
three templates, `flutter analyze` clean workspace-wide, cordelia's 11 tests
green, admin lint/tsc/build green.

**Shared layers (one change, every template inherits):**
- `SizeVariantEntity`/`BrandEntity` + models in `product_details`;
  `ProductDetailEntity.sizeOptions: List<double>` **replaced** by
  `sizeVariants` (+ nullable `brand`). The repository upgrades legacy
  `size_options`-only responses to priced variants (linear scale — the same
  rule as the backend), so screens always see one shape and never price a
  size themselves.
- **Cart lines are (product, size).** `CartItemEntity` gains
  `sizeValue`/`unitPrice`/`originalUnitPrice` (null = base pack;
  `effective*` getters fall back to the product) and `CartCubit`'s ops take
  an optional `sizeValue`. Exact (product, size) match first; a null-size op
  that finds no base-pack line falls back to the product's first line — so
  card steppers/quick-adds, which don't know about sizes, operate on "this
  product's line" instead of growing a phantom base-pack line.
- `ProductDetailsActions` (the cross-template mixin) owns size-selection
  state: `selectedSizeIndex`/`selectSize`, `effectiveSizeIndex` (defaults to
  the variant matching the product's own pack, so the page opens priced like
  the card that led there), and `addSelectedToCart`.
- Wire: cart PUT and order/payment `items[]` gain `sizeValue` (omitted for
  base pack); cart GET/PUT responses gain per-line
  `size_value`/`unit_price`/`original_unit_price`.

**Server (the price authority):** `resolveLinePricing` in `lib/products.ts`
— one function the cart join, `priceCart` (payment intent), and
`createOrder` all resolve a (product, sizeValue) through, so what the
shopper sees, is charged, and is recorded can never disagree. A carted size
the admin later removed degrades to the linearly-scaled price rather than
failing. Order lines' `weight` now formats the pack actually sold. Also
fixed while there: **per-product stock aggregation** in
`priceCart`/`createOrder`/`cancelOrder` — two lines of one product
(different sizes) previously issued two `tx.update`s on the same doc, the
second silently clobbering the first's decrement/restock.

**Cart-totals bug fixed:** `CartItemsX.itemTotal` summed *selling* prices
while `grandTotal` subtracted the discount from it again — every summary
and "N items | ₹X" pill understated what checkout actually charges.
`itemTotal` is now the original-price (MRP) sum, so
`grandTotal = itemTotal − discountTotal` equals the server's charge exactly.

**Template UIs** (deviations recorded in each spec sheet §2/§10, since all
three kits predate sizes-with-prices and brands):
- **gravia** — "Select QTY" chips now drive the price row, discount meta
  chip, and bottom bar; brand as a muted Text/xs line above the name; cart
  rows show the line's pack size and pass `sizeValue` to the steppers.
- **dailymart** — new "Select Size" row reusing My Orders'
  `DailyMartFilterChip` recipe; brand line above the name; `_PriceLabel`'s
  `₹X /pack` follows the selection; `DailyMartProductListTile` gains
  `unitPrice`/`packSize` overrides (cart cards + Checkout's Order List);
  swipe-row keys are per-line, not per-product.
- **grofast** — "Select Size" title + the pack's `GrofastChipRow`;
  `GrofastPrice` and its `pricePerLabel` suffix follow the selection; brand
  joins the title's label pills as a `GrofastBadge` (logo or
  `Icons.sell_rounded`); Bag rows show the line's pack and scope
  swipe/stepper to (product, size); Checkout item rows show the sold pack.

**Not done on this track:** brand as a search/browse facet (needs a
brand-filter axis on the shared search/category blocs — do it with coupons'
filter work or as its own slice), and per-variant stock (deliberately
product-level until there's a reason to split it).

## Coupons — DONE end-to-end (2026-08-04)

Roadmap item 2 (PRODUCT_SPEC): store-scoped discount codes, validated and
priced **only** on the server, applied from every template's promo row.
Workspace analyze clean, cordelia's 11 tests green, admin lint/tsc/build
green, firestore rules deployed.

**Schema** — `stores/{id}/coupons`: `code` (uppercase, unique per store),
`type` percent|flat + `value`, `scope` store|category|product +
`targetIds[]` (the banner-target pattern, multi-select), `minOrderValue`,
`maxDiscount` (percent cap), `validFrom/Until` (ISO, "" = open),
`usageLimit`/`perUserLimit`/`usedCount`, `isActive`. Per-shopper counts in
`coupons/{id}/redemptions/{uid}`, written only inside the order
transaction. Rules: owner-only read/write (NOT world-readable — shoppers
go through the token-verified API), redemptions server-only.

**Admin** — `/dashboard/coupons`: table (code, discount label, scope,
used/limit, active badge) + dialog (type/value, percent cap, scope with
category/product checkbox picker, min order, datetime-local validity
window, limits, active), client-side duplicate-code guard. `usedCount` is
deliberately not form-writable.

**Engine** (`admin/src/lib/coupon-engine.ts`) — one authority:
`eligibleSubtotal` (scope over size-variant-resolved lines),
`assertCouponUsable` (active/window/limits/floor/eligibility, shopper-facing
messages), `computeDiscount` (percent-with-cap or flat, clamped so the
payable amount stays ≥ ₹1 — the gateway minimum), and `previewCoupon` (the
whole non-transactional pipeline). Consumers:
- `POST /coupons/validate` — the Apply preview (token-verified; reserves
  nothing).
- `POST /payments` — intent amount = priceCart − previewCoupon discount.
- `createOrder` — re-runs every check on **transaction-consistent**
  coupon/redemption reads, so a code racing to its limit fails the order
  instead of over-redeeming; counts `usedCount` + `redemptions/{uid}`
  atomically with the order write; order records `couponCode` +
  `couponDiscount`, `total` net of it (serializer: `coupon_code`/
  `coupon_discount`). CouponError → 400 with the reason as the message.

**Cordelia** — coupon slice inside `feature/storefront/cart/`
(`AppliedCouponEntity` {code, discount}, validate usecase/repo/data source
posting the same items payload as orders) + app-root `CouponCubit`
(sealed None/Applying/Applied/Failed — Failed keeps the entered code, the
retry-context rule). Lifecycle: cart mutations **revalidate** the applied
code via BlocListener<CartCubit> on the cart screens (a discount never
lingers on lines it wasn't priced for), storefront entry / sign-out /
order-placed reset it, and checkout sends only the code
(`CheckoutEvent.submitted.couponCode` → both use cases → wire).

**Template UIs** — each pack's existing promo-row silhouette went live
(collapsed TextField inside the pack's own chrome, Apply ↔ Remove, server
reason under the row): gravia's bordered pill (cart summary), dailymart's
recessed strip (cart summary), grofast's dashed voucher row (Bag **and**
Checkout). Applied coupons add a `Coupon (CODE)` line to the
PriceBreakdowns and the shown grand total nets the discount — the same
figure the server charges.

**Not done on this track:** admin-side coupon analytics beyond used-count,
and surfacing `coupon_code`/`coupon_discount` on the shopper's order
details/track-order screens (the data is on the wire already).

## Post-coupon polish + verification status (2026-08-04)

**Verification status of the two catalog-depth/coupons tracks:**
- **Coupons — verified working end-to-end** (admin CRUD → Apply on the
  storefront promo rows → discounted totals → order records the code).
- **Brands — implemented but not yet seen working in any template.**
  Expected, not a defect: the storefront's only brand surface is the
  Product Details brand line/pill, which renders **only when the product
  doc carries a `brandId`** — i.e. after the store owner creates brands on
  `/dashboard/brands` and re-saves products with a brand picked. No
  seeded product has one yet. Verification pass still owed once data
  exists; if the line still doesn't render then, treat it as a bug.

**Pinned back-button headers (dailymart + grofast).** Both packs' §8 scroll
contracts changed from "everything scrolls away" to "back-button headers
pin": `DailyMartScreenBody`/`GrofastScreenBody` gained a `pinnedHeader`
mode that **auto-pins exactly when the header carries a back control**
(title+onBack / showBack), leaving tab roots and custom headerRows
scrolling; grofast Search + Category Details opt their back-carrying
headerRows in explicitly; dailymart Product Details' `_Page` and Legal
pinned by hand (Column → docked header → Expanded scroll); grofast Product
Details pins its floating header row in the screen's outer Stack over the
scrolling hero (controls carry their own fills), skeleton included. Spec
sheets §8 updated.

**Coupon on Track Order + order cards.** `OrderEntity`/`OrderModel` now
parse `coupon_code`/`coupon_discount` (the API already sent them) and gain
`payableTotal` (line-item sum net of the coupon — the server's recorded
charge). dailymart Track Order shows a Coupon row in Payment and its
Amount-paid is coupon-net; grofast Track Order adds a Coupon detail row
and its Total row is coupon-net; **all three templates' order cards**
switched from the raw item sum to `payableTotal` so list and detail agree.

**Fix batch, each fed back into the shared rules where generic:**
- Grofast Apply pill label invisible in light mode — `AppButton` lets a
  `labelStyle`'s inherited theme ink win over `foregroundColor`; label
  colour now re-pinned to `onSecondary` on the style. → new forbidden
  pattern (all 4 rule surfaces).
- Coupon promo fields drew the pack input border inside their own chrome —
  the theme's `inputDecorationTheme` injects borders even into
  `InputDecoration.collapsed`; all four border states now stripped
  explicitly. And the raw fields didn't unfocus on outside tap —
  `onTapOutside` unfocus added (AppTextField's own rule). → one combined
  forbidden pattern (all 4 rule surfaces).
- Grofast Profile's My Orders quick tile still wore the kit Voucher's
  gift.svg — now `Icons.receipt_long_rounded` (the pack's Material-rounded
  menu-row system; it ships no order/receipt SVG).

**Deploy note.** The Flutter app points at the deployed Vercel admin
(`ApiConstants.baseUrl`); everything on these tracks (brands, variants,
coupons routes + engine) must be deployed there for the app to see it.
Firestore + Storage rules for brands/coupons are already deployed.

---

## Product reviews — DONE end-to-end (2026-08-04)

Shopper-written product reviews, live in all three templates and moderated
from the admin console. Workspace analyze clean, cordelia's 11 tests green,
admin tsc + eslint clean. (The one failing test in the repo,
`apps/doc_scanner/test/widget_test.dart`, predates this work — verified on a
clean tree.)

**Eligibility, as the product owner scoped it:** a *product review* is open
to **any signed-in CordeliaApps user**, bought or not. Rating a **delivered
order** is a separate feature and is **not** built here — gravia's Orders
card keeps its "Write A Review" coming-soon snackbar, since that button
belongs to order rating. The purchase check still runs: the server derives
`verifiedPurchase` from the reviewer's delivered orders and every template
badges it, but it gates nothing.

**Schema** — `stores/{id}/products/{productId}/reviews/{uid}`. The doc id
**is** the reviewer's uid, so a shopper has at most one review per product:
posting again edits theirs (no duplicate-spam check needed), and "have I
reviewed this?" is a single get rather than a query. Fields: `rating` (1–5
int), `text` (optional — a star-only review is a real review), `userName` /
`userAvatarUrl` snapshotted from `users/{uid}` at write time (rendering N
reviews would otherwise cost N profile reads), `verifiedPurchase`,
`createdAt`/`updatedAt`, plus denormalized `storeId`/`productId` so the
dashboard's store-wide list is one collection-group query.

**Aggregates live on the product doc** — `ratingAverage`, `reviewCount`,
`ratingBuckets` (per-star 1→5) — and move in the **same transaction** as
every review write/edit/delete, which is why reviews are server-only in
`firestore.rules` (world-readable, `allow write: if false`). Two
consequences worth keeping: product docs are already loaded by every grid,
so a card prints a rating with **zero** extra reads; and the buckets are
stored rather than derived because a plain average cannot draw dailymart's
five-bar histogram. The running sum isn't stored — it's the buckets'
weighted total, so the average can never disagree with the histogram beside
it. Aggregates move by *delta* (remove the old star, add the new), never by
re-reading the subcollection.

**API** — `GET/POST/DELETE /api/stores/{id}/products/{productId}/reviews`
(GET public; POST/DELETE token-verified and always scoped to the caller's
own uid) plus the owner-gated `GET /api/stores/{id}/reviews` and
`DELETE /api/stores/{id}/reviews/{productId}/{uid}` for moderation.
`serializeProduct` gained `rating_average`/`review_count`; the
product-details payload gained `rating` + the first 10 `reviews`, so a
details screen still opens in **one** call. New composite index:
`reviews` COLLECTION_GROUP on `storeId` + `createdAt` desc.

**Admin** — new `/dashboard/reviews`: date (with an "edited" line when the
two timestamps differ), product, customer + verified badge, star row, text,
delete-with-confirm. Fetched over the owner-gated route rather than the
client SDK the other pages use — a collection-group query would need its own
`/{path=**}/reviews/{uid}` rule, and deleting has to move the aggregates
transactionally anyway; the trade is that this one list isn't live, which a
moderation view can afford. Products table gained a Rating column, and
`ProductInput` excludes the aggregates so the product form can never write
them (the `CouponInput`/`usedCount` precedent).

**Cordelia** — one shared `feature/storefront/reviews/` slice (entities,
repository, three use cases, `ProductReviewsBloc`) with per-template
presentation. The bloc is **seeded, not fetched**: the details payload
already carries the first page, so `ProductReviewsEvent.seeded` paints the
section with no second request; every *write* then reloads from the reviews
endpoint rather than patching the seed, because a new review changes the
list's order and the histogram too. The provider wraps the whole screen (not
just the section) — the write sheet is opened from the screen's own
`BaseScreenState`, which has to be under it to dispatch.

**A write refreshes the product silently.** The rating beside a product's
name (dailymart's pill, grofast's badge) reads the *product doc's*
aggregates, which the reviews bloc's own reload can't touch — so a completed
write also dispatches `ProductDetailsEvent.refreshed`, which re-reads the
product **without** emitting `loading`. That's the whole point: the shopper
is looking at a page they just interacted with, and dropping to the skeleton
over it would read as the screen resetting. A silent refresh that *fails*
also emits nothing, leaving the good page alone rather than replacing it
with an error view. All three templates' loaded branches satisfy
`Widget.canUpdate` across the re-emit (same type, same key), so their
switchers repaint in place instead of crossfading, and the size/quantity
selections survive because they live in screen state, not the bloc.

The signal rides on `ProductReviewsLoaded.afterWrite` rather than the screen
remembering a write was in flight — the bloc is the one thing that knows
what just happened. Its companion is a guard in `_onSeeded`: seeding is
first paint, not a reset, so the refreshed details payload (whose review
list is only the first page) can't truncate a longer list the section had
already reloaded.

**Per-template:** dailymart's kit frame `23 Review product` went from
entirely static to entity-driven with its geometry unchanged (bars now fill
to each star's *share* of the reviews); gravia and grofast, whose kits draw
no reviews frame, got sections composed from recipes those packs already
owned. All three gained a write/edit sheet over the shared
`WriteReviewForm` mixin, and a Delete on the shopper's **own** row only.
Every "unrated" state says so rather than printing `0.0` stars, which reads
as *badly reviewed* instead of *unreviewed*.

**Three things this quietly fixed.** `ProductSortOption.ratingHighToLow` was
a dead option in gravia's and dailymart's sort sheets (it fell through to
`break`) — it now sorts, and grofast's filter sheet, which had omitted it on
purpose, offers it. The two remaining pieces of invented copy in the packs
(`DailyMartValueConst.staticRatingLabel`, `GrofastValueConst.staticRatingLabel`)
are deleted. And `CordeliaFormField`/`DailyMartFormField` gained the
`maxLines` passthrough grofast's field already had.

**Promoted to core:** `RatingStars` (fractional — an average lands between
stars) and `RatingStarsField` (whole-star input), both with gallery entries.
`GraviaActionButton` was extracted from `GraviaActionPair`'s private
`_button` so a single action renders the same pill as a paired one.

**Deploy note.** Same as the coupons track: the new routes must reach the
Vercel admin, and `firestore.rules` + `firestore.indexes.json` need
deploying (the collection-group index especially — the dashboard's Reviews
page 500s without it).

**Still open:** order rating (the delivered-order button), review
pagination beyond the first 50, and owner replies.

---

## Order rating + gravia Track Order — DONE (2026-08-04)

Two things, both following from the product-review track: rating a
**delivered order** (the feature product reviews deliberately are *not*), and
gravia's own Track Order, the last surface where one pack fell through to
another's screen.

### Order rating

The second half of the split the product owner drew: a **product** review is
open to any signed-in shopper, bought or not; rating an **order** judges the
delivery, so only the shopper who placed it can rate it, and only once it is
`DELIVERED`.

**Schema** — `rating` / `reviewText` / `reviewedAt` on the order doc, not a
subcollection: strictly 1:1 with the order, and the dashboard already reads
that doc. `rating: 0` is unrated, which covers every order placed before this
shipped.

`rateOrder` is transactional for its two gates (yours, and delivered *when
the write lands*) — without it a cancel racing in could leave a rating on an
order that never arrived. `OrderRatingError` carries its own HTTP status, so
the route maps 400 (bad rating) / 404 (not yours, answered exactly as a
missing order) / 409 (not delivered) without re-deriving intent from a
message. `POST /api/stores/{id}/orders/{orderId}/review` is shopper-only —
no store-owner branch, unlike cancel: an owner rating their own store's
delivery would be fabricating customer feedback.

**App** — `OrdersEvent.rated` writes straight through (not optimistic, unlike
cancel: nothing moves in the list, and a rating that silently reverted would
be worse than one that took a moment), reconciling to the server's order so
`reviewedAt` is authoritative. `rateFailed` joins the existing one-shot
listener flags. All three packs offer it: gravia's order card (its
"Write A Review" button finally does something) and every pack's Track Order,
where the slot that holds Cancel while an order is coming asks how it went
once it has arrived. A cancelled order gets neither.

**Three consolidations rather than copies:** `WriteReviewForm` now takes
`initialRating`/`initialText` instead of a `ReviewEntity`, so **one sheet
body per pack** serves both product and order rating; `OrdersState.freshest`
was promoted out of grofast once dailymart needed it; and three pages that
hand-built `OrdersBloc` adopted the `ordersBlocProvider` factory that existed
for exactly that.

**One documented design change.** dailymart's Track Order had *no* bloc by
design (it pops the order id back for cancel). Rating needs one, so it now
gets `ordersBlocProvider` — cancel still pops, because that update is
optimistic and belongs to the list's bloc, while rating has nothing to
reconcile. Its class doc said "static, no BLoC" and was corrected rather than
left lying.

### gravia Track Order

`/track-order` routed gravia to **dailymart's** screen and gravia's own
Track Order / View Details buttons were `comingSoon` — so the last two
`comingSoon` stubs on that card are gone, and no gravia flow ends in another
pack's visual language. The kit draws no frame for it, so the screen is
composed from recipes the pack owns: `CollapsingHeaderSheet` +
`GraviaHeroHeader`, the order card's `OrderLineItemRow`, the Cart's
`PriceBreakdown` (coupon-aware), and hairline-divided sections. **View
Details** opens the same screen — Track Order *is* the details view; a second
screen saying the same thing would differ only by which one has a live
status.

`GraviaOrderStatusTimeline` renders the three statuses the backend actually
has (two for a cancelled order), dated from `statusHistory`, undated rather
than guessed where the server predates that field. `GraviaOtpDigits` was
extracted from `OrderCard`'s private `_OtpDigitBox` so both draw the same
discs. gravia also gained a routed `OrdersPage` (it only had the shell tab),
so the "My Orders" / "Track Your Order" jumps no longer land in dailymart's
list on the way.

### Admin: one Reviews page, two subjects

`/dashboard/reviews` gained a **Products / Orders** segmented switch beside
Refresh. The two are genuinely different subjects, so they get their own
columns and their own fetch rather than one merged table with half the cells
empty per row: product reviews are public and moderatable (Delete stays),
delivery ratings are private feedback identified by their order (id, date,
total) with **no** Delete — removing feedback nobody else can see would only
destroy the store's own signal. `GET /api/stores/{id}/reviews?type=order`
serves the second, and the page fetches on switch rather than loading both
up front, since the order list reads the whole orders collection.

### Stub/mock audit (2026-08-04)

Ran after the above, so the record is current rather than remembered:

- **Stubs (a control that does nothing):** exactly one — Login's *Continue
  with Google / Apple*. Every other `comingSoon` is gone.
- **Mocks (real UI over data no backend produces):** notifications (bundled
  `assets/data/templates/<id>/notifications.json`; there is no
  `/notifications` route at all — the one feature with no backend behind
  it), the lorem-ipsum Terms & Conditions body, onboarding's seeded stock
  photos, and grofast's two bundled address-tile maps.
- **Schema thinner than the UI implies:** a product carries one image, so
  every photo carousel is single-slide.
- Cleaned up while auditing: `DailyMartImageConst.like` was dead once the
  Reviews frame's vote counters went (nothing votes on a review) — the const
  is gone and the asset stays in the pack folder with a note, the policy
  grofast's unused `scan.svg` set.

## Account deletion — DONE (2026-08-04)

Both app stores require an app that lets users create an account to let them
delete it **in the app** (App Store Review Guideline 5.1.1(v)); Cordelia had
sign-up and no delete, which is a rejection. Added as the last row of every
template's Profile, behind that pack's own confirm sheet.

`DELETE /api/users` (token-verified, always the caller's own uid — no admin
branch) runs `deleteShopperAccount`: the shopper's product reviews first,
each through `deleteReview` so every product's rating aggregates are
corrected rather than left permanently over-counted; then the per-user
subcollections (addresses, carts, favourites, recentSearches); then the
profile doc; then the Firebase Auth user **last** — deliberately ordered so a
partial failure leaves an account that can still sign in and retry, rather
than orphaned data nobody can reach. Needs the collection-group index on
`reviews.uid` (added as a `fieldOverrides` entry, deployed).

**Orders are deliberately kept.** They are the *store's* business record as
much as the shopper's — a store needs its sales history for its own books and
for anything still in dispute, and a shopper closing an account can't
unilaterally erase a merchant's transaction record. The confirm sheet says so
in as many words rather than implying everything disappears.

App-side: `DeleteAccountUseCase` → `deleteAccountAndReturnToLogin`, which
reuses `signOutAndReturnToLogin` for the local teardown (profile cache,
verify-sheet flag, per-account cubits). On failure nothing is torn down — the
account still exists, so staying signed in on a working session is correct —
and the screen snackbars the reason.

The row and its busy state sit behind the shared `DeleteAccountAction`
mixin, which owns the in-flight flag, the re-entry guard, and a
`withDeleteAccountProgress(...)` wrapper each Profile body passes through: a
**full-screen scrim + spinner**, not a busy state on the row, because the
action is irreversible and takes a server round trip — the nav bar and every
other control have to stop responding, not just the tapped one. On success
the mixin skips its `setState`, since navigating to Login has already
disposed the screen. Shared rather than per-pack: only the glyph and the
confirm-sheet chrome should differ between templates, never the copy, the
ordering or the busy behaviour of an irreversible action.

**Every pack uses its own kit's delete glyph** — gravia `trash.svg`,
dailymart and grofast `delete.svg`, all three already exported and already
declared as consts. The first cut used one Material icon across all three,
which threw away the per-pack icon systems for no reason.

**Also worth knowing (not built):** offering Google/Apple social login on iOS
will make *Sign in with Apple* mandatory (Guideline 4.8). Both buttons are
still `comingSoon`, so there's no violation today — it's a requirement on
that future work.

**Still open:** Ola Maps API key not yet provisioned (Krutrim gates credential creation behind Autopay — until `OLA_MAPS_API_KEY` is set, use-my-location/autocomplete error out while pincode autofill and hand-typed addresses work; alternative: swap `admin/src/lib/geo.ts` to LocationIQ/Geoapify); post-delivery returns; gravia's Login social buttons; review
pagination past the first 50; owner replies to reviews; per-store
notifications from the backend.

## Admin rebrand + catalog sort/filter + "Generate sample data" seeder — DONE (2026-08-05)

Three admin-side moves, then the storefront fixes that testing with real
seeded data forced.

**Admin rebrand with a crawlable landing page** (commit `c7b7394`). The
console's brand green (oklch, hue ~170) was promoted from the `.site` scope
to `:root`, so the marketing site and dashboard share one theme; the root
route is now a real marketing page with SEO metadata + JSON-LD (plus
`/login`, `/signup`, `/docs` routes), while the dashboard lives under
`/dashboard/*` unchanged.

**Catalog sort/filter.** Every catalog list was an unordered full-collection
`onSnapshot` — rows sat in Firestore doc-ID order, which reads as random to
a store owner. All client-side over the already-streamed arrays (no query
changes, no new indexes):

- `lib/sort.ts` (comparators + `applySort`, the counterpart to `search.ts`)
  and `SortableTableHead` + `useTableSort` (`sortable-table-head.tsx`) —
  clickable headers with asc/desc arrows and `aria-sort`.
- Products: Name/Price/Stock/Rating sortable + a new **Added** column, and
  three filter `Select`s (category, brand incl. "No brand", in/out of
  stock). Coupons: Code/Used sortable + a new **Valid until** column
  (`compareIsoDates` — `""` = no expiry sorts last) and a Status filter.
  Categories: Name/Group (name tiebreak so groups read as blocks). Brands
  and Banners finally got the `SearchField` they were missing.
- "Newest first" needed `createdAt` surfaced: the docs always had the
  serverTimestamp, but every `map*Doc` dropped it. Now mapped as
  `createdAtMs` (0 = legacy doc / pending latency-compensated timestamp;
  rows print "—" and default sort stays Name so nothing looks broken).
  Excluded from every `*Input` — mapper-derived, never written as a field.

**"Generate sample data"** — the console's first seeding feature: a Sparkles
button on Products opens a preview/confirm dialog and writes a realistic
Indian quick-commerce catalog (~93 products, 10 Zepto-style category groups,
32 real brands, 6 working coupons incl. category- and product-scoped ones, 4
banners) in **one atomic client-SDK `writeBatch`** (~140 docs, well under the
500 cap — all-or-nothing, so the failure toast can promise a clean slate and
retry is always safe). Client SDK, not an API route, deliberately: catalog
writes have no server route, the browser session already holds the owner
credential, and `proxy.ts` CORS allows only GET. Slugs cross-reference the
dataset; the seeder pre-mints doc refs locally (`doc(collection(...))`) so
products can reference categories/brands landing in the same commit. Payloads
are built as `ProductInput`/`CouponInput` through the same helpers the forms
use (`computeDiscountPercentage`, `sizeOptions` derived from variants) so the
seeder can't drift from what the dialogs write. Re-generating warns
(duplicates, incl. duplicate coupon codes) but doesn't block.

Image sourcing was the real work, all verified live:
- **Products** — real branded pack shots from Open Food Facts, harvested via
  their search API per brand (CC-BY-SA, attribution line lives in the
  dialog). OFF search rate-limits ~10 req/min and wants a User-Agent; never
  guess barcode image paths — only URLs their API returned.
- **Banners** — landscape Unsplash photography (`fm=jpg` forced: Flutter
  can't decode the AVIF their CDN negotiates), picked by eye after
  downloading candidates; pack shots stretched across a promo slot read
  wrong.
- **Brand logos** — hybrid after testing five free sources (Clearbit dead,
  icon.horse serves the same grey letter tile for Kissan and Kellogg's): 10
  brands whose sites ship a real ≥64px icon use Google's faviconV2 endpoint
  (its `fallback_opts` 404s cleanly, so it's machine-verifiable); the other
  22 get DiceBear monogram discs — a clean generated monogram beats a
  real-but-16px blur.
- `npm run verify:seed-images` checks **every** URL in the dataset (137
  pass); `scripts/patch-seed-images.mjs <storeId>` regex-reads the current
  dataset (no second copy to drift) and idempotently rewrites banners (by
  title) + brand logos (by name) in an already-seeded store — ran against
  the dev store rather than re-generating into duplicates.

**Grofast fixes the seeded data forced** — kit-length copy had been hiding
real bugs:
- The promo card's copy column overflowed 30px with sentence-length banner
  copy — and the budget math showed any 2-line title overflowed even with
  kit copy. Title capped to 1 line, the pill label no longer wraps (and
  dropped to a new 10/700 `pillLabelBold` token so it fits the narrow
  column), and the 28px offer slot became adaptive: `_PromoSubtitle`
  measures with a `TextPainter` and drops a sentence to body-small on two
  lines while short "40% Off" copy keeps the kit treatment. The lesson went
  into `/add-storefront-template` (all three copies) as a new structural
  convention: fixed-height kit cards must budget for the longest *real*
  copy, not the kit's.
- The promo carousel moved to the dailymart pattern by request: full-bleed
  (no left gutter; default `padEnds` centres the resting page), the 18 gap
  split across both page edges, opens on the second banner via the shared
  `restingPage` rule, and a real-`PageView` skeleton replaces the old
  single-card silhouette so load doesn't jump.
- All Categories tiles: long names ("Tea, Coffee & Health Drinks") now wrap
  to two centred lines instead of truncating bottom-left.

**Still open:** post-delivery returns; gravia's Login social buttons; review
pagination past the first 50; owner replies to reviews; per-store
notifications from the backend; BYOK "custom store with AI" generation mode
(free-tier Groq/Gemini — designed, deferred from seeder v1); gravia +
dailymart untested against the seeded catalog (grofast is); admin catalog
pagination/server ordering if stores outgrow full-collection streaming.

## Per-store language (EN/हिन्दी, gravia) + real-location address form — DONE (2026-08-05)

Two features landed together; both ride existing per-store mechanisms.

### Per-store language

- **Store schema**: `stores/{storeId}.language` (`'en' | 'hi'`, default
  `'en'`) — validated fail-loud in POST/PUT `/api/stores` (same reasoning as
  `templateId`), emitted by `serializeStore` as `language`, selectable in
  the create-store dialog and Settings' store profile
  (`STORE_LANGUAGES`/`STORE_LANGUAGE_LABELS` in `admin/src/lib/types.ts`).
- **Plumbing** mirrors the theme swap exactly: `StoreModel` (`@Default('')`)
  → `StoreEntity`/`ActiveStoreEntity` carry a `StoreLanguage` enum
  (wire-parse defaults unknown → `en`, one policy in
  `store_language.dart`); `StorefrontPage` applies the effective locale
  post-frame with the session guard and resets it in the same teardown
  callback as the theme. `ActiveLocaleController extends
  ValueNotifier<Locale>` + `ActiveLocaleScope` sit above
  `MaterialApp.router`, which now sets `locale`/`supportedLocales`/
  `localizationsDelegates`.
- **Strings**: flutter gen-l10n (`lib/l10n/app_en.arb` + `app_hi.arb`, ~310
  keys) exposed through the existing const holders — `GraviaValueConst` and
  the shared user-facing `ValueConst` subset became `static String get`
  delegating to a static `L10n.current` (reassigned *before* the locale
  notify), so ~400 call sites didn't change. ICU plurals replaced
  `num.plural` inside the holders (`cartSummaryLabel`, `reviewCountLabel`,
  `reviewAgeLabel` buckets). Validation copy localizes via
  `LocalizedValidations` (overrides core's `TextfieldValidations`; core
  gains no intl/arb). Gravia's Profile has a Language row (per-store
  shopper override, `StoreLocalePrefs` in SharedPreferences, wins over the
  admin default). dailymart/grofast keep const English and are forced `en`.
  Gotchas encoded in the add-storefront-template skill: no localized copy in
  `static final` caches (shell `_tabs` became a getter) or `const`
  constructor defaults (review sheet's `textLabel` went nullable).
- App chrome outside a storefront (discovery, onboarding, splash) stays
  English on purpose; auth/legal/reviews/sort copy is localized since a
  storefront can surface it.

### Real-location address form

- **APIs**: Ola Maps (free 5M calls/month/API) proxied server-side —
  `admin/src/lib/geo.ts` + token-authed `GET /api/geo/reverse`,
  `/api/geo/autocomplete`, `/api/geo/pincode/{pincode}` (key in
  `OLA_MAPS_API_KEY`, payments.ts fetch/typed-error pattern); India Post
  (`api.postalpincode.in`, keyless, no SLA → best-effort) proxied too so
  the app has one code path and web dodges CORS.
- **Address schema** (+ order `delivery_address` snapshots, tolerant both
  ways): `state` (default `''`), `latitude`/`longitude` (default `null`).
- **Core**: `LocationService` (geolocator; static singleton, sealed
  `LocationResult`, in-flight dedupe, 15s fix timeout; web supported) and a
  `Failure.location` variant (screens match the type and show pack copy,
  like `Failure.payment`).
- **cordelia**: new `feature/storefront/geo/` (data source → `/api/geo/*`;
  `GeoAddressEntity`/`PlaceSuggestionEntity`/`PincodeInfoEntity` pairs; use
  cases; `AddressLookupBloc` with 350ms debounce+switchMap). The shared
  `AddressFormFields` mixin: **city picklist → free text** (geo prefill
  writes real city names; the US-cities lists are gone), optional `state`
  field, `prefill`/`prefillPincode` hooks, lat/lng carried onto the saved
  entity. All three packs' forms updated; gravia additionally ships the
  chrome: "Use my location" tinted button (LoadingDots while resolving),
  debounced address search with suggestion rows, 6-digit pincode listener.
  Permissions added: Android `ACCESS_COARSE/FINE_LOCATION`, iOS
  `NSLocationWhenInUseUsageDescription`.
- **Deliberately not done**: map pin picker (no map SDK), dailymart/grofast
  location chrome (pure pack work on the same bloc), standalone
  `apps/ecommerce/gravia`'s old address feature (unknown JSON keys are
  ignored), Hindi for catalog content (admin data stays as typed).

### Hindi extended to dailymart + grofast (2026-08-05, same day)

All three templates are now bilingual. `DailyMartValueConst` (~150 keys) and
`GrofastValueConst` (~180 keys) converted to `L10n.current` getters with
`dailymart*`/`grofast*` arb keys (707 keys total per locale, full en/hi
parity); `StorefrontPage._applyStoreLocale` lost its gravia-only gate — the
store language now applies on every template. Both packs' Profiles gained
the Language row (shopper per-store override), deduplicated with gravia's
onto `StoreLanguageSwitchX` (`lib/l10n/store_language_switch.dart`) and
app-level `ValueConst.languageLabel/English/Hindi`. The sweep surfaced and
fixed two more static-cache-of-copy sites beyond the shell `_tabs` class:
dailymart's orders status chips and both packs' orders date-filter quick-pick
labels (all now getters). 38 const-context drops across 17 pack files.
Admin Settings' language helper text no longer names gravia as the only
Hindi template. Wordless formatters (`perUnitSuffix`, `orderLineQuantity`,
`reviewScoreLabel`, date formats incl. `orderStepAt`'s Latin month
abbreviations) deliberately stay pure Dart in both locales.

## Locale-aware money + date formatting — DONE (2026-08-05)

Groundwork for the four European languages queued next (de/fr/es/it). All
four use a decimal **comma**, put the currency symbol **after** the amount,
order dates day-first, and read the clock in 24 hours — none of which the
formatters supported. Every one of them is left-to-right Latin script, so
**no RTL or layout-direction work is involved**; the whole problem is number
and date shape.

**`AppFormat` (`packages/core/lib/core/formatting/app_format.dart`)** — the
ambient locale + ISO-4217 currency every money/date helper reads, with
cached `NumberFormat`s rebuilt on `apply()` (a grid formats a price per
card). Ambient rather than context-derived for the same reason
`L10n.current` is: the readers are `num`/`DateTime` extensions and static
`*ValueConst` formatters, 7 of which have no `BuildContext` at all.
`initCoreDependencies()` calls `AppFormat.init()` so an app can't forget the
CLDR date tables and silently fall back to English month names. `core` gained
`intl`.

**Language and currency are separate axes.** A shopper reading a UK store in
German still pays in £, so the glyph comes from the store
(`StoreCurrency` — new enum + wire parse, `INR`/`EUR`/`GBP`/`USD`, threaded
through `StoreEntity`/`StoreModel`/`ActiveStoreEntity`, admin
`STORE_CURRENCIES` validated fail-loud in `POST`/`PUT /api/stores`, pickers
in Settings and the create-store dialog, `currency` on `serializeStore`)
while separators and symbol side come from the locale.
`ActiveLocaleController.apply(locale, {currency})` is the single entry point
that swaps strings and formatting together, so no frame can render German
copy against an English decimal point; the shopper's in-store language switch
passes no currency, which keeps what the store charges in.

**Converted:** `asPrice`/`asPriceParts` (locale separators, `lastIndexOf` on
`AppFormat.decimalSeparator` — `'.'` is the *thousands* mark in three of the
four); new `asDecimal([digits])` as the locale-aware `toStringAsFixed`, applied
to the 6 rating sites and the fractional-unit branch of `ProductUnitType`;
`DateTimePartsX` rebuilt on CLDR skeletons (`asWeekdayDate`, `asCompactDate`,
`asTime`, `asDateTimeLabel`) with the 12-hour `hour12`/`meridiem` pair
dropped — it was dead code that encoded an English-only clock. The two
duplicated `_months`/`_weekdays` tables that shadowed it are gone: cordelia's
`OrderPlacedAtX` now composes core's renderings, and dailymart's
`orderStepAt` takes its month name and clock from the locale (the
one-script argument held for Hindi's Devanagari, not for four Latin-script
languages).

**Copy that carried formatting** now takes pre-formatted operands so one key
serves every locale: the four `priceFilter*` bucket labels became
`priceFilterUnderLabel`/`OverLabel`/`RangeLabel` over `asPrice` (they baked in
`₹100`), and the order date/time connector became `orderPlacedAtLabel`
(`"{date} at {time}"` — "at" is copy, not punctuation).

**Verified:** 14 new core tests pin the four locales' separators, symbol
side, lakh grouping, currency-independent-of-language behaviour, and 12- vs
24-hour clocks; `flutter analyze` clean workspace-wide; core + cordelia
suites green; `flutter build web` clean. One finding worth keeping: CLDR
joins an English time to AM/PM with a **narrow no-break space** (U+202F), not
an ordinary one — asserted explicitly in the test, since the two are
indistinguishable in a diff.

**Deliberately not converted:** `apps/ecommerce/gravia` (its own hardcoded
`$` formatter and month table) and `apps/doc_scanner` — single-language
exemplar apps with no language packs planned; converting gravia would also
change its shipped price rendering, since it always shows two decimals where
`asPrice` drops them on a whole amount.

**One English-visible delta:** dailymart's timeline stamp now reads
"Dec, 20 2025 - 9:30 AM" instead of "9.30 AM" — the kit's period-as-time-
separator couldn't survive handing the clock to the locale.

### Known gaps for the language tasks

- ~707 ARB keys per locale (full en/hi parity today). Each new language is
  that many translations, not a handful.
- `ProductUnitType`'s `'pc'`/`'pcs'` and the unit abbreviations are English
  literals outside the ARB.
- The price-filter *thresholds* (100/250/500) are still rupee-sized bands; a
  €500 grocery bucket is not a meaningful filter, so the numbers — not just
  their formatting — need a per-currency decision.
- Catalog content stays single-valued (see `content-i18n-plan.md`); this work
  covers chrome and numbers only.

### German (de) — third locale, first European one (2026-08-05, same day)

`app_de.arb` at full 709-key parity with the template, so no screen falls back
to English. `StoreLanguage.de` registered end-to-end (enum case, wire value,
tolerant parse, `asLocale`, self-named "Deutsch" label) plus `de` in the
admin's `STORE_LANGUAGES`/`STORE_LANGUAGE_LABELS`. `supportedLocales` needed no
app change — it derives from the generated `AppLocalizations`, so the arb alone
wires the locale up.

Nothing about number or date shape needed doing: the `AppFormat` groundwork
above already handles de's decimal comma, trailing €, day-first dates and
24-hour clock. German is LTR Latin script, so there was **no** direction or
mirroring work — the whole cost was translation plus width.

**Translated under a written contract** (register, placeholder/ICU rules,
mandatory 60-term glossary so "Cart" is `Warenkorb` in all three packs and
never drifts), then merged by a script that refuses to write the arb unless
every key matches the template, every placeholder survives, both ICU
`one`/`other` branches remain, layout-significant leading/trailing spaces and
`\n` counts are preserved, no value is accidentally still English, and no
value carries a hardcoded currency glyph. Formal **"Sie"** throughout, since a
white-label storefront serves many merchants.

**Width overrides** applied after reading the actual widget for each slot, not
by guesswork: `graviaPendingStatusLabel` → "Aufgegeben" (it renders in a
`GraviaTintBadge`), `gravia`/`dailymart` Track Order → "Verfolgen" (gravia's is
one half of a two-up `GraviaActionPair`; dailymart's is an unconstrained button
sharing a Row with the price inside an 88 px-thumbnail card), both
`ordersAllTimeLabel` → "Alle" (a date quick-pick chip beside "Letzte Woche"),
and all three `refundFailedLabel` → "Fehlgeschlagen", which matches how each
pack already renders the *processed* case as a bare "Erstattet". `grofastNav`
kept "Kategorien" in the plural — gravia's 5-item bar already ships
"Bestellungen" (12 chars), so 10 was never the constraint.

**One English-literal gap closed while here:** `ProductUnitType`'s
`'pc'`/`'pcs'` moved into the arb as an ICU plural, because German writes
"Stk." for one piece and for twenty — a `count == 1 ? 'pc' : 'pcs'` ternary
can't express that.

**Verified:** 9 new cordelia tests — arb parity asserted for *every*
`StoreLanguage` case (so fr/es/it inherit the guard, and gen-l10n's silent
English fallback becomes a test failure), the string+format swap landing
together, currency surviving a language-only switch, teardown restoring the app
default, and the badge/action/nav labels staying inside their measured
ceilings. `flutter analyze` clean, cordelia + core suites green,
`flutter build web` clean.

**Not done — needs a device pass:** the overrides above cover the slots the
port could reason about statically. A real German storefront still wants eyes
on the checkout totals panel, the filter sheets and the grofast promo cards,
where copy meets live catalog data.

#### Reusable gate for the remaining locales

`scripts/check-arb-parity.py` is the German pass's merge/validate step, kept
rather than thrown away — fr/es/it each run it instead of re-deriving the
checks:

    scripts/check-arb-parity.py --all                    # CI-shaped gate
    scripts/check-arb-parity.py fr --merge-from /tmp/x   # assemble then write

It refuses to write an arb unless key parity holds, every placeholder survives,
ICU branch sets are intact, layout-significant leading/trailing spaces and
newline counts match, declared passthrough values are untouched, no long value
is still English, and no value introduces a currency glyph. The non-obvious
trap it encodes: a naive `{name}` regex also matches an ICU *branch body* like
the `{pc}` in `one{pc}`, so a correct German `one{Stk.}` reads as a dropped
placeholder — ICU strings are therefore compared on their argument name
instead.

Running it across the existing locales immediately caught a real defect the
German work had otherwise papered over: Hindi's `unitPiecesLabel` was rendering
the English "pcs" (inherited from the `count == 1 ? 'pc' : 'pcs'` ternary this
change replaced). Now "नग" in both branches.

### French (fr) — fourth locale (2026-08-05, same day)

`app_fr.arb` at full 710-key parity, `StoreLanguage.fr` registered end-to-end,
`fr` in the admin picklist. Merged and validated on the **first pass with zero
overrides** — the German round's lesson (nine width fixes discovered after the
fact) went into the translation contract as a *length-budget table with
pre-decided renderings* for every capped slot, so the translators produced
in-budget copy instead of it being corrected afterwards.

**The French-specific engineering item, resolved.** A probe confirmed what the
locale actually emits: `1 234 567,89 €` groups thousands with a **narrow**
no-break space (**U+202F**) and separates the symbol with a plain one
(**U+00A0**); de/it/es all group with a point instead. Both codepoints are now
pinned by exact literal in `packages/core/test/formatting/app_format_test.dart`,
because they are invisible in a diff and a font subset can lack them.

**Note for the device pass:** U+202F is new to the app as of the formatting
commit and is not French-only — `asTime` emits it in English too ("10:15 AM"),
where the previous hand-rolled formatters used a plain space. If a price or
time ever shows a visible box or breaks mid-number, the one-line mitigation is
to map U+202F → U+00A0 on the way out of `asPrice`/`asTime`; do not "fix" it by
substituting a plain space, which is exactly what the no-break forms exist to
prevent.

French typography applied throughout: U+00A0 before `! ? : ;` — and, on the
translators' correct initiative, before `%` — plus guillemets `« … »` around
quoted `{query}` values.

**Two findings worth keeping:**

- *Zero takes the singular in French.* CLDR puts 0 in the `one` plural
  category, so a translator filling `one` with only the singular sense would
  print "0 unités" on every empty row. Pinned by a test
  (`unitPiecesLabel(0) == 'unité'`).
- *The width test had to become script-aware.* Extending the German
  slot-width assertions across all locales immediately failed on Hindi, and the
  cap was wrong, not the copy: `String.length` is a width proxy only where one
  code unit is about one glyph. Devanagari's combining marks and conjuncts count
  separately but render in one cluster — Hindi's 16-code-unit
  'ऑर्डर ट्रैक करें' is 14 clusters and narrower again on screen, and has shipped
  in that slot for months. The test now excludes non-Latin scripts and says why.
  Latin locales (es, it) inherit the guard automatically.

Also corrected an assumption of the port's own: refund *pending* is **not** a
tight slot, because English itself ships "Refund processing" (17 chars) there —
so German's 20-character "Rückerstattung läuft" was left alone rather than
homogenised to fit a cap that never existed. Only the slots where English is
genuinely short are capped.

### Spanish (es) — fifth locale (2026-08-05, same day)

`app_es.arb` at full 711-key parity, `StoreLanguage.es` registered end-to-end,
`es` in the admin picklist. Register is **informal "tú"** — deliberately unlike
the German and French packs: Spanish retail in Spain addresses the shopper as
"tú", and "usted" reads stiff for a grocery app. Per-language register is a
market decision, not an inconsistency.

**The es-ES vs es-MX question, settled with evidence.** A probe confirmed `es`
and `es-ES` both give Spain's `1.234.567,89 €`, while `es-MX` gives
`€1,234,567.89` (symbol first, comma-grouped). Shipping plain **`es` = Spain**
now. The Mexico path is verified and small: because `AppFormat` reads
`Locale.toLanguageTag()` and gen-l10n resolves `es-MX` → `app_es.arb` for
strings, a Latin-American store needs only a new `StoreLanguage` case
(`Locale('es','MX')`) — **no new translation file and no formatting code**. The
one thing that would need touching is the parity test's assumption of one arb
per enum case.

**A real defect caught here, spanning three locales.** Two translators
independently flagged that `*OrderStepPlacedLabel` and `*OrderStepPendingLabel`
had collapsed to the same value. They are not synonyms: the first is a timeline
*step name* ("Order Placed"), the second marks a step **not yet reached**. The
cause was this pass's own glossary, which grouped "Pending / Order Placed" into
one capped rendering — correct for gravia's status chip (whose English is
literally "Order Placed"), wrong for the step keys. Compounding it,
`dailymartOrderStepPlacedLabel` and `grofastStatusPlacedLabel` *also* serve as
their pack's status pill (`DailyMartPill`, grofast's Track Order pill), where
German had been shipping a 21-character "Bestellung aufgegeben" that the German
pass missed. Both problems have one fix — short *and* semantically "placed":
`Aufgegeben` / `Passée` / `Realizado`. Both keys are now in the width test, with
the reasoning, so neither the collision nor the overflow can recur.

**The gate grew locale-specific typography rules.** `LOCALE_RULES` in
`scripts/check-arb-parity.py` now checks Spanish's mandatory opening `¿`/`¡` and
French's no-break space before `: ; ! ?`. Both defects pass every structural
check — key, placeholders and length are all fine while the copy reads as
broken — so nothing else would have caught them. The rules were self-tested
against deliberate violations rather than trusted because they went green.

Spanish also confirmed a trap worth stating plainly: **0 is plural in Spanish
and singular in French.** Assuming "Romance language, therefore same plural
rules" would have shipped "0 unités" in French. Both are pinned by test.

### Italian (it) — sixth locale, completing the European set (2026-08-05, same day)

`app_it.arb` at full 712-key parity, `StoreLanguage.it` registered end-to-end,
`it` in the admin picklist. Informal **"tu"** (like Spanish, unlike German and
French — per-language register follows each market's retail norm). Italian
shares the point-grouped `1.234.567,89 €` shape with German and Spanish, so no
new formatting work.

Merged with **zero overrides**, like French. The two lessons from the Spanish
round were folded into the dispatch rather than discovered again: the
placed-vs-pending distinction and the 12-char pill cap were stated per-key in
the prompts, so the translators produced `Effettuato` / `In attesa` correctly
first time.

**The gate grew two generic guards**, both self-tested against deliberate
violations before being trusted:

- `DISTINCT_PAIRS` — key pairs whose English differs and which must therefore
  stay distinct in every translation. A narrow cap invites collapsing two short
  labels into one word; when they mean different things that is silent, and it
  is exactly what fr and es shipped.
- `no_foreign_typography` — catches one language's convention bleeding into
  another's file (Spanish's `¿`/`¡`, French's U+00A0 before `: ; ! ?`). Real
  risk when locales are translated in parallel from a shared contract.

Both are mirrored as tests that loop over `StoreLanguage.values`, so every
future locale inherits them.

**A note on writing these tests.** A plain space typed where CLDR emits U+00A0
produces a failure whose expected and actual strings are byte-different and
visually identical — it cost three false debugging rounds in this file. The
price expectations now build from named `nbsp`/`nnbsp` constants instead of
invisible literals. Worth copying in any test that asserts formatted output.

### Where the language work stands

Six locales at full parity: **en, hi, de, fr, es, it**. 38 tests guard them,
looping over the enum so a seventh inherits every check the day its arb lands:
key parity, capped-slot widths (Latin scripts only — `String.length` is not a
width proxy for Devanagari), locale-correct number/date shape, plural-category
correctness (0 is singular in French, plural everywhere else here), typography
per language, and cross-locale contamination.

Still open, unchanged by this work: the per-currency price-filter thresholds
(the bands are still rupee-sized), catalog content (see `content-i18n-plan.md`),
and a device pass on each new language where copy meets live catalog data.

## Per-currency price-filter bands — DONE (2026-08-05)

The last thing blocking a non-INR store. `ProductPriceFilter`'s bands were
formatted correctly after the locale work but the *numbers* were still
rupee-sized, so at a euro store every product fell in "Under €100" and the
filter filtered nothing.

**The edges are now per currency**, on a `StoreCurrencyPriceBandsX` extension:
INR keeps `100 / 250 / 500` (tuned to the seeded Indian catalog), while EUR,
GBP and USD use `2 / 5 / 10`. Deliberately **not** converted between each
other — these are filter-usability numbers, not an exchange rate. ₹100 ≈ €1,
but a €1 edge would leave nearly every European grocery item in one band, which
is the same inert filter with different arithmetic. Each set cuts that market's
catalog into four groups a shopper would actually choose between.

**The enum cases were renamed** `under100 / from100To250 / from250To500 /
over500` → `underLow / lowToMid / midToHigh / overHigh`. The old names baked
rupee amounts into identifiers that no longer describe what the case does. Safe
to rename because the enum is in-memory only (never persisted or sent on the
wire), and every call site uses `.values` or `.all`.

**Both the label and the predicate read one ambient accessor.** `matches()` is
called from a state getter with no currency in scope, and `label` already
resolved currency ambiently through `asPrice`. Threading a parameter into only
one of them is how a chip ends up advertising "Under €2" while filtering at
₹100, so both go through the same `AppFormat`-derived accessor and a test proves
it for every currency rather than trusting the wiring.

**17 tests**, the useful ones being properties rather than examples: the four
bands *tile* the number line for every currency (probes straddle each edge, so
a comparison-operator slip shows up as a price matching zero or two bands), and
every band's label contains the exact formatted edges its predicate uses. The
asymmetric edge semantics from before this change are preserved — `< low`,
`[low, mid]`, `(mid, high]`, `> high` — so a price sitting on an edge still
belongs to the band beneath it.

Also fixed while rendering the labels across all six locales: Italian's
"Under" read `Fino a {price}` ("up to", inclusive) against a strictly exclusive
band. Now `Meno di {price}`, matching the French and Spanish forms.

### Known gap this exposes — country-specific seed catalogs — CLOSED (2026-08-06)

**Closed by the seven market-catalog sections immediately below** (Germany →
France → Spain → Italy → UK/US). The gap analysis is kept as written because
the three decisions it poses are the ones the implementation actually made —
but the heading used to say "planned, not started", which outlived the work by
a day and reads as open to anyone scanning headings rather than the sections
under them. All three were resolved: an explicit picker defaulting from the
store's currency, seven hand-authored catalogs rather than one European proof,
and each catalog seeded in its own market's language.

Fixing the bands surfaced the same problem one layer down, in the data.
"Generate sample data" writes **one hardcoded Indian catalog to every store**
regardless of country, so a German or French store gets Indian brands (Amul,
Britannia, Tata), Zepto-style Indian quick-commerce categories, English/Hindi
product names, and rupee prices (₹10–899) read as euros. That last part
re-breaks this very filter from the data side: at €10–899 nearly every product
lands above the top edge and the filter is inert again.

The fix is **per-market catalogs with native prices**, not the Indian catalog
divided by 90 — a euro catalog should list what a European grocery actually
sells at what it actually charges. The refactor is well-shaped because the data
is already isolated: `grocery-seed-data.ts` exports a `GrocerySeed` type and a
single `GROCERY_SEED` const, so that const becomes a map keyed by market with
the type untouched; `seed-grocery.ts` takes the market instead of hardcoding it;
the dialog picks it and reads that market's counts and currency.

Three decisions to make first: how the market is chosen (derived from the
store's `currency`, or an explicit picker — EUR is ambiguous across DE/FR/ES/IT,
which argues for a picker defaulting from currency); how many catalogs to
hand-author (matching the language packs plus UK/US is six or seven, so proving
the shape with one European catalog first is sensible); and the catalog
language, since content is single-valued plain strings (catalog i18n is
deliberately unbuilt — see `content-i18n-plan.md`), meaning a German catalog's
product names have to be *seeded* in German.

Existing constraints carry over: one atomic 500-write `writeBatch` (today 145
docs), Open Food Facts photography — which is *better* for Europe, being a
French-origin project — at ~10 search requests/min, verified-favicon brand logos
with DiceBear fallbacks, and `verify:seed-images` passing for every new
catalog. Tracked as its own task.

## Germany sample catalog — DONE (2026-08-05)

The first country-specific seed catalog, and the refactor that makes more of
them cheap. "Generate sample data" now asks which market to seed and defaults
that from the store's currency.

**Structure.** `GrocerySeed` and the other `Seed*` types moved to
`seed-types.ts` so no market's data file has to import another's;
`grocery-seed-data.ts` keeps the Indian catalog as `INDIA_SEED`;
`germany-seed-data.ts` holds `GERMANY_SEED`; `seed-markets.ts` is the registry
(catalogs, labels, descriptions, and `defaultSeedMarketForCurrency`).
`seedGroceryData` takes a market, and the dialog reads the store doc itself to
pre-select one — the products page has no reason to know the currency.

**The catalog.** 10 aisles in German supermarket framing (Rewe/Edeka groups —
*Lebensmittel*, *Snacks & Getränke*, *Haushalt*), 55 real German/European
brands (Kerrygold, Dr. Oetker, Ritter Sport, Haribo, Bahlsen, Storck, Dallmayr,
Gerolsteiner, hohes C, Kölln, Hengstenberg, Schwartau, …), **96 products named
and described in German** with euro shelf prices, 7 coupons with German codes
(`WILLKOMMEN10`, `FRISCHE5`, …) and 4 banners. 172 docs — still one atomic
`writeBatch`, well inside the 500-write cap.

Product names are seeded **in German** rather than translated at read time,
because catalog content is single-valued by design (`content-i18n-plan.md`).
That is what makes a German storefront coherent without building catalog i18n.

**Prices are German shelf prices, not converted rupees** — and the point is
measurable. `npm run verify:seed-bands` prints each catalog's spread across the
price bands its currency uses:

    india   (INR, 103 products, 10–615):   under 100=68  100–250=28  250–500=4  over 500=3
    germany (EUR,  96 products, 0.49–14.99): under 2=48  2–5=41  5–10=4  over 10=3

Reading the Indian catalog as euros would instead have put **98 of 103 products
in the single "over €10" band**, which is the concrete way the filter went inert.
The script fails a market whose prices leave any band unreachable *or* pile >90%
into one — and it caught a quieter version of the same bug in the first German
draft, which had nothing over €10, so that chip could never match. Three prices
were corrected (a kilo of Jacobs beans at €8.99, and two household packs priced
as small packs while described as bulk) — all three more accurate as well.

### Two findings worth carrying into the next market

**Open Food Facts' search index is stale relative to its product endpoint.**
Paths harvested from `search.openfoodfacts.org` disagreed with
`/api/v2/product/<barcode>.json` for **60 of 77 barcodes**: short codes come back
unpadded from search (`/20462062/…`) where the canonical path is zero-padded and
split 3/3/3/4 (`/000/002/046/2062/…`), and revision numbers were often behind
(`front_de.133` vs `.178`). Only *one* of those 404'd on the day, so the image
verifier passed and gave false confidence while the rest were quietly primed to
rot. Every path is now re-resolved through the product endpoint. Do that for
fr/es/it too — and note the product endpoint 429s well below its documented
ceiling, so the resolver backs off and resumes.

**OFF is a packaged-*food* database.** 19 of 96 German products carry
`imageUrl: ""` — fresh produce and the entire *Haushalt* aisle, which OFF simply
does not contain. That matches how the Indian catalog already handles its
cleaning products, and every consumer renders a placeholder, but it is the
ceiling on photo coverage for any market: expect ~80%, not 100%.

`verify:seed-images` and `patch-seed-images.mjs` now read every market's file;
adding a market means adding its filename to both, or its URLs go unchecked.

**Still open:** France, Spain, Italy and the UK/US have no catalog, so a store
in those currencies pre-selects Germany — right price scale, wrong brands and
language. `defaultSeedMarketForCurrency` documents that trade-off at the point
where it is made.

## France sample catalog — DONE (2026-08-06)

The second country catalog, and the one that proved the German pass was
repeatable. 10 Carrefour/Intermarché-style aisles in French, 71 real French
brands (Président, Elle & Vire, Bonne Maman, LU, Panzani, Puget, Amora,
Bénédicta, Findus, Fleury Michon, Evian, Badoit, Carte Noire, Malongo, Ricoré,
Cassegrain, Bonduelle, …), **106 products named and described in French** at
French shelf prices, 7 French coupon codes (`BIENVENUE10`, `PRIMEUR5`, …) and 4
banners. 198 docs, still one atomic `writeBatch`.

Open Food Facts is a French-origin project and it shows: the category sweep
returned **1095 candidates for France against 723 for Germany**, so brand
coverage was easier. The gaps are the same ones though — loose produce and the
whole *Entretien* aisle have no photos (26 of 106 placeholders), because OFF
holds packaged *food*.

**Two process notes for Spain and Italy.** The by-name harvest only works with
**single-token queries** — `"Bonne Maman confiture"`, `"L'Or cafe"` and
`"lait demi-ecreme"` all returned zero hits while `confiture`, `Bonne` and
`lait` each returned 20. And Google's favicon endpoint 404s for a meaningful
share of brand domains (8 of 71 here: president.fr, amora.fr, benedicta.fr,
badoit.com, cassegrain.fr and three more), so expect to fall back to monograms
and let `verify:seed-images` tell you which. Re-resolving every barcode through
the product endpoint worked exactly as intended: **zero OFF image failures** on
the first verify, against one on the German pass before that step existed.

### New gate: `npm run verify:seed-refs`

The seeder resolves slugs → freshly minted doc ids and `.filter()`s away any it
can't find. That is right at write time — a bad reference shouldn't abort a
200-doc batch — but it means a typo'd `categorySlug` silently seeds a product
into **no aisle**, and a typo'd coupon target silently seeds a coupon that
discounts nothing. Neither is visible to a type check, an image check or a band
check.

The new script cross-checks every product → category and product → brand
reference, every coupon and banner target, duplicate slugs, and
declared-but-unused brands. All three catalogs' references resolve; it earned
its keep immediately by catching a dead `tipiak` brand doc in the French draft
(fixed by adding the product it was meant to have).

The seed-data gate is now four scripts, and **adding a market means adding its
filename to all four** or its data goes unchecked:
`verify:seed-images`, `verify:seed-bands`, `verify:seed-refs`, plus
`patch-seed-images.mjs` for retrofitting already-seeded stores.

**Still open:** Spain, Italy and the UK/US. A store in those currencies
pre-selects Germany — right price scale, wrong brands and language.
`defaultSeedMarketForCurrency` now says plainly that the euro default is
arbitrary between Germany and France, and why guessing harder would be worse.

## Spain sample catalog — DONE (2026-08-06)

Third country catalog. 10 Mercadona/Carrefour-ES style aisles in Spanish, 70
real Spanish brands (Central Lechera Asturiana, García Baquero, El Caserío,
Carbonell, Coosur, La Española, Gullón, Fontaneda, Cuétara, Artiach, Nocilla,
ColaCao, Solís, Litoral, Gallina Blanca, Calvo, Isabel, El Navarrico, Casa
Tarradellas, Campofrío, Valor, El Almendro, Grefusa, Font Vella, Solán de
Cabras, Marcilla, Saimaza, Bonka, Hornimans, …), **111 products named and
described in Spanish** at Spanish shelf prices, 7 Spanish coupon codes
(`BIENVENIDA10`, `FRESCOS5`, …) and 4 banners. 202 docs, one atomic
`writeBatch`.

The pipeline ran clean on the third pass — harvest, targeted staples pass,
canonical barcode resolution, generate, register in all four gates — with the
only per-market work being curation and pricing. Photo coverage 85/111; the 26
placeholders are loose produce and the whole *Hogar* aisle, the same OFF gap as
the other markets.

### The gate itself needed fixing at this scale

`verify:seed-images` now checks **564 URLs** across four catalogs, and at that
size Open Food Facts' CDN started throttling: the run reported an India
category image as failed, and a single manual fetch of that exact URL returned
**200**. The product endpoint also still advertised it. So it was a false
positive, and a false positive is worse than no check — it is what teaches
people to ignore a red build.

`check()` now distinguishes the two cases. A **404 or 410 is definitive** and
fails immediately: that is the URL rot the script exists to catch. A **429, 5xx
or socket error is transient** and retries up to four times with increasing
backoff. Failures print their reason (`FAIL (HTTP 404) …`), so a real rot is
legible at a glance rather than needing a manual curl to confirm. With that in
place the run is clean at 564 URLs, and the only genuine failures were two
Spanish brand favicons Google's endpoint 404s for (Pascual, Puleva) — now
monograms.

The harvest helper was hardened for the same reason: one connect timeout on the
last of eight search terms was aborting the run and discarding every term
already collected. It now retries and skips.

**Still open:** Italy (to complete the language-pack set), then UK/US. And the
standing gap for all three euro markets — nobody has seeded a live store and
opened the storefront yet.

## Italy sample catalog — DONE (2026-08-06); the language-pack set is complete

Fourth country catalog, and the one that closes the loop: **every language the
storefront speaks (de/fr/es/it) now has a catalog written in it.**

10 Esselunga/Coop-style aisles in Italian, 69 real Italian brands (Barilla,
De Cecco, Rummo, Mulino Bianco, Pavesi, Divella, Colussi, Gentilini, Balocco,
Galbani, Granarolo, Parmalat, Latteria Soresina, Parmareggio, Mutti, Valfrutta,
Saclà, Rio Mare, Monini, Cirio, Ponti, Findus, Buitoni, Cameo, Fratelli
Beretta, Rovagnati, Algida, Perugina, Novi, Loacker, San Carlo, Levissima,
San Pellegrino, Ferrarelle, Uliveto, Santàl, Estathé, Lavazza, illy, Kimbo,
Segafredo, Bonomelli, …), **107 products named and described in Italian** at
Italian shelf prices, 7 Italian coupon codes (`BENVENUTO10`, `FRESCHI5`, …) and
4 banners. 197 docs, one atomic `writeBatch`.

Nothing new broke. The pass was pure execution of the recorded pipeline —
harvest, single-token staples pass, canonical barcode resolution, generate,
register in all four gates — which is what a repeatable recipe is supposed to
feel like by the fourth run.

### Where the seed data now stands

    india   (INR, 103 products, 10–615):     under 100=68  100–250=28  250–500=4  over 500=3
    germany (EUR,  96 products, 0.49–14.99): under 2=48    2–5=41      5–10=4     over 10=3
    france  (EUR, 106 products, 0.45–13.99): under 2=33    2–5=69      5–10=2     over 10=2
    spain   (EUR, 111 products, 0.35–13.75): under 2=46    2–5=56      5–10=7     over 10=2
    italy   (EUR, 107 products, 0.45–13.45): under 2=43    2–5=57      5–10=4     over 10=3

Five markets, 523 products, **687 image URLs all resolving**. Worth noting that
the run was clean on the first attempt at 687 URLs — the retry/backoff added
during the Spanish pass is what makes a check that size trustworthy, and
without it this run would have reported phantom failures again.

Photo coverage is 78 of 107 for Italy; the 29 placeholders are loose produce
and the whole *Casa* aisle, the same Open Food Facts boundary every market
hits.

**France and Spain have been seeded into live stores and render correctly**
(confirmed 2026-08-06). Germany and Italy have not been opened yet, though they
come off the identical pipeline.

**Still open:** UK and US. Both currently pre-select the German catalog — right
price scale for GBP/USD, wrong brands and language. Neither has a language pack
either, so English copy plus a British or American catalog would be the natural
pairing; unlike the four European markets, the *language* side is already done
for them.

## UK and US sample catalogs — DONE (2026-08-06); every market has a catalog

The last two markets, shipped together because they share a property none of
the others had: **English needs no language pack**, so only the catalog side
was ever outstanding for them.

Two separate catalogs rather than one English one. The price *scale* is
identical (GBP and USD both use the 2/5/10 bands), but the brands diverge
completely — Warburtons/Cathedral City/Yorkshire Tea/Branston against
Cheerios/Kraft/Chobani/DiGiorno/Folgers — and a British shopper being offered
Goldfish crackers is the same failure as a German one being offered Amul.

- **UK**: 10 Tesco/Sainsbury's-style aisles, 70 British brands, 102 products at
  pound shelf prices, 7 coupons, 4 banners. 193 docs.
- **US**: 10 Kroger/Publix-style aisles, 69 American brands, 100 products at
  dollar shelf prices, 7 coupons, 4 banners. 190 docs.

### `defaultSeedMarketForCurrency` finally does real work

Until now every non-rupee currency landed on Germany — right price scale for
GBP and USD, wrong brands and language. With catalogs behind those two
currencies the mapping is now exact for three of the four: INR to India,
GBP to UK, USD to US. Only EUR still falls back arbitrarily, and that is
irreducible: the euro genuinely cannot distinguish Germany from France, Spain
or Italy, and all four have catalogs. Germany wins that tie, which the doc
comment says plainly rather than dressing up as inference.

### Seven markets

    india   (INR, 103 products, 10-615):     under 100=68  100-250=28  250-500=4  over 500=3
    germany (EUR,  96 products, 0.49-14.99): under 2=48    2-5=41      5-10=4     over 10=3
    france  (EUR, 106 products, 0.45-13.99): under 2=33    2-5=69      5-10=2     over 10=2
    spain   (EUR, 111 products, 0.35-13.75): under 2=46    2-5=56      5-10=7     over 10=2
    italy   (EUR, 107 products, 0.45-13.45): under 2=43    2-5=57      5-10=4     over 10=3
    uk      (GBP, 102 products, 0.65-12.75): under 2=50    2-5=45      5-10=5     over 10=2
    us      (USD, 100 products, 0.99-13.99): under 2=20    2-5=53      5-10=23    over 10=4

**719 products, 918 image URLs, all resolving.** The verifier stayed clean at
918 with no false positives — the retry/backoff added during the Spanish pass
is what makes a check that size trustworthy, and it has now been load-bearing
twice.

The UK draft initially had a single product in its 5-10 band. That passes the
band gate (nothing is unreachable) but it is a filter chip returning one item,
so four prices were corrected upward — premium instant coffee and butter, both
genuinely underpriced in the draft. The gate catches empty bands; a nearly
empty one still needs a human to look.

Worth noting the US spread is much flatter than the European ones (20/53/23/4
against Germany's 48/41/4/3). That is real, not a modelling artefact: American
grocery packs are larger and priced higher per unit, so the same 2/5/10 edges
land differently. It makes the US filter the most useful of the seven.

### The remaining gap, unchanged

Catalog *content* is still single-valued (see `content-i18n-plan.md`), so each
catalog is written in one language and a shopper switching the storefront's
language sees translated chrome around untranslated product names. That is the
deliberate boundary this whole line of work has sat inside.

France and Spain are confirmed working in live stores. Germany, Italy, UK and
US come off the identical pipeline and pass every gate, but have not been
opened yet.

## Admin console renders the store's currency — DONE (2026-08-06)

The storefront had been formatting money per store currency since the
`AppFormat` work; the dashboard was still printing **₹ in 21 places**. An admin
managing a euro store saw rupee prices for the products that store actually
sells in euros — the two halves of the same product disagreeing about what a
number means.

**`lib/money.ts`** is the one place money is rendered now: `formatMoney`,
`currencySymbol` and `compactMoney`, each taking the currency as an argument
rather than reaching for React context, so they work from non-React code and
are trivially testable. Each currency renders in the locale that market writes
numbers in — `₹1,234.50`, `1.234,50 €`, `£1,234.50`, `$1,234.50`. That mirrors
the storefront (which pairs the store's currency with the *shopper's* locale)
with the one difference that the admin has a single UI language, so the
currency picks the convention.

**`storeCurrency` comes off the snapshot the store context already ran.** It
watches each owned store's doc for `name`; reading `currency` from the same
callback costs no extra read and live-updates when Settings changes it.

**Converted:** the Orders table and order detail (line items, subtotal, coupon
line, total), the Products table and its price/original-price form labels, the
Coupons table discount labels and all three form labels, the Reviews table's
order total, and the dashboard's revenue and average-order-value tiles.

Two things that were more than a symbol swap:

- **`compactCurrency` hardcoded lakh and crore.** Right for rupees and worth
  keeping — that is how Indian business writes large sums — but applying it to
  dollars would print "$1.2L", which means nothing. `compactMoney` keeps Cr/L
  for INR and uses K/M everywhere else, so the same revenue reads `₹12.4L` or
  `$1.2M` depending on the store.
- **`COUPON_TYPE_LABELS` was a static constant** whose flat entry read "Flat
  amount off (₹)". It is now `couponTypeLabels(currencySign)` — the label names
  a currency, so it could not stay a constant.

### One related bug left deliberately unfixed

`coupon-engine.ts` throws `"This coupon needs a minimum order of ₹20"`, and
that string is **shopper-facing** — it travels through
`POST /api/stores/{id}/coupons/validate` into cordelia's checkout. A euro
store's customer sees rupees today.

It is not fixed here because the honest fix has a cost to weigh:
`previewCoupon` never loads the store doc, so making the message
currency-correct means adding a Firestore read to a payment-adjacent path.
The cheap version is to read it lazily inside the failure branch (only the
error path pays), which requires making `assertCouponUsable` async. Worth
doing, worth deciding on purpose rather than slipping into a currency cleanup.

Untouched by design: the seed catalogs (each market's prices are in its own
currency already) and the marketing landing page (not store-scoped).

## Coupon minimum-order message — currency-correct and localized (2026-08-06)

The last hardcoded rupee on a shopper-facing path. `coupon-engine.ts` threw
`"This coupon needs a minimum order of ₹20"`, and that string travels through
the validate, payments and orders routes into cordelia's checkout — so a euro
store's customer was told their basket was under **₹20**. It was also English
in every storefront, German ones included.

**The amount now crosses the wire as a number, not a sentence.** `CouponError`
carries an optional `code` and `minOrderValue`; `couponErrorBody()` serializes
them so the three routes can't drift; the client turns them into copy. That is
the only place with both halves of the answer — the store's currency *and* the
shopper's language — and it needs no Firestore read, which is why the server
doesn't do it: `previewCoupon` never loads the store doc, and adding a read to
a payment-adjacent path to format an error string is a bad trade.

The server's own `message` stays a usable English fallback, now
currency-neutral ("…minimum of 20"). A caller that ignores the code gets
something plainer but never something *wrong*.

**Client side:** `CouponRejectedException` (declared beside the data-source
contract that raises it) carries a finished sentence; the data source builds it
from the new `couponMinOrderMessage` arb key plus `asPrice`; the repository maps
it to a `Failure.server` so `handleRequest`'s generic mapping doesn't overwrite
it with the server's fallback. Six locales translated, parity intact at 713
keys.

Only the tagged rejection is rewritten — every other coupon error still shows
the server's text unchanged, which keeps the blast radius to the one message
that names money.

**7 tests** cover both directions: the amount renders in the store's currency
(and never in rupees), it changes with the shopper's language, a rupee store
still reads in rupees, and four fall-through cases — an untagged error, a
different code, a tagged body missing the amount, and a bodyless network error
— are all left alone rather than turned into "minimum of null".

### A near-miss worth recording

The first pass replaced `{ error: e.message }` by regex across the three
routes, which also caught their **401 and 502 branches** — `UnauthorizedError`
and `RazorpayError` being handed to a coupon-error serializer. It typechecked,
because those classes are structurally compatible with `Error`, and it would
have behaved correctly today since neither carries a `code`. Caught by reading
the call sites afterwards rather than by any tool. Structural typing plus a
broad regex is a combination that hides this kind of mistake.

---

## Long-label layout pass across all three packs — DONE (2026-08-06)

Six languages and seven catalogs later, the copy that broke is not the copy any
kit was drawn with. Both fixes below are the same defect in two places: a label
capped at one line whose text arrives from the catalog or from a translation.

**Category names, everywhere they rail.** German grocery categories are
compounds — "Nudeln, Reis & Konserven", "Molkereiprodukte & Eier" — and every
pack truncated them to a prefix on Home and on the categories screen. All three
now wrap to two lines, but each needed a different structural fix, which is the
part worth remembering:

- **dailymart** draws a fixed-height tile, so a second line needs the tile to
  grow: `categoryTileHeight` 92 → 106, with the arithmetic (4 inset + 63 image +
  2 × 18.6 lines) written into the constant so the next person can't change the
  image height and silently overflow.
- **grofast** rails a tile with the label *below* it, so the row's cells must
  top-align — without that, a two-line cell recentres its neighbours and the
  whole rail bounces.
- **gravia** already had the room; it only needed the cap lifted.

Wrapped text also needs `textAlign: TextAlign.center` and a horizontal inset it
never needed on one line — a wrapped label without them reads ragged against the
tile edge.

**grofast's profile quick tiles** — the three-across row at the top of Profile —
had the same cap. Translations push those past one line ("Meine Bestellungen",
"Mis direcciones") where English fits. Two lines, centred, with an `xs3` inset.

**Nine widget tests** (`test/widget/templates/long_label_wrapping_test.dart`)
cover all four surfaces. They are structural only — see the caveat below.

### What the tests could not tell us

The first version asserted "a long name makes the tile taller" and failed. The
widget-test fallback font renders **every glyph as a square of the font size**,
roughly twice a real glyph's width, so even "Bebidas" wraps at 70px and the
long and short cases produce the same height. The tests were reframed onto
font-independent properties — `maxLines`, `textAlign`, the tile's declared
height, `CrossAxisAlignment.start` on the rail — and the fit question was
answered by opening the storefronts.

This is now rule 7 in `docs/ai-rules/design.md` §3, alongside a new checklist
bullet ("any label fed by store data or translation gets two lines") and three
matching screen smells.

### German copy fix shipped alongside

"Benachrichtigung(en)" → "Mitteilung(en)" across all 12 German notification
strings — shorter, and the word German apps actually use for in-app
notifications. Applied to every pack, not just the one it was spotted in.

---

## Admin record self-heal + bulk CSV product import — DONE (2026-08-06)

Two of the productionisation gaps, plus the landing-page and SEO work that
shipped alongside them.

### `admins/{uid}` self-heal

Sign-up is two steps — create the Firebase Auth account, then write
`admins/{uid}` — and only the first is atomic. The gap was recorded in M1a as
"a valid Auth account with no admins doc"; auditing it before fixing it made
the real severity **narrower and more permanent** than the note said.
`POST /api/stores` already writes `{ storeIds: arrayUnion(...) }` with
`{ merge: true }`, so such an account can still create a store and the doc
appears. What it can never regain is `email` and `role`, because
`firestore.rules` denies client updates to an existing admins doc
(`allow update, delete: if false`). So the account works; the *record* is
permanently half-written, and only the Admin SDK can complete it.

**`POST /api/admins/ensure`** — token-verified, always the caller's own uid, no
uid parameter and no admin branch. Fills only absent fields, never overwrites.
`createdAt` is stamped **only when the doc doesn't exist at all**: backfilling
it onto an older doc would record today as the sign-up date, and a missing
timestamp beats a wrong one. It is therefore also excluded from the client's
completeness check, or a doc legitimately lacking it would ask to be healed on
every load.

**The client detects it for free.** `StoreProvider` already holds an
`onSnapshot` on that exact doc, so completeness is read off a snapshot it was
subscribed to anyway — zero extra reads in the normal case. The repair is
attempted once per session (a `useRef` guard), not once per snapshot, because
the heal's own write re-fires the callback and a failing route would otherwise
retry in a loop. A failure is silent: the owner can still work, the next load
tries again, and there is nothing actionable to say about a record they don't
know exists.

Nothing reads `role` today — it is written for the claim-based tightening M1a
still has open (`role: storeAdmin` stamped as a custom claim), which is why the
field is worth repairing rather than dropping.

### Bulk CSV import — products, categories, banners, coupons (v1)

The M5 line item that had stayed a scratchpad script since July. A store with
a few hundred SKUs could not be onboarded through the Products dialog, which
made it the gap most likely to kill a real onboarding.

**CSV, not `.xlsx`** — deliberate. The npm `xlsx` package has been pinned at
0.18.5 since 2022 with open prototype-pollution advisories (SheetJS moved
everything newer to their own CDN), and a console that writes store data is
the wrong place for a known-vulnerable parser. Every spreadsheet tool exports
CSV in one click. Reading `.xlsx` directly belongs with the **v2 AI mapping**
work, where an arbitrary sheet is the whole point — at which stage the parser
runs server-side on a file the owner already chose to hand over.

`papaparse` does the parsing. Hand-rolling was considered and rejected on the
specific inputs that break hand-rolled parsers and that a real Excel export
always has: a BOM, CRLF line endings, and quoted fields containing commas.

**Four entities, one implementation.** `lib/import/` splits so the logic is
checkable without a project — every planner is pure, no Firestore and no React:
- `csv-core.ts` — parsing, coercion, RFC-4180 quoting, line numbering, and the
  plan/error shapes. Everything that would otherwise be re-typed per entity, so
  the four can't disagree about it.
- `store-catalog.ts` — the store's live contents plus the rules deciding what a
  *sample* may put in its linking columns.
- `product-csv.ts`, `category-csv.ts`, `banner-csv.ts`, `coupon-csv.ts` — each
  declares its columns and validates its own rows.
- `import-rows.ts` — one batched writer for all four; what differs is only
  which fields a create seeds (`createDefaults` — coupons start at
  `usedCount: 0`, the way `addCoupon` does), never the write's shape.
- `components/import-csv-dialog.tsx` — file → plan → confirm → write, driven by
  an `ImportSpec` the page supplies (it is the only place holding live data).

Per-entity contracts worth knowing:
- **Categories** have no cross-references, so their sample is the same whatever
  the store holds — the one that can't fail.
- **Banners** take a target by *name*, not doc id: an owner filling a
  spreadsheet knows "Fresh Fruits", not the 20-character id. A sample whose
  target doesn't exist in the store is emitted display-only rather than as a
  failing row.
- **Coupons** are uppercased on the way in, because `coupon-engine.ts` looks up
  `code.trim().toUpperCase()` — a lowercase import would create a code no
  shopper could redeem. A scoped seed coupon is included in the sample **only
  when every one of its targets resolves**; silently rewriting it to
  whole-order scope would hand the owner a coupon discounting far more than the
  one they copied.

**Decisions worth keeping:**
- **Two-step, never blind.** The file is fully validated *before* anything is
  written and the owner confirms a plan ("12 to create, 3 to update, 2 cannot
  be imported") with each bad row named by its line number in their editor.
  Bad rows are skipped, not fatal — a 400-row sheet with two typos should not
  be all-or-nothing.
- **Upsert key:** the optional `id` column when present, otherwise a
  case-insensitive name match. So re-importing an edited file updates rather
  than duplicating.
- **Updates `merge`, never plain `set`.** `ratingAverage`/`reviewCount`/
  `ratingBuckets` belong to the review transaction and `createdAt` to the
  original write; a full overwrite would silently reset every imported
  product's rating. That is the one thing an import must not be able to do.
- **Unknown categories and brands are row errors, not silent creation** — a
  typo would otherwise quietly mint "Beverges" and split the catalog in two.
  The message names the page to fix it on.
- **Over 500 rows is not atomic** (Firestore's batch cap), and the dialog says
  so *before* the owner commits rather than after a partial failure. The
  seeder gets one atomic commit only because a bundled catalog is ~170 docs.
- **The sample is generated from the store's own market seed catalog**, not a
  static asset and not invented rows — real products, in the store's language,
  at that market's prices. The market comes from the store's `language`, with
  `currency` breaking the tie only for English (India / UK / US all speak it);
  this is exactly the euro ambiguity `defaultSeedMarketForCurrency` documents
  and cannot resolve on its own, so `seedMarketForStore` was added beside it.
  The store's language rides the store-doc snapshot `StoreProvider` already
  holds, so reading it costs nothing.
- **The sample must import cleanly into the store that downloaded it.** The
  first version failed this and the verification hid it: the sample's category
  and brand columns named a hardcoded Indian catalog, and the check fed the
  planner a fake store containing exactly those names — proving the parser and
  nothing else. On a real store every row errored. The linking columns are now
  resolved against the store's *live* catalog: a seed category the store has is
  used; if none match but the store has categories, its first one; if the store
  has none, blank (the column is optional). Brands follow the same three cases.
  The check now runs **all seven markets × three store shapes**, including a
  store sharing none of the seed's names.
- Currency-formatted numbers are accepted (`"₹1,299.00"` → `1299`) — a
  spreadsheet formats a money column without asking, and the owner believes
  they typed a number.
- **Available on an empty store**, unlike "Add product" beside it. The
  `categories` column is optional, so a fresh store can be bulk-loaded; and
  when a file does name categories, the per-row errors name exactly which ones
  to create. Gating the button on `categories.length` (copied from its
  neighbour on the first pass) disabled the feature precisely in the
  onboarding case it exists for.

**A line-numbering bug the four-entity checks caught.** Papaparse was reading
with `skipEmptyLines: "greedy"`, which drops blank rows from the data array —
and since error line numbers come from that array's index, one blank row in the
middle of a sheet sent the owner to the wrong line for *every* error after it
(verified: a row physically on line 4 reported as line 3). Exported
spreadsheets have blank rows constantly, so this would have misdirected people
routinely. Blank rows are now skipped inside `eachRow`, after the index has
been counted, and are skipped rather than rejected — a spacer or a trailing
newline is an artefact, not something the owner meant to import.

**`npm run verify:import-csv`** — 128 checks over the planners, following the
existing `verify:seed-*` convention since `admin/` has no test runner. The bulk
of it is **4 entities × 7 markets × 3 store shapes** — every sample importing
cleanly into an empty store, a store sharing none of the seed's names, and a
seeded-looking one. Plus: an Excel-shaped file (BOM + CRLF + re-cased,
reordered headers), every validation rejection per entity (12 product, 2
category, 6 banner, 11 coupon), line numbers surviving blank rows,
`id`-beats-name precedence, case-insensitive matching, pipe-split
multi-value columns, the currency-glyph number path, the empty-store onboarding
case, image URLs surviving the round-trip as literal https, and market
resolution by language.

The lesson worth carrying: **a fixture built to match the thing it checks
proves nothing.** The sample-vs-store checks now vary the store, not just the
file.

**Not in v1:** per-size variants (no sensible flat-file shape — an update
merges, so a product that already has variants keeps them), category/brand
creation, and image upload (URLs only).

**A pre-existing seed gap this surfaced, deliberately left alone.** Checking
that every sample row carries a real image URL failed on six of seven markets,
and the cause is in the seed catalogs themselves: **2–30 products per market
have no `imageUrl` at all** (india 2, germany 19, france 26, spain 26, italy
29, uk 29, us 30). "Generate sample data" writes those imageless products
today — this is not new, and it is not something the import introduced.

The sample now *selects* only products that have an image (every market has far
more than the eight it needs), which fixes the download without editing a byte
of seed data: the diff to `lib/seed/` is 36 insertions and zero deletions, all
of them the new `seedMarketForStore`. All 56 sample image URLs (7 markets × 8
rows) were confirmed to return HTTP 200.

Filling the missing seed images is its own task — `verify:seed-images` checks
that the URLs which *exist* resolve, not that every product has one, so a
catalog can pass it with 30 blanks. Worth adding that assertion when the
images are authored.

### Landing page: the dialog no longer opens on arrival

`/login` and `/signup` rendered the landing page with the auth dialog seeded
open, so arriving at either put a sign-in form over a blurred marketing page
before the visitor had asked for anything — and the dashboard's signed-out
bounce sent people there, so it did not take a typed URL to hit. The dialog now
opens **only from a click** (nav "Log in", any "Start free" CTA); `initialMode`
is gone entirely rather than gated, both routes 307 to `/`, and the dashboard's
signed-out bounce goes to `/`.

Temporary (307) not permanent: a 308 is cached by browsers indefinitely and
would make reinstating either route painful.

Consequence accepted on purpose: a signed-out admin landing on `/dashboard`
now arrives at the marketing page with no prompt and signs in from the nav.

### `sitemap.ts` + `robots.ts`

Both were missing entirely. Two public routes (`/`, `/docs`); `/dashboard/` and
`/api/` disallowed. `/login` and `/signup` are deliberately **not** disallowed —
a crawler blocked from fetching a URL never learns it redirects, and would keep
the dead URL on file instead of dropping it. No `lastModified`: these are cached
Route Handlers, so `new Date()` would evaluate at build time and claim every
page changed on every deploy, and Google discounts a lastmod it can't trust.

The site origin was hardcoded in three places; it is now `lib/site.ts`, read by
`page.tsx`'s `metadataBase`, the JSON-LD blocks, and both new files. A sitemap
listing a domain the canonical tag doesn't use is worse than no sitemap.

---

## Terms & Conditions — real copy, six locales — DONE (2026-08-06)

The last lorem ipsum in the storefront, and a store-review blocker: the Privacy
Policy beside it had been rewritten months earlier, but Terms was still the
"It is a long established fact that a reader will be distracted…" filler — and
the six-language pass had faithfully translated that filler into all six.

**Shape.** Terms was one heading plus one body; it is now an intro plus **ten
numbered clauses** using the same `…SectionNHeading`/`Body` naming the Privacy
Policy already used, so `LegalDocumentContent` builds both documents
identically and all three packs render it with no template change. 713 → 731
keys per locale, at full parity.

**The three facts that shaped it**, decided rather than assumed:

- **The store is the merchant of record, not CordeliaApps.** This follows what
  the payments layer already does — each store settles into its own Razorpay
  account and the platform never holds shopper money — so the Terms say the
  purchase agreement is with the store, and that orders, products and refunds
  are the store's responsibility with the app as the channel. Writing it the
  other way round would have contradicted the code.
- **Operated from India, serving stores worldwide.** §1 says so plainly, notes
  the app is available in several languages with prices in each store's own
  currency, and names the English version as controlling where a translation
  differs — the standard way to keep six translations from becoming six
  slightly different contracts.
- **Indian law, with a consumer carve-out.** §9 names Indian law and Indian
  courts, then says explicitly that this does not remove mandatory local
  consumer protection — UK and EU shoppers keep their statutory rights,
  including any withdrawal right. A single governing-law clause naming India
  and stopping there would have been wrong for four of the seven markets that
  now have catalogs.

The operator is named as **"CordeliaApps"**, a trading name — no registered
entity is claimed, because none was given. Both app stores want a real
operator identity on a submission, so the registered name and address still
need to be added before one.

**Not legal advice.** These are working terms written to be accurate about how
the product actually behaves; they have not been reviewed by a lawyer, and the
EU/UK consumer clause in particular is the part worth having checked once a
real European store is live.

**Gates:** `scripts/check-arb-parity.py --all` green at 731 keys across de, es,
fr, hi, it (including French's no-break space before `:` and the still-English
detector); `flutter analyze` clean; all 85 cordelia tests pass.

### A pivot considered and reversed, worth recording

Mid-task the direction was briefly to drop Hindi and INR entirely and target
US/UK/EU only. It was reversed before landing, and the reason it was worth
pausing over is the one that will come back: **Razorpay only works for Indian
merchants.** It spans 62 files — per-store keys, encrypted secrets, webhooks,
refunds, the whole checkout — and settles INR into Indian bank accounts, so a
German, UK or US store cannot onboard to it at all. Any real move to those
markets is a Stripe migration first and a copy change second.

Two smaller facts found while scoping it, both still true: `toStoreCurrency()`
falls back to `StoreCurrency.inr` and `money.ts` has `FALLBACK: "INR"`, so INR
is the *default*, not merely an option — retiring it means naming a new default
and deciding what happens to existing store docs. And the India Post pincode
lookup plus Ola Maps geo proxy are India-only features that a US/UK/EU-only
product would have no use for.

---

## Productionisation: brand, domain, analytics, and cordelia on Play — DONE (2026-08-07)

The first end-to-end pass at *shipping* rather than building. Cordelia is now a
signed release bundle on Google Play, installable from an internal-testing
link. Everything below is what that turned out to require.

### The domain, and the SEO it quietly fixed

`cordeliaapps.com` was referenced everywhere in code — `metadataBase`, the
canonical tag, the JSON-LD Organization URL — and **had never been
registered**. WHOIS returned no match. So every SEO signal pointed at a host
that did not resolve, which is worse than none: a canonical naming an
unreachable URL tells Google the real one isn't the one to index.

Registered at Hostinger, DNS pointed at Vercel (A + CNAME), and `www` 308s to
the apex. That redirect had to go in **`next.config.ts`, not Vercel's Domains
UI** — Vercel only offers the redirect control on domains it doesn't consider
production-assigned, and once both hostnames resolve to the project the control
disappears. Doing it in config also puts the rule in a diff instead of a
dashboard nobody can review.

Two pre-existing bugs surfaced while verifying:

- **`metadataBase` lived on the home page only**, so `/docs` (and every page
  added since) emitted a *relative* canonical, `href="/docs"`. Moved to the
  root layout where every route inherits it.
- The root fallback `<title>` still read **"FlutterAgentic Admin"** long after
  the rebrand — the tab title on every dashboard page.

### The brand mark, everywhere

The Figma symbol (`symbol-swift-bird`, node 7:120) replaced the stock Next.js
favicon and the placeholder purple "C" across web and mobile. The exported SVG
needed two corrections before it was usable, both found by rendering it rather
than trusting it:

- **The facet cut was a `#0A0A0B` stroke** — the dark artboard's background
  painted over the wings. It reads as a gap on that canvas and as a **black
  slash** on anything else. Reimplemented as a `<mask>`, so the cut is a real
  transparent gap and the mark sits on any surface.
- **The artwork was off-centre** in its 80×80 frame (occupying y 11–56), so it
  hung high in every square container. viewBox tightened to the bounding box;
  gradients are `userSpaceOnUse` and unaffected.

On the Flutter side, `/add-app-logo` generated every launcher size — and the
adaptive icon came out visibly smaller than its siblings because
**`ic_launcher.xml` applies its own `android:inset="16%"` on top of whatever
foreground you supply**. A 55% foreground lands at ~37% of the final icon.
Rescaled to 78% so the inset does the safe-zone work.

**The in-app splash was silently broken, and had been.** `cordelia-wordmark.svg`
set "ordelia Apps" in an SVG `<text>` element — which **flutter_svg does not lay
out at all**. The splash could only ever have shown the symbol with the name
missing, and nothing would have complained. Replaced with the mark plus real
`Text` in the theme's typeface, which also themes and translates correctly.
Three tests guard it, including that the mark still parses and its cut is still
a mask.

### Analytics, with consent that actually gates

GA4 via Firebase. The measurement ID had been sitting in `.env.local` and in
Vercel production since the project was created, unused — `firebase.ts` only
ever called `getAuth`/`getFirestore`/`getStorage`.

**Nothing loads before consent**, and that is verified rather than asserted:
`firebase/analytics` is behind a dynamic `import()`, and the build confirms the
gtag loader lives in its own 20K chunk with zero occurrences in the layout
entry. A visitor who declines downloads no SDK and sets no cookie — a stronger
position than Consent Mode's "load but restrict".

Events: `page_view` sent manually (the SDK's automatic one is disabled via
`send_page_view: false`, or the landing page double-counts), `signup_opened`
with a `location` naming which of the five CTAs fired, and GA4's recommended
`sign_up` on success so it lands in built-in reports.

Consent is read with `useSyncExternalStore` rather than mirrored into state —
the repo's lint forbids `setState` in an effect, and it genuinely *is* external
state, which also makes a choice in another tab update this one for free.

### Legal pages, and the ones Play demands

Four now exist where the footer previously linked to three 404s:

| | |
|---|---|
| `/privacy` | website + console, for **store owners** |
| `/terms` | platform agreement with a store owner |
| `/app-privacy` | shopper-facing — the URL submitted to Play |
| `/delete-account` | Play's required data-deletion URL |

`/app-privacy` is separate from `/privacy` deliberately: different audience,
different controller. Pointing Play at the store-owner policy would describe
the wrong processing to the wrong reader. Claims in both are checked against
the code — the deleted list mirrors `USER_SUBCOLLECTIONS` in `account.ts`, and
"no advertising, no tracking, no analytics SDK" is true because the Flutter app
ships none of those packages.

`/refunds` was removed from the footer rather than written: a refund policy for
a free product invents an obligation that doesn't exist.

A `LegalPage` shell was extracted the moment there were two of these.

### Company email

`support@cordeliaapps.com`, via **ImprovMX** free forwarding (MX + SPF at
Hostinger, no nameserver move, website records untouched). Zoho's Forever Free
plan is **no longer offered in its setup flow** — the console shows only paid
tiers — so the earlier recommendation didn't survive contact.

The Gmail address had been published in **19 files**: the site's privacy,
terms, docs, footer, final CTA and JSON-LD, plus the app's Terms in all six
languages. All swapped, localizations regenerated, ARB parity re-gated at 731
keys. Still receive-only: replies come from Gmail until "Send mail as" is set
up.

### Cordelia on Google Play

The last hard blocker: release builds were signed **`CN=Android Debug`**, which
Play rejects outright — confirmed by reading the certificate out of the built
bundle, not assumed from the TODO comment.

- `build.gradle.kts` now reads `android/key.properties` into a real release
  `signingConfig`, **falling back to the debug key when absent** so a fresh
  clone and CI without secrets still build.
- `version: 0.1.0` → `1.0.0+1`. The build number after `+` is what Play keys
  uploads on and must increase every time; left implicit it defaults to 1 and
  silently blocks the second upload.
- Upload key generated by the user (interactively, so the password never
  entered a transcript or shell history), stored outside the repo.

Verified on the rebuilt bundle: signer `CN=Abhinav Kumar, O=Cordelia Apps`,
valid to 2053 (Play requires past 2033), package `com.cordeliaapps.superapp`,
66.5 MB against Play's 150 MB base limit.

**Android developer verification** turned out to need no work: publishing
through Play auto-registers the package, and the console showed it Registered.
The upload key is absent from that key list until the first upload, because
Play learns it *from* the upload — which is why it looked alarming and wasn't.

Bundle uploaded, internal testing track rolled out, **tester link confirmed
working**.

### What this leaves open

- **No crash reporting.** The app is now installable by strangers and a
  production crash is still invisible. This is the highest-value remaining gap.
- ~~**12 testers × 14 days** of closed testing before production access, if the
  Play account is personal and post-Nov-2023. Not shortenable — worth starting
  early.~~ **Testers met (2026-08-19)** — the closed-testing track has its 12
  opted-in testers. The 14-day continuous window is the clock, not a task: it
  runs from the day the twelfth tester opted in, and dropping below 12 at any
  point restarts it, so the group has to stay intact until Play offers the
  production-access application.
- ~~**At least one real live store** before the public listing: a reviewer
  opening the app to an empty discovery list is a rejection under minimum
  functionality.~~ **Met (2026-08-11)** — a real store is published and
  reachable in discovery, on the `grofast` template. Worth keeping in view
  rather than deleting: the publish lifecycle shipped after this was written,
  and discovery now shows *only* published stores, so this blocker returns the
  moment that store is unpublished.
- Data safety form; iOS signing; `support@` cannot yet send. *(The app-level
  theme's purple/green clash is closed — see "Discovery + brand chrome"
  below.)*

## Notifications — push + in-app centre, end-to-end — DONE (2026-08-08)

The last per-template mock is gone. Notifications were the one storefront
surface still reading a bundled JSON file keyed on the *template*, so every
store on `dailymart` showed the same invented list. They are now real data,
composed in the console or by the platform, delivered as a push and kept in
the notification centre.

### Sending is one operation, not two

`admin/src/lib/push.ts` writes the Firestore record **and** calls FCM. Nothing
else may do either half. That is why the console composes through an API route
rather than the client SDK it uses everywhere else: only the Admin SDK can
reach FCM, so a client-side `addDoc` would inevitably drift into "saved but
never pushed".

The write comes first, and only *its* failure fails the call. A saved
notification with no push is one the shopper still finds on their next visit; a
push with no record is a banner that vanishes and leaves nothing behind. A dead
FCM path therefore degrades to in-app-only and reports `pushed: false`, which
the console surfaces as "Saved, but the push could not be delivered" instead of
claiming a delivery that didn't happen.

### Topics, not a token registry

Every push today addresses a **topic** — `platform`, `store_{storeId}`,
`user_{uid}`. No fan-out, no stale-token cleanup, and a reinstall
re-subscribes itself. The store topic is subscribed as a storefront session
opens and dropped as it closes (inside the same session guard as the theme and
locale reset, or a tab jump that replaced the visit would silence its
successor). The user topic follows `authStateChanges` rather than the sign-in
and sign-out call sites, because five different things change who should
receive order pushes and only one of them is a button — and dropping the old
topic matters more than adding the new one, or the next person to sign in on
that handset keeps getting the previous account's order updates.

Device tokens are filed anyway (`devices/{token}` — see the ownership section
below). **Nothing sends to them yet.** They exist because a topic can address
an audience but never a device, and because the row is the record of who
accepted the permission and on what.

### Server-authored copy, and the localization trap

Order updates are composed on the server because the events are server-side:
the shopper who needs to hear "delivered" is by definition not the person who
pressed the button. That creates the problem `docs/how-to/add-language-pack.md`
warns about — server copy can't be localized by the app. So the four events are
written out per language in `order-notifications.ts` and picked by the
**store's** language. Imperfect and knowingly so: a shopper who overrode the
language on their own device still gets the store's default, because nothing
server-side knows about an on-device override.

Two smaller calls in the same file: no amount is interpolated into any string
(a currency figure inside translated copy is its own trap), and a cancellation
sends under the `payment` kind — there is no `cancelled` kind, and adding one
would mean touching all three packs' glyph maps for a message that is a refund
from the shopper's side anyway.

### Permission and init timing

The permission prompt belongs to **signing in**, not launch: a visitor still
deciding whether to make an account shouldn't be interrupted by a dialog they
have no reason to accept, and iOS only ever offers it once. `init()` runs from
Discovery's first frame, never `main()` — on iOS, querying the launch
notification before the navigator is mounted drops the tap that opened the app
from a terminated state.

### Where a tap lands

Originally every tap opened Discovery, because a storefront page needs a live
session the push can't carry — it holds only a store id. Fixed by making the
router *earn* the session: it fetches the store by id (new
`GET /api/stores/{storeId}` consumer: `GetStoreUseCase`), mounts that
storefront, and pushes the notification centre one frame later, once
`StorefrontPage.initState` has seeded `ActiveStoreCubit`. If the shopper is
already inside the sending store it pushes directly rather than re-mounting,
which would reset the shell to its home tab and drop whatever they had above
it. Platform notifications belong to no store and still land on Discovery,
as does anything unroutable — a deactivated store, or no network on a cold
start.

### Three things Android made us find out

- **`@mipmap/ic_launcher` is wrong as a notification icon.** Android keeps only
  a small icon's alpha channel and fills it white, so the round adaptive
  launcher rendered as a filled donut. A flat monochrome `ic_notification`
  drawable, plus the `default_notification_icon`/`_color` manifest meta-data
  the OS reads when a *backgrounded* push is drawn without running our Dart.
- **`flutter_local_notifications` needs core-library desugaring** — without
  `isCoreLibraryDesugaringEnabled` the Gradle build fails outright.
- **FCM silently drops a push image over ~300 KB** — the push still arrives,
  just with no picture and no error anywhere. Enforced at upload time in the
  console so the sender finds out there rather than from a complaint.

### Also shipped in this pass

Artwork now renders in the notification centre, not just the banner: a
full-width 2:1 block under the row in each pack's own corner (gravia's
`AppRadius.lg`, dailymart's card radius, grofast's tile radius inset inside the
card). Full width rather than aligned to the text column — it reads as the
banner it was uploaded as, and doesn't have to track the leading disc's size.

### The screen asks before it shows

The notification centre now checks the OS permission first: granted → the
loading/loaded/empty states as before; not granted → a shared prompt
(`NotificationsPermissionBody`) with the pack's own CTA, which raises the
system dialog and loads the feed on a yes.

The check lives in `NotificationsBloc`, not in a screen's `setState` — it is
state the screen renders from, and putting it in the bloc is what gives all
three templates the same gate for one implementation. It reaches
`FirebaseMessagingService.instance` directly, the same way `AddressBloc`
reaches `SharedPreferenceService.instance`: static-singleton services are
ambient infrastructure here, not GetIt entries or repository dependencies.

Two behaviours worth knowing:

- **The button always works, even after a refusal.** Both platforms return the
  standing decision from `requestPermission()` rather than re-prompting, so a
  shopper who denied earlier gets `false` with no dialog — the bloc marks the
  state `blocked` and every template snackbars where the switch is. If they
  then enable it in Settings and come back, the same button returns granted
  and loads the feed, so no app-lifecycle listener is needed to recover.
- **A failed status read reports granted.** `isPermissionGranted()` swallows
  its errors optimistically, because the cost of being wrong in that direction
  is a prompt that shouldn't have appeared, while the other direction hides a
  feed that loads fine. On web it returns granted outright — Firebase isn't
  initialised there, so there is nothing to enable.

Copy is app-level (`ValueConst.notificationsPermission*`, four new keys at 738
across six locales) rather than per-pack like the empty/error strings beside
it: the wording is functional, not brand voice.

**Known trade-off:** while permission is off, the in-app feed is behind the
prompt — including notifications that arrived earlier. The centre itself works
without push permission, so this is a deliberate "ask first" choice, not a
technical limit; making it a dismissible banner over the list is a one-branch
change if it reads as too aggressive in use.

### One phone, two shoppers — DONE (2026-08-08)

A handset gets sold, lent, or shared. Asking "is this device token still
active?" turned out to be the wrong question — it conflates two: is the
install *alive* (a timestamp can estimate that) and *whose* is it (a timestamp
can never say). Checking the code found the ownership half broken in two
places and the liveness half measuring the wrong thing.

**The topic leak was live, not theoretical.** Order updates are addressed to
`user_{uid}`, and the unsubscribe on sign-out was best-effort with the
subscribed uid held only in memory. Sign out with no network — or kill the app
while signed out — and the handset stayed subscribed to the previous account
forever, with nothing left that knew to undo it. The next shopper to sign in
received their order notifications.

Fixed by persisting what the device believes it is subscribed to
(`fcm_subscribed_topics` in SharedPreferences, written only after FCM accepts
each call) and reconciling on the first auth report of every launch: exactly
two subscriptions are legitimate then — `platform` and the signed-in
shopper's — so anything else is left over and gets dropped, retried each
launch until it sticks. That also collects store topics whose storefront never
got to tear down.

**The registry's DELETE could never have run.** `_unregisterDevice` fetched
its ID token from `FirebaseAuth.instance.currentUser`, but it was called from
the `authStateChanges` listener — which fires *after* sign-out completes, when
`currentUser` is already null. It returned early every single time, so A's row
survived and B's registration wrote a second row for the same token.

The fix is the data model, not the call: a device is now `devices/{token}` at
the top level with `uid` as a **field**. The token is unique per install, so
the document *is* the handset — signing in takes ownership by writing it, and
two accounts can never hold one phone. Filing under `users/{uid}/devices`
encoded ownership in the path, which is precisely what changes here. Release
on sign-out survives as hygiene (`releaseDevice`, now called from
`FirebaseAuthService.signOut` *before* the sign-out, which is the only moment
an ID token still exists), and it's transactionally guarded to no-op if the
row has since been claimed by someone else — a late release must not
unregister the new owner.

Two smaller holes closed with it: a rotated token used to leave its
predecessor behind forever (`onTokenRefresh` now releases the outgoing row
first), and account deletion never touched devices, `notifications` or
`notificationReads` — the first now swept by uid, the other two added to
`USER_SUBCOLLECTIONS`.

**Liveness now measures liveness.** `updatedAt` moves on every launch, but
registration used to be skipped entirely when permission wasn't granted — so
revoking notifications in Settings froze the timestamp and looked exactly like
an uninstall. The device registers either way now, with `granted` on the row.
A weekly `POST /api/devices/prune` (Vercel Cron via `CRON_SECRET`, or a
superadmin by hand) deletes rows untouched for 270 days — FCM's own staleness
horizon, so the sweep cannot discard a device FCM would still have delivered
to.

The real reaper is still missing and always will be until something sends by
token: the authoritative signal that a token is dead is FCM answering
`messaging/registration-token-not-registered`, which no amount of timestamp
arithmetic substitutes for.

### Audit pass — six defects and two rough edges (2026-08-08)

A read-through of the whole notification path, after the device-ownership
work, found more than the ownership half:

- **A repeated status PATCH re-pushed.** `updateOrderStatus` no-ops when the
  status already matches, but couldn't say so through its return value, so the
  route notified regardless — a double-clicked "Delivered" told the shopper
  twice. The route now compares against the order it already read.
- **Closed accounts were being re-created as notification data.** Orders
  deliberately outlive the account that placed them, and advancing one wrote
  `users/{uid}/notifications` under a uid that no longer existed — Firestore
  creates subcollections beneath a missing parent doc without complaint, and
  nothing would ever have deleted them. `notify()` checks the account first.
- **Mark-as-read dropped a third of a full feed.** The batch sliced to
  `PER_SOURCE_LIMIT * 2` with a comment saying the feed caps at 100 — but the
  feed merges *three* sources, so it returns up to 150 and the tail never got
  a receipt. Named `MAX_FEED_SIZE` off a `SOURCE_COUNT` so the two can't drift
  again.
- **Opening the screen cost more every year.** Read state came from listing
  the whole `notificationReads` collection, which nothing ever prunes — not
  even when the notification a receipt points at is deleted. Now a `getAll`
  of just the ids in the merged feed: one round trip, bounded by
  `MAX_FEED_SIZE`, and orphaned receipts simply stop being read rather than
  needing a sweep of their own.
- **A dead image host meant no banner at all.** The foreground path built its
  own `Dio()` with no timeouts, and the notification isn't drawn until the
  artwork fetch returns. 5s connect/receive on `BaseOptions` (a
  `connectTimeout` can't be set per-request, and connect is the case that
  hangs), so it degrades to text-only as intended.
- **The 300 KB ceiling was advice, not a rule.** It ran in the sender's
  browser; the route accepted any string as `imageUrl`. The constant moved to
  `lib/types.ts` (both ends read it), the input parser now requires a real
  **https** URL — FCM fetches it on the device, where `http://` is blocked by
  both platforms — and the send routes HEAD the URL to check `content-length`.
  A HEAD that fails or answers without a length is *not* an error: refusing to
  send over someone else's CDN behaviour would be worse than the invisible
  drop it guards against.
- **A self-cancel no longer notifies.** The cancel route serves both the store
  and the shopper; pushing "Your order was cancelled" at someone still looking
  at the screen where they tapped Cancel reports their own action back to
  them. Only an admin cancellation sends now.

Left alone deliberately: deleting a notification leaves its uploaded artwork
in Storage, which every catalog delete in the console also does — a consistent
existing choice, not a notification bug.

### What this leaves open

- **iOS artwork needs a Notification Service Extension.** FCM maps
  `notification.imageUrl` to `apns.fcm_options.image`, which iOS renders only
  if the app ships that extension target. There isn't one, so the image work
  is Android-only regardless of the APNs key — worth scoping with the iOS push
  work rather than after it.
- **iOS push is unconfigured** — no `aps-environment` entitlement, no
  `remote-notification` background mode, no APNs key in Firebase. Android-only
  until an Apple developer account is in play.
- **The device registry has no reader.** Every send is topic-addressed, so the
  tokens accumulate unused until something needs to reach one device — and
  until then there is no `registration-token-not-registered` feedback to prune
  on, only the 270-day sweep.
- **`CRON_SECRET` must be set in Vercel** for the weekly prune to run at all;
  unset, the cron door is closed by design and the endpoint stays
  superadmin-only.
- **No shopper-side controls** — a shopper can mute a store only by leaving it,
  and the OS-level toggle is all-or-nothing.
- **The feed doesn't page.** 50 per source is well past a scroll, and a chatty
  store can't push the platform's messages off the end because the cap is per
  source — but it is still a cap, not pagination.

## Discovery + brand chrome — DONE (2026-08-08)

The shopper's first two screens were the least designed in the app. Login
and Discovery are the platform's own surfaces — they run before any store's
template takes over — and neither had an identity of its own.

### The theme was a colour, not a palette

`assets/theme/theme_config.json` was an inlined copy of the shared `gravia`
preset with `primary`/`onPrimary` swapped to `#7059FF`. Every other role —
`primaryContainer` `#D0FBE8`, `secondary` `#0D9488`, `tintedPrimaryFill`
`#ECFDF6` — was still gravia's mint/teal family, so a purple button sat above
mint containers and a green brand mark.

It is now a real palette derived from the mark's own gradient stops
(`#007A60` → `#2DA987`, `assets/icons/cordelia-icon.svg`), light and dark.
Dark keeps `primary` identical to light for the same reason gravia does: the
header canvas and every filled button pair it with `onPrimary` white, and a
lighter dark-mode primary breaks that contrast. `web/manifest.json`'s
`theme_color` moved with it.

The cost, accepted deliberately: gravia's own primary is `#027A60`, so the
CordeliaApps shell now reads close to a gravia storefront. Tying the shell to
its own mark beat tying it to a colour the mark contradicts — and the shell
is only ever seen *outside* a store, never beside one.

### The chrome's header and CTA are a gradient, not a role

`#02291F` → `#027A60`, in `CordeliaColorConst`. Two orientations, and the
difference is load-bearing rather than taste:

- **Headers** ramp strictly top→bottom. `CollapsingHeaderSheet` paints
  `headerColor` flat behind the sheet's rounded top corners, so only a
  vertical ramp leaves the header's whole bottom edge at `#027A60` — any
  diagonal parks one corner mid-gradient and seams visibly. Every screen
  using it therefore passes `headerColor: brandGradientEnd`.
- **Pill CTAs** ramp left→right. The same vertical ramp across a 45px pill
  reads as a bevel on the control, not as a brand sweep.

`HeaderCanvas` gained an optional `gradient` (flat `cs.primary` still the
default, so no pack moved) with a gallery variant. `CordeliaPrimaryButton`
gained one too — opt-in, *not* the default, because that widget is also
`GraviaPrimaryButton` via typedef: defaulting it would repaint every gravia
storefront's Cart, Address and Edit Profile CTA in the platform's brand
instead of the store's. Only Login's Continue and Signup's Create Account
pass it; the social buttons stay secondary and the resend link stays text.

### The mark now reaches users who never see the splash

It had exactly one consumer, the splash, which is gone in under a second.
`CordeliaBrandMark` (`lib/widgets/`) is the mark on an `onPrimary` disc,
optionally followed by the app name as live text. The disc is load-bearing,
not decoration: the mark's greens are fixed (a gradient, not tintable), and
the canvas it sits on is now the same green.

It opens Login's header, shares Signup's back-button row (name-less — the
title already says what the screen is), and opens Discovery's.

### Discovery

Was: an `AppTopBar`, a title, a `dense` search field about 40px tall, and a
flat `ListView` of every store. Now the `HeaderCanvas` + `CollapsingHeaderSheet`
composition the storefront packs already use —

- **Header** — brand lockup and the shopper's avatar, a time-of-day greeting
  by first name, and the search field on the canvas at a real 52px. The
  greeting renders name-less until the profile resolves rather than flashing
  a placeholder; `ProfileBloc` is hoisted to `DiscoveryPage` so it survives
  every list rebuild.
- **Body** — a "Jump back in" rail over "All stores". Both headers disappear
  while a search is active: a result list is one flat answer to what was typed.

### Recents are ids, not a cache

`recent_stores_prefs.dart` stores up to six store **ids**, most-recent first;
re-opening promotes rather than duplicates. The bloc resolves them against the
store list it just loaded, so a renamed, restyled or removed store can never
show a stale card — and there is no serialization of `StorefrontTemplate` /
`StoreLanguage` / `StoreCurrency` to keep in sync. Recorded on the way *into* a
storefront so the rail is already reordered on the way back out, and cleared
by `signOutAndReturnToLogin` (which account deletion also runs) — which stores
someone shops is personal.

The loading skeleton reads the same prefs synchronously, so a first-time
shopper doesn't get a shimmering rail that never arrives.

### Follow-ups to the discovery pass (2026-08-08, same day)

Four fixes the new screens surfaced, and one Play-policy correction that had
nothing to do with them:

- **"Forgot password" worked once.** Both outcomes of that handler are
  one-shot snackbar signals rather than rendered state, and the handler
  deliberately skips `loading` (Login's spinner reads that state, and this is
  a near-instant fire-and-forget). So a second tap on the same address — 
  exactly what someone does when the first mail hasn't arrived — emitted a
  state equal to the current one, which bloc drops: no snackbar, button
  apparently dead. `AuthState` now carries an `attempt` counter that means
  nothing to the UI and only exists so consecutive answers differ.
- **The gallery permissions came off the manifest.** `READ_MEDIA_IMAGES` and
  `READ_EXTERNAL_STORAGE` are gone; the one gallery read in the app is Edit
  Profile's avatar picker, which now runs through the Android Photo Picker
  (`ImagePickerService` opts in via `useAndroidPhotoPicker`). The picker hands
  back the single URI the user chose, so it needs no storage permission at
  all — and declaring one anyway trips Google Play's Photo and Video
  Permissions policy, which reserves it for apps with a frequent need.
  Relevant to the production-access track, not just tidiness.
- **Predictive back** — `enableOnBackInvokedCallback` on the application tag.
- A **223-line regression test** pinning that entering a storefront fetches
  home, cart and favourites *once each*, plus a discovery-header test and a
  reworked store-list skeleton.
- Two operator scripts the multi-store work needed:
  `transfer-store-ownership.mjs` and `transfer-shopper-data.mjs`.

## Store publication lifecycle — DONE (2026-08-10)

Until now every store a shopper could reach was simply every store that
existed. A half-built store with three products and no logo sat in discovery
beside a finished one, and there was no state that meant "not ready yet".

`stores/{id}.status` is now a four-state lifecycle
(`admin/src/lib/store-status.ts`):

```
draft ──submit──► pending ──approve──► published
  ▲                  │                     │
  └──reject(reason)──┘                unpublish──┐
  └───────────────────────────────────────────────┘
```

**The server owns every transition.** `firestore.rules` lets a store owner
write their own store doc, so a client-writable status would let any admin
publish themselves without review. All four actions go through one route
(`POST /api/stores/{id}/publish`) with two audiences — owner submits,
superadmin approves/rejects/unpublishes — mirroring the dual-role cancel
route, and for the same reason: the state machine is one thing, and splitting
it across two files is how the halves drift into disagreeing about which
transitions are legal. Each action declares which statuses it may be applied
to, so a double-clicked button or a stale tab can't approve an
already-published store or resurrect a draft straight to live.

Stores predating the lifecycle carry the old `"active"` marker, which meant
exactly "visible in discovery" — `normalizeStoreStatus` reads it as
`published`, so a store that was live stays live whether or not
`scripts/migrate-store-status.mjs` has run against it. Anything unrecognised
reads as `draft`, which fails closed.

**A readiness checklist, not a rule engine** (`admin/src/lib/store-readiness.ts`)
— logo, at least one category, at least one product, payments connected. It is
owner-only, because naming what a store is missing isn't public information,
and it recomputes on every call, caching a `previewReady` flag back onto the
doc. That flag is what discovery reads: counting subcollections per store on
every load would be a query per store, and an owner's empty store showing an
empty storefront helps nobody. So an owner sees their own unpublished store in
the real app while they set it up, and nobody else does.

Storefront side: `StoreStatus`/`StoreFilter` enums, a "Not published yet"
marker on the owner's own cards, and a filter chip row that appears **only**
for someone who actually owns an unpublished store — for an ordinary shopper
"Setting up" would be a permanently empty tab, and a control that can never do
anything is worse than no control. The rail and the list are filtered by the
same chip, which they weren't at first: recents were resolved before the
filter, so the screen contradicted itself.

## Stripe as a second payment provider — DONE (2026-08-10)

Razorpay is INR-only. Seven markets had catalogs, six locales had copy, and a
EUR/GBP/USD store still could not take a single payment — `quoteCart`
hardcoded `"INR"` as the charge currency. Stripe closes that.

**One provider interface, two adapters** (`admin/src/lib/payment-providers/`).
The provider is never a setting the owner picks: it is read off the key prefix
(`rzp_test_`/`rzp_live_` → Razorpay, `pk_test_`/`pk_live_` → Stripe), so
pasting a key *is* choosing a provider and the two can never disagree. Both
adapters are raw `fetch` rather than each vendor's SDK — this is six endpoints
per provider, and the SDK's only job would be building those requests.

**The verification models are genuinely different, and the code had to bend to
it.** Razorpay hands back an HMAC signature the client returns and the server
checks locally; that signature binds the intent id, so the charged amount
never had to be re-derived. Stripe's PaymentSheet returns no signature — its
equivalent is a server-side re-fetch asserting the PaymentIntent really
reached `succeeded` for the amount intended. That means the second half of
checkout now has to arrive at *exactly* the same number as the first, and
"exactly the same" is only guaranteed if it is the same code. Hence
`admin/src/lib/checkout-quote.ts`: the one place the charged amount is
derived, called by both `POST /payments` and `POST /orders`. Both halves used
to price the cart with their own copy of the same three steps.

Also in this pass: a Stripe refund webhook beside the Razorpay one, a provider
switch in Settings that keeps both sets of credentials so a store can move
between them without retyping, `verify:stripe` and `verify:payment-config`
scripts, and a Flutter `StripeService` behind the same `PaymentGatewayRepository`
the storefront already used — the app still never names a provider, it routes
to one (`routing_payment_gateway_data_source_impl.dart`).

## Delivery fee and per-store serviceability — DONE (2026-08-11)

The last unclosed item from the original "Missing flows" list (#12). Every
storefront's totals panel printed **"Delivery — FREE"** as a hardcoded string,
in three packs and six languages, because there was nothing behind it to
print.

**One policy, on the store doc** (`stores/{id}.delivery`): a flat `fee`, a
`freeAbove` waiver threshold, and `areas` — postal-code **prefixes** the store
serves. Prefixes rather than whole codes because the unit a store actually
thinks in is a city or a district (`560` is Bengaluru, `SW1` is Westminster),
and enumerating every code in one would be thousands of rows an owner
maintains by hand. Empty `areas` means "delivers everywhere", `fee: 0` means
"never charges" — so every store predating the field reads back as exactly
what it was already doing, and no backfill is needed.

**The arithmetic lives in one file** (`admin/src/lib/delivery.ts`), for the
reason the Stripe pass established: the fee is part of the charged amount, so
`quoteCart` (the payment intent) and `createOrder` (the order transaction)
must reach the same number, and a drift between them doesn't surface as a
wrong figure on a screen — it surfaces as a *failed payment verification*.
`POST /orders` therefore passes `addressId` into its verification quote too,
which is easy to miss: without it the re-derived total comes out short by the
fee and every checkout at a charging store fails.

**Two decisions worth recording, because both are visible to shoppers:**

- The threshold is measured on the basket **after** any coupon — what the
  shopper actually pays for goods. So a coupon can drop a cart back under the
  threshold and re-introduce the fee. The alternative (measuring the
  pre-discount total) would let a large enough coupon buy free delivery the
  store never offered. The Delivery settings card says so in as many words.
- An address with **no postal code** is never refused. The field is optional
  in the address form and absent entirely from addresses saved before it
  existed; blocking checkout on a field the shopper was never asked for would
  break accounts that did nothing wrong. A store that needs the guarantee gets
  it by asking for the code, which the form already offers.

**Serviceability is checked twice, deliberately.** `POST /payments` refuses an
out-of-area address *before* the intent exists, so it costs a message rather
than a refund; `createOrder` re-checks inside its transaction, because the
address can be edited and the policy narrowed between the two calls. Both
return `code: "unserviceable_address"` so the client can point at the address
rather than at the basket.

**The app checks first, in the shopper's language.** All three packs guard
their checkout submit against `context.storeDelivery.serves(...)` and show a
localized message; the server's own refusal is English-only, the same
constraint recorded for order notifications. That mirror is the risk in this
design, so it is pinned down by tests on both sides:
`admin/scripts/verify-delivery.ts` and cordelia's
`test/unit/feature/home/store_delivery_test.dart` check the *same* cases —
threshold inclusivity, prefix width, the empty-postal-code lenience. Change
one, change both.

The fee now renders in every place a total is explained: all three packs' cart
totals, dailymart's and grofast's checkout, all three Track Order screens
(from `order.deliveryFee`, snapshotted at placement so a later policy change
can't rewrite an old order), and the console's order detail — where Subtotal
earns its line as soon as anything sits between it and the total. `payableTotal`
is now `items − coupon + delivery`, which fixed every order total the app
showed by inference. The floating cart pill outside the cart is deliberately
left as goods-only: it is a basket indicator, not a bill, and it doesn't net
the coupon either.

Store settings gains a **Delivery** tab. Nothing there is trusted at checkout —
the server recomputes both halves from the doc — so the form is the policy,
not the arithmetic.

### The form had to learn the store's market, not just its currency

The first version of the Delivery tab took its fee label from the store's
currency (`currencySymbol`) and got that right, but showed **Bengaluru
pincodes** to every store: `560001` as the placeholder, "`560` covers all of
560xxx" as the help text. A Berlin owner learns nothing about what to type
from that, and a New York one doesn't even call it a postal code.

The store already declares a language and a currency, and between them they
name a country — the same inference the CSV import sample uses to pick which
market's products to demonstrate. That helper lived in
`lib/seed/seed-markets.ts`, which imports all seven catalogs at its top, so
using it from a settings form would have bundled thousands of lines of
product data to decide between "PIN code" and "ZIP code". It now lives in
`lib/market.ts` with no catalog imports; `seed-markets.ts` re-exports both
functions under their original names, so the seeder dialog and the import
sample are untouched.

`lib/postal-examples.ts` maps each market to its noun ("PIN code" / "ZIP
code" / "postcode" / "CAP"), two real example codes and a prefix with what it
covers. The UK entry is the one that matters most: it is the only market whose
codes aren't digits, so its example has to show both that letters are fine and
that the space is harmless (the normalizer strips it). `verify:delivery` now
asserts, for every market, that each printed example survives
`normalizeDeliveryAreas` and that the prefix in the help sentence genuinely
matches the example beside it — a wrong example is worse than none, because an
owner copies it verbatim.

The console's own UI stays English; that is the standing decision in
`lib/money.ts`, and what varies here is the example, not the sentence around
it. The shopper-facing half was already localized: the fee renders through
`AppFormat`, which `ActiveLocaleController` sets to the store's locale *and*
currency in one call, and both the "Delivery/Free" labels and the
out-of-area message ship in all six languages.

### Corrections to earlier entries in this document

Four items recorded as open above have since been closed, and reading them
cold would send someone off to build what exists:

- **The `storeAdmin` custom claim** (M1a step 3, "not yet built") ships — but
  not as the Cloud Function that entry describes. `setCustomUserClaims` runs
  in `POST /api/stores` and in `lib/api/admin-guard.ts`; there is no
  `functions/` directory in this repo at all.
- **Crash reporting** — called "the highest-value remaining gap" in the
  productionisation pass — is wired: `firebase_crashlytics` in cordelia.
- **The multi-store switcher UI**, listed as "not yet built" since the first
  catalog milestone, is `/dashboard/stores`.
- **The "at least one real live store" Play blocker is met** (2026-08-11) —
  a real `grofast` store is published and reachable in discovery.
- **Store-owner subscription billing is not a pending track.** Two older
  paragraphs (Missing flow #11, and the phased timeline's closing line) called
  it "a separate later track"; the 2026-08-07 decision dropped it outright and
  the landing page's pricing section now commits publicly to charging stores
  nothing. Both paragraphs are annotated in place.
- **Missing flow #12 (delivery/serviceability)** is closed by the section
  above. With it, the only items still open from that list of 13 are #9
  (search — `searchKeywords[]` substring matching is still the whole of it,
  cross-store search unbuilt) and the parts of #1/#2 the auth and publish work
  didn't cover.

### What this leaves open

- **No delivery zones with different fees.** One flat fee per store. A store
  that charges more for the far side of the city has to pick one number.
- **No serviceability signal before checkout.** An out-of-area address is
  refused at the submit, not greyed out in Select Address — that would be
  per-pack UI in three packs, and the refusal is at least immediate and
  localized.
- **No delivery-time estimate.** The kits of all three packs draw one; nothing
  in the backend knows it, which is why they never did.
- **The server's own refusals stay English.** Consistent with "Insufficient
  stock for X", which has always been shown to shoppers verbatim in every
  locale.

## Delivery-agent apps — decided, not built (2026-08-11)

The largest functional hole left in the platform is that nothing downstream of
"order placed" is done by the person actually doing it. A store admin advances
an order by clicking a status in the console, and the 4-digit handoff OTP is
generated and shown to *both* the shopper and the admin while nothing verifies
it — there is no endpoint that takes it and no surface that would submit one.
"Delivered" is an honour-system button.

**The shape agreed:** a store's delivery agents get their own app, and the
shopper app lists those apps from a **new entry point in the top-right corner
of Discovery**. Discovery is the right host because it is the one screen that
exists outside any storefront — an agent works for a store but arrives at the
app before choosing one, exactly like a shopper does.

Deliberately **not** started yet, and nothing about the agent side is designed
here beyond that entry point: it is a separate app surface with its own
identity, its own roles and its own routes, and sketching those before the
Play production track is unblocked would be inventing requirements. Recorded
now so the corner is reserved and the OTP's dangling half has a named owner
rather than reading as an oversight.

Two things it will eventually close, both already recorded as open elsewhere
in this document: the unverified handoff OTP, and status transitions that
today only a store admin at a desk can make.

## API latency — region move + discovery query DONE, CDN caching deferred (2026-08-18)

Every API call took ~0.70s no matter how little it returned. The cause was not
the code: **Firestore is `asia-south1` (Mumbai) while every Vercel function ran
in the default `iad1` (Washington DC)**, so a request from an Indian shopper
went phone → Mumbai edge → Virginia → *back to Mumbai for the data* → Virginia →
India. Two intercontinental round trips to serve a few hundred bytes.

The tell was that payload size did not matter: a 31-byte search response and a
1.9KB categories response timed identically, and a route that returns 401
without touching Firestore still cost 0.35s — that 0.35s being the India↔iad1
leg on its own.

**Fix 1 — `regions: ["bom1"]` in `admin/vercel.json`.** Project-level rather
than a per-route `preferredRegion` export: there are 80 route files and a
per-route setting is 80 places to drift. `vercel.json` is schema-validated and
rejects unknown keys, so the reasoning could not live beside it as a comment —
it sits in `lib/firebase-admin.ts` instead, next to the existing `preferRest`
transport note, because moving the database region later means moving the
Vercel region with it. The two are one decision, not two.

**Fix 2 — `getStores()` queries instead of scanning.** Discovery read *every*
store doc and filtered published-vs-draft in JS: 14 docs read to return 1, with
drafts being the majority and growing with every owner who signs up and never
publishes — a cost that tracked signups rather than catalog size. Now one
`status in ["published","active"]` query, plus an `ownerUid ==` query only when
a signed-in viewer might own an unpublished store.

Three things that fix had to get right, each of which would have been a silent
bug: `"active"` must be named explicitly because it is the pre-lifecycle marker
`normalizeStoreStatus()` reads as published, and a *query* matches the stored
string, not the normalized one; the two result sets must be deduped, because an
owner's own published store matches both; and the merge must be re-sorted,
because merging two Firestore results loses the document order each arrived in.

`createdAtMs` was surfaced on `Store` in the same pass (the field already
existed on all 14 docs, it was simply never mapped) and now orders both store
lists **in opposite directions, deliberately**: discovery is a feed and runs
newest-first, while `/api/admin/stores` is a review queue and runs oldest-first
within its status priority, so the submission that has waited longest surfaces
next. `tsc` caught a third `Store` construction site during this — the
notification-tap route `api/stores/[storeId]/route.ts` — that grep had missed.

### Measured (from India, production)

| Endpoint | Before (iad1) | After region | After query fix |
|---|---|---|---|
| `/stores` | 0.696s | 0.490s | **0.219s** |
| `/categories` | 0.718s | 0.208s | 0.215s |
| `/products/popular` | 0.698s | 0.188s | 0.195s |
| `/banners` | 0.702s | 0.188s | 0.200s |
| `/search?q=` | 0.679s | 0.184s | 0.195s |
| `/brands` | 0.658s | 0.178s | 0.181s |

~3.5x on every warm call. The five unrelated routes holding steady across the
second deploy is the evidence that the `getStores` change regressed nothing.

### What this leaves open — cold starts, and the caching that would hide them

**Cold starts did not move and are now the whole remaining problem.** They are
module boot (`firebase` + `firebase-admin` + `getTemplates`), not distance, so
Mumbai costs the same as Virginia. Every Next.js route is its own function with
its own cold start, so each new screen a shopper opens can pay it again. Warm is
~0.20s; cold is 1.0–2.5s, and `/api/stores` — the first screen — is the worst of
them at ~2.5s because it is the heaviest module. Observed back-to-back on one
endpoint in the same second: 1.34s then 0.20s × 7.

**Accepted for now (2026-08-18): one ~2s cold start is fine.** Not a gap to
close before launch.

The fix when it is wanted is **CDN caching, not faster boots** — these routes
serve `cache-control: public, max-age=0, must-revalidate` on world-readable,
near-static data, so every shopper invokes a function for bytes that could come
off the edge. Caching sidesteps cold starts rather than fighting them.

Two things a future implementer must know, the second of which is a security
constraint and not an optimisation note:

1. **Staleness is already safe for catalog data**, because price and stock are
   re-read live inside the order transaction (`lib/orders.ts`, "name/image/
   price/stock all come from the live doc"). A stale catalog is cosmetic: the
   shopper is charged the live price, and a stale in-stock reads as an
   "Insufficient stock" refusal at checkout rather than an oversell. Bound it
   with `s-maxage` + `stale-while-revalidate`, and purge on admin write to drop
   real staleness to ~zero.

2. **Two routes vary by `Authorization` header and must never get a shared
   cache** — this would be cross-user leakage, not staleness:
   - `GET /api/stores` returns extra rows when an owner's token is present. A
     shared cache warmed by an owner's request would serve *that owner's
     unpublished draft stores to every anonymous shopper* — precisely the leak
     the route's own comment says the `/api/admin/stores` split exists to
     prevent.
   - `GET /api/stores/{id}/search` **without `q`** returns `recent_searches`
     keyed to the caller's uid. With `q` it is pure catalog and safe — the same
     URL is cacheable or not depending on whether a parameter is present.

   Safe to cache today: `categories`, `banners`, `products/popular`, `brands`,
   `products/{id}`, and `search` only when `q` is present. Never: `stores`,
   `search` without `q`, `cart`, `orders`, `favourites`, `notifications`,
   `users`. Caching discovery needs the anonymous and authenticated responses
   split, or a cache key on the auth header — a design change, not a header.

## Merchant documentation site + share cards — DONE (2026-08-18)

The public surface of `cordeliaapps.com` was one landing page and five legal
pages. It is now that plus a 24-article documentation site, and the share card
every one of those URLs had been promising and not delivering. Full search plan
and its open items: `docs/explanation/seo-plan.md`.

### The share card was a 404, and the cause was a literal array

`/og.png` was declared in the homepage metadata and had never existed, so every
link shared to Slack, LinkedIn or WhatsApp rendered blank — the one thing on the
site guaranteed to be seen by someone who has not visited it yet.

Fixed by **generating rather than uploading**: `admin/src/app/opengraph-image.tsx`
renders a 1200×630 card from the brand palette and Manrope through `next/og`,
with `twitter-image.tsx` re-exporting it. Two decisions worth keeping:

- **It lives at the `app/` root**, so *every* route inherits it. `/app-privacy`
  and `/delete-account` are the URLs submitted to Google Play and get shared in
  contexts nobody here controls; they now carry a card without a per-page
  declaration.
- **The hand-declared `openGraph.images` array had to be deleted** from
  `page.tsx`. A literal `images` array **overrides** the `opengraph-image.tsx`
  file convention — that array was what pointed at the missing file, so adding
  the generator without removing it would have changed nothing. This is now a
  rule in `admin/README.md`.

Manrope TTFs are vendored at `admin/src/assets/fonts/` so the build fetches
nothing. Both routes prerender statically; verified live in all three clients. A
link shared *before* the fix still shows blank until that platform re-scrapes —
platform caches, not our HTML.

### The documentation site

`/docs` had been a stub carrying `robots: { index: false }`. It is now 24 MDX
guides across 7 categories (~14,900 words): getting started, store setup,
catalog, payments, orders, growing your store, going live — written against the
console as it actually behaves, so each guide ships beside the feature it
documents.

**Content is files, not a database.** `src/content/docs/<category>/<slug>.mdx`,
read at build time by `src/lib/docs.ts` with `gray-matter` frontmatter
(`title`, `description`, `order`, optional `sidebarTitle`). A doc change is a
diff in the same PR as the feature, reviewable the same way. No CMS — that is a
decision for article #50.

**Everything reads the directory.** Sidebar, ⌘K search index, `generateStaticParams`,
prev/next pager and `sitemap.ts` all enumerate the collection, so adding a guide
is adding one file. The single exception is deliberate: a **category** is
declared in `docCategories`, because the order guides appear in is editorial —
what a new merchant hits first — not alphabetical, and a folder name cannot
carry a description or an icon. A category with no articles is filtered out of
the rail *and* the sitemap, since its route 404s.

Four implementation details that were each a bug first:

- **Headings are extracted from the raw source, not the compiled tree.**
  `compileMDX` runs in a server component and returns an opaque element — by
  render time there is nothing left to walk. Fenced code is stripped before
  scanning, or a `#` comment inside a bash block becomes a table-of-contents
  entry.
- **`slugifyHeading` is shared** by the TOC and the `h2`/`h3` MDX components.
  They must agree exactly or every TOC link is a dead scroll.
- **`blockJS: false`.** `next-mdx-remote` blocks `{…}` expressions by default —
  correct for MDX arriving from users, wrong for files in this repo, because
  with them blocked props like `labels={[…]}` and `cols={3}` are *silently
  stripped* rather than erroring. A component quietly rendering without its
  props is a worse failure than the one being guarded against.
  `blockDangerousJS` stays on.
- **`remarkGfm` is not optional.** Plain MDX is CommonMark, where a pipe table
  is literal text, and these guides are full of column specs. `rehypeHighlight`
  runs at build time so the reader downloads coloured markup instead of a
  highlighter.

The shell reuses `SiteNav`/`SiteFooter` rather than shipping its own header —
the docs read as a room in the same building as the landing page, not a second
brand. Authoring components: `Callout`, `Steps`, `Tabs`, `Cards`, `Accordion`.

### What it changed for search

- **The sitemap went from 6 URLs to ~38** — home + 5 legal + `/docs` + 7
  category pages + 24 articles, every one statically prerendered with its own
  `<title>`, description and self-canonical.
- **A P0 fix reversed itself within the day, correctly.** Hours earlier `/docs`
  was *removed* from the sitemap because it declared `noindex` — submitting a
  URL we had told Google to drop. The docstring recorded the condition for adding it
  back: the commit that gives the page real content and drops the flag. That
  commit is this one.
- **JSON-LD extended** beyond the homepage's `Organization` /
  `SoftwareApplication` / `FAQPage`: `CollectionPage` with `hasPart` on the
  index, `TechArticle` per guide.
- The domain has its first crawlable *depth* — internal links pointing at
  distinct pages instead of homepage anchors — and its first body of long-form
  unique content.

Google Search Console was registered in the same pass.

### What this leaves open

**None of it addresses commercial intent, and that is the point to hold onto.**
Every new URL answers an existing customer's question ("how do I connect
Razorpay"), not a prospect's ("how much does a grocery app cost in India"). A
store owner who has never heard of CordeliaApps still has exactly **one** page
to land on: pricing, templates and security are still anchors on `/`, not
rankable URLs. That structural fix is P1 in `seo-plan.md` and is untouched.

Smaller and specific:

- The sitemap is not yet **submitted** in Search Console, and Bing Webmaster
  Tools is unregistered. Until then the work above is unmeasured.
- The homepage `<title>` still leads with the brand rather than the category.
- The hero's **"App reviews — None"** stat means "no App Store review process to
  wait through" and reads as "nobody has reviewed this product."
- **`WebSite` JSON-LD** exists only as an `isPartOf` reference from docs
  articles, never as its own block — that is the one that binds the domain to
  the brand entity.
- **`BreadcrumbList` JSON-LD** is missing and got more valuable, not less:
  articles now sit three levels deep and the pages already render a *visual*
  breadcrumb, so the markup is describing something that is on screen.

One thing this pass bought for free: **the blog infrastructure P3 wanted is now
mostly built.** `next-mdx-remote/rsc` + `gray-matter` + `remarkGfm` +
`rehypeHighlight`, the typography shell, the frontmatter contract and the
sitemap-from-disk pattern are proven in production. A `/blog` is a second
collection over the same machinery.

## Consolidated open items (as of 2026-08-11)

Everything still open, in one place. This document is a chronological log, so
what remains is spread across six separate "What this leaves open" blocks, a
"Missing flows" list from the first week, and a corrections section — which is
enough surfaces that a reader can come away with the wrong picture in either
direction. Twice in one review an item was called open here that had shipped a
day later further down.

**This section is an index, not a second source of truth.** Each line points at
the section that owns the detail; when one closes, mark it there and strike it
here in the same pass.

### Blocking the Play production track

| Item | Owning section |
|---|---|
| Play Console rejected the closed-testing submission: `Financial features → Mobile payments and digital wallets` was declared, which restricts distribution to organization accounts. Cordelia sells physical goods through third-party gateways and holds no funds — the declaration is being cleared and appealed | new (2026-08-11), no section yet |
| The build number must exceed the `+3` already uploaded; a re-upload at the same version code is refused | — |
| Data safety form unfilled | "Cordelia on Google Play" |
| ~~12 testers × 14 days of closed testing, not shortenable on a personal account~~ — **12 testers met (2026-08-19)**; the 14-day window is now just elapsing | "What this leaves open" (productionisation) |
| Discovery must stay non-empty — it lists only *published* stores, so unpublishing the one live `grofast` store restores a minimum-functionality rejection | Corrections to earlier entries |

### The largest functional hole

**Delivery-agent apps** — nothing downstream of "order placed" is done by the
person doing it. The handoff OTP is generated and shown to both shopper and
admin while no endpoint accepts one; "Delivered" is a button a store admin
presses at a desk. Shape agreed, entry point reserved in Discovery's top-right
corner, deliberately unstarted. → "Delivery-agent apps — decided, not built".

### Shopper-facing blockers (2026-08-21 readiness scan)

| Item | Owning section |
|---|---|
| **Out-of-stock is invisible until checkout fails** — `stock` is enforced server-side but never serialized to the storefront, so a zero-stock product browses, adds to cart and is refused at payment | "Go-live readiness scan" |
| **No support channel anywhere** — no email, phone, form or thread; the `/refunds` policy page on the merchant site is not linked from the app either | same |
| **Hard login wall before any browsing** — splash routes an unauthenticated visitor to `/login`; no guest mode, no deep-link redirect-back | same |

### Commerce flows

- **Post-delivery returns/refunds** — refund is wired only to *cancel*; a
  delivered order cannot be returned. → Phase 3.6 in `end-goal.md`.
- **No delivery zones** — one flat fee per store. → "Delivery fee and per-store
  serviceability".
- **No pre-checkout serviceability signal** — an out-of-area address is refused
  at submit, not greyed out in Select Address. → same.
- **No delivery-time estimate** — all three kits draw one; nothing in the
  backend knows it. → same.

### iOS

~~Unstarted as a track~~ — **closed 2026-08-21**: the APNs key,
`aps-environment` entitlement, `remote-notification` background mode and signing
all landed, and the app is in TestFlight. What is still open is push verified on
real hardware, a Notification Service Extension for rich notification images,
and the App Store listing itself. → "iOS — signing, push entitlement, and the
first TestFlight build".

### Content and data

- **Catalog content is single-valued** — each market's catalog is written in
  that market's language, so a shopper switching the storefront's language gets
  translated chrome around a fixed-language catalog. The deliberate boundary. →
  `content-i18n-plan.md`, and "The remaining gap, unchanged".
- **Placeholder content** — onboarding's three slides are seeded stock photos;
  grofast's address tiles cycle two bundled map images; the product photo
  "carousel" is single-slide because the schema holds one image. → Phase 3.6 in
  `end-goal.md`.

### Smaller

- **Login's two social buttons** — **removed** (2026-08-21) rather than wired:
  placeholder UI that fires a coming-soon snackbar is a standing App Review
  rejection (Guideline 2.1). The copy and the divider recipe remain, so this
  stays open as a feature, not as a stub.
- **Search** — `searchKeywords[]` substring matching is the whole of it;
  cross-store search unbuilt. Missing flow #9, the last of those 13 still open
  apart from parts of #1/#2.
- **Notifications** — no shopper-side per-store mute, feed caps at 50 per source
  rather than paging, the device registry has no reader, and `CRON_SECRET` must
  be set in Vercel for the weekly prune to run at all.
- **Server-authored refusals stay English** in every locale ("Insufficient stock
  for X", serviceability refusals) — the app cannot localize copy the server
  writes.
- **API cold starts (~1–2.5s)** — warm calls are ~0.20s after the region move,
  but every route boots its own function. Accepted as fine for now; the fix is
  CDN caching, which two auth-varying routes must be excluded from. → "API
  latency — region move + discovery query DONE, CDN caching deferred".

### Explicitly not open

Recorded because each was believed open during this review and is not: crash
reporting (`firebase_crashlytics`), the `storeAdmin` custom claim
(`setCustomUserClaims`, no `functions/` directory), the multi-store switcher
(`/dashboard/stores`), the live-store Play blocker, store-owner subscription
billing (dropped, not deferred), per-market seed catalogs (all seven ship), and
persistent cart, stock, image hosting, CSV import validation and security rules
from the original Missing-flows list.

---

## iOS — signing, push entitlement, and the first TestFlight build — DONE (2026-08-21)

The iOS track was listed as unstarted ten days ago: no APNs key, no
`aps-environment` entitlement, no `remote-notification` background mode, no
signing. All four are done, and `com.cordeliaapps.superapp` (app Apple ID
`6803333321`, team `6VS9Z92P4Y`) has been delivered to App Store Connect and is
in TestFlight.

### Paying for the developer program is not the same as having one

Certificates, Identifiers & Profiles answers a plain **404** — not "access
denied" — until the enrolment activates, which sent the first pass into
debugging a URL that was correct all along. Two more traps sat behind it. The
Mac was signed into a *different* Apple ID than the one holding the membership,
detectable locally because the only codesigning identity was an
`Apple Development` cert from a free Personal Team and there were no
provisioning profiles at all. And the Signing pane's "your team has no devices"
warning is a **development** profile problem with no bearing on an App Store
archive — a Mac cannot be registered to clear it, since iOS development profiles
take iOS device UDIDs only.

The **Paid Apps Agreement is deliberately unsigned**. It governs charging
*through Apple*; Cordelia sells physical goods through Razorpay/Stripe, which
Apple exempts from IAP. Free Apps Agreement active is the entire requirement,
and leaving Paid unsigned skips the banking and tax forms outright.

### Push is three things, and two of them look like one

Push Notifications and Background Modes are separate capabilities. Adding
Background Modes alone leaves no `aps-environment` entitlement, so iOS never
issues an APNs token and the uploaded `.p8` does nothing. The full set is: the
APNs auth key registered under Keys and uploaded to Firebase Cloud Messaging,
the **Push Notifications** capability (which also enables Push on the identifier
in the portal, and writes `Runner.entitlements`), and `remote-notification` in
`UIBackgroundModes`.

The entitlements file reads `aps-environment: development` and should be left
that way — Xcode substitutes `production` during App Store export. Verified in
the shipped binary rather than assumed:
`codesign -d --entitlements` on the exported `Runner.app` returns
`aps-environment: production`, `beta-reports-active: true`,
`get-task-allow: false`.

### Four project changes made before the first build

- **`ITSAppUsesNonExemptEncryption = false`** — without it every single upload
  stalls on a manual export-compliance question.
- **`TARGETED_DEVICE_FAMILY` `"1,2"` → `1`** — the project claimed iPad support
  it never had. iPad would have required 13" screenshots and put three packs'
  untuned layouts in front of a reviewer on a screen size none were designed
  for.
- **Login's two social buttons removed** — they fired a coming-soon snackbar,
  and placeholder UI is a standing Guideline 2.1 rejection.
- **Bottom-line versioning** — `1.0.3+3` delivered; `1.0.4+4` built with the two
  delivery-warning fixes below. iOS build numbers are independent of Play's.

### Both delivery warnings were real, and neither was ours

`ITMS-90683` demanded `NSLocationAlwaysAndWhenInUseUsageDescription` even though
the app only ever calls `Geolocator.requestPermission()` for when-in-use. The
cause is `geolocator_apple`'s `PermissionHandler.m`, which calls
`requestAlwaysAuthorization` — Apple's scan reads compiled symbols, not your
Dart. Declaring the key changes no behaviour: iOS only offers "Always" when the
app requests it.

The missing `Razorpay.framework` dSYM was **shipped all along**, at
`ios-arm64/dSYMs/` *inside* the vendored `.xcframework`, with exactly the UUID
Apple named (`465D3250-8266-356E-B167-9FA7BAAD6F02`). Xcode does not copy dSYMs
bundled inside a vendored xcframework into the archive. Fixed with a
`Copy vendored xcframework dSYMs` run-script phase on the Runner target, guarded
to `$ACTION = install` so it only fires on archive, and written generically so
any future vendored xcframework is covered. Left unfixed it costs unsymbolicated
crash reports inside the payment SDK — the highest-stakes path in the app.

One incidental discovery: Flutter 3.44 resolves nearly every plugin through
**Swift Package Manager**, and only `razorpay_flutter` still goes through
CocoaPods. `Podfile.lock` therefore lists four pods and nothing else, and
`Pods/` contains no `geolocator_apple` — which is why the first search for the
`ITMS-90683` culprit came up empty.

### What this leaves open

- **Push is unverified on real hardware.** The Simulator cannot prove FCM token
  registration, and the app was never run on a device in this pass. TestFlight
  is the right proving ground: it runs against **production** APNs, the same
  environment the shipped app uses. Foreground, background and terminated
  delivery all need checking, plus tap-routing into the right store's
  notification centre.
- **Rich (image) notifications still need a Notification Service Extension
  target** — unchanged from the previous entry, and unbuilt.
- **Not submitted for review.** The listing has no screenshots (6.9" iPhone),
  App Privacy labels, privacy policy URL, age rating or category, and no demo
  account or review note explaining that physical goods sold through external
  gateways are exempt from IAP.
- **EU is excluded.** DSA trader status is unset, which restricts distribution
  to the non-EU storefronts. Providing it publishes a contact address on the
  product page — an individual account means a personal address — and Cordelia
  being a multi-tenant marketplace additionally implies DSA Article 30 merchant
  traceability (verified identity, address, payment account per selling store)
  before an EU launch. Neither is scoped.
- **The developer name on the listing is the enrolled individual's legal name**,
  not "CordeliaApps". Changing it needs an Organization account (D-U-N-S, a
  fresh enrolment) or an approved d/b/a.
- **Firebase client API keys are unrestricted.** Not a leak — they are
  extractable from any shipped binary and Google documents them as
  non-secret — but the four keys under `corderlia-ecom` still need application
  restrictions (bundle ID / package + SHA-1 / referrer) and App Check
  enforcement before the listing is public.

---

## Go-live readiness scan — product perspective (2026-08-21)

A sweep of `admin/` and `apps/ecommerce/cordelia/` for what a real shopper and a
real store owner would hit, with store publishing deliberately excluded — that
track is covered by the iOS section above and the Play entries earlier.

Neither codebase carries a single `TODO`, `FIXME` or `HACK`. Everything below is
**unbuilt product, not unfinished code**, which is exactly why none of it
surfaces in a lint, an analyzer run, or a code review. It only surfaces by
walking the flows.

### Out-of-stock is invisible until checkout fails

The finding that would embarrass the app fastest, and the only one here that was
not already known in some form.

Stock is fully modelled on the merchant side: every product doc carries `stock`,
the catalog list filters in/out and sorts by it
(`admin/src/app/dashboard/products/page.tsx:141`), and the server enforces it
transactionally on both write paths — `Insufficient stock` → 409 at payment
intent (`api/stores/[storeId]/payments/route.ts:70`) and at order placement
(`api/stores/[storeId]/orders/route.ts:150,208`).

It is modelled nowhere on the shopper side. `serializeProduct`
(`admin/src/lib/api/serializers.ts:54`) returns fourteen fields and `stock` is
not among them; grep for `stock` across `admin/src/app/api/` returns only those
three refusal sites, all on writes. `ProductEntity` has no such field to drop it
into. So an out-of-stock item renders as an ordinary purchasable product in all
three packs, survives add-to-cart and the whole of checkout, and is refused at
the last step — by a server-authored English string, in every locale.

For a grocery catalog this is the ordinary path, not an edge case: stock goes to
zero constantly and the storefront cannot tell. The fix is small on both sides
(one serializer field, one entity field, a disabled state on the card and the
Add button) and is bounded by no other work.

### There is no support channel

Not a thin one — none. The code assumes one repeatedly: "an id a shopper would
hand to support" appears in gravia's and dailymart's Track Order screens and in
`OrderEntity`'s doc comment, and
`templates/dailymart/constants/dailymart_value_const.dart:213` states plainly
that Help & Support is among the things "this app has [not]". Every Profile tab
across the three packs runs Change Password / My Orders / My Address / Dark Mode
/ Language / Privacy / Terms / Logout / Delete Account, and stops.

A shopper with a wrong item, a missing delivery, or a refund that never landed
has no email, no phone, no form, and no in-app thread. The admin console's own
merchant site publishes a `/refunds` policy page, which the app does not link
either — so the one written commitment about refunds is invisible to the person
it is written for.

### The login wall precedes discovery

`feature/splash/presentation/view/splash_page.dart:44` routes anyone without a
session to `/login`. There is no guest mode, no redirect-back-after-auth on a
product deep link, and nothing browsable before an account exists.

For a multi-tenant marketplace whose entire proposition is *discover stores*,
the funnel opens with a signup form in front of an empty promise. This is a
product decision to revisit rather than a defect — but it should be a decision,
and right now it is a default.

### Nothing downstream of "order placed" — re-confirmed

Unchanged from "Delivery-agent apps — decided, not built": the handoff OTP is
generated and displayed to both shopper and store admin while no endpoint
accepts one, and `DELIVERED` is a button pressed at a desk. Worth restating with
the status model beside it — `OrderStatus` is four values (`pending`,
`inProcess`, `delivered`, `cancelled`), so even with an agent app there is no
*packed* or *out for delivery* to report into, and no ETA, though all three kits
draw one.

### Known gaps this scan re-confirmed rather than found

- **No post-delivery returns** — refund is wired only to cancel.
- **Server-authored refusals stay English** in every locale — the stock refusal
  above is the highest-traffic instance of this, which raises its priority.
- **No pre-checkout serviceability signal** — refused at submit, not greyed out
  in Select Address.
- **Search** is `searchKeywords[]` substring matching, and there is still no
  cross-store search — conspicuous in an app whose home screen is discovery.
- **Notifications** — no shopper-side per-store mute; the feed caps at 50 per
  source with no paging.
- **Placeholder content** — single-image product "carousel", onboarding's
  seeded stock photos, grofast's two bundled map images.
- **Operational** — Firebase client keys still unrestricted with App Check off,
  `CRON_SECRET` unset so the weekly device prune has never run, and ~1–2.5s API
  cold starts (accepted).

### What the scan found solid

Recorded so the list above is not read as a verdict on the whole: two payment
providers with per-store settlement, cancel + refund with signature-verified
webhooks and refund idempotency, product *and* order reviews with server-derived
verified-purchase, in-app account deletion, delivery fee + per-store
serviceability, the store publication lifecycle, per-store notifications
end-to-end, and five languages across seven market catalogs. Size variants are
admin-driven and do reach the product-details payload — checked, because the
grid serializer's omissions made it look like they might not.

### The minimum set

If go-live means "a stranger's first order does not go wrong in a way we cannot
answer for", it is the first three: **stock visibility, a support channel, and
letting people browse before signing up**. Each is small relative to what is
already built, each is bounded, and each shows up on day one rather than at
scale. The delivery-agent track is the larger hole but it is a whole app, and
its absence degrades gracefully as long as order volume stays inside what a
store admin can advance by hand.
