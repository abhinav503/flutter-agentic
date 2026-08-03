# Add a Storefront Template (from a Figma kit)

When the user asks to add a new storefront template / style pack / skin to
`apps/ecommerce/cordelia`, follow every phase below. This adds a complete new
UI template from a Figma kit read over MCP: theme preset + pack constants +
spec-sheet contracts sampled from the kit, a frame inventory against the
surfaces cordelia already implements (frames with no feature behind them are
discarded and recorded as deviations), a full end-to-end implementation of
every storefront surface as `presentation/templates/<id>/` slices over the
unchanged shared `domain`/`data`/`bloc` layers, a review + cross-pack
reusability/promotion sweep, and doc/progress updates. `dailymart` is the
proven exemplar of this exact process.

Prerequisite reading (in this order): `docs/ai-rules/design.md` (§2 shared
composition catalog + §3 screen rules + §4 pack procedure),
`docs/ai-rules/style-packs/_TEMPLATE.md`,
`docs/ai-rules/style-packs/dailymart.md` (the second-template exemplar),
`docs/reference/architecture.md` (nav-shell case),
`docs/how-to/design-tab-flow.md` (the warm-start `BlocCache` pattern), and
`docs/how-to/review-code.md`.

---

## Phase 0 — Inputs & preflight

Ask the user for:

1. **The Figma file** — URL or file key of the kit.
2. **Template id** — lowercase single word (`gravia`, `dailymart`, …). It
   becomes the wire value, folder names, asset paths, and the preset key.
3. **Licence note** for the spec sheet §0 (UI8-style licences permit use in
   end products, not asset redistribution — patterns and proportions are
   re-authored, exported glyphs need the licence to allow it).

Verify the **Figma MCP server** responds (`get_metadata` on the file). No
MCP → stop and tell the user to connect Figma first; do not hand-transcribe
from screenshots.

---

## Phase 1 — Sample the kit → contracts (theme + constants)

Values before screens. A pack whose contracts are written down can be
reproduced; a pack that only exists in its screens can only be copied.

1. **Inventory the file.** `get_metadata` → record every page and frame with
   its node id. This frame list drives Phase 2.
2. **Sample real screens, never the foundation page.** Kits routinely ship
   stale defaults on their "colours/typography" pages that no real screen
   uses. Pull `get_variable_defs` + `get_design_context` (and
   `get_screenshot` for the eye) on 2–3 *shipped* frames: the home screen, a
   detail/form screen, and a bottom sheet.
3. **Write the theme as data:**
   - a named preset in
     `packages/core/lib/core/theme/app_theme_presets.dart` (`'<id>'`), light
     **and** dark, including the cross-pack `dockedHairline` /
     `sheetHairline` / `tintedPrimaryFill` roles;
   - `apps/ecommerce/cordelia/assets/theme/templates/<id>_theme_config.json`
     (+ its `pubspec.yaml` asset line). The path is derived from the enum's
     `wireValue`, so no dispatch code changes for theming.
4. **Write the pack constants** under
   `apps/ecommerce/cordelia/lib/templates/<id>/constants/`:
   - `<id>_color_const.dart` — only raw swatches with no `ColorScheme` role;
   - `<id>_text_style_const.dart` — `TextStyle fn(TextTheme tt)` methods off
     theme roles, like `DailyMartTextStyleConst`;
   - `<id>_dimen_const.dart` — `controlHeight` first; a number that appears
     in three places is a constant. Derive any floating-CTA scroll clearance
     from `MediaQuery.paddingOf(context)` (a context method, not a static —
     see `DailyMartDimenConst.floatingActionScrollInset`);
   - `<id>_value_const.dart` — ALL of the pack's copy;
   - `<id>_image_const.dart` — kit SVGs exported via `download_assets` into
     `assets/images/templates/<id>/`; where the kit exports no glyph, record
     the Material-icon fallback convention in the const's doc comment.
5. **Copy `style-packs/_TEMPLATE.md` → `style-packs/<id>.md` and fill
   §0–§9 now** (identity, colour/shape/dimension/type/icon contracts,
   contrast ladder, motion, screen skeleton, overlay policy). §10–§14 are
   filled as screens ship.

---

## Phase 2 — Screen inventory: kit frames × implemented surfaces

Cordelia's storefront supports exactly these surfaces end-to-end (shared
feature → what the template must draw):

| Surface | Shared feature / bloc | Entry |
|---|---|---|
| Nav shell + tabs | `StorefrontShellPage`/`State` base | `StorefrontPage` switch |
| Home | `home` / `HomeBloc` (BlocCache) | tab 0 |
| Search (+ recent searches) | `search` / `SearchBloc` (BlocCache) | route |
| Category details (+ sort/price filter) | `category_details` / `CategoryDetailsBloc` | route |
| Product details (+ add to cart) | `product_details` + `ProductDetailsActions` | route |
| Cart | `cart` / `CartCubit` | tab and/or route |
| Checkout + Razorpay + success | `checkout` / `CheckoutBloc` (provider-agnostic) | pack-specific: inline from Cart (gravia) or routed page (dailymart) |
| Orders (list, cancel) | `orders` / `OrdersBloc` (BlocCache, optimistic cancel) | tab or route |
| Track order (status timeline, OTP, refund) | `OrderEntity.statusHistory` | route |
| Address select / add / edit / delete | `address` / `AddressBloc` + `AddressFormFields` mixin | routes |
| Profile | `profile` / `ProfileBloc` | tab |
| Edit profile (+ avatar upload) | `EditProfileBloc` + `EditProfileForm` mixin | route |
| Change password | `ChangePasswordBloc` + `ChangePasswordForm` mixin | route |
| Favourites / wishlist / bookmarks | `FavouritesCubit` (app-root) | tab or route |
| Notifications | `notifications` / `NotificationsBloc` (per-template mock) | route |
| Privacy Policy + Terms & Conditions | `legal` / shared `LegalDocumentContent` | routes |

**Not templated — do not build:** Login/Signup/verify-email (shared
Cordelia-brand chrome on `Cordelia*` widgets, reachable from every template
by design), splash, onboarding, store discovery.

Now bucket every kit frame:

1. **Direct match** — a frame for a supported surface → implement from it.
2. **Supported surface, no frame** — compose it from the pack's own recipes;
   never skip the surface. (dailymart precedents: Change Password, Add/Edit
   Address, Wishlist — each assembled from the pack's declared contracts.)
3. **Frame with no feature behind it** — **discard**, and record the
   deviation + reasoning in the spec sheet. (dailymart precedents: shipping
   type tiers, delivery ETA, carrier tracking id, DOB/gender fields, a
   six-step order pipeline the backend's three statuses can't fill.) Never
   invent storage for data the backend doesn't return, and never ship a
   dead control.

Present the three buckets and the proposed **tab set** to the user before
writing code — shells legitimately differ per pack (gravia: 5 tabs with
Categories/Orders; dailymart: 4 with Wishlist/Cart) and the tab set is a
product decision.

---

## Phase 3 — Implement end-to-end

Order of work (proven by the dailymart port):

1. **Register the template.** Add the enum case + `wireValue` in
   `feature/storefront/template/storefront_template.dart`; a branch in
   `StorefrontPage.buildBody`'s **exhaustive** switch; a `<id>:` builder in
   **every** `StorefrontTemplateSwitch` in `app.dart` (grep for the type —
   silent fall-through to another pack is the drift this architecture
   exists to prevent); mock data under `assets/data/templates/<id>/`
   (notifications) + pubspec lines.
2. **Build the pack kit** (`lib/templates/<id>/widgets/`) to the spec-sheet
   roster *before* screens — the screen shell first (the pack's
   `DailyMartScreenBody` equivalent: one scroll/padding recipe for every
   state a screen swaps through, optional floating CTA, device-inset
   bottom), then sheet chrome (ride `AppBottomSheet`'s params — `leading`,
   `centerTitle`, `handleSize`, `headerHeight`, `showCloseAction`,
   `showHeader: false` for chromeless; add a defaulted param to core rather
   than fork), primary button, header row, icon disc, form + dropdown
   fields, product card/grid + skeletons, content switcher over
   `AppSwitcher`.
3. **Per-feature template slices** — `presentation/templates/<id>/`
   (`view/` + `widgets/`) over the **unchanged** shared blocs. If a shared
   layer turns out to be secretly pack-flavoured (imports a pack const,
   hardcodes a label), fix the leak in the shared layer — don't route
   around it in the new pack. **"Reuse before you build" below is this
   step's standing rule** — check its three shelves before writing any
   widget or screen behaviour.

4. **Per-screen conventions checklist** (each screen, every branch):
   loading is a `*SkeletonBody` mirroring the loaded layout inside the same
   shell — never a spinner; **every** state branch pays its own bottom
   inset; exhaustive `switch` on state (no `is` checks); copy only from
   `<Id>ValueConst`; tokens/theme only; `overlayStyle` override, not
   `AnnotatedRegion`; `kIsWeb`-guard native-only actions with a snackbar.
5. **Checkout/Razorpay:** the shared `CheckoutBloc` already runs
   create-intent → native checkout → server-verified order write, with the
   web payment-less test path. The template draws only the checkout UI and
   the success body, and decides *where* the flow starts (Cart-inline vs
   routed page).

Run the app against a store set to the new template after each feature
slice; `flutter analyze` must stay clean throughout.

### Kit-fidelity rules (every one bought with a correction pass)

Each rule below is something a first implementation pass has shipped wrong
and a correction sweep then had to fix. Apply them **during** Phase 1/3,
not after.

**Read the kit's geometry, don't infer it from the render:**

- **Signature shapes: fetch the vector.** A boolean that *looks* like a
  cut-out may be a **union** (an edge bulging up around a control reads,
  at a glance, like a hole with the control dropped in). Where a circle
  meets a flat edge, kits draw tangent shoulders — a raw union or cut
  leaves a cusp. Sample the actual path, fit against the rendered alpha,
  and reproduce the tangent geometry.
- **A pack shape the same colour as its canvas needs a visibility
  mechanism.** Find the kit's: content passing behind it (→ `extendBody` +
  a scroll inset derived from what `MediaQuery` then reports) and/or a
  shadow/wash (→ **painted** under the fill from the same path — a
  `ClipPath` can't cast a shadow, and Material `elevation` alpha is far too
  faint for same-on-same at this scale).
- **Measure radii per surface class.** Kits routinely run more than one —
  cards at one radius, image wells or line rows a step softer. Don't
  collapse everything to the theme's `cardRadius`.
- **A dimension that mixes an absolute inset with proportional widths, or
  owns a big fraction of the screen, is a formula, not a constant** — a
  peeking carousel's page fraction moves with the width, a hero that owns
  most of a frame is a fraction of the screen, anything docked derives from
  the device inset.
- **Diff every component variant, not just the default.** State treatments
  hide in variant pairs — a control's saved/selected state, a row's
  swipe-to-delete affordance. One variant sampled = states invented.
- **A screen's own frame overrides the pack recipe.** A kit that floats its
  CTAs everywhere may weld one screen's CTA into a corner. Check each
  frame's bottom band, header, and inset story before reusing the standard
  shell.
- **Use the kit's exported glyph wherever the kit has a component for the
  slot.** Material stand-ins are the single most visible tell of a
  generated screen.

**Kit artwork is curated; store data is not:**

- **Copy laid over artwork, images run edge-to-edge** — both only work
  because the kit's illustration was drawn around them. A store uploads a
  photograph: give copy its own column/panel instead of a scrim, and re-add
  the margin a cut-out PNG carries inside its own file (an uploaded
  rectangular photo has none, so `contain` runs it to the edges).
- **Data the kit shows but the backend lacks is a three-way call**, made
  per instance and recorded in the spec sheet's deviations: render the
  kit's placeholder when the layout is built around it (and document it as
  invented copy), omit when it states a promise the store never made, or
  extend the backend when the cost is small.
- **Derive unit/price suffixes without changing meaning.** Dropping the
  amount from a formatted pack size turns a per-pack price into a per-unit
  one — keep the whole pack unless it is exactly one unit.

**Mechanics that always bite:**

- **Concentric moving parts share one animation driver** — two tweens of
  the same duration still drift the moment either curve changes.
- **`Alignment` positions a child by its edges** — anything centring on a
  moving x (a travelling nav label) needs a fixed-width `Positioned` slot.
- **Weights go through `TextStyle.atWeight`, never
  `copyWith(fontWeight:)`** — google_fonts pins each role to one file and
  `copyWith` fake-bolds it (every spec sheet §4 carries this).
- **A header row whose every element is hidden must drop, not reserve its
  height** (a tab root with no back, no title, no trailing).
- **Peeking carousels:** the gutter belongs to the viewport (`padEnds:
  false` + outer padding), the gap belongs inside the page, and the
  fraction is derived per width.

### Reuse before you build (Phase 3's standing rule)

The template layer is *only* chrome — before writing any widget or screen
behaviour, check these three shelves in order. Hand-rolling something a
shelf already has is the #1 review finding on every port.

**a. Warm-start `BlocCache` — copy the wiring, don't re-derive it.** Every
frequently-revisited storefront screen (`HomeBloc`, `SearchBloc`,
`OrdersBloc`, `AddressBloc`, `CategoriesBloc`) already caches its fetched
data in a static `BlocCache` with a `_cachedStoreId` guard, seeds
`loaded` on construction (`_cache.seed(warm: …, cold: …)`), and refreshes
silently underneath — so a revisit never re-shimmers, a refresh failure
under warm content toasts instead of replacing the screen with an error
view, and a refresh success must **not** reset the shopper's view
selections (tab/filter/search — see `OrdersBloc._onStarted`). The new
pack's page files must construct these blocs **identically to the existing
pack's `*_page.dart`** — open the other template's page file for the same
feature and mirror its `BlocProvider` wiring (bloc + `..add(started)`)
exactly; the caching is in the shared bloc, so matching construction is
all the template has to do. Full pattern: `docs/how-to/design-tab-flow.md`.

**b. Shared behaviour that already exists** — mix in / call, never re-type:

| Shared piece | Owns | Lives at |
|---|---|---|
| `StorefrontShellPage`/`State` | nav-shell base: tab state, favourites hydration | `feature/storefront/shell/presentation/` |
| `EditProfileForm` mixin | controllers, avatar pick (`kIsWeb`-guarded), validation, submit, success-pop listener | `profile/presentation/edit_profile_form.dart` |
| `ChangePasswordForm` mixin | the three password fields end-to-end | `profile/presentation/change_password_form.dart` |
| `AddressFormFields` mixin | 7 controllers, City/Country picks, `validateName`/`validateMobile`, entity compose+pop | `address/presentation/address_form_fields.dart` |
| `QuantitySelection` mixin | quantity floor-of-1 stepper state | `cart/presentation/quantity_selection.dart` |
| `ProductDetailsActions` | product-details add-to-cart plumbing | `product_details/presentation/` |
| `signOutAndReturnToLogin` | full sign-out sequence (Firebase, caches, cubit resets, route) | `feature/auth/presentation/sign_out.dart` |
| `CheckoutBloc` | the whole payment flow incl. Razorpay + web payment-less path | `checkout/presentation/bloc/` |
| `FavouritesCubit` / `CartCubit` | app-root wishlist/cart state | provided at app root — never re-provide per tab |
| `HeroSearchFieldFlight` | Home ↔ Search hero-flight mechanics | `core/ui/blocks/` |
| `LegalDocumentContent` | privacy/terms copy structure | `feature/legal/` |

**c. The design system** — consult `docs/ai-rules/design.md` §2 (the
catalog is indexed there, not re-listed here) and `review-code.md` §3
before hand-rolling anything. Non-negotiables that bite every port:
`EmptyState` / `ErrorView` for every empty/error branch; `AppSwitcher`
(or the pack's preset over it) for state swaps — never raw
`AnimatedSwitcher`; `ShimmerBox`/`ShimmerListRow`/`ShimmerSectionHeader`/
`ShimmerCircleTile` for skeletons; `IconInfoRow` for any
leading-block + title + trailing row (extend it in core rather than
forking a private `_Row`); `SectionRail` for header + horizontal rail;
`PriceBreakdown` for totals panels; `AppBottomSheet` (via the pack's
`show<Id>Sheet` wrapper) for all sheets; `context.appColors` /
`context.appShapes` — never hand-typed `Theme.of(context).extension<…>()`;
core `num`/`int` extensions (`asPrice`, `asPercent`, `plural`) — never
inline `toStringAsFixed` or `> 1 ? 's' : ''`. App-level `Cordelia*`
widgets (`lib/widgets/`) serve shared chrome; a pack may `typedef`-alias
one into its own namespace (gravia's form field/button/glass disc do).

---

## Phase 4 — Review & promotion sweep

1. Run the **`/review-code`** checklist over everything added.
2. **Reusability sweep across all packs** — diff the new pack against the
   existing ones for repeated code and promote by scope:
   - generic mechanism/widget → `packages/core/lib/core/ui/` (**with its
     `apps/design_gallery` entry in the same commit**);
   - app-generic (used by shared chrome too) → `lib/widgets/` as
     `Cordelia*` with constants in `lib/constants/` (packs may
     `typedef`-alias it back into their own namespace);
   - screen *behaviour* duplicated across packs → a feature-level mixin
     beside the bloc (the `EditProfileForm` shape);
   - pack-only recurring recipe → the pack kit. Extract on the second
     screen that repeats a composition, not the third.
3. `flutter analyze` at the repo root (must be clean) and `make test`.
4. **Switch test:** open a store of each template id and walk every surface
   in the table above — no screen may render another pack's chrome.

---

## Phase 5 — Document

1. Finish the spec sheet (§10 signature compositions, §12 blocks used, §13
   wrapper roster with a "built" list, §14 state design), including every
   Phase-2 deviation with its reasoning.
2. Add the pack's catalog row in `docs/ai-rules/design.md` §1.
3. Update progress: a dated entry in
   `docs/explanation/superapp-ecommerce-plan.md` and the Phase 3.6 list in
   `docs/explanation/end-goal.md`.
4. Agent-surface sync per `docs/ai-rules/conventions.md` — anything this
   work changed in shared rules must land on the hand-synced surfaces in
   the same commit.
