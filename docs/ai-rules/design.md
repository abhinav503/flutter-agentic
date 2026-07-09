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

**Signature compositions (the look, in order of importance):**

- **Coloured header canvas + white sheet.** The screen's top region (title
  row, search, filters) sits directly on the primary green; content below
  lives on a surface "sheet" whose large top radius overlaps the header.
  On-header controls are translucent white circles/pills (`onPrimary` at low
  alpha), never default AppBar icons.
- **Photo-forward product grid.** Two columns; square photos with the card
  radius; the photo *is* the card — no border, no elevation box around it.
  Under it: mint quantity badge (`AppBadge` info intent), bold title, muted
  meta row (delivery time, discount), bold price + struck original, and a
  full-width small pill CTA. → `ProductCard` block.
- **Circle category rail/grid.** Product cutout on an elevated circle, label
  below. → `CategoryTile` block.
- **Section rhythm.** Every content section opens `SectionHeader` (bold title
  + primary "See All").
- **Pill quantity stepper** on cart rows and detail. → `QuantityStepper`.
- **Docked bottom CTA.** Checkout-style primary actions dock at the bottom as
  one full-width large pill above the safe area.
- **Pill-highlight bottom nav.** Active tab = pill with icon + label on
  primary; inactive tabs = icon-only circles. → `BottomNavBar`.

**Blocks:** `package:core/core/ui/blocks/` is split by scope:
- **Root** — cross-domain compositions any style pack can use as-is:
  `section_header.dart`, `quantity_stepper.dart`, `bottom_nav_bar.dart`. These
  only read `Theme.of(context)` (colour/shape/spacing tokens), so a new preset
  re-skins them for free — no new block needed just because a new pack shows
  up.
- **`ecommerce/`** — compositions that encode ecommerce-specific data (price,
  discount, delivery time, product photo): `product_card.dart`,
  `category_tile.dart`. A future pack in the *same* category (another
  ecommerce/grocery/retail preset) reuses these unchanged; a pack in a
  *different* category (finance, health, social, …) gets its own sibling
  subfolder — see §3.

Compose these before hand-rolling a new layout; if a needed composition is
missing, build it as a new block (theme-driven, no literals) in the root if
it's cross-domain, or in a `blocks/<category>/` subfolder if it encodes
domain-specific data — never inline in the app.

---

## 2. Screen design rules (always apply)

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
