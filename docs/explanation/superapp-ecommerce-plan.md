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
