# Design system decision + screen design rules

Read this **before writing any screen, scaffolding an app's UI, or restyling**.
`conventions.md` says how the code is organised; this doc says how the result
should **look**.

It is **pack-agnostic**. Everything here applies to every app regardless of
which style pack it uses:

| § | Answers |
|---|---|
| 1 | *Which design system does this app use?* — pack selection + catalog |
| 2 | *What do I compose from?* — the shared atom/molecule/block catalog |
| 3 | *What does a well-designed screen look like?* — universal screen rules |
| 4 | *How do I add a new pack?* — the procedure + the spec-sheet template |

**Pack-specific values** — palette, radii, control heights, icon style, motion
durations, signature compositions, wrapper roster — live in one spec sheet per
pack under `docs/ai-rules/style-packs/`. Once you know which pack the app uses,
**read that file too**; it is the reproducible description of the look.

- `style-packs/_TEMPLATE.md` — the blank spec sheet every pack fills
- `style-packs/gravia.md` — the ecommerce pack (the worked example)

---

## 1. Deciding the design system (before generating)

Every app's look is data: a theme preset name in
`assets/theme/theme_config.json`, resolved by
`packages/core/lib/core/theme/app_theme_presets.dart`. Picking the design
system = picking a **style pack** from the catalog below.

**Selection procedure:**

1. Infer the app's **category** (ecommerce, health, finance, social, …) and
   **mood** signals ("minimal", "playful", "premium", "dark") from the user's
   description.
2. Rank the catalog by category match, then mood, then block coverage (a pack
   whose blocks cover the screens the spec needs beats a generic one).
3. Clear winner → use it and say so. Two or more plausible → ask the user,
   naming the moods ("fresh green commerce look vs. warm minimal look?"). No
   match → nearest pack by mood; `rocketWarm` is the neutral fallback.
4. Write the chosen preset into the app's `theme_config.json`. Never invent
   per-app theme Dart or inline hex values — a new look is a new preset in
   core, never forked widgets.
5. **Open the pack's spec sheet** and keep it beside you while generating.

### Style-pack catalog

| Pack (`activeTheme`) | Categories | Mood | Blocks coverage | Spec sheet |
|---|---|---|---|---|
| `gravia` | ecommerce, grocery, retail, marketplace, food delivery | fresh, clean, premium | product-grid, cart, categories, checkout patterns | [`style-packs/gravia.md`](style-packs/gravia.md) — full profile, exemplar app `apps/ecommerce/gravia` |
| `dailyMart` | ecommerce, grocery, quick-commerce, retail | fresh, bright, friendly, photo-led | product-grid, promo carousel, category rail, search + filter | [`style-packs/dailymart.md`](style-packs/dailymart.md) — full profile, exemplar `apps/ecommerce/cordelia`'s `dailymart` storefront template |
| `grofast` | ecommerce, grocery | fresh, generous, soft, unhurried | staggered product grid, promo carousel, category grid + rail, domed sheets, domed nav | [`style-packs/grofast.md`](style-packs/grofast.md) — full profile, exemplar `apps/ecommerce/cordelia`'s `grofast` storefront template |
| `rocketWarm` | utility, productivity, tools | warm, minimal, editorial | generic | — preset only (ink + amber, pill buttons); no exemplar app yet |
| `oceanBreeze` | productivity, finance, reading | calm, clean, cool | generic | — preset only (sky blue + navy) |
| `forestWalk` | health, wellness, outdoors | grounded, natural | generic | — preset only (forest green) |
| `dadJokes` | entertainment, casual | playful, warm | generic | — preset only (coral + purple) |

> A pack with "preset only" has colours and shape but no proven screen
> language. Generating a full app on one means **filling its spec sheet as you
> go** (§4) — every decision you make becomes that pack's contract, so record
> it instead of leaving it in the screens.

---

## 2. The shared composition catalog

Compose from these before hand-rolling a layout. They read only
`Theme.of(context)` (colour/shape/spacing tokens), so a new preset re-skins
them for free — **no new block is needed just because a new pack shows up.**

- **atoms** (`core/ui/atoms/`) — single widget, no BLoC reads: `AppButton`,
  `AppTextField`, `AppBadge`, `AppChip`, `AppCheckbox`, `AppSwitch`,
  `AppRadioDot`, `AppTopBar`, `AppIconButton`, `AppIconCircle` (the
  *non-interactive* tinted disc + centred glyph — notification rows, menu
  tiles; `AppIconButton` is its tappable sibling), `AppSwitcher` (the
  design-system content-swap fade: standard 300ms `AnimatedSwitcher` with
  optional `curve`/`topAligned` — use it instead of a raw `AnimatedSwitcher`
  so durations can't drift per screen), `AppDropdownMenu`,
  `AppNetworkImage`, `AppSvgImage`, `AppGlassSurface`, `CommonGlassSurface`,
  `AppGlassChip`, `AppConcentricCircles`, `PageIndicator`, `ShimmerBox`,
  `LoadingIndicator`, `LoadingDots`, `DeviceFrame`, `ThemeModeToggle`
- **molecules** (`core/ui/molecules/`) — composed atoms: `AppBottomSheet`,
  `AppDialog`, `EmptyState`, `ErrorView`, `AppMenuTile`, `AppRadioGroup`,
  `IconInfoRow` (leading block beside a title, optional subtitle, optional
  `trailing` control and whole-row `onTap` — the notification / activity-feed
  / tappable-list-result row; the pack supplies the styled leading and
  trailing widgets. Don't fork this silhouette into a private `_Row` —
  extend it here),
  `SwipeToDeleteRow` (row swiped left to reveal a delete panel — the panel is
  painted under the row inside one clip so the glyph holds still, with
  `onDelete` for an optimistic commit or `confirmDismiss` for a gated one;
  don't hand-roll a `Dismissible` + `Stack` for this),
  `ShimmerListRow` + `ShimmerSectionHeader` + `ShimmerCircleTile` (the
  common skeleton silhouettes — disc + two lines with `itemCount`, title +
  action chip, and circle-over-label category tile — compose these before
  hand-rolling a `ShimmerBox` layout)
- **blocks** (`core/ui/blocks/`) — larger compositions, split by scope:

**Root — cross-domain, any style pack can use as-is:**

| Block | What it is |
|---|---|
| `header_canvas.dart` | `HeaderCanvas` — the primary-coloured, status-bar-inset canvas a hero header sits on. Keep `Center`/`Align` out of what you put on it (see its doc) |
| `hero_header.dart` | `HeroHeader` / `.page` — the two title compositions: back-or-not, centered-or-left, optional `bottom` row. A pack still wraps this in its own preset for pack-specific `leading` control and title styles |
| `collapsing_header_sheet.dart` | header + a surface sheet whose large top radius overlaps it and scrolls up underneath, rather than header and sheet scrolling as one unit |
| `docked_bar.dart` | `DockedBar` — docked bottom CTA shell: surface colour, top hairline from `AppColorsExtension.dockedHairline`, safe area, bar padding |
| `docked_bar_overlap.dart` | bottom-docked bar whose rounded top corners float over content extending `overlap` px underneath — a plain `Column` would show the scaffold background through the corner cut-outs |
| `bottom_nav_bar.dart` | `BottomNavBar` — `variant:` picks the pack's look: `pill` (active tab is a filled pill, inactive are icon circles — `gravia`) or `stacked` (icon over label on every tab, colour marks active — `dailyMart`) |
| `section_header.dart` | `SectionHeader` — bold title + action. The action is a text link by default (`actionLabel`) or any widget (`action:`) when a pack renders it as a chip/icon instead |
| `section_rail.dart` | `SectionRail` — a section header over a horizontally scrolling item rail. Owns the one rule every hand-rolled copy re-derived: the rail takes a **left inset only** (matching the header's gutter) so items scroll to the true screen edge. Params for gutter/spacing/trailing gap/shadow padding |
| `quantity_stepper.dart` | `QuantityStepper` |
| `chunked_grid.dart` | `ChunkedGrid` — a fixed-column grid inside a scrollable that isn't sliver-composed, laid out with manual `Row`/`Expanded` chunking rather than `GridView` |

> **Why `ChunkedGrid` and not `GridView`.** A `shrinkWrap` `GridView` nested in
> another scrollable lays every item out up front anyway (no real laziness
> win), and a guessed `mainAxisExtent` either clips content or leaves dead
> space. An off-layout "measure one item first" approach was tried and
> reverted — it introduced a worse class of layout bug (a stray inter-row gap
> from an unexplained bad remeasurement). Don't reach for it again without a
> much stronger reason.

**`blocks/<category>/` — compositions encoding domain-specific data.** Today:
`ecommerce/` (`product_card.dart`, `category_tile.dart`, `product_meta_row.dart`
— the icon+label meta row, extracted once a second surface needed the same row
outside a full card, so the two can't drift into hand-copied `Row`s again —
and `price_breakdown.dart` — `PriceBreakdown` + `PriceLine`: the cart/checkout
totals panel (optional coupon-row `leading` slot → label/value lines →
hairline → total), extracted after both storefront templates shipped a
byte-identical private `_SummaryRow`; styles stay with the caller per line). A
future pack in the *same* category reuses these unchanged; a pack in a
*different* category (finance, health, social, …) gets its own sibling
subfolder.

If a needed composition is missing, build it as a new block (theme-driven, no
literals) — root if cross-domain, `blocks/<category>/` if it encodes
domain-specific data — **never inline in the app**.

**Whenever you add a new atom, molecule, or block to `core/ui/`, add a matching
showcase entry to `apps/design_gallery`** (Widgetbook — see
`apps/design_gallery/lib/main.dart`) in the same commit. That app is the living,
executable version of this catalog and of the "Verify" step in §4 — it renders
every component against every theme preset, which a hand-written list can't
check itself. Nothing else notices when it falls behind, so treat a missing
showcase entry as equivalent to a missing entry in this doc. Skip only a
component that structurally can't run there (e.g. it imports `dart:io` and
`design_gallery` also builds for web — note the exception inline in `main.dart`
rather than silently omitting it).

### App-level presets on top of a core widget

When a style pack's spec for some control is a fixed, opinionated look that
differs from core's themed default (no check icon, a border colour that doesn't
flip with the theme, a tinted fill, a pinned height …), **don't fork the atom
and don't hand-repeat the override params at every call site.** Instead:

1. Add the override param to the **core** widget (e.g. `AppChip.showCheckIcon`,
   `AppTextField.borderRadius`/`.labelStyle`/`.height`) — always defaulting to
   the prior themed behaviour, so existing callers are unaffected.
2. Wrap it in a small preset widget in the app's `lib/widgets/` that bakes
   those overrides in as defaults.
3. Every screen renders the preset.

The same rule applies one level up, to **blocks**: when a pack's spec for a
block is a fixed recipe of many styling params, wrap it once and make every
screen render the wrapper. The full list of roles a pack fills this way is the
**wrapper roster** in its spec sheet (§13 of the template). Extract the preset
on the **second** screen that repeats a styled composition, not the third.

---

## 3. Screen design rules (always apply)

### Laying out a screen's initial structure (before any polish)

Get the shape right before touching a `TextStyle` or a colour.

1. **Chrome: `AppBar` or the pack's header treatment?** Check the pack's
   **screen skeleton** (spec sheet §8) first — most packs define a canonical
   page structure that no screen deviates from. Reach for a plain `AppBar` only
   when the pack's catalog defines no header pattern for this kind of screen.
2. **Order the body top-to-bottom by information priority, not by
   convenience.** For a detail-style screen in any category: hero media →
   primary identity (name) → supporting meta → price/status row → divider →
   user choices (selectors) → divider → informational copy → discovery. Worked
   example: gravia's `ProductDetailsScreen._buildLoaded`.
3. **One persistent action → a docked bottom bar, never an inline button.** If
   the screen has a single primary action that should stay reachable while
   scrolling (Add to Cart, Checkout, Submit), give it its own `SafeArea`-wrapped
   bar pinned **outside** the scroll view — never a button living at the bottom
   of scrollable content, where it disappears as soon as there's enough content
   to scroll past it. A pack that *floats* the action over a bleed-to-edge fade
   instead of docking it opts out of the bottom `SafeArea`, and then owes the
   inset by hand on every body it swaps into that slot — see the safe-area
   rules in `docs/ai-rules/conventions.md`.
4. **One divider colour per app, computed once and reused everywhere.** Don't
   invent a hairline shade per screen. Use the pack's `dockedHairline` for the
   docked bar's top border, the bottom nav's top border, and every in-content
   `Divider`.
5. **Reuse a block before hand-building a row.** Before writing a `Row` of
   icon+label pairs, a badge, or a chip, check whether an existing block (§2) or
   an app-level `lib/widgets/` preset already renders it. If the same visual
   shows up in two places, that's the signal to extract a shared widget rather
   than copy the `Row`.
6. **Verify both themes and every interactive state before calling the layout
   done.** Not finished until: light *and* dark render correctly, every
   selector/chip's selected *and* unselected state resolves to the right token
   (not just whichever state you happened to screenshot), and `flutter analyze`
   is clean.

Then apply the rules below for the actual polish.

- **One focal element per screen.** Decide what the screen is *for* and make
  that the largest/boldest thing. Everything else steps down in size, weight, or
  colour. If two things compete, demote one.
- **Spacing rhythm, not density.** Screen gutters `AppSpacing.lg`; between
  sections `AppSpacing.xl4`+; inside a card `AppSpacing.base`. When in doubt,
  add space — generated UIs fail cramped far more often than sparse.
- **Type expresses hierarchy, weight expresses importance.** Titles and prices
  bold; supporting copy `bodyMedium`/`bodySmall` in `onSurfaceVariant`. Never
  more than two text roles inside one card. Never a raw `TextStyle` — always
  `textTheme` roles with `copyWith`.
- **Colour has a job.** Primary = action + brand canvas. Containers = tints
  behind small info (badges, steppers). Errors only for errors. If a screen
  shows primary in more than the header + one CTA + small accents, it's shouting.
- **Contrast comes from the surface ladder, not from new colours.** Layer
  widgets across `surface` → `surfaceContainerLow` → `primaryContainer` per the
  pack's contrast ladder (spec sheet §6); never reach for an unlisted shade to
  make something stand out.
- **Icons are a system.** One stroke weight, one style (line *or* filled), one
  source across the whole app — see the pack's iconography contract (spec sheet
  §5). A Material filled icon dropped among thin line SVGs is instantly visible.
- **One control height.** Buttons, icon discs, form fields, and tab bars sharing
  a single height is most of what makes unrelated controls read as one system
  (spec sheet §3).
- **Empty, loading, and error states are designed moments.** `EmptyState` with
  an icon, one-line title, one-line subtitle, and a next-step action;
  `ErrorView` with retry. A bare spinner or plain-text "No items" is unfinished
  work. A full-screen initial load gets a **skeleton mirroring the loaded
  layout's silhouette** (`ShimmerBox` composed to match), not a centred spinner.
  On a bottom-nav tab, that skeleton should only ever appear on a genuine cold
  start — switching tabs and back must not re-show it once the tab has loaded
  this session; see `docs/how-to/design-tab-flow.md`.
- **Images carry the design.** Photo-led apps (commerce, food, travel): big
  images, tight metadata. Always `fit: BoxFit.cover` inside a clipped radius; no
  stretched or letterboxed photos.
- **Touch targets ≥ 44px**; primary CTAs full-width pills at the bottom of
  flows, not small buttons lost mid-screen.
- **Motion is subtle and tiered.** Pick a duration from the pack's motion
  contract (spec sheet §7) — never a per-widget guess. Two things that read as
  one transition share one duration. No gratuitous bounces.
- **One overlay type per job.** Whether a decision is carried by a bottom sheet
  or a dialog is an app-wide choice, not a per-screen one (spec sheet §9).

### Screen smells (design twin of forbidden patterns)

- A screen that is only stacked default `ListTile`s
- Default `AppBar` on a screen the style pack gives a header treatment
- Three+ font sizes or two+ accent colours inside one card
- Buttons/CTAs styled differently on sibling screens
- Icons of mixed stroke weight or mixed line/filled style in one app
- Two controls that should share the pack's control height but don't
- Spinner centred in a full screen where a skeleton/`EmptyState` belongs
- `Colors.*`, raw hex, `TextStyle(fontSize:)`, `EdgeInsets.all(13)` — token and
  theme violations (see `conventions.md` forbidden patterns)
- A hand-rolled composition that an existing block already provides
- A screen with its own one-off divider/hairline shade instead of the one value
  the app's persistent chrome uses
- A primary action button living at the bottom of scrollable content instead of
  docked outside the scroll view
- A dialog in an app whose every other decision is a bottom sheet (or vice versa)
- An animation duration that matches nothing else in the app
- A bottom-nav tab that re-plays its full loading shimmer every time the user
  switches back to it, instead of showing the already-fetched data instantly and
  refreshing silently underneath (see `docs/how-to/design-tab-flow.md`)

---

## 4. Adding a new style pack (from a UI kit / Figma file)

1. **Extract** palette (sample **real screens**, not the kit's foundation page —
   those ship stale defaults), shape language, and typography; add a named
   preset to `app_theme_presets.dart` (light **and** dark).
2. **Copy `style-packs/_TEMPLATE.md` to `style-packs/<pack>.md` and fill the
   contracts (§0–§9) first.** Values before screens: colour invariants, radii,
   the shared control height, type tokens, icon stroke, the contrast ladder,
   motion tiers, the screen skeleton, the overlay policy. A pack whose contracts
   are written down can be reproduced; a pack that only exists in its screens
   can only be copied.
3. **Re-author its signature compositions as theme-driven blocks** (patterns and
   proportions, never copied assets — UI8-style licences permit use in end
   products, not redistribution). Place each by scope: cross-domain →
   `core/ui/blocks/` root; domain-specific → `core/ui/blocks/<category>/` (new
   subfolder if the category is new). Record them in the spec sheet's §10/§12.
4. **Fill the pack's wrapper roster** (spec sheet §13) — the app-level
   `lib/widgets/` layer of thin presets. Every role in that table recurs in any
   app regardless of vertical; only the **domain card** is category-specific.
   When a role's spec needs an override the core widget doesn't expose, add the
   param to the core widget (defaulting to prior behaviour) **before** wrapping.
5. **Add a catalog row** in §1 above, linking the new spec sheet.
6. **Verify:** switch an app's `theme_config.json` to the new preset — atoms,
   blocks, and raw Material must all re-skin with **zero app-code changes**.
   `apps/design_gallery` renders every component against every preset; use it as
   the check.
