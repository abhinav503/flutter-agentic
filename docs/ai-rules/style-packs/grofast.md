# Style pack spec sheet — `grofast`

> Sections §1–§9 are the **contracts**: read them once and you can generate a
> screen that already looks like the pack. §10–§14 are the compositions and
> the wrapper layer. Procedure that produced this file:
> `docs/how-to/add-storefront-template.md`.

---

## 0. Identity

| Field | Value |
|---|---|
| Preset key (`activeTheme`) | `grofast` |
| Source | UI8 kit — "GROFAST · eCommerce Grocery App UI Kit (LIGHT)", Figma file `bpUABss9li4hSRt7NGPRN3`. Licence permits use in an end product; kit assets are **not** redistributed — patterns and proportions are re-authored here, and only glyph SVGs the licence allows are exported into `assets/icons/templates/grofast/` |
| Categories | ecommerce (grocery) |
| Mood | fresh, generous, soft, unhurried |
| Exemplar app | `apps/ecommerce/cordelia` — the `grofast` storefront template (third of three) |
| Font family | **Raleway** (theme) + **Montserrat** (numerics only — see §4) |
| Preset location | `packages/core/lib/core/theme/app_theme_presets.dart` → `'grofast'` |
| App constants | `apps/ecommerce/cordelia/lib/templates/grofast/constants/` — `grofast_color_const.dart`, `grofast_text_style_const.dart`, `grofast_dimen_const.dart`, `grofast_value_const.dart`, `grofast_image_const.dart` |

**Language note (cordelia).** This pack is bilingual — English + Hindi.
Every user-facing string in `GrofastValueConst` is a getter over `L10n.current`
(`grofast*` keys in `apps/ecommerce/cordelia/lib/l10n/app_en.arb` /
`app_hi.arb`); only wordless number/date formatters and data values stay
`const`. The store doc's admin-picked `language` is the default; the
shopper's per-store override (Profile → Language row, wired through
`StoreLanguageSwitchX`) wins; both are applied per storefront visit by
`StorefrontPage` via `ActiveLocaleController` — the exact lifecycle of the
template theme swap. Never cache a localized label in a `static
final`/`static const` list.

**Sourcing note.** Every value here was measured on a *shipped* frame — Home
(`17:1`), Product Detail (`27:288`), Bag (`129:1144`), Search Result
(`148:2151`), Search Option sheet (`23:285`), Category Expanded (`119:796`),
Checkout (`119:819`), Profile (`122:1143`) — on the kit's 375-wide artboard.
The file's variable collection is thin (six colours and three type tokens), so
fills, radii and gradients came from `get_design_context` on the components
themselves rather than from a foundation page.

The kit is the **LIGHT** edition: it ships no dark screens. The dark half of
the preset is authored, not sampled — see §1.

---

## 1. Colour contract

The full role map lives in the preset — **don't restate hexes in app code**.

**Character.** The pack is white-surfaced and low-contrast, and its ink is
*green*: `onSurface` is the kit's Dark-Green `#194B38`, not a neutral black.
Every heading, product name and body line inherits it, and that single choice
is most of what makes the pack read as "grocery" rather than "generic
storefront". Primary (`#4CBB5E`, Light-Green) is an **accent**, not a canvas —
it appears as prices, active chip ink and the tint inside the brand gradient,
and never as a large flat fill. Affirmative controls are painted with the
**gradient** instead (see below). Surfaces separate by fill, not by shadow:
cards are `#F1F4F3` on white, with no elevation at all. Dark mode inverts the
same idea — the forest ink drops to a near-black green canvas (`#0F1A15`) and
the neutrals climb back up as elevation — holding both greens fixed so the
gradient and the prices are identical in both modes.

**Cross-mode invariants** — roles deliberately identical in light and dark:

| Role | Value | Why it doesn't flip |
|---|---|---|
| `primary` | `#4CBB5E` | Prices are the pack's signature; a flipped green would read as a different brand |
| Brand gradient | `#26AD71 → #32CB4B` | It is the pack's "primary button", and it carries white text in both modes |
| `error` | `#EC534A` light / `#F08A83` dark | Hue held; only lightness moves, so a favourited heart stays the same red |
| `secondary` / `onSecondary` | `#194B38` / `#FFFFFF` | The role's only consumer is the promo row's "Apply" pill, and the kit inks it Dark-Green. Inverting it to a near-white chip made the one control on a dark coupon row the brightest thing on the screen — louder than the gradient CTA below it |

**Fixed swatches** — pinned in both modes, in `grofast_color_const.dart`:

| Constant | Value | Used by |
|---|---|---|
| `gradientStart` / `gradientEnd` | `#26AD71` / `#32CB4B` | every affirmative control (§10) |
| `brandGradient` | bottom-left → top-right, stops `0.063 / 0.967` | the one recipe all of them share |
| `categoryTints` | 7 pastels (mint `#EBF4F1`, cream `#F5F4E8`, sand `#F6EDE4`, blush `#FBECEC`, butter `#F7F4E3`, peach `#F8EFE4`, sky `#E9F1F7`) | category tiles, cycled by index (light only) |

**Extension roles** (`AppColorsExtension`, read via `context.appColors`):

| Role | Light | Dark | Used by |
|---|---|---|---|
| `dockedHairline` | `#E8ECEA` | `#35473F` | the Bag's totals separator, in-content dividers |
| `sheetHairline` | `#E8ECEA` | `#253830` | in-sheet dividers (the drag handle is **white**, see §2) |
| `tintedPrimaryFill` | `#EBF4F1` | `#334CBB5E` | selected chip fill, quick-tile wells |
| `onSheetMuted` | `#777777` | `#9FB0A8` | sheet subtitles |

Two roles the pack computes rather than stores, in `GrofastColorSchemeX`:
`categoryTint(index)` (falls back to `surfaceContainerLow` on dark, where the
pastels turn to mud) and `fieldFill` — the search field is **`onSurface` at
6%**, a green-cast tint no neutral role reproduces.

**Unused ramp policy.** The kit ships six named colours and no ramp, so the
preset promotes all six and derives the rest from the seed. A shade the kit
doesn't name goes to `AppColorsExtension` if it's semantic, or to
`grofast_color_const.dart` if it's an exact pack swatch — never inline.

---

## 2. Shape contract

| Role | Radius | Source |
|---|---|---|
| Button | 999 (pill) | preset `shape.button` |
| Chip | 999 (pill) | preset `shape.chip` |
| Card / product image | **28** | preset `shape.card` |
| Category tile / line-item row / address card / Profile's menu rows + quick tiles | **23** | `GrofastDimenConst.tileRadius` — the kit's second radius, for the row-scale surfaces; only true product/promo *cards* keep the 28 |
| Input (shared default) | **18** | preset `shape.input` |
| Bottom sheet | 28 (fallback only) | preset `shape.sheet` |
| Sheet-over-header (the content sheet's top edge) | **an arc, not a radius** | `GrofastDimenConst.sheetDomeRise` = 22 |
| List thumbnail | 28 | card radius, reused |
| Icon circle / avatar | full circle | |

The 28 is doing a lot of work: card, image well inside the card and promo
banner all share it, which is why cards can sit directly on white without a
border or a shadow. The kit softens by 5 for the *row-scale* surfaces — the
category tile's tinted well, the cart / checkout / order line-item row, the
address card, and Profile's menu rows and quick tiles — and that 23 is the
pack's only other radius. A skeleton standing in for one of
them passes `GrofastCardSkeleton(radius: tileRadius)`, or the loading state
rounds differently from what replaces it.

**Documented deviations:**

| Where | Deviates to | Why |
|---|---|---|
| Back control | 60 × 40 **rounded rectangle**, not a disc | The kit's own back button; the pack has no circular back anywhere |
| Product card's add button | top-left 15, bottom-right 28 | It is welded into the card's corner and inherits that corner's radius |
| Sheet top edge | elliptical arc, rise 22 | The pack's signature — see §10 |
| Product Details hero | arc on its **bottom** edge | Same dome, flipped |

---

## 3. Dimension contract

| Constant | Value | Applies to |
|---|---|---|
| `tileRadius` | **23** | category tile's well, line-item row, address card, Profile's menu rows and quick tiles — see §2 |
| `GrofastDimenConst.controlHeight` | **50** | search bar, scan button, every wide CTA, form fields |
| `screenGutter` | **30** | every screen's content inset — wider than any other pack, and the main reason the screens feel unhurried |
| Back control | 60 × 40 | `backButtonWidth` / `backButtonHeight` |
| Icon glyph size (header / nav) | 25 | `headerIconSize`, `navGlyphSize` |
| Icon glyph size (inline / trailing) | 16–18 | inside rows and chips |
| Product card | 245 tall (215 for the first cell) × 149 wide at 375 | `productCardHeight` / `productCardShortHeight` |
| Product card chrome below the image | 71 | `productCardChromeHeight` — the well is `height − 71` |
| Card corner add button | 53 × 41 | `productAddButtonWidth` / `Height` |
| Product image inset | 20 | `productImageInset` — the margin the kit's cut-out artwork carries in-file, added as real padding for uploaded photos |
| Card heart | 25 outer, 20 inner (0.81), 8 glyph (0.4 of inner), inset 17 | `productHeartSize` / `productHeartInset` — two concentric circles, see §10 |
| Grid gaps | 17 column / 18 row | `gridColumnGap` / `gridRowGap` |
| Category rail entry | 70 tile, 89 total | `categoryRailTileSize` / `categoryRailEntryHeight` |
| Category grid cell | square (1:1) | `categoryGridAspectRatio` |
| Promo card | 150 tall, 0.776 of the screen wide, 18 gap, copy/artwork split 40:60 | `promoCardHeight` / `promoCardWidthFraction` / `promoCardGap` / `promoCopyFlex` / `promoImageFlex`; the carousel's page fraction is derived by `promoPageFraction(width)` |
| Nav bar / dome / disc | 90 / 82 / 64 | `navBarHeight` / `navBumpDiameter` / `navDiscSize` |
| Line-item row | 100 tall, 76 thumb | `lineItemRowHeight` / `lineItemThumbSize` |
| Stepper button | 28, radius 8 | `stepperButtonSize` / `stepperButtonRadius` — white rounded squares, not discs |
| Bag row heart | 20 | `lineItemHeartSize` — the card's heart at the wide row's size |
| Coupon row | 70 tall, dashed outline at 20% ink | `couponRowHeight` / `couponBorderOpacity` |
| Apply pill | 40 tall, radius 15 | `applyPillHeight` / `applyPillRadius` — the pack's one non-pill button |
| Chip — sheet options | 28 | `chipHeight` — the sheet frames' pill (Search Option `23:285`) |
| Chip — list-screen filter row (`Button-Text/Big`) | **35** tall at `tileRadius`, 22 side padding | `bigChipHeight` / `bigChipHorizontalPad` — Montserrat 12/500 label, active ink/border the kit's Medium-Green `chipActiveInk` on `cs.surfaceContainer` (Notification `168:2316`) |
| Order card | 100 tall at `tileRadius`, square image well | `orderCardHeight` — the kit's notification card |
| Track Order detail fields | 33 tall at radius **13** | `trackFieldHeight` / `trackFieldRadius` — the Status / Purchase Date pair; the pack's one odd radius |
| Field label inset | 9 | `fieldLabelInset` — every labelled field's label starts 9 in from its field's edge (forms, pickers, the Order Detail pair); applied inside `GrofastFormField`/`GrofastDropdownField` so no screen re-adds it |
| Tracking event card | 70 tall at `tileRadius` | `trackEventCardHeight` — the newest event (`Track/New`) |
| Timeline bullet / connector / indent | 8 / 1 / derived | `timelineDiscSize` / `timelineLineWidth` / `timelinePastIndent` — the indent is derived from the event card's padding + glyph so the rail centres under its icon |
| Total row price | 22/18 | `totalPriceScale` — the kit's `Item/Menu/Total-Title` split price |
| Avatar — profile / edit | 100 / 120 | `profileAvatarSize` / `editAvatarSize` |
| Product Details hero | 465/812 of the screen | `detailImageHeightFraction` → `detailImageHeight(context)` — the one height in the pack taken as a fraction, because a surface that owns 57% of the screen can't be pinned to a number |
| Product Details favourite | 50, resting 39 above the well's flat bottom | `detailFavouriteSize` / `detailFavouriteBottomInset` — **inside** the well, clear of the arc (the dome drops `sheetDomeRise` at the edges) |
| Product Details dock | device inset + stepper; panel 196/375 wide, one 28 radius top-left | `detailDockHeight(context)` / `detailDockPanelWidthFraction` / `detailDockPanelRadius` — the kit's 92 includes an 18 panel overshoot that is dead white on the stepper's side, so the band hugs its row instead |
| Product Details stepper | 40, radius 15 | `detailStepperButtonSize` / `detailStepperButtonRadius` — `GrofastQuantityStepper.large`, tinted keys on white (the Bag row's inverts) |
| Screen gutter | `screenGutter` (30) | not `AppSpacing.lg` — this pack is wider |
| Between sections | `AppSpacing.xl4`+ | |
| Inside a card | `AppSpacing.lg` | |
| Minimum touch target | ≥ 44, except the card heart / add button and the stepper, which are secondary controls **on top of** a large target |

> `controlHeight` = 50 is the pack's highest-signal number: the search bar, the
> scan button beside it, and every CTA share it, which is what makes unrelated
> controls read as one system. Never re-declare it per widget.

---

## 4. Type contract

| Field | Value |
|---|---|
| Family | **Raleway** for everything the theme sets; **Montserrat** for numerics only |
| Letter-spacing | 0 throughout — the kit sets none at any size |
| Weights in use | 400 / 500 / 600 / 700, plus **800** on Home's greeting and the promo banner's two lines. No light weights |
| Scale source | the kit's `Text/Reguler/{Big,Medium,Small}` + `Text/Link/Small` tokens, extended only where a real screen needed a step between them |

The two-family pairing is the pack's least obvious contract: prices, unit
suffixes, item counts, order dates and inline links are **Montserrat**, and
everything else is Raleway. A theme preset carries one `fontFamily`, so
Raleway arrives on every role from the preset and the Montserrat half is
resolved at the call site through `GoogleFonts` in
`GrofastTextStyleConst`. `core`'s 13-role M3 scale is shared by every preset —
never edit it for one pack.

**A Raleway token sets its weight with `atWeight`, never
`copyWith(fontWeight:)`.** google_fonts binds a style to one font *file* when
the family resolves, and the preset resolves each role at that role's own
weight (`headlineMedium` is w400). Copying a heavier weight onto it keeps the
regular file and fake-bolds it, so every weight above the role's renders
identically — 700 and 800 are the same picture, which is how the greeting
shipped looking unchanged after a deliberate bump to 800.
`TextStyle.atWeight` (`core/extensions/text_style_extensions.dart`)
re-resolves the real cut. The Montserrat half never had the problem: it passes
its weight to `GoogleFonts` in the first place.

| Token | M3 role it wraps | Used for |
|---|---|---|
| `displayBold` | `headlineMedium` | 28/700 — screen titles ("My Bag", "Success!") |
| `welcomeBold` | `headlineMedium` | 28/800 — Home's greeting; the kit draws it from its own `Text/Welcome Text` component, not the `Text/Reguler/Big` token behind `displayBold` |
| `sectionBold` | `titleLarge` | 20/700 — section headers |
| `subheadBold` | `titleMedium` | 18/700 — sheet titles, card headlines |
| `rowTitleBold` | `titleMedium` | 16/700 — category names, row primaries |
| `cardTitleBold` | `titleSmall` | 14/700 — product card names |
| `promoTitle` | `titleSmall` | 14/800 — the promo banner's headline; the pack's only extra-bold, paired with `promoAmount` |
| `labelSemibold` | `labelLarge` | 14/600 — button labels, the active nav label |
| `chipMedium` | `bodySmall` (Montserrat) | 12/500 — the big list chip's label; one weight up from `link` |
| header title | `link` in `cs.headerInk` | the kit's `Header/Back and Text`: Montserrat 12/400 in Dark-Grey `#4B4B4B` (dark mode falls back to `onSurfaceVariant`) — quiet on purpose; the pack's real title is the bold line the content opens with |
| `bodyMedium` | `bodyMedium` | 14/500 — menu rows, chips |
| `bodySmall` | `bodySmall` | 12/500 — sub-lines, timestamps, form labels |
| `placeholder` | `bodySmall` | 12/400 — field placeholders, drawn at 40% ink |
| `price` / `priceDecimal` | `titleMedium` / `titleSmall` | Montserrat 18/600 + 14/600 — a price's integer and decimal runs |
| `unitSuffix` | `labelSmall` | Montserrat 10/500 at 50% opacity — "/kg" |
| `meta` | `labelSmall` | Montserrat 10/500 — counts, dates |
| `promoAmount` | `headlineMedium` | Montserrat 28/800 — the promo banner's offer figure, the 800 half that pairs with `promoTitle` |
| `link` | `bodySmall` | Montserrat 12/400 — "see all", "add new" |

---

## 5. Iconography contract

| Field | Value |
|---|---|
| Style | **solid / filled** — no line icons anywhere, including the nav |
| Stroke width | n/a (filled glyphs) |
| Corner/terminal | rounded |
| Source | kit SVGs in `assets/icons/templates/grofast/`, rendered via `AppSvgImage.asset` with `color` passed in |
| Material fallback | where the kit exports no glyph: the header's location pin + chevron, the avatar placeholder, a menu row's chevron, the edit pencil, the rating star, Change Password's lock, the legal shield. The wrapper takes `asset` **or** `icon`, never both |
| Colour policy | one export serves both states — active takes `cs.onPrimary` (on the gradient disc) or `cs.onSurface`, inactive takes `cs.onSurfaceVariant`. No glyph carries a baked-in fill |
| Sizes | see §3 |

Two exports ship but are deliberately unused: `scan.svg` and
`list_view_menu.svg` — see §11.

---

## 6. Surface & contrast ladder

| Layer | Token | Carries |
|---|---|---|
| Brand canvas | — (not used by this pack) | grofast has **no** coloured canvas; every screen is `cs.surface` |
| Content sheet | `cs.surface` | every screen body, and the dome sheet |
| Raised neutral (cards, rows, wells) | `cs.surfaceContainerLow` (`#F1F4F3`) | product cards, cart rows, menu rows, quick tiles, image wells |
| Tinted info | `cs.surfaceContainer` / `tintedPrimaryFill` | selected chips, category tiles (via `categoryTint`) |
| Affirmative control | `GrofastColorConst.brandGradient` | **not** a colour role — the gradient is the fill |
| Hairline | `appColors.dockedHairline` | the Bag's totals separator |
| Floating | `GrofastElevation.raised` | the nav disc, the filter pill, the success icon |
| Nav bar | `GrofastElevation.navBar` | a wash, not a lift: bar and canvas are both `cs.surface`, so without it the dome only reads where content happens to sit behind it. **Not** a Material `elevation` — the alpha `Canvas.drawShadow` derives is invisible at this scale, and a `ClipPath` can't cast a shadow at all, so `GrofastNavBarSurface` paints the shadow layers and the fill from one path |

The ladder is unusually flat: two neutral steps (white → `#F1F4F3`) carry
almost the whole app, and depth comes from the 28 radius and the gradient
rather than from elevation. Both shadow recipes share one green ink
(`#369246`) — a third is drift. **Cards never take a shadow** — that's what
separates this pack from `dailymart`, which lifts white cards off a mint
canvas.

---

## 7. Motion contract

| Tier | Duration | Curve | Used for |
|---|---|---|---|
| Micro (state flip) | 150ms | `easeOut` | heart toggle, chip selection, stepper press |
| Component | 300ms | `easeOutCubic` | the nav's dome + disc sliding between tabs, page indicator |
| Content swap | 300ms | `easeInOut` | `AppSwitcher` between skeleton / loaded / empty / error |
| Route | 350ms in / 300ms out | `easeInOut` | page transitions (fade, matching the app's other packs) |
| Shared element | 300ms | default | Home ↔ Search field flight (`HeroSearchFieldFlight`) |
| Ambient / looping | 1200ms | `easeInOut` | skeleton shimmer |

The dome and the disc are one transition and therefore share one *driver* —
not merely one duration. Two animations of equal duration drift apart the
moment either curve is touched, and the disc then visibly leaves its dome.
No bounces anywhere; a mount-in animation fades or scales, never relayouts.

---

## 8. Screen skeleton

```
Scaffold (BasePage, no AppBar — the pack draws its own header row)
└─ SafeArea(bottom: false)          ← the floating CTA / nav re-adds the inset
   └─ CustomScrollView / Column, padded to screenGutter (30)
      ├─ header row      (back control 60×40 | centred title | trailing bag)
      ├─ optional search / filter row  (controlHeight 50)
      ├─ section header  (sectionBold + a Montserrat "see all" link)
      ├─ body            (staggered grid | list of 100-tall rows | form)
      └─ bottom inset    (nav inset inside the shell, CTA inset outside it)
```

| Region | Widget | Notes |
|---|---|---|
| Chrome | `GrofastHeaderRow` | Never a Material `AppBar` — the back control is a rounded rectangle and the title is optically centred against it |
| Scroll behaviour | Back-button headers **pin** above the scroll; back-less headers scroll away | `GrofastScreenBody` auto-pins when its title-built header shows the back control; tab roots (`showBack: false` / custom `headerRow`) keep scrolling, and Search/Category Details opt their back-carrying `headerRow` in with `pinnedHeader: true`. Product Details pins its floating header row over the hero in the screen's outer Stack instead — its controls carry their own fills |
| Body | `GrofastScreenBody` | One padding/scroll recipe for **every** state a screen swaps through |
| Persistent action | floating pill over a `surface → transparent` fade | Not a docked bar — the CTA floats, and the fade is what separates it from the content. **One exception:** Product Details, whose kit frame welds its CTA into the corner (see §10) |
| Global nav | `GrofastNavBar` | 4 slots, domed, only inside the shell — its `Scaffold` runs `extendBody` so the tab's content passes behind the dome, and every tab pays `navScrollInset` |

**Screens that deviate:** Product Details (hero dome, no header row — the back
and bag controls float on the image); the success sheet (no header at all);
auth / splash / onboarding, which are shared Cordelia chrome and never
templated.

---

## 9. Overlay policy

| Interaction | Overlay | Entry point |
|---|---|---|
| Bounded picklist (sort, price, city, country) | **dome sheet** | `showGrofastSheet` |
| Confirm / destructive (log out, delete address, cancel order) | **dome sheet**, chrome-free | `showGrofastConfirmSheet` |
| Terminal confirmation (order placed) | **dome sheet**, chrome-free, non-dismissible | `showGrofastSuccessSheet` |
| Contextual action list (avatar source) | **dome sheet** | `showGrofastSheet` |
| Transient feedback | snackbar | `showSnackBar` from `BaseScreenState` |

`AppDialog`, `showDialog`, `PopupMenuButton` and `AppDropdownMenu` are **not
used at all** in this pack. Every overlay is the dome sheet; the only axis
that varies is whether it carries chrome (title + close) and whether it can be
dismissed. This is the strictest overlay policy of the three packs, and it is
deliberate — the dome is the pack's signature, so diluting it with a second
overlay type would cost the identity.

---

## 10. Signature compositions

- **The dome sheet.** Every overlay's top edge is an upward arc peaking 22
  above its edges, with the drag handle floating on the scrim *above* it. Both
  are one `GrofastDomeSheetBorder` passed to `AppBottomSheet.shape`, so the
  sheet fills and clips to the same path and the gap between handle and dome
  shows the scrim through. Content clears `GrofastSheetMetrics.contentTop`.
- **The domed nav.** A white 90px bar whose top edge *lifts into* a Ø82 dome
  around the active tab — a bulge, not a hole — with the tab's Ø64 gradient
  disc sitting in it, concentric, the 9px difference reading as a white ring.
  The label sits under the disc, *inside* the bar. Dome and disc animate as one
  300ms movement off one driver.

  Two things make or break it. **The shoulders:** where the circle meets the
  flat edge its tangent is vertical, so a plain rectangle-∪-circle leaves two
  cusps; the kit instead lifts the edge 60.5 out from the centre and runs a
  quadratic Bézier to the circle's tangent at 59°, control point at
  `r / sin(59°)`, tangent-continuous at both ends (`GrofastNavBarClipper`).
  **What's behind it:** a white bulge on a white canvas has no silhouette, so
  the shell's `Scaffold` runs `extendBody` and the tab's own content scrolls
  under the dome. Without that the shape is invisible and the bar reads as a
  plain strip with a floating disc.
- **The Bag row.** The kit's wide card carries the *favourite* heart in its
  top-right and the stepper bottom-right — no remove control. Deleting a line
  is a **swipe** (the kit's `Card/Product/Wide+Delete`: the row slides off a
  soft `errorContainer` panel with the outlined trash glyph in `error`), which
  is why the visible control is the one that can't be undone by accident. The
  swipe is core's `SwipeToDeleteRow` (which owns the panel-under-the-row
  clip recipe), fed the kit's trash glyph at the row's 23 radius. Its totals
  show every line that makes the
  sum — subtotal, discount when there is one, then the total under a hairline
  — on core's `PriceBreakdown`, the same block Checkout uses, with the coupon
  row in its `leading` slot.
- **The favourite heart.** Two concentric circles, Ø25 over Ø20, and the
  outer one only exists once saved: not saved is a plain white Ø20 disc with
  an `error` glyph; saved fills that disc with `error`, flips the glyph white,
  and grows a detached `error` hairline **ring** at Ø25 with the card showing
  through the gap. So the toggle changes the silhouette, not just the colour —
  it is the kit's own difference between `Card/Product/Tall` and
  `Card/Product/Tall-favorite-disabled`. The Ø25 box is kept in both states so
  the tap target doesn't move. `GrofastFavouriteHeart` scales both circles off
  its `size`, which is what lets Product Details reuse it at 56.
- **The corner add button.** A 53 × 41 gradient block welded into the product
  card's bottom-right: it inherits the card's 28 radius on that corner and
  rounds its top-left by 15, so it reads as a piece cut out of the card. The
  pack's most recognisable element.
- **The staggered grid.** Two independent columns, 17 apart. The stagger is
  produced by giving the **first** card the short height (215 vs 245); because
  the columns lay out independently, that one difference offsets the right
  column for the rest of the scroll and never resynchronises.
- **The split price.** Montserrat in `cs.primary`, the decimals a size smaller
  than the integer part, with a 10/500 unit suffix at 50% opacity trailing it.
  On every card, row, hero and total.
- **The flipped dome.** Product Details' hero well takes the same arc on its
  *bottom* edge. The favourite disc floats **inside** the well, above the
  curve — it does not straddle the edge.
- **The welded dock.** Product Details' "Add to bag" is not the pack's
  floating pill: it is a gradient **panel** driven into the bottom-right
  corner, carrying a single 28 radius on its top-left and no safe-area inset
  at all, so it runs behind the home indicator. Only the stepper beside it
  keeps that inset, and the label centres on the stepper's line rather than on
  the panel's. The band is exactly the row's height — the kit draws the panel
  18 taller than the stepper, which reads as dead padding above the stepper
  once the row is the only thing in it. The band under both is opaque
  `cs.surface`, and the fade over it is `GrofastBottomFade.overDock` — no
  device inset (the band owns it) and a gradient that runs its whole length,
  because the ordinary fade's opaque lower half would stack a second white
  slab on top of an already-opaque band. The fade sits
  *above* it, so nothing scrolls through the row. Same family as the product
  card's corner add button — a piece cut out of the surface, not laid on it.

## 11. Recipes

**Deviations from the kit, and why.** Each is a frame or detail the kit draws
that this template does not, because no data or feature stands behind it.
Recorded so nobody "restores" them:

| Kit shows | grofast does | Why |
|---|---|---|
| Scan tab + 3D-scan button on Home | Categories tab; plain search field on Home | No barcode feature — the control would be dead. `scan.svg` stays unused in the pack folder |
| Grid/list view toggle (a Vertical + Horizontal frame per list screen) | Grid only | Presentation-only axis; shipping half of it beats shipping a toggle nobody asked for. `list_view_menu.svg` unused |
| Voucher screen + Coupon Detail + Profile's Voucher tile | Profile's middle tile is **My Orders** | No coupon backend; My Orders is a real surface the kit's own menu never reaches |
| Promo-code field with a working Apply | The field, with the other packs' "coming soon" snackbar | Same coupon gap; removing the row would leave a hole in the kit's Bag layout |
| Map thumbnails (Tracking header, Checkout address cards, Notification cards) | Omitted — except the address cards, which cycle two bundled placeholder maps (`ImageConst.addressPlaceholders`) | Nothing stores an address's or delivery's coordinates; the address card keeps the silhouette because the kit's `Item/Location` layout is built around the thumbnail |
| Saved payment cards on Checkout | Omitted | Razorpay owns payment; a card picker here decides nothing |
| Courier event feed on Tracking (staging depots, city names, "See N more updates", six steps) | The statuses the order actually reached, dated by `statusHistory`: newest on the kit's tinted `Track/New` card (red `-Canceled` variant), earlier ones as its bullet rows | `OrderStatus` has four values and no locations; unreached steps aren't shown — the kit's feed is a log of what happened, not a pipeline |
| Courier tracking id, delivery ETA | Order id; no ETA | Not on `OrderEntity` |
| Product rating (`4.7`) on Product Details | The kit's badge, rendering the product's real rating — `ValueConst.ratingLabel(average, count)`, or `unratedLabel` with a greyed star when nobody has reviewed it | Was the pack's one piece of invented copy until reviews shipped; `ProductEntity` now carries `ratingAverage`/`reviewCount`, so the badge's geometry is unchanged and only the source moved. An unrated product must never print `0.0` — that reads as badly-reviewed rather than unreviewed |
| "Free shipping" chip on Product Details | Omitted | No shipping model — unlike the rating it names a promise the store never made |
| "112 Items" under each category tile | Omitted | Not on `CategoryEntity` |
| Per-category hand-picked pastel tints | A 7-stop ramp cycled by index | The backend has no tint field |
| Notification status filter chips (All / On Delivery / Delivered / Canceled) | Kept as a chip row, but over the feed's own **section titles** (All / Now / Past …) rather than order statuses | The feed is a mixed-kind mock, not an order list — the sections are the only real axis it has |
| Category rail across Category Details | Omitted | It would re-fetch the whole category list to render sideways navigation |
| Filter sheet's "Free Shipping" row and Lowest/Highest price inputs | Sort + the app's `ProductPriceFilter` bands as chips | No shipping model; a free range needs a filter axis the shared bloc lacks |
| No account-deletion row | Profile's menu ends with **Delete Account** on the kit's `delete.svg`, under Log out, behind `showGrofastConfirmSheet` | Both app stores require in-app account deletion wherever sign-up exists (App Store Review Guideline 5.1.1(v)) — a store requirement the kit has no frame for, so every pack builds the row from its own menu recipe |
| No order-rating surface | Track Order's floating slot becomes **Rate Order** once the order is delivered (Edit Rating afterwards), where it holds Cancel Order while the order is still coming; a cancelled order gets neither | Rating a delivery is a real backend capability (`orders/{id}.rating`, gated server-side to the shopper's own delivered order) that the kit has no frame for. The sheet body is the pack's own `write_review_sheet_content`, the same one its product reviews use |
| Product Review frame | A **Reviews** block on Product Details, under Description: the average + per-star histogram, the review rows, and the pack's gradient CTA opening a write-review sheet | The kit draws no reviews frame, so the block is composed from recipes the pack already owns (`sectionBold` heading, `GrofastBadge.outlined` for each row's rating, `GrofastPrimaryButton`, `showGrofastSheet` for the composer). Reviews are a real feature now — see `feature/storefront/reviews/` |
| Notification Setting frame | Omitted as a screen; its form silhouette serves Edit Profile / Change Password | No notification-preference feature |
| Flat banner artwork with the copy over it | A 40/60 split — copy column, then the photo — on a colour the store picks | The kit's illustration is drawn *around* its words; a store's uploaded photograph isn't, and a scrim over it (the first attempt) muddies the artwork and forces white copy. The split keeps the pack's ink on a flat surface and every store's banner legible; `BannerEntity.backgroundArgb` (admin → `backgroundColor`) is what ties the copy panel to the photo beside it, falling back to `surfaceContainerLow`. The copy itself is `GrofastColorConst.promoInk` — the kit's Dark-Green held constant in **both** modes, because it sits on the store's colour, not the theme's canvas |
| Edge-to-edge product image well | The same well, with `productImageInset` (20) of padding | Same cause: the kit's cut-out artwork carries that margin in the asset, an uploaded photograph doesn't, and `contain` then runs it to the card's edges |
| "All Categories" page title | Dropped; the grid starts under the search field | The nav bar already names the tab and the whole body is the grid. Per-group headers stay — they name something the screen can't otherwise tell you |
| Price suffix as a bare unit (`/kg`) | The whole pack unless it is exactly one unit (`/500 g`) | The kit's products are all 1 kg, so the bare unit is honest there. A 500 g pack labelled `/g` prices it per gram — see `ProductUnitTypeX.pricePerLabel` |
| No option picker on Product Details | One "Select {option}" title + `GrofastChipRow` per option axis (Size, Colour, a pack size), between the price row and Description; unavailable values struck through | The general product model (up to 3 axes, per-variant price and stock) landed after the kit; the price, its `/pack` suffix, the "Only N left" badge, the stepper ceiling and the dock all follow the selected variant, and Add to bag carries it into the cart line as a `variantId`. An `attributes` spec list renders under Description |
| No brand on Product Details | The brand joins the title's label pills as a `GrofastBadge.outlined` — its logo artwork when it has one, the rounded-icon system (`Icons.sell_rounded`) otherwise | Brands landed after the kit; unbranded products simply don't render the pill |

**One went the other way.** The kit's category chip beside that rating was the
first surface to need a product's category, which the storefront API didn't
return — `GET /api/stores/{id}/products/{productId}` now resolves the first of
the product's `categoryIds` and answers a `category` object (null when it has
none), carried through as `ProductDetailEntity.category`. The badge renders
the category's real name and artwork; the kit's emoji is its own placeholder.

**Address picking is the kit's Select Location sheet (`129:1458`), not a
page.** Mid-flow selection (Bag → checkout, Checkout's change address) opens
`showGrofastAddressPicker` — the domed sheet listing `Item/Location` cards
(`GrofastAddressTile`: 100 tall at `tileRadius`, a rounded-18 map thumbnail
inset 6, name over a hairline, pin + address lines; active takes a 2px
`gradientStart` ring). The sheet owns its own `AddressBloc` and dispatches
`started` on open — warm cache renders instantly, cold runs a tile-shaped
shimmer — and tapping a card *is* the commit. The routed Select Address page
survives as Profile's **management** surface only, on the same tile plus the
affordances the sheet doesn't carry: edit as a pencil in the tile's trailing
slot (`edit.svg` — authored in the kit's icon language, since the kit ships
no pencil), delete as a left swipe on core's `SwipeToDeleteRow`, gated behind
the pack's confirm sheet and non-optimistic so a failed server delete keeps
the row. The tile is the pack's *one*
address rendering: Home's location pill opens the picker too, and Checkout's
delivery-address card is the same tile in its active ring (the former
`GrofastCheckoutAddressCard` is deleted). The thumbnails cycle two
app-level placeholder maps (`ImageConst.addressPlaceholders`) — nothing
stores an address's coordinates, the same data gap that dropped the kit's
other maps.

**Track Order** follows its three frames minus the map header — the page
starts at Order Detail: the kit's side-by-side Status / Purchase Date fields
(33-tall at radius 13, labels inset `fieldLabelInset` = 9 from the field
edge — the inset every labelled field in the pack shares, forms included;
Delivered fills with the **brand gradient** under white text — an
affirmative fill is always the gradient — in-flight takes the mint +
Medium-Green, cancelled the error tint), then the
id rows — Order ID and Payment ID each carry a **copy** glyph in
`cs.primary`, the whole row tapping to clipboard with a snackbar. The Total
prints as the kit's `Item/Menu/Total-Title` row (`totalPriceScale`, 22/18).
Cancel Order is the kit's quiet outlined neutral — the destructive red lives
in the confirm sheet, not on the button.

**Surfaces the kit has no frame for**, composed from the pack's own recipes:
My Orders (Notification `168:2316`'s search field → `Button-Text/Big` chip
row → 100-tall cards — the same layout Notifications itself renders, minus
the search row, its chips being All + the feed's section titles and its
card wells holding the kind's glyph disc instead of a photo. Each order
card carries the order's date, split total, hairline
and a "Delivered/Delivering to *address tag*" line; no status chip on the
card — the chip row above already scopes the list, and the kit's chip labels
map onto `OrdersStatusFilter` as All / On Delivery (`active`) / Delivered
(`completed`) / Canceled. The pack's filter square docks beside the search
field — glyph lit `cs.primary` while a filter is in force — opening a
**date-only** sheet on the shared `OrdersFilter` (quick picks + range picker
+ Apply over Reset); status stays on the chip row, so the two can't
disagree), Edit Profile and
Change Password (the labelled-field stack + floating CTA), Add/Edit Address
(the same, with the City/Country pair as sheet-opening picklists), Wishlist
(the header row + staggered grid), and the nav shell's tab set. Profile's
**Dark Mode** row is the same recipe: the kit ships only light screens and so
draws no theme control, but the preset authors a dark half (§1) that nothing
would otherwise reach — the row is a `GrofastMenuTile` whose `trailing` slot
carries an `AppSwitch` over `ThemeModeScope` instead of a chevron, and whose
own tap toggles it (a chevron there would promise a screen).

## 12. Blocks used

From `core/ui/blocks/`: `section_header` (via `GrofastSectionHeader`),
`section_rail` (Home's category rail), `ecommerce/price_breakdown` (Checkout
and Track Order totals). From `core/ui/molecules/`: `empty_state`,
`error_view`, `icon_info_row`, `radio_group` (picklist
sheets), `skeleton_rows`. From `core/ui/atoms/`: `app_switcher`,
`shimmer_box`, `network_image`, `svg_image`, `page_indicator`,
`concentric_circles`, `button`.

**Deliberately not used:** `blocks/ecommerce/product_card.dart` and
`blocks/ecommerce/category_tile.dart` — the first is badge → title → meta →
price → full-width pill CTA with no corner-button equivalent, the second a
circular image on a disc with the label beneath. Both would need every slot
overridden (see §10).

**Contributed to core:** `AppButton.gradient` (a primary pill painted with a
gradient a `ColorScheme` role can't hold) and `AppBottomSheet.shape` (a sheet
silhouette that isn't a pair of rounded corners), each defaulted to prior
behaviour, plus the matching design-gallery entry.

## 13. Wrapper roster

| Wrapper role | Wraps | This pack's instance |
|---|---|---|
| Full-width primary CTA | `AppButton` | `GrofastPrimaryButton` (50px pill, brand gradient) |
| Destructive / tinted inline pill | `AppButton` | secondary variant with `cs.error` border — the confirm sheet's destructive action. Track Order's Cancel is the **neutral** outline (`cs.outline` border, muted label): the kit keeps the red in the confirm sheet. A secondary/outline button floating over the fade needs an opaque `cs.surface` box behind it — its own fill is transparent |
| Two half-width actions side by side | — (not used by this pack) | the confirm sheet stacks its pair vertically |
| Form text field | `TextField` | `GrofastFormField` (label over a filled 50px input at radius 18) |
| Bounded-picklist trigger field | field-styled box | `GrofastDropdownField` |
| Styled bottom-sheet chrome | `AppBottomSheet` | `showGrofastSheet` (+ `GrofastDomeSheetBorder`) |
| Chrome-free confirmation sheet | `AppBottomSheet` | `showGrofastConfirmSheet` / `GrofastConfirmSheetContent` |
| Terminal confirmation sheet | `AppBottomSheet` | `showGrofastSuccessSheet` / `GrofastSuccessSheetContent` |
| Bounded-picklist selection sheet | `AppRadioGroup` | `GrofastOptionsSheetContent` |
| Back + centered-title header | — | `GrofastHeaderRow` + `GrofastBackButton` (60 × 40 rounded rect) |
| Glass / icon header control | — | `GrofastHeaderAction` (bare glyph + optional dot), `GrofastBagAction` (the bag glyph + live cart dot + push, shared by the three screens that carry it), `GrofastGradientDisc` |
| Single-select option chip | — | `GrofastChip` (28 sheet pill) / `GrofastChip.big` (the list-screen `Button-Text/Big`), laid out by `GrofastChipRow` — every chip row scrolls **horizontally** off the edge, the way the kit crops "Canceled" mid-word; never a `Wrap`. `GrofastBadge.outlined` / `.tinted` for the **static** pills under Product Details' title (rating, category), which are labels rather than controls and take no `onTap` |
| Thumbnail / avatar / info badge | `AppNetworkImage` | `GrofastLineItemRow`'s well, `GrofastOrderStatusPill` |
| Quantity or numeric stepper | — | `GrofastQuantityStepper` (glyphs in `gradientEnd` — the kit inks the keys as controls, not copy) |
| Address card | — | `GrofastAddressTile` (+ `GrofastAddressTileAction` for the page's edit/delete); picked via `showGrofastAddressPicker` |
| Loading skeleton body | `ShimmerBox` | `GrofastProductGridSkeleton` + per-screen `_*SkeletonBody` |
| Screen shell | — | `GrofastScreenBody` + `GrofastBottomFade` (`.overDock` when the fade sits on an opaque band — no inset, gradient runs its whole length) |
| **Domain card** | — | `GrofastProductCard`, `GrofastCategoryTile` / `GrofastCategoryRailTile`, `GrofastPromoCard`, `GrofastLineItemRow` |
| Price | — | `GrofastPrice` |
| Menu / quick tile | — | `GrofastMenuTile` (chevron by default; a `trailing` slot swaps in a real control — Dark Mode's `AppSwitch`), `GrofastQuickTile` |
| Search field + docked square | — | `GrofastSearchField` (button or live-input mode) + `GrofastSquareAction` (the filter square; `active: true` inks the glyph `cs.primary` while a filter is in force) |
| Global nav | — | `GrofastNavBar` |

## 14. State design

| State | Treatment |
|---|---|
| First load | a `*SkeletonBody` mirroring the loaded silhouette inside the same `GrofastScreenBody` — never a spinner |
| Warm revisit (nav tab) | cached data instantly from the shared bloc's `BlocCache`, silent refresh — no re-shimmer |
| Empty | `GrofastEmptyState`: icon + one-line title + one-line subtitle + a gradient next-step action |
| Error | `GrofastErrorView` + retry, with the retry inputs carried on the error state |
| Failed silent refresh | snackbar over the still-visible cached content, never an error view |
| Inline pending | the CTA's own `AppButtonState.loading` |

Every state swaps inside `GrofastSwitcher` (core's `AppSwitcher`), and every
branch renders inside the same shell, so the header, gutters and bottom inset
are paid once regardless of which state is showing.

---

## 15. Content states the kit doesn't draw

A UI8 kit is a catalogue of happy paths: everything is in stock, someone is
signed in, and the basket has a total. These five states have **no frame in
the GROFAST kit** and were each composed from recipes this pack already owned.
They are contracts, not options — a pack missing them fails at checkout, at
review, or both.

### 15.1 Stock and availability

`ProductEntityStockX` answers the questions (`isOutOfStock`, `isLowStock`,
`purchaseLimit`); the pack decides how each reads.

| Surface | GROFAST's treatment |
|---|---|
| Product card, either state | One `_StockTag`, positioned **opposite the heart** at `GrofastDimenConst.productHeartInset` — the corner the kit leaves empty. Sold out reads as a neutral stamp (`cs.onSurface`), running low as a warning (`cs.error`); both are the same tag shape |
| Product card photo | `kSoldOutImageOpacity` while sold out |
| Add control | Disabled while sold out |
| Quantity control | Capped at `purchaseLimit` |
| Cart row | Subtitle replaced by `CartItemAvailabilityX.availabilityLabel` |

The staggered grid makes this worth checking twice: a tag added to the short
first card must not push its fixed height, so measure the tag against the
card's inner budget the way §11's copy-budget rule requires.

### 15.2 Delivery fee

A row in the totals block of `cart_screen.dart` and `checkout_screen.dart`,
and on Track Order. The fee comes from the shared quote — never recomputed per
screen, because the payment intent and the order transaction must agree with
what this line says.

### 15.3 Help & Support

`GrofastScreenBody` + `GrofastMenuTile` — the pack's existing screen shell and
row, no new widget. One row per `SupportChannel` the store publishes, with the
platform fallback underneath when the store publishes nothing.

Two entry points: the Profile row, and a row in the **body** of Track Order
("Need help with this order?") which pre-fills the order id, store, account
and app version into the message.

### 15.4 Reporting a review, blocking its author

`report_review_sheet_content.dart` — the pack's domed sheet with its floating
handle over the shared `ReportReviewForm` mixin and `ReviewReportReason`.
Reached from the overflow control on a review that is **not** the reader's
own; the same sheet also blocks the author, because a reader who has had
enough of someone shouldn't have to find a second control.

Required by App Store Review Guideline 1.2 for any app carrying UGC.

### 15.5 Signed out

`ProfileSignedOut()` renders `GrofastProfileSkeletonBody`. That is safe **only
because the Profile tab is itself gated** — a guest tapping it gets Login
pushed, so the state is transient rather than a shimmer nobody escapes. The
branch must still exist; without it a guest's Profile shimmers forever.

Every write-shaped tap (bag, wishlist, order, profile, review) goes through
`context.requireSignIn()`, which **pushes** Login so backing out returns the
shopper to the exact product they were on. Browsing — home, categories,
product details, search, reading reviews — needs no account and must render
fully without one.
