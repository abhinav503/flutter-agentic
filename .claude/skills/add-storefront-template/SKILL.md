# add-storefront-template

Adds a **new UI template** to `apps/ecommerce/cordelia` (the multi-tenant
storefront) from a **Figma kit read over MCP** — a complete third skin where
every storefront surface renders in the new pack over the unchanged shared
`domain`/`data`/`bloc` layers. `dailymart` is the proven exemplar of this
process.

Follow every phase in the guide below. Notes on how this skill splits the work:

## Phase 0 — Inputs

Ask for the Figma file (URL/key), the lowercase template id, and the kit's
licence note. Verify the Figma MCP server answers (`get_metadata`) — no MCP,
no skill; never hand-transcribe from screenshots.

## Phase 1 — Kit → contracts

Sample **real screens** (never the kit's foundation page — it lies) with
`get_variable_defs` / `get_design_context` / `get_screenshot`; export glyphs
with `download_assets`. Produce: the `'<id>'` preset (light + dark) in
`app_theme_presets.dart`, `assets/theme/templates/<id>_theme_config.json`,
the five pack const files under `lib/templates/<id>/constants/`, and the
spec sheet `docs/ai-rules/style-packs/<id>.md` with contracts §0–§9 filled
**before any screen exists**.

## Phase 2 — Frame inventory

Match every kit frame against the storefront surface table in the guide
(shell/tabs, home, search, category details, product details, cart,
checkout + Razorpay, orders + track, address CRUD/select, profile + edit +
change password, favourites/wishlist, notifications, privacy + terms).
Three buckets: direct match → build from frame; supported surface with no
frame → **compose from the pack's own recipes** (never skip it); frame with
no feature behind it → **discard and record the deviation** in the spec
sheet. Auth/splash/onboarding/discovery are shared Cordelia-brand chrome —
never templated. Confirm the bucket lists and the shell tab set with the
user before writing code.

## Phase 3 — Implement

Register the template (enum + `wireValue`, `StorefrontPage` switch, a
branch in **every** `StorefrontTemplateSwitch` in `app.dart`, theme
assets — there is no bundled mock data any more), build the pack kit to the roster spec (screen shell
first), then per-feature `presentation/templates/<id>/` slices. The
guide's **"Reuse before you build"** section is the standing rule — three
shelves checked before writing anything (for what *already exists*; don't
invent a shared abstraction on the first pass — duplication is expected and
Phase 5's sweep is where it resolves): (a) the warm-start `BlocCache`
recipe (mirror the other pack's `*_page.dart` bloc wiring exactly; the
caching lives in the shared bloc), (b) the shared-behaviour table
(`EditProfileForm`, `ChangePasswordForm`, `AddressFormFields`,
`QuantitySelection`, `StorefrontShellPage`, `HeroSearchFieldFlight`,
`signOutAndReturnToLogin`, `CheckoutBloc`, app-root cubits), (c) the
design-system catalog (`EmptyState`/`ErrorView`/`AppSwitcher`/shimmer
atoms/`IconInfoRow`/`SectionRail`/`PriceBreakdown`/`context.appColors`/
`context.appShapes`/`asPrice`-`plural` extensions), and (d) the structural
conventions the other packs follow — a `<Pack>Switcher`/`EmptyState`/
`ErrorView` trio in `<id>_state_views.dart` used by **every** body-swapping
screen, skeleton bodies as public pack-prefixed files under
`templates/<id>/widgets/` that mirror the loaded **structure** (dock and
all, since the dock pays the bottom inset), nav badges reading live cubit
state instead of a `static const` tab list, `*_bloc_provider.dart`
factories instead of inline bloc construction, `ChromelessStorefrontPage`
for the no-app-bar pages, the Home ↔ Search `HeroSearchFieldFlight` (a
per-store `heroTagFor` both ends derive from, an inert shuttle, and **no**
tag on Category Details), and a doc comment on every core-component fork
naming what didn't fit. Bottom inset on **every** branch, exhaustive
switches, `ValueConst`-only copy.

## Phase 4 — Prove it with tests, not a device

Four cross-cutting concerns are **inherited, never rebuilt**: warm-start
caching (`BlocCache`/`ScopedBlocCache`), failures mapped to copy once at the
presentation boundary (never `e.toString()`; react to `Failure.refused`'s
`code`, not its message), `CrashReporterService` (registered in `main.dart`,
static singleton, no-op on web/debug), and notifications (real per-store data;
the pack maps `NotificationKind` to glyphs and owns nothing else).

Then ship tests **with** the pack, in the same commit — manual fakes only, no
network, `bloc_test` `MockBloc` for widget tests, reusing
`test/helpers/fake_storefront_use_cases.dart` and `fake_auth_session.dart`.
A new pack owes: template dispatch + no cross-pack fall-through, warm revisit
with no skeleton, session teardown, long-label wrapping, stock states,
signed-out browse + gated taps, an error branch whose retry re-dispatches, and
empty ≠ error. Remember what the fake font can prove (no overflow, `maxLines`,
shared heights, the right widget, the right event) and what it can't (whether
copy *fits*, spacing, colour). `make test` + `make analyze` over the **whole**
workspace.

## Phase 5 — Review & promotion

Run `/review-code`, then a reusability sweep across all packs: promote
duplicates by scope (core + gallery entry / `lib/widgets` `Cordelia*` /
feature mixin / pack kit), re-running Phase 4's suite after each promotion.
Then a **contract audit** — grep for every mechanism the spec sheet names,
since Phase 1 writes contracts before the screens exist and an unimplemented
row fails nothing. Finish with a switch walk over every surface **and
transition** in each template.

## Phase 6 — Document

Finish the spec sheet (§10–§15 + deviations — **§15 is the states the kit
never draws**: stock/availability, delivery fee, report+block on reviews,
signed-out), add the `design.md` §1 catalog row, and update
`superapp-ecommerce-plan.md` + `end-goal.md` progress.

@docs/how-to/add-storefront-template.md
