# Super App Ecommerce (FlutterAgenticEcommerce) — Platform Plan

> Status: **M1a done; catalog CRUD, read API, and gravia catalog wiring done;
> cart/order-creation/admin-order-management APIs done; shopper-auth trust gap
> closed (all shopper routes now token-verified); checkout + per-store Razorpay
> payments + cancel/refund done (both shopper and admin); `cordelia`
> multi-template storefront **fully ported** (all storefront features + shell +
> checkout, not just the Phase-1 Home slice); admin-side template
> management (validated `templateId`, `PUT /api/stores/{id}`, store-profile
> settings UI) done; the `dailymart` template is now a **real second
> template** (own design pack + shell + Home + Notifications), not just open
> seams. Not yet deployed** (last updated 2026-07-29). Turns the
> `gravia` exemplar into a multi-tenant "app of apps" ecommerce platform.
> See also `docs/explanation/end-goal.md`.
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

## Multi-template storefront in `cordelia` — PLANNED, not yet built (2026-07-25)

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

## Missing flows (fill these or explicitly defer)

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
