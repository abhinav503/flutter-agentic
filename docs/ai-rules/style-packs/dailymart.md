# Style pack — `dailyMart`

Bright grass green on a mint canvas. Cool blue-grey neutrals, white cards
lifted on a hairline shadow, and a pill for almost every control.

Companion docs: `docs/ai-rules/design.md` (pack-agnostic screen rules),
`docs/ai-rules/conventions.md` (code organisation).

---

## 0. Identity

| Field | Value |
|---|---|
| Preset key (`activeTheme`) | `dailyMart` |
| Source | UI8 — *DailyMart · Grocery Shop App UI Kit* (Figma `kSTxkipKGeY8FrqWqibDLH`). Licensed for use in end products; **patterns and proportions are re-authored here, kit assets are not redistributed** |
| Categories | ecommerce, grocery, quick-commerce, retail |
| Mood | fresh, bright, friendly, photo-led |
| Exemplar app | `apps/ecommerce/cordelia` — the `dailymart` storefront template (`feature/storefront/*/presentation/templates/dailymart/`) |
| Font family | Plus Jakarta Sans |
| Preset location | `packages/core/lib/core/theme/app_theme_presets.dart` → `'dailyMart'` |
| App constants | `apps/ecommerce/cordelia/lib/templates/dailymart/constants/` — `dailymart_color_const.dart`, `dailymart_text_style_const.dart`, `dailymart_dimen_const.dart`, `dailymart_value_const.dart`, `dailymart_image_const.dart` |
| Icon assets | `apps/ecommerce/cordelia/assets/icons/templates/dailymart/` (pack-scoped, registered in the app's `pubspec.yaml`) |
| Theme config | `apps/ecommerce/cordelia/assets/theme/templates/dailymart_theme_config.json` (loaded at runtime by `StorefrontPage`, not at boot) |
| Mock data | `apps/ecommerce/cordelia/assets/data/templates/dailymart/` — one folder per template, keyed by `StorefrontTemplate.wireValue`, so each pack's screens demo their own kit's copy. Threaded from the screen as a call param (`GetNotificationsParams.template`), the same way `storeId` is. Also needs its own `pubspec.yaml` line |

**Sourcing note.** Every value below was sampled from the kit's **real
screens** — `16 Home`, `17 Home Scroll`, `19 Search product`, `20 Search
product [result]`, `21 Filter`. The kit's foundation pages lie in two ways,
and both were rejected:

- Its **colour** page (`node 6037-11786`) ships a `Greyscale/*` +
  `System Background/*` ramp (`#0D0D12`, `#666D80`, `#A7AEC1`, …) that **no
  live screen paints**. Screens use a `Gary Modern/*` ramp instead
  (`#0D121C`, `#697586`, `#CDD5DF`). Only `Project Color` `#44BC28` agreed.
- Its **typography** page (`node 2-8755`) ships an **Inter Tight** Display /
  Heading scale. Every screen renders **Plus Jakarta Sans**. Inter Tight is
  not used anywhere in this pack.

The kit has **no dark screens**. The light block of the preset is measured;
the dark block is authored (§1) by inverting the same neutral ramp. Treat
dark values as this pack's decisions, not the kit's.

---

## 1. Colour contract

**Character.** Primary is an *accent*, not a canvas: it paints CTAs, the
active nav tab, "See all" chips, the add button, and the active search
border — never a full-bleed header. What replaces the coloured header of
other packs is `primaryContainer` — the mint `#C6FFB9` wash that Home's
entire page sits on, with **ink text on top of it, not white**. Every other
screen (Search, Search results, and anything behind the Filter sheet) is
plain white. Content separates from the canvas by being a **white card with
a soft shadow**, not by a surface-ladder step.

Dark mode differs in kind, not just value: the mint canvas has no dark
equivalent (a desaturated green wash reads as sickly), so Home's canvas
becomes `surface` and the white cards become `surfaceContainerLow`. The
brand green is the one thing held constant.

**Cross-mode invariants:**

| Role | Value | Why it doesn't flip |
|---|---|---|
| `primary` | `#44BC28` | The kit's only brand hue ("Project Color"); it clears contrast on both white and the dark canvas, so flipping it would only weaken brand recognition |
| `onPrimary` | `#FFFFFF` | Every green surface in the kit carries white text — the pairing is part of the brand, not a contrast calculation |
| Rating star | `DailyMartColorConst.ratingStar` `#F1B826` | A product-photo overlay; amber must stay amber on a photo regardless of app theme |

**Fixed swatches** — pinned to one value in both modes, in
`dailymart_color_const.dart`:

| Constant | Value | Used by |
|---|---|---|
| `ratingStar` | `#F1B826` | The product card's rating star glyph. Matches the fill baked into `star.svg`, so tinting is a no-op — the swatch stays the source of truth for the number beside it |
| `promoScrim` | `#33000000` | The 20 % black wash over a promo card's photo so white copy stays legible on any image |
| `reviewAmber` / `onReviewAmber` | `#FACC15` / `#0D121C` | The Reviews tab's summary stars, star bars, and review-row rating pill (kit `warning/400` + its ink). Pinned because the preset declares no warning role and review amber must stay amber in both modes |

The mint canvas is deliberately **not** a fixed swatch: it's
`cs.primaryContainer` in light and `cs.surface` in dark, so it lives as
`ColorScheme.canvas` (`DailyMartColorSchemeX` in the same file). Read
`Theme.of(context).colorScheme.canvas`; never the raw `#C6FFB9`.

**Collapsed shades.** The kit draws two field borders one ramp stop apart —
`#9AA4B2` (Home's search bar) and `#CDD5DF` (bell disc, Filter fields). Both
resolve to `cs.outline` (`#CDD5DF`) here. A one-stop difference doesn't
survive §6's one-hairline-value rule, and reproducing it would mean a second
border constant nobody could tell apart on device.

**Extension roles** (`AppColorsExtension`, set from the preset):

| Role | Light | Dark | Used by |
|---|---|---|---|
| `dockedHairline` | `#CDD5DF` (Gary Modern/300) | `#4B5565` (Gary Modern/600) | bottom-nav top border, in-content dividers |
| `sheetHairline` | `#DFE1E7` (Greyscale/100) | `#2A3448` | Filter sheet's drag handle + dividers |
| `tintedPrimaryFill` | `#C6FFB9` | `#3344BC28` (primary @ 20 %) | selected chips / emphasis pills. Light reuses the canvas mint — this pack has exactly one primary tint; dark drops to alpha because the mint swatch blows out on a dark surface |
| `onSheetMuted` | `#697586` | `#9AA4B2` | Filter sheet's field labels |

**Unused ramp policy.** The kit's `Gary Modern` ramp runs 300→950; the
preset promotes exactly four stops — 300 → `outline`, 400 → dark
`onSurfaceVariant`, 500 → light `onSurfaceVariant`, 950 → `onSurface`. The
kit's `Action/*` ramp (SystemGreen, SystemBlue) is parked on
`secondary`/`tertiary` **unused**, so a future accent lands on a kit value
instead of a seed-derived tone. An in-between shade a screen needs goes to
`dailymart_color_const.dart` if it's a pack-specific exact swatch, and to
`AppColorsExtension` in core only if it's a generic semantic role.

---

## 2. Shape contract

| Role | Radius | Source |
|---|---|---|
| Button | 999 (pill) | preset `shape.button` |
| Chip | 999 (pill) | preset `shape.chip` |
| Card / product image | 16 | preset `shape.card` |
| Input (shared default) | 999 (pill) | preset `shape.input` |
| Bottom sheet | 24 | preset `shape.sheet` |
| Sheet-over-header | — (not used by this pack — no collapsing-sheet screens) | |
| List thumbnail | `AppRadius.sm` (4) | category tile — and its inner photo, whose kit value of 2 rounds up to the same token rather than adding an off-scale literal |
| Icon circle / avatar | full circle | avatar, bell, back disc, favourite disc, the add button (card + result rows) |
| Stepper square | `AppRadius.sm` (4) | the quantity stepper's − / + discs — drawn in Flutter around the bare kit glyphs, `cs.primary` fill (the kit exported the + round; it's squared to the −'s silhouette so the pair reads as one control) |

**Documented deviations:**

| Where | Deviates to | Why |
|---|---|---|
| Product card's inner image well | 14 | Sits 2 px inside the card's own 16 — a concentric inset, so matching the parent radius would read as a thicker white border on the corners |
| Category tile | 4 | The kit's one non-pill, non-card corner. A small photo tile deliberately reads as a chip of the grid, not a card |
| "See all" section chip | 4 | Matches the category tile, not the pill CTAs — it's a label affordance, not an action button |
| Filter sheet's select fields | 10 | Bordered dropdown triggers, **not** pills. This is the pack's only non-pill input; it's what distinguishes an inert trigger from the live search field |
| Filter FAB | 40 | Effectively a pill at its 52 px height; recorded because it is a literal 40 in the kit, not the 999 token |
| Product Details' hero image well | 12 | The screen's one photo frame (`detailImageHeight` 226) — a step outside the 16 card family on purpose, so the hero doesn't read as an oversized product card |
| Cart-row / add-to-cart-sheet thumbnails | 12 (`AppRadius.lg`) | A 90 px photo at the list-thumbnail 4 reads sharp-cornered inside its 16-radius card; 12 keeps the concentric look. The *result-row* thumbnails on Search stay at 4 — they are list thumbnails, not card insets |
| Edit Profile's form fields (`DailyMartFormField`) | 12 (`AppRadius.lg`) | The pill `shape.input` belongs to the **search** field, the pack's one round input; a stack of pilled form rows reads as a stack of search bars. The kit draws these square-rounded for the same reason |
| Profile's menu rows (`DailyMartMenuTile`) | 12 (`AppRadius.lg`) | Matches the form field it sits a screen away from — the two are one "bordered strip" family, distinct from both the 16 card and the pill CTA |
| Edit Profile's avatar badge | 12 (`AppRadius.lg`) | A rounded **square** against the circular portrait — the contrast is what makes it read as a button rather than part of the photo. (The kit measures 12.7; the token is the nearest value and no one can tell them apart on device) |

---

## 3. Dimension contract

| Constant | Value | Applies to |
|---|---|---|
| `DailyMartDimenConst.controlHeight` | **48** | back disc, Filter-sheet close disc, all three Filter select fields, the Search screens' search bar |
| `DailyMartDimenConst.headerControlHeight` | 52 | Home's header row only — avatar, bell disc, and the search bar share this taller size so the row reads as one band |
| `DailyMartDimenConst.ctaHeight` | 56 | Filter sheet's Reset / Apply pair; every full-width CTA (`DailyMartPrimaryButton` / `DailyMartOutlineButton`) |
| `DailyMartDimenConst.formFieldHeight` | 56 | Edit Profile's form fields — deliberately the CTA height, so a form and its submit button read as one column |
| `DailyMartDimenConst.menuRowHeight` | 52 | Profile's bordered menu rows. Shares `headerControlHeight`'s number but not its meaning: a full-width strip, not a disc |
| Icon-circle diameter (header control) | 52 | bell, avatar |
| Icon-circle diameter (back / sheet close) | 48 | |
| Icon-circle diameter (card overlay) | 28 | favourite heart, add button |
| Icon glyph size (in a circle) | 24 | nav, bell, back, close |
| Icon glyph size (inline / trailing) | 22 (search bar), 20 (recent-search rows), 16 (rating star) | |
| Product-card image well | 150 tall, full card width | |
| Category tile | 78 × 92 (image 70 × 63) | |
| Promo card | 286 wide | horizontal carousel, peeking neighbours |
| Avatar — header | 52 | |
| Avatar — Profile identity row | 64 | |
| Avatar — Edit Profile hero | 140, with a 38 badge overlapping its bottom-right | |
| Address-row selection disc | 20 | filled + white tick when selected, bare `outline` ring when not |
| Legal document's scroll rail | 4 wide, inset one gutter from the right edge | |
| Screen gutter | `AppSpacing.lg` (16) — the kit measures 20 on a 375 frame; 16 is the token nearest it and keeps the pack on the shared scale | |
| Between sections | `AppSpacing.xl4` (24) | |
| Inside a card | `AppSpacing.base` (12) | |
| Minimum touch target | ≥ 44 — the 28 px card discs are exempt only because they sit inside a larger tappable card | |

> `controlHeight` (48) is the number to reach for. 52 and 56 are the two
> declared exceptions above; anything else sharing a height with them is a
> drift, not a decision.

---

## 4. Type contract

| Field | Value |
|---|---|
| Family | Plus Jakarta Sans (**not** the foundation page's Inter Tight — see §0) |
| Letter-spacing | −2 % below 18 px (`−0.32` @16, `−0.28` @14, `−0.24` @12); **0** at 18 px and above. The H5 token is the lone positive (+0.5) |
| Weights in use | 400 Regular, 500 Medium, 600 SemiBold, 700 Bold. No light weights; 700 appears only on promo-card headlines, the "See all" chip, and the shopper's name on Profile |
| Scale source | The kit's `Heading/H5` + `Body/{Large,Medium,Small,XSmall}` × `{Semibold, Medium, Regular}` groups |

`core`'s 13-role M3 scale is shared by every preset — never edited for one
pack. `dailymart_text_style_const.dart` wraps only the tokens a real screen
uses:
**A token sets its weight with `atWeight`, never `copyWith(fontWeight:)`.**
google_fonts binds a style to one font *file* when the family resolves, and
the preset resolves each M3 role at that role's own weight — so copying a
heavier weight onto it keeps the regular file and fake-bolds it, and every
weight above the role's renders identically. `TextStyle.atWeight`
(`core/extensions/text_style_extensions.dart`) re-resolves the real cut.


| Token | M3 role it wraps | Used for |
|---|---|---|
| `headingH5(tt)` | `titleLarge` (20/600, lh 28, ls +0.5) | Filter sheet's centered title |
| `bodyLgSemibold(tt)` | `titleMedium` (18/600, lh 1.55, ls 0) | every section header ("Top Seller🔥", "Shop by category", "Result for …"); Profile's General / Preferences group labels; the legal document's effective-date line |
| `bodyLgBold(tt)` | `titleMedium` (18/700, lh 1.4, ls 0) | the shopper's name on Profile — the pack's third and last use of Bold |
| `bodyMdMedium(tt)` | `titleMedium` (16/500, lh 1.6, ls −0.32) | "See all" link text, "4 founds", every CTA label, the legal document's section headings |
| `bodyMdSemibold(tt)` | `titleMedium` (16/600, lh 1.55, ls −0.32) | user name in the Home header; an address card's tag line |
| `bodyMdRegular(tt)` | `bodyLarge` (16/400, lh 1.6, ls −0.32) | Filter select-field values; form-field values; sheet action-list rows |
| `bodySmSemibold(tt)` | `bodyMedium` (14/600, lh 1.55, ls −0.28) | product name, product price, Filter field labels |
| `bodySmMedium(tt)` | `bodyMedium` (14/500, lh 1.55, ls −0.28) | Profile menu-row labels, form-field labels |
| `bodySmRegular(tt)` | `bodyMedium` (14/400, lh 1.55, ls −0.28) | search placeholder, location line, recent-search terms, address lines, legal body copy |
| `bodyXsMedium(tt)` | `bodySmall` (12/500, lh 1.55, ls −0.24) | category label, rating, nav labels, promo subtitle |
| `bodyXsSemibold(tt)` | `bodySmall` (12/600, lh 1.55, ls −0.24) | discount pill, "Order Now" |
| `promoTitle(tt)` | `headlineSmall` (24/700, lh 1.36) | promo-card headline — the pack's single largest type |

---

## 5. Iconography contract

| Field | Value |
|---|---|
| Style | line (outline), single weight |
| Stroke width | 1.5 |
| Corner/terminal | round caps, round joins |
| Source | Kit SVGs in `assets/icons/templates/dailymart/`, named by [`DailyMartImageConst`], rendered via `AppSvgImage.asset(…, color: …)`. The folder needs its own line in the app's `pubspec.yaml` — a directory asset entry is **not** recursive |
| Material fallback | Only for a glyph the kit hasn't exported yet — see the gap list below. `DailyMartIconDisc` takes `asset` **or** `icon`, never both, so a fallback is always visible at the call site rather than hidden inside a wrapper |
| Colour policy | Every glyph is tinted at the call site: nav takes `cs.primary` active / `cs.onSurfaceVariant` inactive, header discs take `cs.onSurface`. The rating star is the one fixed swatch (`DailyMartColorConst.ratingStar`) |
| Sizes | see §3 |

**Six glyphs behave specially, and all are asset facts, not choices:**

- **`home.svg` is the *active* state only** — a filled green house with a
  white smile cut into it. An `srcIn` tint repaints the smile as well and
  flattens the glyph into a solid block, so it renders **untinted** while its
  tab is selected (its own `#44BC28` already equals `cs.primary`) and tinted
  only when inactive, which is a state the kit never draws. An outline
  `home` export would remove the special case entirely.
- **The favourite heart's filled counterpart is hand-derived, not a kit
  export** — `heart_filled.svg` fills `heart.svg`'s exact path while keeping
  the outline's stroke, so the two states share one silhouette and toggling
  doesn't jump. Favourited renders the filled asset tinted **`cs.primary`**
  (brand green, not the error red); unmarked stays the outline in ink. Same
  pair serves the Wishlist tab at 24 (filled while the tab is selected) and
  the product card / Product Details heart at 16.
- **`plus.svg` / `minus.svg` are *bare glyphs*** — the disc is **not** baked
  into the export; the container is drawn in Flutter so it restyles with the
  theme: `DailyMartQuantityStepper` draws a radius-4 (`AppRadius.sm`) square
  and the add buttons (product card, Search result rows, via
  `DailyMartIconDisc`) draw a circle, all filled `cs.primary` with the glyph
  tinted `cs.onPrimary`. The disabled stepper side dims by opacity. Both
  glyphs ship on the same square 16 canvas (the minus bar centered with
  transparent margins) rendered at 16/24 of the disc — the square canvas is
  load-bearing, since `SvgPicture` stretches a non-square canvas to fill an
  explicit width × height box.
- **`like.svg` is exported but unused, and carries no const.** The kit's
  Reviews frame votes a review up or down (drawing the down arrow as this
  same glyph rotated 180°, having exported no separate one); nothing in this
  backend records a vote on a review, so the counters aren't built and the
  asset sits in the pack folder the way grofast's `scan.svg` does.
- **`logout.svg` is mirrored at the call site** — the export's arrow points
  *into* the door; the kit's own Profile frame flips it horizontally so the
  arrow exits rightwards, which `DailyMartMenuTile.flipIconHorizontally`
  reproduces rather than the asset being re-authored by hand.
- **`check.svg` and `location.svg` ship non-square** (11.3 × 8.4 and
  14 × 20) — same hazard as `star.svg`: give them a square box and let
  `BoxFit.contain` letterbox, never an explicit width × height that
  stretches them. `check.svg` is also a *bare* glyph like `plus`/`minus`:
  the green disc behind the selected address is drawn in Flutter.

**`user-linear.svg` is not `user.svg`.** The kit draws the nav tab's person
with a shoulder arc and the Profile row's with a rounded-rectangle body, so
they are two exports rather than one glyph at two sizes. Reusing either for
the other is a review finding.

**One documented exception to the outline rule** — the Notification screen's
row glyphs are the kit's `Icon / solid / …` family (`discount-solid.svg`,
`profile-solid.svg`). The kit draws them solid there and nowhere else, so the
outline rule still describes every other surface. Of the five
`NotificationKind` values the kit exports only these two; the order and
security kinds take a **filled** `_rounded` Material Symbol so the row set
still reads as one family.

**Still Material Symbols** (`_rounded`/`_outlined` only), pending an export:
the location pin and its chevron in Home's header, the static review row's
person placeholder (Home's avatar falls back to the app-level default
portrait via `CordeliaAvatarImage`, not a glyph), the placeholder tabs'
`EmptyState` glyphs, the sheet chrome's close ×, the cart row's trash, and
the coupon row's discount badge, and three Profile rows the kit's own list
never offers — My Orders (`shopping_bag_outlined`), Dark Mode
(`dark_mode_outlined`) and Terms & Conditions (`article_outlined`).
(The Filter pill needs no Material stand-in — the kit exports its funnel,
shipped as `DailyMartImageConst.filterSolid`; see §10.)
`_rounded`/`_outlined` are the one permitted family because DailyMart's
glyphs are round-capped outlines — a `_sharp` or filled Material icon here
is immediately visible and is a review finding.

---

## 6. Surface & contrast ladder

| Layer | Token | Carries |
|---|---|---|
| Brand canvas | `cs.primaryContainer` (light) / `cs.surface` (dark) | Home's full-bleed page background. **Not `cs.primary`** — this pack has no coloured header |
| Content sheet | `cs.surface` | every non-Home screen's background; the Filter sheet |
| Raised neutral | `cs.surface` + `DailyMartElevation.card` shadow | product cards, category tiles, promo "Order Now" pill. On the mint canvas the card separates by **shadow**, not by a lighter fill — there is no lighter fill than white |
| Recessed neutral | `cs.surfaceContainerLow` (`#F5F8FF`) / `cs.surfaceContainer` (`#EEF2F6`) | active search field; back-button and sheet-close discs |
| Tinted info | `cs.surfaceContainerHighest` (`#EFF4FF`) | the well behind a product photo — a cool tint so produce photography reads warm against it |
| Emphasis | `cs.primary` fill / `tintedPrimaryFill` | "See all" chip, add button, active nav, Apply CTA |
| Hairline | `AppColorsExtension.dockedHairline` | nav top border and every in-content divider — one value, app-wide |
| Glass | — (not used by this pack — the gravia glass language has no DailyMart equivalent) | |

**Card elevation** is a real token here, unlike packs that separate by fill
alone: `0 1 2 rgba(0,0,0,.25)` for cards and tiles, `0 -20 30
rgba(0,0,0,.08)` for the bottom nav's upward lift, `0 12 12
rgba(87,111,133,.24)` for the floating Filter FAB. All three live on
`DailyMartElevation`; a fourth shadow value is drift.

---

## 7. Motion contract

| Tier | Duration | Curve | Used for |
|---|---|---|---|
| Micro (state flip) | 200 ms | `Curves.easeOut` | nav tab colour, favourite heart, chip selection |
| Component | 250 ms | `Curves.easeInOut` | promo-carousel page settle, page-indicator dot |
| Content swap | 300 ms | `Curves.easeInOut` | `DailyMartTopSwitcher` (a preset of core's `AppSwitcher`: eased curve + top-aligned in-flight children) between skeleton / loaded / error |
| Route | 350 ms in, 300 ms out | `Curves.easeInOut` | page transitions (fade — matches cordelia's existing routes) |
| Shared element | 350 ms in, 300 ms out (rides the route fade) | linear `RectTween` | the search bar's `Hero` flight, Home ↔ Search — both ends tag via `DailyMartSearchBar.heroTagFor(storeId)`; the flight mechanics (plain `RectTween`, non-interactive shuttle copy) live once in the app-level `HeroSearchFieldFlight`, shared with gravia |
| Ambient / looping | 1400 ms | linear | `ShimmerBox` sweep (core's own constant) |

No bounces, no overshoot. The nav tab and its label share the 200 ms micro
tier because they read as one flip.

---

## 8. Screen skeleton

```
Scaffold (backgroundColor: DailyMartColorConst.canvas(context))
└── SafeArea
    └── CustomScrollView / SingleChildScrollView   ← the whole page scrolls; nothing pins
        ├── header row      (48–52 controls: back disc | title or search bar | action disc)
        ├── section         (SectionHeader + rail or grid)
        ├── section
        └── …
    ⋯ optional floating control over a bottom fade  (the cart status pill)
BottomNavBar (stacked variant)                    ← shell-owned, not per screen
```

| Region | Widget | Notes |
|---|---|---|
| Chrome | **No `AppBar`, ever** | Every screen builds its own header row as the first item in the scroll view. `BasePageState.buildAppBar` returns `null` for all tabs |
| Scroll behaviour | Back-button headers **pin** above the scroll; back-less headers scroll away | `DailyMartScreenBody` auto-pins when it builds a `title` + `onBack` header (Column: docked header row → `Expanded` scroll view, the pattern Cart/Checkout/Wishlist always hand-rolled); tab roots and custom `headerRow`s keep scrolling. No `CollapsingHeaderSheet` — content clips below the docked row, it doesn't slide under it |
| Body | Sections separated by `AppSpacing.xl4` | |
| Persistent action | Floating controls over a bottom `surface→transparent` fade (`DailyMartBottomFade`) | Search floats the cart status pill (both browse and results modes — the kit's Filter pill was removed from Search, see §10); Product Details floats its cart-disc + Add To Cart row; Edit Profile floats Save Changes, Change Password floats Update Password, Checkout floats Continue to Payment, Track Order floats Cancel Order while the order is coming and Rate Order once it has arrived, Add/Edit Address floats Add Address / Update Address, and Select Address floats Add New Address, all over the same fade with `floatingActionScrollInset(context)` — derived from the device inset, since the CTA sits at `paddingOf.bottom + lg` and a static clearance runs short on notched devices — under the scroll content (all via `DailyMartScreenBody`'s `floatingAction` slot, §13). A full-width *docked bar* is still **not** part of this pack — the Cart screen's checkout CTA (`DailyMartCartCheckoutBar`) is the one docked surface, a slim sheet-cornered region of that screen; the coupon row + totals (`DailyMartCartSummarySection`) scroll with the item cards rather than docking |
| Cart presence outside the shell | `DailyMartCartStatusBar` — the floating-pill signature (primary fill, `floatingAction` shadow) | Screens pushed *outside* the shell (Product Details, Search's browse state) float it while the cart is non-empty; inside the shell the Cart tab itself is the affordance, so the shell never docks it |
| Global nav | `BottomNavBar(variant: stacked)` — Home / Wishlist / Cart / Profile | Four tabs; the cart **is** a tab here (unlike gravia, where it's a docked status bar). Every storefront surface is now ported to this pack — the four tabs plus Checkout, Search, Category Details, Product Details, Edit Profile, Change Password, Select Address, Add/Edit Address, My Orders, Track Order and the legal document. Nothing falls through to a gravia screen, so two packs' visual languages never meet on one nav bar |

**Screens that deviate:** none within the storefront. Cordelia's own
app-level screens (Splash, Onboarding, Login, Discovery) are not part of this
pack — they keep CordeliaApps' brand chrome regardless of which store's
template is open.

---

## 9. Overlay policy

**Bottom sheets carry every decision in this pack. `AppDialog` /
`showDialog` are not used at all.**

| Interaction | Overlay | Entry point |
|---|---|---|
| Bounded picklist (category, sort, price) | bottom sheet | `showDailyMartSheet` → `AppRadioGroup` body |
| Confirm / destructive | bottom sheet, centred title + message over two 56 px pills side by side (outlined Cancel + filled confirm) | `showDailyMartConfirmSheet` — chrome-free: the two buttons *are* the exits, so it carries no handle and no close disc |
| Terminal confirmation | bottom sheet, single full-width pill | `showDailyMartSheet` |
| Contextual action list | bottom sheet | — |
| Transient feedback | snackbar | `showSnackBar` from `BaseScreenState` |

`PopupMenuButton` / `AppDropdownMenu` are **not** used — the Filter screen's
three "dropdowns" are bordered trigger fields that open a sheet, which is
why they are field-shaped (10 px, bordered) rather than menu-shaped.

---

## 10. Signature compositions

- **The mint canvas.** Home is one continuous `#C6FFB9` page — header,
  sections, and the gaps between them all sit on it. There is no header
  block, no coloured band, no sheet. This single decision is what makes the
  pack recognisable at a glance; a DailyMart screen with a white Home
  background is wrong.
- **The product card.** White, radius 16, `0 1 2` shadow, 2 px inner
  padding. A 150 px image well (radius 14, on the cool `#EFF4FF` tint)
  carries a red discount pill top-left and a white 28 px favourite disc
  top-right. Below: name and price stacked at 14/600 on the left, a green
  28 px circular **+** on the right, then a rating row (14 px amber
  `star.svg` + `4.9 (345)` at 12/500). **The rating row always renders**,
  unrated products included — the kit's card is laid out around it, and
  hiding it on some cards would ripple a height change through the grid; an
  unrated product greys the star and reads `ValueConst.unratedLabel` rather
  than printing `0.0`, which would say *badly reviewed* instead of
  *unreviewed*. The numbers come off `ProductEntity.ratingAverage` /
  `reviewCount`. Its height is part of
  `DailyMartDimenConst.productCardChromeHeight`, which skeletons size against. It appears in a 2-column grid on Home and Search
  results, and in a rail on Search's "Recently viewed".
- **The promo carousel.** 286 px cards, radius 16, peeking neighbours, a
  photo under a 20 % black scrim, headline at 24/700, two-line subtitle at
  12/500, and a small white "Order Now" pill — all white-on-photo. A dot
  `PageIndicator` sits centred beneath.
- **The "See all" chip.** Sections end their header row with a *filled green
  chip* at radius 4, not a text link. (Home's first screen state shows a
  plain green text link on the category row; `17 Home Scroll` shows the chip
  on every row. The chip is the pack's rule — the text link is the outlier
  and is not reproduced.)
- **The category tile.** A 78 × 92 white tile at radius 4: a 70 × 63 photo
  at radius 2 on top, a 12/500 centred label beneath. Rails horizontally.
- **The search bar, in three states.** Idle on Home — white fill, 1 px
  `#9AA4B2` border, 52 tall. Idle on Search — no border, `#EEF2F6` @ 70 %
  fill, 48 tall. Active with a query — `#F5F8FF` fill with a **1 px primary
  border**. That green border is the only place a form control turns brand
  green.
- **The bordered strip.** Profile's menu rows and Edit Profile's form
  fields are the same silhouette at two heights — a `cs.outline` hairline at
  radius 12 on the plain surface, with no fill and no shadow. It is the
  pack's third container family after the shadowed white card and the pill,
  and it exists to mark *inert* surfaces: a strip is something you fill in
  or step through, never something you tap for an action (that's a pill) and
  never a piece of content (that's a card).
- **The selectable address card.** A radius-16 `surfaceContainer` block —
  pin, tag, address lines, trailing 20 px disc. Selected lifts to
  `surfaceContainerLow` behind a 1 px **primary** border and the disc fills
  green with a white tick; unselected keeps a bare `outline` ring. That
  green border is the pack's only one outside the active search field, and
  it carries real weight here: the kit gives this screen no confirm button,
  so **selecting is committing** — the tap persists the choice and pops.
  The kit frame draws no edit or delete, so the row carries three actions
  under three affordances: the body selects, a 28 px pencil disc
  (`addressActionSize`, `cs.surface` fill) opens the Add/Edit form, and a
  left swipe reveals the Cart row's `errorContainer` + trash (both rows sit
  on core's `SwipeToDeleteRow`) and gates the
  delete behind `showDailyMartConfirmSheet`. That swipe's `confirmDismiss`
  always returns `false`: the delete is a server round-trip the bloc awaits,
  so the row leaves when the new list lands and survives a failed delete
  (returning `true` would rebuild a `Dismissible` Flutter thinks it already
  dismissed).
- **The order card + status timeline** (frames `35`/`36`). The card is a
  radius-16 `surfaceContainer @ .8` block — 88 px thumbnail, name, size,
  total, and a compact 32 px "Track Order" (radius 8; the kit's 6 rounded to
  the nearest token) filled with `surface` under its primary border. The kit
  leaves that button unfilled, but the card's own `surfaceContainer @ .8`
  sits within a few percent of white over the light canvas, so a transparent
  button all but vanished into it; `surface` is a step off the card's fill
  in both modes (white on light, the near-black canvas on dark), which a
  literal white would not be. The kit draws a *product* in the card (image,
  name, **category**, price); an order is a basket, so it renders its first
  line item's photo and name with the category slot carrying the basket's
  size **and placed date** on one line ("3 items · Mar 09, 2026" — the
  compact `asFilterDate` form, since a second line would push the text block
  past the 88 px thumbnail). A **status pill** (`DailyMartPill`) sits at the
  end of the name line while the chip row is on **All**, and only then —
  under Active / Completed / Cancelled the chip above the list already says
  it, and repeating it per card costs the name its width. Its three fills
  are preset roles, not new colours: `tintedPrimaryFill` for Delivered,
  `errorContainer` for Cancelled, and the kit's reserved blue Action ramp
  (`tertiaryContainer` / `tertiary`) for an order still moving — the first
  screen in this pack to paint that ramp, which the preset holds precisely
  for an accent like this. That stand-in only works where a
  card *is* one row of a list — the kit repeats the card atop Track Order,
  where it hid every line item but the first, so **that screen itemises the
  order instead**: an "Order List" of Checkout's read-only row
  (`DailyMartOrderItemRow`, `× quantity` in the stepper slot), with the
  order's identity and total already covered by the Order Details and
  Payment blocks below it. The timeline is a 24 px checked disc per step
  over a 2 px connector, green as far as the order has got and
  `outlineVariant` after.
- **Frames `35`/`36` deviations**, all for the same reason — no data behind
  them: the timeline shows **three** steps (Placed / On the way / Delivered,
  or Placed / Cancelled), not the kit's six, because `OrderStatus` has no
  Confirmed / Preparing / Shipped / Out-for-delivery; **Expected Delivery**
  is dropped (no order carries an ETA); **Tracking ID** becomes the order id
  plus, while the order is out, the delivery OTP. The frame's "Trending
  product" heading over those rows is kit boilerplate from Home and is
  titled "Order Details" instead, and frame `35`'s bottom nav (with the Cart
  tab lit) isn't reproduced — My Orders is pushed from Profile, since this
  template's shell has no Orders tab. Two *additions* to frame `36`, neither
  in the kit: a **Payment** block (amount paid, payment id, and the refund
  state on a cancelled order — an order screen that can't say where a refund
  got to sends the shopper to support for something the app knows), and a
  **Cancel Order** CTA for pre-dispatch orders, floating over the standard
  `DailyMartBottomFade` rather than docking, since the Cart screen's
  checkout bar remains this pack's only docked surface. Rows carrying an id
  (order, payment) get a tap-to-copy Material glyph before the value — the
  kit exports none.
- **The floating Filter pill** (`DailyMartFilterPill`, kit node `6007:3304`).
  A green pill with the solid funnel glyph + a 16/500 `onPrimary` label,
  52 px at radius 40 under `DailyMartElevation.floatingAction`, shrink-wrapped
  and centred over a `surface → transparent` bottom fade so scrolling content
  dissolves behind it rather than colliding with it. The kit draws it on
  Search; this pack **removed it from there** (Search's floating slot docks
  the cart status pill in both modes) and ships it on **Category Details**,
  where the kit's own gridded frame puts it, and on **My Orders** — the two
  screens with a fixed result set to narrow. One addition to the kit's pill: a small
  `onPrimary` dot after the label while a filter is applied — collapsed, the
  pill is otherwise identical whether or not it's hiding orders, which
  leaves a shopper looking at four of twenty with nothing explaining why.
- **The Wishlist tab.** The kit ships **no** wishlist frame (its sourced
  screens stop at Home, Search, Filter, the cart pair, checkout and the
  order pair), so the tab is composed from recipes the pack already owns
  rather than invented chrome: the tab root's back-less
  `DailyMartHeaderRow` titled from the nav tab itself, `DailyMartProductGrid`
  below it, and the Cart tab's empty-state-with-a-way-out. Every card's
  heart is filled here by definition and tapping it removes the product —
  the grid reads that straight off `FavouritesCubit`, so no `isFavourite`
  override is needed (gravia's screen passes one). Like Cart, it has no bloc
  of its own.
- **Category Details** (kit frames `20`/`21`). The kit draws frame `20` as
  its *Search results* screen — back disc + field, a `Result for "…"` /
  "N founds" row, the 2-column card grid, Filter pill floating over the
  fade. This pack gave Search a different body (a vertical list mixing
  categories and products) and reserved the gridded frame for Category
  Details, which is the screen that actually has a fixed result set to sort.
  Two departures follow from reusing a search frame: the editable field
  becomes the pack's idle tap-to-navigate `DailyMartSearchBar` (typing
  belongs to Search, which this pushes, and it carries **no** hero tag —
  the flight pairs Home's bar with Search's field, and a third claimant
  would make the tag ambiguous), and the `Result for "Fruits"` heading
  becomes the category's own name, since this screen is a category and not a
  query. The count keeps the kit's "N founds". This is also the one screen
  in the pack that floats **two** controls: the Filter pill with the cart
  status pill stacked under it (§8 gives every out-of-shell screen that
  pill), over one fade grown by the extra control's height.
- **The filter sheets** (`DailyMartCategoryFilterSheetContent`,
  `DailyMartOrdersFilterSheetContent`). Both wear kit frame `21`'s chrome —
  centred title over a left close disc, bordered radius-10 select fields,
  the `DailyMartActionPair` Reset / Apply at 56 px — and both commit on
  Reset rather than only clearing the draft, since a Reset that needs a
  second tap on Apply reads as a control that didn't work. Category Details
  offers **Sort by** and **Price** (gravia's two axes, sharing
  `ProductSortOption` / `ProductPriceFilter`); frame `21`'s third field,
  Category, isn't reproduced — this screen is already scoped to the category
  it was pushed with, and changing that is a different fetch, i.e.
  navigation, not a filter over the loaded list. Each field opens its
  picklist as a second sheet over the first (`DailyMartRadioSheetContent`),
  which is why both sheet bodies take the screen's `showDailyMartSheet` as a
  parameter — the extension lives on `BaseScreenState`.
- **My Orders' Filter sheet** (`DailyMartOrdersFilterSheetContent`). The kit
  frame `21` chrome over **dates only**: quick-pick chips (Last week / Last
  month, re-tap to clear), one bordered `DailyMartDropdownField` opening the
  Material range picker, and the `DailyMartActionPair` Reset / Apply. No
  status control, unlike gravia's version — this template puts status on the
  screen as the chip row, and a second status control in the sheet would let
  the two disagree. Reset commits the cleared filter immediately rather than
  only clearing the draft (`OrdersEvent.filterApplied` takes a nullable
  filter for this); Reset that needs a second tap on Apply reads as a
  control that didn't work.
- **Product Details' size row and brand line (kit deviations).** The kit's
  frames `22`/`23` predate both features. The brand renders as a
  bodyXsMedium `onSurfaceVariant` line above the name (only when the
  product has one). Below the price row, a "Select Size" label over a
  horizontal row of `DailyMartFilterChip`s — My Orders' status-chip recipe
  reused as a single-select — carries the sizes; the price label
  (`₹X /pack`) follows the selected chip, and Add To Cart carries the
  selection into the cart line, which then shows that pack size and
  per-size price on the Cart's item cards and Checkout's Order List.
- **Order rating.** Track Order's floating slot holds Cancel Order while an
  order is on its way and **Rate Order** once it has been delivered (Edit
  Rating after the first time); a cancelled order gets neither, since there
  is nothing left to stop and no delivery to judge. The sheet is the pack's
  own `write_review_sheet_content` — the *same* body the product reviews
  use, since a rating form is a rating form — over `showDailyMartSheet`.
  The kit draws no rating frame at all; this is a real backend capability
  (`orders/{id}.rating`, gated server-side to the shopper's own delivered
  order), not a kit surface.
- **The Reviews tab is live** (kit frame `23 Review product`). The frame's
  geometry is reproduced verbatim — the bordered summary card with
  `score/5.0` and its five amber stars beside the five `N Star` bar rows,
  then the review rows under a hairline — but every value is the store's:
  the score and count from the product's aggregates, each bar filled to
  that star's *share of all reviews*, and one row per real review. Two
  deviations, both for missing data: the row's thumbs up/down counters are
  gone (nothing votes on a review), and a product with no reviews yet gets
  an `EmptyState`, which the frame has no equivalent for. The tab also gains
  what the kit has no frame for — a `DailyMartOutlineButton` opening the
  pack's write-review sheet (`showDailyMartSheet` over
  `RatingStarsField` + a multi-line `DailyMartFormField`), and a Delete
  action on the shopper's *own* row only; everyone else's is moderated from
  the admin console.

---

## 11. Recipes

- **Peeking carousel.** The promo rail is a `PageView` with
  `viewportFraction ≈ 0.79` (286 / 375), not a `ListView` — a `ListView` gets
  the peek right but loses page snapping and the indicator's page index.
  Drive the `PageIndicator` from the controller's `page`, rounded, so the dot
  settles with the card.
  **The rail takes no screen gutter of its own** and **opens on page 1**
  (`initialPage: 1` whenever there are 2+ banners; a lone banner stays on 0).
  Those two go together: `padEnds` left at its default insets the viewport
  equally on both sides, so the resting card is centred with its neighbours
  peeking symmetrically. Wrapping the rail in the `AppSpacing.lg` gutter, or
  setting `padEnds: false`, knocks that off-centre. Each page's own inset is
  **symmetric** (`AppSpacing.xs2` per edge) for the same reason — a
  right-only inset shifts every card off its slot. Everything else on the
  screen keeps the gutter, including the section header above the rail.
- **Bottom fade over a scroll view.** The Filter FAB's backdrop is a
  `DecoratedBox` with a `LinearGradient` from `cs.surface` (at ~24 % stop)
  to the same colour at zero alpha, `IgnorePointer`-wrapped and stacked over
  the scroll view — not a solid bar. `Colors.transparent` as the end stop
  produces a grey halo on some engines; use `cs.surface.withValues(alpha: 0)`.
- **Ink text on the mint canvas.** `primaryContainer` is a *light* tint, so
  `onPrimaryContainer` is set to the ink `#0D121C`, not white. Any widget
  placed on the canvas must read `cs.onSurface` (or `onPrimaryContainer`),
  never `cs.onPrimary` — that would come out white-on-mint.

---

## 12. Blocks used

From `core/ui/blocks/` — `bottom_nav_bar.dart`, `section_header.dart`,
`section_rail.dart` (Home's category rail), `chunked_grid.dart` (via
`DailyMartProductGrid`), `ecommerce/price_breakdown.dart` (the cart's totals
panel). From `core/ui/molecules/` — `EmptyState`, `ErrorView`, `IconInfoRow`
(notification rows, search result/recent rows), `ShimmerListRow` /
`ShimmerSectionHeader`. From `core/ui/atoms/` — `AppNetworkImage`,
`AppIconButton` (via `DailyMartIconDisc`), `AppIconCircle`, `AppSwitcher`
(via `DailyMartTopSwitcher`), `PageIndicator`, `ShimmerBox`, `AppButton`.

**Contributed back to core by this pack** (each defaulting to the prior
behaviour, so no existing caller changed):

| Component | Added |
|---|---|
| `BottomNavBar` | `variant:` (`pill` \| `stacked`), plus `activeColor` and `shadows` |
| `SectionHeader` | `action:` — an arbitrary widget in place of the text link, for the green chip |
| `AppIconButton` | `backgroundColor` / `foregroundColor` / `borderColor` — a neutral or bordered disc, which none of the three variants could express |
| `PageIndicator` | `activeColor` / `inactiveColor` — the default `surfaceContainerHighest` dot vanishes on a tinted canvas |

**Deliberately not used:** `blocks/ecommerce/product_card.dart`. Core's
`ProductCard` is square-image → badge → title → meta → price → full-width
pill CTA. DailyMart's is fixed-height image with corner overlays → name +
price beside a circular add button → rating row. The orders and the CTA
shape both differ; bending one into the other would need overrides for
every slot. `DailyMartProductCard` composes core **atoms** directly instead
— recorded here so nobody "fixes" it back to the block. Same reasoning for
`blocks/ecommerce/category_tile.dart` (circular; DailyMart's is a rounded
rectangle), `molecules/menu_tile.dart` (`AppMenuTile` is a tinted icon
circle on a bare surface; DailyMart's row is an outlined strip with no
circle — see `DailyMartMenuTile` in §13) and `blocks/header_canvas.dart` /
`collapsing_header_sheet.dart` (this pack has no coloured header — see §8).

---

## 13. Wrapper roster

App-level presets under
`apps/ecommerce/cordelia/lib/templates/dailymart/widgets/`:

| Wrapper role | Wraps | This pack's instance |
|---|---|---|
| Screen shell | `SingleChildScrollView` (+ `Stack` when a CTA floats) | `DailyMartScreenBody` — the one `lg / base / lg` scroll-and-padding recipe every state of a screen swaps through (loading / loaded / error must share it, so a swap never shifts content or drops the bottom inset). Slots: `title`/`onBack`/`trailing` → `DailyMartHeaderRow` (or a `headerRow` override, or headerless for a tab root / body under a pinned header), `gap`, `topPadding`, `floatingAction` (docked over `DailyMartBottomFade` at `paddingOf.bottom + lg`, the scroll content clearing it via `floatingActionScrollInset(context)`), `bottomInset` override for tab roots whose nav bar owns the bottom edge, `fullBleedBody` for Home's peeking carousel. Every dailymart screen renders through it — never a re-typed private `_Page` (seven of those were deleted when it shipped) |
| Full-width primary CTA | `AppButton` | `DailyMartPrimaryButton` — 56 px, pill, `bodyMdMedium` label |
| Destructive / tinted inline pill | `AppButton` | `DailyMartOutlineButton` — 56 px pill, 1 px `cs.primary` border, primary label (the Filter sheet's Reset; the confirmation sheet's Cancel) |
| Two half-width actions side by side | two buttons | `DailyMartActionPair` — outline + filled, `AppSpacing.lg` gap |
| Form text field | `AppTextField` | `DailyMartFormField` — 56 px at **radius 12**, `cs.outline` border, 14/500 ink label (§2 deviations — the pill belongs to the search field alone) |
| Settings / profile row | core atoms (**not** `AppMenuTile` — that molecule's silhouette is a tinted icon *circle* on a bare surface, and this kit draws no circle and an explicit outline instead; every slot would need an override, same §12 reasoning as the product card) | `DailyMartMenuTile` — 52 px bordered strip at radius 12, 20 px glyph, 14/500 label, kit chevron; takes `asset` **or** `icon`, and a `trailing` slot for the Dark Mode switch |
| Bounded-picklist trigger field | field-styled box | `DailyMartDropdownField` — `DailyMartFormField`'s exact chrome (56 px, radius 12, `cs.outline` border, 14/500 label) with the kit's `arrow-right` under a quarter turn, so a form mixing typed and picked values reads as one stack. Built for Add/Edit Address's City/Country, and reused by both filter sheets. The kit's *Filter sheet* draws its own shorter select (48 px, radius **10**); that variant is deliberately **not** built — one field silhouette across the pack beat a second control differing by 8 px and 2 px of radius, so the filter sheets take this one as-is |
| Styled bottom-sheet chrome | `AppBottomSheet` | `showDailyMartSheet` — 24 px top radius, 64 × 5 drag handle, close disc left + centred `headingH5` title |
| Chrome-free confirmation sheet | `AppBottomSheet` (chromeless — `showHeader: false`) | `showDailyMartConfirmSheet` + `DailyMartConfirmSheetContent` — the sheet container and bottom device inset come from core; the content carries its own centred title, and its two CTAs are the only exits |
| Bounded-picklist selection sheet | sheet body | `DailyMartRadioSheetContent` → `AppRadioGroup` |
| Back + centered-title / page-title header | — | `DailyMartHeaderRow` — back disc + flexible middle + optional trailing. This pack has no `HeroHeader`/`HeaderCanvas` usage (§8) |
| Glass / icon header control | `AppIconButton` | `DailyMartIconDisc` (neutral `surfaceContainer` fill) / `.outlined` (transparent + `cs.outline` ring, Home's bell); takes `asset` or `icon`, **no glass** in this pack |
| Single-select option chip | `AppChip` | `DailyMartChip` |
| Selectable filter chip | `AppChip` (its selected state is a *tinted* fill with an ink label, and its radius comes from the theme's chip shape — which this pack pins to a pill; every slot would need an override, same §12 reasoning as the product card) | `DailyMartFilterChip` — 36 px at radius 16, primary fill + `onPrimary` label when selected, plain surface + `cs.outline` hairline when not (My Orders' status row) |
| Typed search field that filters in place | `AppTextField` | `DailyMartSearchInput` — 48 px pill on `surfaceContainer @ .7` (`idleFill`), leading kit glyph. The row recipe lives only here: Search's `DailyMartSearchFieldBar` composes it in `bare` mode inside its own animated has-query container (fill lift + 1 px primary border), so the two can't drift; the taller tap-to-navigate one is `DailyMartSearchBar` |
| Thumbnail / avatar / info badge | `AppNetworkImage` / `AppBadge` | `DailyMartAvatar` (52 circle), `DailyMartPill` (the pack's one static label pill — radius-full fill, `base` side padding, optional leading glyph and fixed-height mode; instances: the card's error-fill discount badge, Search's tinted category badge, the Reviews frame's amber rating pill) |
| Quantity or numeric stepper | core atoms (not `QuantityStepper` — that block draws a bordered tinted pill around the controls, and this kit draws no container at all; overriding the pill away would fight every style slot, same §12 reasoning as the product card) | `DailyMartQuantityStepper` — kit `minus.svg` / count at Heading/H5 / kit `plus.svg`, bare on the surface |
| Loading skeleton body | `ShimmerBox` + a grid/rail | `DailyMartProductGridSkeleton` (the one 2-column grid shimmer — Home, Search and Product Details render it instead of re-inlining `ChunkedGrid` + `ShimmerBox`), `DailyMartCategoryRailSkeleton`, `DailyMartPromoSkeleton` |
| **Domain card** | core atoms (not `blocks/ecommerce/product_card.dart` — see §12) | `DailyMartProductCard` |
| Product grid | `ChunkedGrid` | `DailyMartProductGrid` — the bare 2-column recipe (base/lg spacing, top-aligned, favourites watch baked in); Home/Search's popular grid and Product Details' related grid all render it. Headers and gutters stay with the caller |
| Content-swap transition | `AppSwitcher` | `DailyMartTopSwitcher` — eased curve + top-aligned in-flight children (§7) |
| Section header with chip action | `SectionHeader` | `DailyMartSectionHeader` — bakes the `bodyLgSemibold` title and the green radius-4 "See all" chip |
| Promo banner | — | `DailyMartPromoCard` + `DailyMartPromoCarousel` |
| Category tile | — | `DailyMartCategoryTile` |

**Built today** (the shell + Home + Notifications + Search + Product Details
+ Cart + Profile slice): `DailyMartIconDisc`, `DailyMartSectionHeader`,
`DailyMartHeaderRow`, `DailyMartProductCard`, `DailyMartProductGrid`,
`DailyMartProductGridSkeleton`, `DailyMartPill`, `DailyMartCategoryTile`,
`DailyMartPromoCard`, `DailyMartSearchBar`, `DailyMartPrimaryButton`,
`DailyMartOutlineButton`, `DailyMartActionPair`, `DailyMartMenuTile`,
`DailyMartFormField`, `DailyMartQuantityStepper`, `DailyMartTopSwitcher`,
`showDailyMartSheet` (+ the add-to-cart and order-placed sheets),
`showDailyMartConfirmSheet`, `DailyMartRadioSheetContent`
(the Filter sheet left Search, but Add/Edit Address's City/Country pickers
picked it up), `DailyMartDropdownField`, `DailyMartFilterChip`,
`DailyMartSearchInput`, `DailyMartScreenBody`,
`DailyMartBottomFade`, `DailyMartCartStatusBar`, plus the
`DailyMartElevation` shadow set. **Never re-implement `DailyMartIconDisc`
inline** — three private forks of it (the card's favourite disc, Product
Details' cart disc, the recent-search close button) have already been found
and deleted; size/fill/ring are all parameters. The
sheet chrome rides `AppBottomSheet` through `leading` / `centerTitle` /
`handleSize` / `headerHeight` / `showCloseAction` / `showHeader` params
contributed back to core (each defaulting to the prior behaviour, per §12's
table) —
`showCloseAction: false` because the pack closes through the leading disc,
and a sheet with a trailing X as well reads as two competing exits.

Every other row above is the pack's **declared spec, not a shipped widget** —
the name and the values are fixed here so the screen that first needs one
builds it to this contract instead of inventing a second recipe. Extract on
the second screen that repeats a styled composition, not the third.

---

## 14. State design

| State | Treatment |
|---|---|
| First load | A `*SkeletonBody` mirroring that screen's loaded layout inside the same scroll view and padding — `DailyMartHomeSkeletonBody` (promo block, category rail, 2-column grid), `DailyMartProfileSkeletonBody` (identity row + two groups of 52 px radius-12 rows), `DailyMartAddressSkeletonBody` (three tinted radius-16 cards). Never a spinner, and never a differently-structured body that makes the page jump when data lands |
| Warm revisit (nav tab) | `HomeBloc`'s `BlocCache` seeds `loaded` straight from cache; the refetch runs silently underneath. Switching tabs and back must not re-shimmer |
| Empty | `EmptyState` — icon + one-line title + one-line subtitle + a next-step action |
| Error | `ErrorView` + retry; the retry inputs (`storeId`) ride on the error state |
| Inline pending | `LoadingDots` |
