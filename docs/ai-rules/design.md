# Design system decision + screen design rules

Read this **before writing any screen or restyling an app**. It answers two
questions in order: *which design system does this app use?* (style-pack
selection) and *what does a well-designed screen look like here?* (screen
rules). The architecture rules in `conventions.md` say how code is organised;
this doc says how the result should **look**.

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
2. Rank the catalog by category match, then mood, then block coverage
   (a pack whose blocks cover the screens the spec needs beats a generic one).
3. Clear winner → use it and say so. Two or more plausible → ask the user,
   naming the moods ("fresh green commerce look vs. warm minimal look?").
   No match → nearest pack by mood; `rocketWarm` is the neutral fallback.
4. Write the chosen preset into the app's `theme_config.json`. Never invent
   per-app theme Dart or inline hex values — a new look is a new preset in
   core, never forked widgets.

### Style-pack catalog

| Pack (`activeTheme`) | Categories | Mood | Blocks coverage | Notes |
|---|---|---|---|---|
| `gravia` | ecommerce, grocery, retail, marketplace, food delivery | fresh, clean, premium | product-grid, cart, categories, checkout patterns | The ecommerce pack — see profile below |
| `rocketWarm` | utility, productivity, tools | warm, minimal, editorial | generic | Neutral fallback; ink + amber, pill buttons |
| `oceanBreeze` | productivity, finance, reading | calm, clean, cool | generic | Sky blue + navy |
| `forestWalk` | health, wellness, outdoors | grounded, natural | generic | Forest green |
| `dadJokes` | entertainment, casual | playful, warm | generic | Coral + purple |

### Style pack profile: `gravia` (ecommerce)

Source: UI8 "Gravia — Grocery Shop App UI Kit" (RL Studio), re-authored as
tokens + blocks (patterns, not pixel assets); preset values are the kit's
real Figma variables, not resampled pixels. Full light + dark coverage.

**Palette & shape** (already encoded in the preset — don't restate hexes in
app code): deep emerald primary `#027A60` (the kit's Primary/500) used as a
*canvas*, not an accent; mint containers (Primary/100) for badges/tints; teal
secondary and indigo tertiary ramps for supporting accents; pure-white light
surfaces with warm near-black text (Dark/500); warm near-black dark surface
with cool-grey elevated circles (the kit's Light ramp); **buttons and chips
are pills** (confirmed on real screens — e.g. the Signup CTA — radius 999,
the kit's fullCorner variable); **inputs are 16px, not pill** (confirmed on
the Signup form fields — the kit's foundation library page shows a stale
fullCorner default that real screens don't use); cards and images use a
large 20px radius. Type is Plus Jakarta Sans — bold weights for titles and
prices, no light weights.

Don't trust a kit's abstract "Design System" foundation page over an actual
screen instance — foundation components can carry stale/default values
(e.g. this kit's Button foundation page shows square corners) that real
screens override per-instance. Always sample 1-2 real screens before writing
a radius/color into a preset.

The foundation page also exposes a full 50–950 tonal ramp per family
(Primary, Secondary, Tertiary, Dark, Gray, Light) plus absolute Black/White —
confirmed hex-for-hex against the values already in the preset above. M3's
`ColorScheme` only has ~4-6 role slots per family, so the preset promotes
just those stops (base, 100→`*Container`, 900/950→`on*Container`, plus the
dark-mode swap); the rest of each ramp is intentionally unused until a screen
needs an in-between shade. When that happens — never an inline hex; two homes
depending on scope:
- **Generic role any pack could need** (success/warning-like semantics, one
  light + one dark value) → `AppColorsExtension` in core, ramp position noted.
- **Pack-specific exact swatch** the kit calls out on a screen (e.g. gravia's
  Gray/500 nav icons, Gray/200-light/Light/900-dark sheet hairlines, Gray/700
  stepper icons that stay fixed across modes) → that app's
  `constants/color_const.dart`, named by ramp stop (`gray500`, `light900`);
  when the kit's light/dark picks sit asymmetrically on the ramp (so no
  single role fits), select per-mode at the call site via
  `Theme.of(context).brightness`.

**Typography scale.** The kit's Design System page defines two token groups,
each in Regular/Medium/Bold, all with **-2% letter-spacing**:
- **Display** — 2xl 72px/125%, xl 60px/125%, lg 48px/126%, md 36px/129%,
  sm 30px/120%, xs 24px/132%
- **Text** — xl 20px/150%, lg 18px/155%, md 16px/150%, sm 14px/140%,
  xs 12px/150%

This doesn't map 1:1 onto `core`'s fixed 13-role M3 scale
(`AppTheme._textTheme`, shared by every preset) — don't edit that scale for
one pack. Instead extend
`apps/ecommerce/gravia/lib/constants/text_style_const.dart` **on demand**:
one `copyWith`-based static method per token+weight an actual screen uses,
named after the Figma token (`textLgBold`, `textSmRegular`), based off the
nearest M3 role so font family/default color still come from the theme.
Consuming blocks accept an optional style-override param the same way
`SectionHeader` already does (`titleStyle`/`actionStyle`; `CategoryTile`
follows the same shape with `labelStyle`) — `core` stays generic, the app
supplies the pack-specific metrics.

**Signature compositions (the look, in order of importance):**

- **Coloured header canvas + white sheet.** The screen's top region (title
  row, search, filters) sits directly on the primary green; content below
  lives on a surface "sheet" whose large top radius overlaps the header and
  scrolls up underneath it as the sheet is dragged, rather than the header
  and sheet scrolling as one unit. On-header controls are translucent white
  circles/pills (`onPrimary` at low alpha), never default AppBar icons. →
  `CollapsingHeaderSheet` — caller supplies `header`/`body`. Every gravia
  screen has its own header widget built on this canvas: `HomeHeroHeader`
  (location + notification + search field), `SearchHeroHeader` (back + live
  search field, Hero-morphed from Home's), `ProductDetailHeroHeader` (back +
  centered title + favourite), `CategoriesHeroHeader` (title + search icon),
  `CategoryDetailsHeroHeader` (back + centered title + search icon, *plus* a
  second row — see the filter chip row bullet below), `ProfileHeroHeader`
  (title + avatar/name/email identity row + glass edit trigger; the avatar
  uses `AppNetworkImage`'s `assetPlaceholder` param — a bundled default photo
  shown whenever `url` is empty or fails to load, not just a spinner/broken-
  image icon — so a profile screen ships with a real default look before a
  user-provided photo URL exists).
- **Photo-forward product grid.** Two columns; square photos with the card
  radius; the photo *is* the card — no border, no elevation box around it.
  Under it: mint quantity badge (`AppBadge` info intent), bold title, muted
  meta row (delivery time, discount — `ProductMetaRow`), bold price + struck
  original, and a full-width small pill CTA. → `ProductCard` block. Used
  both as a horizontal rail (Home's Popular Items, Search, a product's
  Similar Products) and as the main content of a full listing screen
  (`CategoryDetailsScreen`, 2-column) — same block either way, laid out with
  manual `Row`/`Expanded` chunking, not `GridView` (see the Blocks note
  below).
- **Circle category rail/grid.** Product cutout on an elevated circle, label
  below. → `CategoryTile` block; gravia tightens `imagePadding` so the PNG
  fills more of the same-size circle, and fixes the circle's own fill to a
  raw Gray/50-light / Gray/950-dark swatch (`backgroundColor` override —
  neither shade is a `ColorScheme` role) rather than the themed
  `surfaceContainerHighest` default. Two instances: Home's single horizontal
  rail (`HomeCategorySection`, one `SingleChildScrollView`+`Row`), and the
  Categories tab's full browse view (`CategoryGroupSection`) — categories
  grouped under bold section headings, each group a 4-column grid (manual
  `Row`/`Expanded` chunking, same reasoning as the product grid). Tapping
  either navigates to `CategoryDetailsScreen`.
- **Filter chip row + single-select filter sheet.** A second row on the
  coloured canvas, below the title row: horizontally-scrolling "liquid
  glass" pill chips (`AppGlassChip` — real frosted-glass treatment via
  `CommonGlassSurface`, not a flat tinted box), each opening a bottom sheet
  filter. Sheet body is a single-select list, `AppBottomSheet`'s
  title+"Cancel"-link header (same override pattern as the quick-add sheet
  below). Two list styles depending on what's being chosen: a plain option
  (Sort, Price) uses `AppRadioDot` — a classic outer-ring + inner-dot radio,
  *not* a checkmark — via the generic `RadioOptionsSheetContent<T>`; a
  count-labelled option (`"Apple (4)"`-style) uses square `AppCheckbox`
  with its checkmark, single-select enforced by the BLoC (only one stays
  checked) rather than by the widget itself, which is a plain multi-capable
  checkbox. → `CategoryDetailsHeroHeader` + `RadioOptionsSheetContent`.
- **Section rhythm.** Every content section opens `SectionHeader` (bold title
  + primary "See All").
- **Pill quantity stepper** on cart rows and detail. → `QuantityStepper`; in
  gravia the +/− are the kit's own SVGs (`decrementIconBuilder`/
  `incrementIconBuilder`) in fixed Gray/700 (`iconColor`), count in
  Text/md/bold (`valueTextStyle`).
- **Search takeover.** Home's header search field is a non-editable trigger —
  tapping it opens a dedicated Search screen whose reduced header is a glass
  back button + the same field, now editable; the field itself visibly
  glides from Home's header up into Search's (see the Hero flight recipe
  below the compositions list). Below the header: "Recent Search" rows
  exactly 20px tall — kit `undo`/`remove` SVGs in `onSurface`, term in
  Text/sm/regular Gray/700 light / Gray/100 dark — then the same Popular
  Items rail as Home.
- **Quick-add bottom sheet.** A product card's quick-add icon opens a sheet
  with product photo/name/weight/price and a live quantity stepper that
  scales price and weight together; Cancel + primary `Add to Cart` pills
  footer it. The header itself deviates from `AppBottomSheet`'s default: a
  "Cancel" text link (not the default `X` icon) sits opposite the title. →
  `AppBottomSheet`'s `titleStyle`/`closeLabel`/`closeLabelStyle`/
  `dividerColor`/`handleColor` overrides + `QuantityStepper`.
- **Docked bottom CTA.** Checkout-style primary actions dock at the bottom as
  one full-width large pill above the safe area — often paired with a
  `QuantityStepper` beside it (`ProductDetailBottomBar`). Same top-hairline
  treatment as the bottom nav bar (see rule 4 in §2), not a one-off shade.
- **Pill-highlight bottom nav.** Active tab = pill with icon + label on
  primary; inactive tabs = icon-only circles on Gray/50
  (`surfaceContainerLow` — barely off the surface, not `Highest`), icons in
  fixed Gray/500 both modes (`inactiveIconColor`). The kit's tab set is
  **Home, Categories, Favourite, Orders (bag), Profile** — the cart is not a
  nav tab. → `BottomNavBar`.
- **Settings/menu list.** A vertical stack of icon-circle + label + chevron
  rows below a coloured header (Profile is the reference screen). Each row:
  a fixed-size tinted circle (Gray/50 light / Gray/950 dark — the same
  swatch pair as the category rail's circles) holding a themed-colour SVG
  icon, then the label in Text/md/medium, then a trailing element — by
  default a `direction-right.svg` chevron whenever the row has an `onTap`
  and no explicit override. Two row variants deviate from that default
  trailing: an interactive row swaps the chevron for a real control (Dark
  Mode uses `AppSwitch` — see below); a destructive row (`danger: true`,
  e.g. Logout) tints its icon circle with `error` at 12% alpha, colours the
  icon + label `error`, and drops the trailing chevron entirely (nothing to
  navigate into). → `ProfileMenuTile`.
- **Plain splash.** Pure surface (white/near-black), only the centered
  wordmark: black type with the middle glyph in primary green. No coloured
  canvas, no tagline.

**Hero flight recipe** — how the "same widget glides between screens" effect
(the Search takeover's field) is actually built; reuse this for any
shared-element transition. Reference implementation:
`apps/ecommerce/gravia/lib/widgets/search_field_bar.dart` +
the `/search` route in `apps/ecommerce/gravia/lib/app.dart`.

1. **One shared widget, one shared tag.** Both screens render the *same*
   widget class wrapped in `Hero`; the tag is a single `static const` on
   that widget (namespaced, e.g. `'gravia-search-field-hero'`) that both
   ends inherit by default — two hand-typed literals will eventually drift
   and silently kill the flight.
2. **Trigger mode vs input mode.** The origin screen's copy is display-only:
   `GestureDetector` (navigates) around `AbsorbPointer` (so the real text
   field inside never grabs focus/keyboard). The destination's copy is live.
3. **The route must not slide.** Use an in-place fade
   (`CustomTransitionPage` + `FadeTransition` in the `GoRoute.pageBuilder`,
   ~350ms). When both screens share the same canvas colour the fade is
   invisible up top, so the Hero's glide is the only perceived motion; the
   default horizontal push drags both pages (and the field with them)
   sideways and destroys the "same widget moving" read.
4. **Non-interactive `flightShuttleBuilder`.** Mid-flight the widget is
   rebuilt inside the navigator's Overlay, so the shuttle needs: a
   `Material(type: transparency)` ancestor (text fields require one); a
   backdrop matching the origin surface (a `ColoredBox` in the canvas
   colour) if the widget uses a `BackdropFilter` glass effect — the Overlay
   has nothing behind it to blur; and **no live state**: build the copy
   without the `FocusNode`/`autofocus`/callbacks, wrapped in
   `ExcludeFocus` + `AbsorbPointer` — a `FocusNode` attached to two widgets
   at once throws and aborts the flight.
5. **Linear `createRectTween`.** The navigator default
   (`MaterialRectArcTween`) sweeps rect corners along arcs, so when the two
   ends differ diagonally (position *and* width) the in-flight rect dips a
   few px shorter than either end → `RenderFlex` overflow stripes on the
   shuttle. `RectTween` holds the height constant and gives the straight
   vertical glide anyway.
6. **Focus after the flight.** Don't `autofocus` the destination field; the
   keyboard resizing the screen mid-flight reads as jank. Give it a
   `FocusNode` and `requestFocus()` from a `ModalRoute.of(context).animation`
   status listener once the transition completes. On the way back, `unfocus()`
   before popping so the keyboard's exit runs alongside the return flight.
7. **Pin it with a test** that pumps a mid-flight frame and asserts exactly
   one copy of the widget exists (the shuttle), positioned strictly between
   the endpoints, and sweeps the return flight for exceptions — see
   `test/widget/widgets/search_field_bar_hero_test.dart`; a broken flight
   degrades silently into a crossfade otherwise.

**Blocks:** `package:core/core/ui/blocks/` is split by scope:
- **Root** — cross-domain compositions any style pack can use as-is:
  `section_header.dart`, `quantity_stepper.dart`, `bottom_nav_bar.dart`,
  `collapsing_header_sheet.dart`, `docked_bar_overlap.dart` (bottom-docked
  bar whose rounded top corners float over content extending `overlap` px
  underneath — a plain `Column` would show the scaffold background through
  the corner cut-outs; see gravia's `CartStatusBar` in `ShellPage`). These
  only read `Theme.of(context)`
  (colour/shape/spacing tokens), so a new preset re-skins them for free — no
  new block needed just because a new pack shows up. A fixed-column grid
  nested inside `CollapsingHeaderSheet`'s body (or any scrollable that isn't
  itself sliver-composed) should be laid out with manual `Row`/`Expanded`
  chunking (see `CategoryGroupSection`, `CategoryDetailsScreen`'s product
  grid), not `GridView` — a `shrinkWrap` `GridView` there forces every item
  to lay out up front anyway (no real laziness win), and a guessed
  `mainAxisExtent` either clips content or leaves dead space. An off-layout
  "measure one item first" approach was tried and reverted — it introduced a
  new class of layout bug (a stray gap between rows from a since-unexplained
  bad remeasurement) worse than the one it fixed; don't reach for it again
  without a much stronger reason.
- **`ecommerce/`** — compositions that encode ecommerce-specific data (price,
  discount, delivery time, product photo): `product_card.dart`,
  `category_tile.dart`, `product_meta_row.dart` (the icon+label meta row —
  delivery time, discount — extracted out of `product_card.dart` once a
  second surface, `ProductDetailsScreen`, needed the exact same row outside
  a full card; `ProductCard` now builds its own meta row on top of it too,
  so the two surfaces can't drift apart into hand-copied `Row`s again). A
  future pack in the *same* category (another ecommerce/grocery/retail
  preset) reuses these unchanged; a pack in a *different* category (finance,
  health, social, …) gets its own sibling subfolder — see §3.

Compose these before hand-rolling a new layout; if a needed composition is
missing, build it as a new block (theme-driven, no literals) in the root if
it's cross-domain, or in a `blocks/<category>/` subfolder if it encodes
domain-specific data — never inline in the app.

**App-level presets on top of a `core` atom:** when a style pack's spec for
some interactive control is a fixed, opinionated look that differs from
`core`'s themed default (no check icon, a border colour that doesn't flip
with the theme, a tinted fill, …), don't fork the atom or hand-repeat the
override params at every call site — add the override params to the `core`
atom itself (e.g. `AppChip.showCheckIcon`, `AppCheckbox.showCheckIcon`,
`AppGlassChip.height`; all default to the prior themed behaviour, so
existing callers are unaffected), then wrap it in a small preset widget in
the app's `lib/widgets/` that bakes those overrides in as defaults —
`SelectorChip` (gravia's single-select size/variant chip) wrapping `AppChip`
is the reference example. `core` stays generic and themeable by any pack;
the pack-specific look lives in exactly one place in the app, not
copy-pasted at every screen that needs it.

The same rule applies one level up, to **blocks**: when a pack's spec for a
block is a fixed recipe of many styling params (styles, icons, badge fill,
trailing widgets), wrap it once in an app preset and make every screen
render the preset. `GraviaProductCard` (gravia's `lib/widgets/`) wrapping
core's `ProductCard` is the reference example — it bakes in the weight
badge, flash/percent meta row, price formatting, and the signature CTA rail
(pill "Add To Cart" + glass bag-add quick-add `AppIconButton` on its right),
exposing only `product` + callbacks and small flags (`showDiscount`,
`discountLabel`, `width`). Before it existed, four screens hand-styled
`ProductCard` inline and the copies drifted (Cart's rail shipped with a lock
icon where the glass quick-add belongs). When generating a new surface that
repeats an already-styled block a second time, extract the preset then, not
after the third copy.

**Gravia's preset roster (`apps/ecommerce/gravia/lib/widgets/`)** — when a
gravia screen needs one of these compositions, render the preset; never
re-style the underlying atom/block inline:

| Need | Preset |
|---|---|
| Product card (any rail or grid) | `GraviaProductCard` — never raw `ProductCard` |
| Coloured header canvas | `GraviaHeaderCanvas` (rich headers compose onto it; no `Center`/`Align` inside — see its doc) |
| Back + centered-title header (± trailing action, ± second row) | `GraviaHeroHeader` |
| Tab-root page-title header (left XL title, no back) | `GraviaHeroHeader.page` |
| Glass header control (back/search/favourite/bell) | `GraviaGlassIconButton` — never raw glass `AppIconButton` |
| Docked bottom CTA bar shell | `GraviaDockedBar` (top hairline + safe area + bar padding) |
| Full-width primary CTA (in a docked bar) | `GraviaPrimaryButton` — never a re-typed `AppButton` recipe |
| Styled bottom sheet | `showGraviaSheet` / `showGraviaAddToCartSheet` (extension on `BaseScreenState` in `gravia_sheet.dart`) — never raw `showAppBottomSheet` styling |
| Single-select option chip | `SelectorChip` |
| Hairline colours | `ColorScheme.dockedHairline` / `ColorScheme.sheetHairline` (extensions in `color_const.dart`, like `tintedPrimaryFill`) — never re-derive the brightness ternary |

**When the built-in widget has no override point for the spec at all,** stop
trying to theme it and build a dedicated `core` atom instead. Reference case:
Material's `Switch` grows its thumb radius (8→12) on selection with no public
way to pin both states to one size — `thumbIcon` only forces *both* to the
larger radius, not the smaller one the kit's spec calls for. `AppSwitch`
(`core/ui/atoms/switch.dart`) is a plain custom-painted pill+circle instead:
thumb size is one constant computed from `height`, never branched on `value`,
so both states are the same size by construction, not by a themed
coincidence. Gravia's Dark Mode row feeds it the kit's exact track swatches —
`ColorConst.gray100` (`#EDEDED`) off, `ColorConst.success500` (`#22C55E`) on
— a distinct green from `primary`, so it's a named raw swatch in
`color_const.dart`, not a `ColorScheme` role.

**Whenever you add a new atom, molecule, or block to `core/ui/`, add a
matching showcase entry to `apps/design_gallery`** (Widgetbook — see
`apps/design_gallery/lib/main.dart`) in the same commit. That app is the
living, executable version of this catalog and of the "Verify" step in §3 —
it renders every component against every theme preset, which a hand-written
list can't check itself. Nothing else notices when it falls behind, so
treat a missing showcase entry as equivalent to a missing entry in this doc.
Skip only a component that structurally can't run there (e.g. it imports
`dart:io` and `design_gallery` also builds for web — note the exception
inline in `main.dart` rather than silently omitting it).

---

## 2. Screen design rules (always apply)

### Laying out a screen's initial structure (before any polish)

Get the shape right before touching a `TextStyle` or a colour.

1. **Chrome: `AppBar` or the pack's header treatment?** Check the style
   pack's "Signature compositions" list (§1) first — gravia's screens never
   use a default `AppBar`; they use `CollapsingHeaderSheet` with a
   pack-specific header widget (`HomeHeroHeader`, `SearchHeroHeader`,
   `ProductDetailHeroHeader`). Reach for a plain `AppBar` only when the
   pack's own catalog doesn't define a header pattern for this kind of
   screen.
2. **Order the body top-to-bottom by information priority, not by
   convenience.** For a PDP-shaped screen, see
   `ProductDetailsScreen._buildLoaded` as a worked example: hero media →
   primary identity (name) → supporting meta (delivery time, discount —
   `ProductMetaRow`) → price row → divider → user choices (size/variant
   selectors — `SelectorChip`) → divider → informational copy
   (`ProductDetailKeyInfo`) → discovery (`ProductDetailSimilarProducts`).
   The same top-to-bottom logic (identity → meta → primary choices →
   supporting detail → discovery) applies to any detail-style screen in
   any category, not just ecommerce.
3. **One persistent action → a docked bottom bar, never an inline button.**
   If the screen has a single primary action that should stay reachable
   while scrolling (Add to Cart, Checkout, Submit), give it its own
   `SafeArea`-wrapped bar pinned outside the scroll view (see
   `ProductDetailBottomBar`) — never a button living at the bottom of the
   scrollable content, where it disappears as soon as there's enough
   content to scroll past it.
4. **One divider colour per app, computed once and reused everywhere.**
   Don't invent a hairline shade per screen. Compute it the same way the
   app's persistent chrome does (e.g. gravia's
   `isDark ? Colors.white : ColorConst.gray500`, matching `BottomNavBar`'s
   `topBorderColor`) and reuse that exact value for every hairline in the
   app: the docked bottom bar's top border, the bottom nav bar's top
   border, and any in-content `Divider`. A screen with its own one-off
   divider shade is a smell (see "Screen smells" below).
5. **Reuse a block before hand-building a row.** Before writing a `Row` of
   icon+label pairs, a badge, or a chip, check whether an existing
   `core/ui/blocks/` piece or an app-level `lib/widgets/` preset already
   renders it (e.g. `ProductMetaRow`, `SelectorChip`, `ProductCard`'s
   badge). If the same visual shows up in two places — twice in the new
   screen, or once here and once in an existing screen — that's the signal
   to extract a shared widget rather than copy the `Row`. A style-pack
   preset that wraps a `core` atom with the pack's fixed defaults (e.g.
   `SelectorChip` wrapping `AppChip`) belongs in the app's `lib/widgets/`,
   not hand-repeated at every call site.
6. **Verify both themes and every interactive state before calling the
   layout done.** Not finished until: light *and* dark render correctly,
   every selector/chip's selected *and* unselected state resolves to the
   right token (not just whichever state you happened to screenshot), and
   `flutter analyze` is clean.

Then apply the rules below for the actual polish — spacing, type, colour,
motion.

- **One focal element per screen.** Decide what the screen is *for* and make
  that the largest/boldest thing. Everything else steps down in size, weight,
  or colour. If two things compete, demote one.
- **Spacing rhythm, not density.** Screen gutters `AppSpacing.lg`; between
  sections `AppSpacing.xl4`+; inside a card `AppSpacing.base`. When in doubt,
  add space — generated UIs fail cramped far more often than sparse.
- **Type expresses hierarchy, weight expresses importance.** Titles and
  prices bold (`w700`); supporting copy `bodyMedium`/`bodySmall` in
  `onSurfaceVariant`. Never more than two text roles inside one card. Never
  raw `TextStyle` — always `textTheme` roles with `copyWith`.
- **Colour has a job.** Primary = action + brand canvas. Containers = tints
  behind small info (badges, steppers). Errors only for errors. If a screen
  shows primary in more than the header + one CTA + small accents, it's
  shouting.
- **Empty, loading, and error states are designed moments.** `EmptyState`
  with an icon, one-line title, one-line subtitle, and a next-step action;
  `LoadingIndicator`/`LoadingDots`; `ErrorView` with retry. A bare spinner or
  plain-text "No items" is unfinished work.
- **Images carry the design.** Photo-led apps (commerce, food, travel): big
  images, tight metadata. Always `fit: BoxFit.cover` inside a clipped radius;
  no stretched or letterboxed photos.
- **Touch targets ≥ 44px**; primary CTAs full-width pills at the bottom of
  flows, not small buttons lost mid-screen.
- **Motion is subtle.** Standard transitions and implicit animations
  (~150–250ms); no gratuitous bounces.

### Screen smells (design twin of forbidden patterns)

- A screen that is only stacked default `ListTile`s
- Default `AppBar` on a screen the style pack gives a header treatment
- Three+ font sizes or two+ accent colours inside one card
- Buttons/CTAs styled differently on sibling screens
- Spinner centred in a full screen where skeleton/`EmptyState` belongs
- `Colors.*`, raw hex, `TextStyle(fontSize:)`, `EdgeInsets.all(13)` — token
  and theme violations (see `conventions.md` forbidden patterns)
- A hand-rolled composition that an existing block already provides
- A screen with its own one-off divider/hairline shade instead of the one
  value the app's persistent chrome (bottom nav, docked bottom bar) uses
- A primary action button living at the bottom of scrollable content
  instead of docked outside the scroll view

---

## 3. Adding a new style pack (from a UI kit / Figma file)

1. Extract palette (sample real pixels), shape language, and typography from
   the kit's screens; add a named preset to `app_theme_presets.dart`
   (light **and** dark).
2. Re-author its signature compositions as theme-driven blocks (patterns and
   proportions, never copied assets — UI8 licence: use in end products, no
   redistribution of assets). Place each new block by scope: cross-domain
   (no domain-specific data, reusable by any pack) → `core/ui/blocks/` root;
   domain-specific (encodes data particular to the pack's category) →
   `core/ui/blocks/<category>/` (new subfolder if the category is new, same
   subfolder as an existing pack if the category matches).
3. Add a catalog row + a profile section here: categories, mood, signature
   compositions, block list.
4. Verify: switch an app's `theme_config.json` to the new preset — atoms,
   blocks, and raw Material must all re-skin with zero app-code changes.
