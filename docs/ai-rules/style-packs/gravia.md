# Style pack: `gravia` (ecommerce)

Filled from `_TEMPLATE.md`. §1–§9 are the **contracts** — read these to
generate a screen that already looks like gravia. §10–§14 are the
**compositions** — the signature screen shapes and the app-level wrapper layer.

Pack-agnostic rules (selection, the shared block catalog, screen design rules)
live in `docs/ai-rules/design.md`.

---

## 0. Identity

| Field | Value |
|---|---|
| Preset key | `gravia` |
| Source | UI8 "Gravia — Grocery Shop App UI Kit" (RL Studio), re-authored as tokens + blocks — patterns, not pixel assets. UI8 licence: use in end products, no redistribution of assets |
| Categories | ecommerce, grocery, retail, marketplace, food delivery |
| Mood | fresh, clean, premium |
| Exemplar app | `apps/ecommerce/gravia` |
| Font family | Plus Jakarta Sans |
| Preset | `packages/core/lib/core/theme/app_theme_presets.dart` → `'gravia'` (full light + dark) |
| App constants | `apps/ecommerce/gravia/lib/constants/` — `color_const.dart`, `text_style_const.dart`, `dimen_const.dart`, `image_const.dart` |

**Sourcing note.** Preset values are the kit's real Figma variables, not
resampled pixels. **Don't trust a kit's abstract "Design System" foundation
page over an actual screen instance** — foundation components carry stale
defaults that real screens override per-instance (this kit's Button foundation
page shows square corners; the Signup CTA is a pill. Its foundation page also
shows a `fullCorner` input default that no real form field uses). Always sample
1–2 real screens before writing a radius or colour into a preset.

---

## 1. Colour contract

**Character.** Deep emerald primary `#027A60` (Primary/500) used as a
**canvas**, not an accent — it paints the whole top region of nearly every
screen. Mint containers (Primary/100) tint badges and steppers. Light mode is
pure-white surfaces with warm near-black text (Dark/500); dark mode is a warm
near-black surface with **cool-grey** elevated circles (the kit's Light ramp) —
so dark mode differs in kind, not just in value: its neutrals shift hue away
from the surface. Teal secondary and indigo tertiary ramps are encoded but
unpainted today (kept so a future accent matches the kit instead of a
seed-derived tone).

**Cross-mode invariants:**

| Role | Value | Why it doesn't flip |
|---|---|---|
| `primary` | `#027A60` | The header canvas is the brand; a lighter dark-mode primary would make the same screen read as two different apps |
| `onPrimary` | `#FFFFFF` | Follows primary — the light-mode pairing already clears contrast on this tone |

**Fixed swatches** (`lib/constants/color_const.dart`, named by ramp stop):

| Constant | Value | Used by |
|---|---|---|
| `gray500` | Gray/500 | bottom-nav inactive icons, form-field labels (identical in both themes, unlike `onSurfaceVariant`) |
| `gray700` | Gray/700 | quantity-stepper +/− glyphs |
| `gray100` | `#EDEDED` | `AppSwitch` off track |
| `success500` | `#22C55E` | `AppSwitch` on track — a distinct green from `primary`, so it's a named raw swatch, not a `ColorScheme` role |
| `light900` | Light/900 | dark-mode sheet hairline |

`ColorScheme.tintedErrorFill` and `inkContrast` (pure black/white flipped per mode — the Address card's kit spec) stay gravia-local
derived getter — single-caller, error-specific, not promoted to core.

**Extension roles** (`AppColorsExtension`, real theme data set per-preset — read
via `Theme.of(context).extension<AppColorsExtension>()!`, **never** re-derive
the brightness ternary at a call site):

| Role | Light | Dark | Used by |
|---|---|---|---|
| `dockedHairline` | `#A1A1A1` Gray/500 | `#FFFFFF` | docked bar + bottom nav top border, in-content dividers |
| `sheetHairline` | `#DFDFDF` Gray/200 | `#3A3B3F` Light/900 | sheet divider + drag handle |
| `tintedPrimaryFill` | `#ECFDF6` Primary/50 | `#33027A60` Primary/500 @20% | selected/emphasis pill fill |
| `onSheetMuted` | `#7B7B7B` Gray/700 | `#FFFFFF` | chrome-free sheet subtitle |

**Unused ramp policy.** The kit exposes a full 50–950 tonal ramp per family
(Primary, Secondary, Tertiary, Dark, Gray, Light) plus absolute Black/White —
confirmed hex-for-hex against the preset. M3's `ColorScheme` has only ~4–6 role
slots per family, so the preset promotes just those stops (base, 100 →
`*Container`, 900/950 → `on*Container`, plus the dark-mode swap); the rest is
intentionally unused until a screen needs an in-between shade. When that
happens — never an inline hex, two homes by scope:

- **Generic role any pack could need** (success/warning-like semantics, one
  light + one dark value) → `AppColorsExtension` in core, ramp position noted.
- **Pack-specific exact swatch** the kit calls out on a screen → the app's
  `color_const.dart` (table above). When the kit's light/dark picks sit
  asymmetrically on the ramp so no single role fits, select per-mode at the
  call site via `Theme.of(context).brightness`.

---

## 2. Shape contract

| Role | Radius | Source |
|---|---|---|
| Button | 999 (pill) | preset `shape.button` — confirmed on the real Signup CTA |
| Chip | 999 (pill) | preset `shape.chip` |
| Card / product image | 20 | preset `shape.card` |
| Input (shared default) | 999 (pill) | preset `shape.input` — `SearchFieldBar`'s glass field |
| Bottom sheet | 28 | preset `shape.sheet` |
| Content sheet over header | large top radius | `CollapsingHeaderSheet` |
| List thumbnail | `AppRadius.lg` (12) | `GraviaListThumbnail` |
| Icon circle / avatar | full circle | |

**Documented deviations** — don't "fix" these back:

| Where | Deviates to | Why |
|---|---|---|
| Form fields (`GraviaFormField`) | 16, not the pill `shape.input` | Confirmed on the Signup form; screen-local override via `AppTextField.borderRadius`, not a preset change. Search and quick-add keep the pill input untouched |

---

## 3. Dimension contract

| Constant | Value | Applies to |
|---|---|---|
| `DimenConst.controlHeight` | **45** | pill buttons, glass icon discs, form fields, segmented tab bars — one shared source, not several independently-named constants that happen to agree |
| Header glass icon disc | 45 (`= controlHeight`) | `GraviaGlassIconButton.containerSize` |
| Icon glyph in a glass disc | 20 | `GraviaGlassIconButton.iconSize` |
| Icon glyph inline / trailing | 18 | menu-tile icon + chevron |
| List thumbnail | passed per site, one radius | cart rows, order line items, search suggestions |
| Avatar | 56 (profile header) / 96 (edit picker) | `GraviaAvatarImage` — one widget, two sizes |
| Screen gutter | `AppSpacing.lg` (16) | |
| Between sections | `AppSpacing.xl4`+ (24+) | |
| Inside a card | `AppSpacing.base` (12) | |
| Recent-search row height | 20 | Search screen |
| Minimum touch target | ≥ 44 | |

> The 45 is the highest-signal number in this pack. A button, a glass back
> disc, a form field, and the Orders segmented bar all being exactly 45 tall is
> what makes unrelated controls read as one system.

---

## 4. Type contract

| Field | Value |
|---|---|
| Family | Plus Jakarta Sans |
| Letter-spacing | **-2%** on every token |
| Weights | Regular / Medium / Bold. Titles and prices **bold**; **no light weights** |

The kit's Design System page defines two token groups, each in Regular/Medium/Bold:

- **Display** — 2xl 72/125%, xl 60/125%, lg 48/126%, md 36/129%, sm 30/120%, xs 24/132%
- **Text** — xl 20/150%, lg 18/155%, md 16/150%, sm 14/140%, xs 12/150%

This doesn't map 1:1 onto core's fixed 13-role M3 scale (`AppTheme._textTheme`,
shared by every preset) — **don't edit that scale for one pack**. Extend
`lib/constants/cordelia_text_style_const.dart` **on demand**: one static method
per token+weight an actual screen uses, named after the Figma token
(`textLgBold`, `textSmRegular`), based off the nearest M3 role so font family
and default colour still come from the theme. Consuming blocks accept an
optional style-override param the way `SectionHeader` does
(`titleStyle`/`actionStyle`; `CategoryTile` follows with `labelStyle`) — core
stays generic, the app supplies the pack-specific metrics.

**A token sets its weight with `atWeight`, never `copyWith(fontWeight:)`.**
google_fonts binds a style to one font *file* when the family resolves, and the
preset resolves each M3 role at that role's own weight — so copying a heavier
weight onto it keeps the regular file and fake-bolds it, and every weight above
the role's renders identically. `TextStyle.atWeight`
(`core/extensions/text_style_extensions.dart`) re-resolves the real cut.

Common tokens in use: `textMdMedium` (menu-tile labels), `textSmMedium` (paired
action buttons — see the `OrderCard` note in §10), `textSmBold` (active
segmented-tab label), `textSmRegular` (recent-search terms, form labels).

---

## 5. Iconography contract

| Field | Value |
|---|---|
| Style | **line / outline** — never filled glyphs (exception: `heart-filled.svg` as the *selected* state of `heart.svg`) |
| Stroke width | **1.5** on kit icons (a few decorative glyphs use 0.8). Thin strokes and Material's heavier filled icons are different design languages — mixing them is instantly visible |
| Source | kit SVGs in `assets/icons/`, rendered via `AppSvgImage.asset` with `color` passed in — the asset ships uncoloured so it takes a theme role |
| Material fallback | only where no kit SVG exists yet. `GraviaGlassIconButton` takes `asset` **or** `icon`, exactly one, never both |
| Colour policy | themed role by default (`cs.onSurface`, `cs.onSurfaceVariant`, `cs.primary`, `cs.error` for destructive). Two exceptions are pinned across modes: bottom-nav inactive icons (`ColorConst.gray500`) and stepper +/− (`gray700`) |
| Sizes | 20 in a glass disc, 18 inline/trailing — see §3 |

---

## 6. Surface & contrast ladder

Back to front. Pure token selection — no new colours.

| Layer | Token | Carries |
|---|---|---|
| Brand canvas | `cs.primary` | header region: title row, search field, filter chips, segmented tabs |
| Content sheet | `cs.surface` | everything below the header, on a large-radius sheet that overlaps the canvas |
| Raised neutral | `cs.surfaceContainerLow` (Gray/50 light / Gray/950 dark) | icon circles (menu rows, bottom-nav inactive tabs), category tiles — barely off the surface, **not** `surfaceContainerHighest` |
| Tinted info | `cs.primaryContainer` / `tintedPrimaryFill` | weight badges, status badges, stepper track, selected pills |
| Hairline | `AppColorsExtension.dockedHairline` | docked bar + bottom nav top border, in-content dividers |
| Glass | blurred tint of the surface behind it | on-canvas controls only — see below |

**Glass is a canvas-only treatment.** Anything sitting *on the primary canvas*
is frosted glass, never a flat translucent fill: header icon discs
(`GraviaGlassIconButton` → `AppGlassSurface`), the header search field
(`SearchFieldBar` → `CommonGlassSurface`), filter chips (`AppGlassChip`), and
the Orders segmented track. All are real `BackdropFilter` blur (sigma 10) with
a 15%-alpha tint of the colour the surface would otherwise be, plus an inset
top glow / bottom shadow rim. Nothing on the white sheet uses glass.

**One divider colour per app.** `dockedHairline` is used for *every* hairline —
docked bar top border, bottom-nav top border, in-content `Divider`, order-card
separator. A screen with its own one-off shade is a smell.

---

## 7. Motion contract

| Tier | Duration | Curve | Used for |
|---|---|---|---|
| Micro (state flip) | 150ms | default | `AppButton`, `AppChip`, `AppCheckbox`, `AppSwitch` press + selection |
| Component | 200–250ms | `easeInOut` | bottom-nav pill (200), page indicator (200), onboarding (220/250), Orders segmented-tab slide (250) |
| Content swap | 300ms | default | `AnimatedSwitcher` between loading / loaded / error on every screen |
| Route | 300ms fade | — | `CustomTransitionPage` + `FadeTransition` app-wide |
| Shared element | 350ms | linear `RectTween` | the search-field `Hero` flight (§11) |
| Ambient / looping | 1200–1600ms | — | `LoadingDots` 1200, `ShimmerBox` 1400, `AppConcentricCircles` mount-in 1500, splash 1600 |

Rules:

- **Two things that read as one transition share one duration.** The Orders
  filter button fades on the segmented bar's `slideDuration`, not its own.
- **Routes fade, they don't slide.** A horizontal push drags both pages and
  destroys any shared-element read; the canvas colour makes the fade invisible
  up top anyway.
- **Mount-in animations don't relayout** — scale/fade from zero, never a size
  animation (see `AppConcentricCircles`' cascading rings).
- No bounces, no gratuitous motion.

---

## 8. Screen skeleton

Every gravia screen starts from the same stack — this is why the app reads as
one product:

```
CollapsingHeaderSheet
├── header:  HeaderCanvas (cs.primary, status-bar inset)
│              └── GraviaHeroHeader          (back + centered title + optional
│                                             trailing glass action)
│                  or GraviaHeroHeader.page  (left-aligned XL title, tab roots)
│                  or a screen-specific header composed onto HeaderCanvas
│                     (Home, Search, Category Details, Profile, Login, Signup)
└── body:    cs.surface sheet, large top radius, overlaps the canvas and
             scrolls up *underneath* the header (header and sheet are not one
             scrolling unit)

+ DockedBar          — when the screen has one persistent primary action
+ BottomNavBar       — the five shell tabs (Home, Categories, Favourite,
                       Orders, Profile); the cart is not a tab
```

| Region | Rule |
|---|---|
| Chrome | **Never a default `AppBar`.** On-header controls are glass circles, never default AppBar icons |
| Header content | Keep `Center`/`Align` out of what you put on `HeaderCanvas` (see its doc) |
| Header widgets | Most screens call `GraviaHeroHeader` / `.page` **inline** — Select Address, Cart, Product Details, Categories, Add/Edit Address all do. A screen gets its own header widget only when it composes real extra content onto the canvas: `HomeHeroHeader` (location + notification + search), `SearchHeroHeader` (back + live search field, no title row), `CategoryDetailsHeroHeader` (hero header + filter chip row), `ProfileHeroHeader` (`.page` + avatar/name/email identity row) |
| Body order | Information priority, top-to-bottom — see `design.md` §3 |
| Persistent action | Docked bar outside the scroll view, never a button at the bottom of scrollable content |

**Deviations:** splash (pure surface, centered wordmark, no canvas — see §10),
onboarding (a permanently-docked sheet, not modal), and the chrome-free
confirmation sheet.

---

## 9. Overlay policy

**Bottom sheets carry every in-app decision. `AppDialog`, `showDialog`,
`PopupMenuButton`, and `AppDropdownMenu` are used nowhere in this app** — a
bounded picklist opens a sheet whether it's triggered by a chip or a form
field, so every selection in the app sits behind one UI.

| Interaction | Overlay | Entry point |
|---|---|---|
| Bounded picklist (sort, price, city, status) | radio-list sheet | `showGraviaSheet` + `RadioOptionsSheetContent<T>` |
| Quick add to cart | product sheet with live stepper | `showGraviaAddToCartSheet` |
| Confirm / destructive | confirm sheet | `showGraviaSheet` + `GraviaConfirmSheetContent` |
| Terminal confirmation (order placed) | chrome-free sheet | `showOrderPlacedSheet` — bypasses `AppBottomSheet` entirely |
| Contextual action list (take photo / gallery) | plain action-row sheet | `showGraviaSheet` |
| Date range | Material `showDateRangePicker` | Orders filter — the one non-sheet overlay, no in-house calendar |
| Transient feedback | snackbar | `showSnackBar` from `BaseScreenState` |

Sheet chrome: `AppBottomSheet` defaults are overridden once in
`showGraviaSheet` (title style, "Cancel" text link instead of the default `X`,
divider + handle colours). Never re-style `showAppBottomSheet` at a call site.

---

## 10. Signature compositions

- **Coloured header canvas + white sheet.** The screen's top region (title row,
  search, filters) sits directly on the primary green; content below lives on a
  surface "sheet" whose large top radius overlaps the header and scrolls up
  underneath it as the sheet is dragged, rather than the header and sheet
  scrolling as one unit. → `CollapsingHeaderSheet` + `HeaderCanvas`; see §8 for
  which header widget a screen gets. `ProfileHeroHeader`'s avatar uses
  `AppNetworkImage`'s `assetPlaceholder` — a bundled default photo shown
  whenever `url` is empty or fails, not just a spinner/broken-image icon — so a
  profile screen ships with a real default look before a user photo exists.
- **Photo-forward product grid.** Two columns; square photos with the card
  radius; **the photo *is* the card** — no border, no elevation box around it.
  Under it: mint quantity badge (`AppBadge` info intent), bold title, muted meta
  row (delivery time, discount — `ProductMetaRow`), bold price + struck
  original, and a full-width small pill CTA. → `ProductCard`. Used both as a
  horizontal rail (Home's Popular Items, Search, Similar Products) and as a full
  listing screen's main content (`CategoryDetailsScreen`, 2-column) — same
  block either way, laid out with `ChunkedGrid`, not `GridView`.
- **Circle category rail/grid.** Product cutout on an elevated circle, label
  below. → `CategoryTile`; gravia tightens `imagePadding` so the PNG fills more
  of the same-size circle and sets the fill to `surfaceContainerLow` rather than
  the themed `surfaceContainerHighest` default. Two instances: Home's single
  horizontal rail (`HomeCategorySection`), and the Categories tab's browse view
  (`CategoryGroupSection`) — grouped under bold section headings, each group a
  4-column `ChunkedGrid`. Both navigate to `CategoryDetailsScreen`.
- **Filter chip row + single-select filter sheet.** A second row on the canvas
  below the title row: horizontally-scrolling liquid-glass pill chips
  (`AppGlassChip`), each opening a bottom-sheet filter. Two list styles by what's
  being chosen: a plain option (Sort, Price) uses `AppRadioDot` — a classic
  outer-ring + inner-dot radio, **not** a checkmark — via
  `RadioOptionsSheetContent<T>`; a count-labelled option (`"Apple (4)"`) uses
  square `AppCheckbox` with its checkmark, single-select enforced by the BLoC
  (only one stays checked) rather than by the widget, which is a plain
  multi-capable checkbox. → `CategoryDetailsHeroHeader` + `RadioOptionsSheetContent`.
- **Section rhythm.** Every content section opens `SectionHeader` (bold title +
  primary "See All").
- **Pill quantity stepper** on cart rows and detail. → `QuantityStepper`; the
  +/− are the kit's own SVGs (`decrementIconBuilder`/`incrementIconBuilder`) in
  fixed Gray/700 (`iconColor`), count in Text/md/bold (`valueTextStyle`).
- **Search takeover.** Home's header search field is a non-editable trigger —
  tapping it opens a dedicated Search screen whose reduced header is a glass
  back button + the same field, now editable; the field visibly glides from
  Home's header into Search's (§11). Below the header, two body modes swap under
  the *persistent* header (swapping the whole sheet would rebuild the field and
  drop keyboard focus). Field empty: "Recent Search" rows exactly 20px tall —
  kit `undo`/`remove` SVGs in `onSurface`, term in Text/sm/regular Gray/700
  light / Gray/100 dark — then the same Popular Items rail as Home; recents are
  tapped catalog items (product *or* category), not raw query strings, so each
  row deep-links to its details page. Typing (debounced 300ms): at most 5
  suggestion rows — `GraviaListThumbnail` + name, price trailing for products, a
  `GraviaTintBadge` "Category" marker for categories.
- **Quick-add bottom sheet.** A product card's quick-add icon opens a sheet with
  product photo/name/weight/price and a live quantity stepper that scales price
  and weight together; Cancel + primary `Add to Cart` pills footer it. The header
  deviates from `AppBottomSheet`'s default: a "Cancel" text link (not the `X`)
  opposite the title. → `AppBottomSheet`'s `titleStyle`/`closeLabel`/
  `closeLabelStyle`/`dividerColor`/`handleColor` overrides + `QuantityStepper`.
- **Chrome-free confirmation sheet.** Cart's "Proceed to Checkout" opens a sheet
  with no title row and no close control at all — just a handle, a
  concentric-circle status icon, headline + subtitle, and a single full-width
  CTA — since there's nothing to cancel back out of once the order is placed.
  `AppBottomSheet`'s header always reserves a fixed-height row (and forces a
  close `X` even with no `closeLabel` — every other caller relies on that), so
  this bypasses it and presents content directly via `showModalBottomSheet`,
  same reasoning as the onboarding sheet. The status icon is two identical
  translucent `primary` circles (10% alpha) stacked concentrically — overlap
  alone makes the inner ring read darker, no third colour needed — plus a solid
  `primary` disc with a check glyph in `onPrimary`, each ring popping in
  outer→inner on mount (cascading scale-from-zero, not a relayout) →
  `AppConcentricCircles` (core atom — any pack's status/celebration graphic
  reuses it). → `showOrderPlacedSheet` / `OrderPlacedSheetContent`. Tapping the
  CTA lands on the Orders tab via `ShellPage.ordersTabIndex` + `initialTab`
  (`context.go(AppRoutes.home, extra: ShellPage.ordersTabIndex)`) — the shell's
  tab is otherwise UI-local `setState`, so this is the one supported way to jump
  to a specific tab from a route pushed outside the shell.
- **Docked bottom CTA.** Checkout-style primary actions dock at the bottom as one
  full-width large pill above the safe area — often paired with a
  `QuantityStepper` beside it (`ProductDetailBottomBar`). → core's `DockedBar`
  wrapping `GraviaPrimaryButton`. A screen with nothing but the button calls both
  inline (Cart, Select Address); `ProductDetailBottomBar` keeps its own widget
  only because it also owns the stepper and the live quantity-scaled price label.
- **Form fields (Add/Edit Address, Edit Profile).** Every gravia form field
  renders `GraviaFormField` (wrapping `AppTextField`) — 16 radius, pinned to
  `controlHeight` (§2 deviation, §3). Labels are Text/sm/regular in the fixed
  `ColorConst.gray500` via `.labelStyle`, with extra label-to-field breathing
  room via `.labelSpacing`. City/Country are bounded picklists, not free text —
  `GraviaDropdownField` opens the same `RadioOptionsSheetContent` sheet as the
  filter chips.
- **Avatar photo picker (Edit Profile).** A large centered avatar circle with a
  small dark translucent camera badge on top (`camera.svg`, white, centered —
  not a corner badge); tapping anywhere opens a two-row action sheet (Take
  Photo / Choose from Gallery, `showGraviaSheet` — a plain action list, not
  `RadioOptionsSheetContent`, since there's no currently-`selected` value) which
  calls `ImagePickerService`, `kIsWeb`-guarded with a "mobile only" snackbar
  exactly like `doc_scanner`'s camera/gallery calls. The picked photo is read
  via `XFile.readAsBytes()` into a `Uint8List` — never `dart:io`'s `File` /
  `Image.file`, which doesn't compile for web — previewed immediately and
  carried in `ProfileEntity.avatarBytes` (session-only; no upload backend, so it
  never round-trips through `ProfileModel`/JSON). → `GraviaAvatarImage` is every
  avatar render site's one composition — `avatarBytes` wins over `avatarUrl`
  when both are set, else the `assetPlaceholder` fallback. Used by
  `ProfileHeroHeader` (56) and the picker (96) — never re-branch per call site.
- **Pill-highlight bottom nav.** Active tab = pill with icon + label on primary;
  inactive tabs = icon-only circles on `surfaceContainerLow`, icons in fixed
  Gray/500 both modes (`inactiveIconColor`). Tabs: **Home, Categories,
  Favourite, Orders (bag), Profile** — the cart is not a nav tab. → `BottomNavBar`.
- **Glass segmented tab bar + order cards (Orders tab).** A real frosted-glass
  pill track (`CommonGlassSurface`) sits on the canvas below the "Orders" title,
  with a single solid `cs.surface` pill that *slides* between the two segments
  (`AnimatedAlign`, 250ms `easeInOut`) rather than each segment crossfading its
  own background. The active label reads `textSmBold`, the inactive `textSmMedium`
  — both animate via `AnimatedDefaultTextStyle` on the same duration as the
  slide. The bar is pinned to `controlHeight` (`OrdersSegmentedTabBar._barHeight`)
  rather than left to intrinsic sizing — the `Stack` the sliding pill needs sizes
  itself from its one non-positioned child (the label `Row`; the pill is
  `Positioned.fill`), and that intrinsic path visibly shrank the bar when the
  slide first landed. Don't revert to intrinsic sizing without re-checking that
  regression. → `OrdersSegmentedTabBar` (feature-local — promote if a second
  segmented control appears). Loading mirrors the silhouette — two
  `OrderCard`-shaped skeletons via `OrdersSkeletonBody` — and only on genuine
  first load (warm-start rule, §14).

  An order is **one delivery of possibly several products**, each with its own
  quantity and line price — never a single product by itself (an earlier version
  modelled "order" as one product row, which silently split two same-timestamp
  products into two orders; don't repeat that shape). Each card: a photo + name +
  "weight × qty" + line-price row per product (`OrderLineItemRow` — `CartItemRow`
  minus the stepper, since a placed order is read-only), a hairline, then a
  full-width date + order-total row (the sum of every line) — with the status
  badge beside the total for a delivered/cancelled order — then a final row that
  depends on status: while in-process, a "Delivery OTP" row (status badge + four
  circular outlined digit boxes, `cs.primary` ring + text; one OTP per *order*)
  followed by Cancel/Track Order; once delivered/cancelled, View Details/Write A
  Review instead. Every button in these paired rows (`GraviaTintedButton` for
  Cancel, raw `AppButton` for the other three) **must share the exact same
  `labelStyle`** (`textSmMedium` / `cs.onPrimary`-or-`cs.primary`) — `AppButton`
  without an explicit override falls back to `tt.labelMedium`, a different
  Material role, which visibly mismatches `GraviaTintedButton` side by side. This
  bit us once; don't drop the override. → `OrderCard`.

  The tab defaults to **Past**, and the filter is Past-only: the header's glass
  filter button (`filter.svg`) fades out on Upcoming (`AnimatedOpacity` +
  `IgnorePointer`, on the segmented bar's `slideDuration` so both read as one
  transition — it stays *laid out*, because a null `trailing` shrinks the title
  row by the disc height and the header visibly jumps), and Upcoming ignores any
  applied filter. The button opens a *composite* filter sheet
  (`OrdersFilterSheetContent`), unlike the single-select chip sheets: quick-period
  radios (inline `RadioOptionRow`s, not a whole `RadioOptionsSheetContent`), a
  Status `GraviaDropdownField` opening a nested picklist (with a null "All"), a
  Date `GraviaDropdownField` (calendar `trailingIcon`) opening
  `showDateRangePicker`, and a full-width Apply. Draft selections are sheet-local
  state; Apply dispatches one `OrdersFilter` into `OrdersBloc`, which stores it on
  `OrdersLoaded`. Quick periods and the default range end at `DateTime.now()`;
  `orders.json`'s dates are kept spread over the ~4 months before the present so
  Last Week/Last Month demo with real results — nudge them forward when stale.
- **Settings/menu list.** A vertical stack of icon-circle + label + chevron rows
  below a coloured header (Profile is the reference). Each row: a fixed circle
  filled with `surfaceContainerLow` holding a themed-colour SVG, then the label
  in Text/md/medium, then a trailing element — by default a `direction-right.svg`
  chevron whenever the row has an `onTap` and no override. Two deviations: an
  interactive row swaps the chevron for a real control (Dark Mode uses
  `AppSwitch`); a destructive row (`danger: true`, e.g. Logout) tints its icon
  circle with `error` at 12% alpha, colours icon + label `error`, and drops the
  chevron entirely. → `ProfileMenuTile`.
- **Plain splash.** Pure surface (white/near-black), only the centered wordmark:
  black type with the middle glyph in primary green. No coloured canvas, no
  tagline.

---

## 11. Recipes

### Hero flight — "the same widget glides between screens"

How the Search takeover's field is actually built; reuse for any shared-element
transition. Reference: `lib/widgets/search_field_bar.dart` + the `/search`
route in `lib/app.dart`.

1. **One shared widget, one shared tag factory.** Both screens render the
   *same* widget class wrapped in `Hero`; the tag comes from one static
   factory on that widget, **scoped per store** —
   `SearchFieldBar.heroTagFor(storeId)` — and is a required parameter. Two
   hand-typed literals drift and silently kill the flight, and an *unscoped*
   constant is worse: two storefronts running this pack in one transition
   (a tab jump between stores) would pair their bars and fly the field out
   of one store's Home into another's. Never render two Heroes with one tag
   in a single route — e.g. an `AnimatedSwitcher` whose branches each build
   the header keeps both mounted mid-crossfade, which is a hard framework
   error; build the header once outside the switcher (see Home).
2. **Trigger mode vs input mode.** The origin's copy is display-only:
   `GestureDetector` (navigates) around `AbsorbPointer` (so the real field never
   grabs focus). The destination's copy is live.
3. **The route must not slide.** Use an in-place fade (`CustomTransitionPage` +
   `FadeTransition`, ~350ms). When both screens share the canvas colour the fade
   is invisible up top, so the Hero's glide is the only perceived motion; the
   default horizontal push drags both pages sideways and destroys the read.
4. **Non-interactive `flightShuttleBuilder`.** Mid-flight the widget rebuilds in
   the navigator's Overlay, so the shuttle needs: a `Material(type:
   transparency)` ancestor (text fields require one); a backdrop matching the
   origin surface (a `ColoredBox` in the canvas colour) if the widget uses a
   `BackdropFilter` — the Overlay has nothing behind it to blur; and **no live
   state** — build it without the `FocusNode`/`autofocus`/callbacks, wrapped in
   `ExcludeFocus` + `AbsorbPointer`. A `FocusNode` attached to two widgets at
   once throws and aborts the flight.
5. **Linear `createRectTween`.** The navigator default (`MaterialRectArcTween`)
   sweeps rect corners along arcs, so when the ends differ diagonally (position
   *and* width) the in-flight rect dips shorter than either end → `RenderFlex`
   overflow stripes on the shuttle. `RectTween` holds height constant and gives
   the straight vertical glide anyway.
6. **Focus after the flight.** Don't `autofocus` the destination; the keyboard
   resizing the screen mid-flight reads as jank. Give it a `FocusNode` and
   `requestFocus()` from a `ModalRoute.of(context).animation` status listener
   once the transition completes. On the way back, `unfocus()` before popping so
   the keyboard's exit runs alongside the return flight.
7. **Pin it with a test** that pumps a mid-flight frame and asserts exactly one
   copy exists (the shuttle), positioned strictly between the endpoints, and
   sweeps the return flight for exceptions — see
   `test/widget/widgets/search_field_bar_hero_test.dart`. A broken flight
   degrades silently into a crossfade otherwise.

---

## 12. Blocks used

From `core/ui/blocks/` (index in `design.md` §2): `header_canvas`,
`hero_header`, `collapsing_header_sheet`, `docked_bar`, `docked_bar_overlap`,
`bottom_nav_bar`, `section_header`, `section_rail` (the header + left-inset
rail every "Popular Items"/"All Categories"/"Similar Products" section now
renders), `quantity_stepper`, `chunked_grid`, and the `ecommerce/` subfolder
(`product_card`, `category_tile`, `product_meta_row`, `price_breakdown` —
the cart's coupon-slot + lines + divider + total panel).

Every one of these was **contributed by gravia** (or extracted once the
second template repeated it) and promoted out of the app once it had no
pack-specific styling left. A future pack in the same category reuses
`ecommerce/` unchanged; a pack in a different category gets its own sibling
subfolder. Also from core since the 2026-07-30 reusability sweep:
`AppSwitcher` (every screen's 300ms skeleton/loaded/error crossfade —
never a raw `AnimatedSwitcher`), `AppIconCircle` (notification rows, the
cart status bar's disc), `IconInfoRow` (search suggestion rows, order line
rows — extended with `trailing`/`onTap` instead of forked), and
`ShimmerCircleTile` (Home's and Categories' circle-tile skeletons).

---

## 13. Wrapper roster (`apps/ecommerce/gravia/lib/widgets/`)

> In `cordelia`'s port of this pack the same roster lives under
> `lib/templates/gravia/widgets/` with the same `Gravia*` names (the four
> that had drifted to app-level `Cordelia*` names — hero header, primary
> button, glass icon button, form field — were moved back and renamed in the
> 2026-07-30 sweep; only the genuinely template-agnostic
> `CordeliaAvatarImage` and `HeroSearchFieldFlight` stay in `lib/widgets/`).
> `GraviaProductGrid` exists in the cordelia port only.

When a gravia screen needs one of these compositions, **render the preset;
never re-style the underlying atom/block inline.**

| Need | Preset |
|---|---|
| Product card (any rail or grid) | `GraviaProductCard` — never raw `ProductCard` |
| Coloured header canvas | core's `HeaderCanvas` directly — structural now, no gravia styling left, so screens import `package:core/core/ui/blocks/header_canvas.dart`. Rich headers (`HomeHeroHeader`, `SearchHeroHeader`, `LoginHeader`, `SignupHeader`) compose onto it; no `Center`/`Align` inside |
| Back + centered-title header (± trailing, ± second row) | `GraviaHeroHeader` — thin preset over core's `HeroHeader`, baking in `GraviaGlassIconButton` as the leading control and the pack's title styles |
| Tab-root page-title header (left XL title, no back) | `GraviaHeroHeader.page` |
| Glass header control (back/search/favourite/bell/filter) | `GraviaGlassIconButton` — never raw glass `AppIconButton`; pass `asset` for a kit SVG or `icon` for a Material fallback, exactly one |
| Docked bottom CTA bar shell | core's `DockedBar` directly — structural now (top hairline + safe area + bar padding), imported without a gravia wrapper |
| Full-width primary CTA (in a docked bar) | `GraviaPrimaryButton` — never a re-typed `AppButton` recipe |
| Tinted-error pill (destructive inline action) | `GraviaTintedButton` — no `AppButton` variant renders a filled error-tinted pill; never fork the atom |
| Two half-width actions side by side | `GraviaActionPair` — bakes in `DimenConst.controlHeight` + `textSmMedium` across both, and renders a `GraviaTintedButton` for a `tintedError` action so a paired row never mixes recipes |
| Quantity stepper | `GraviaQuantityStepper` |
| Mint-on-tinted-primary info badge (weight, tag, in-process status) | `GraviaTintBadge` — `GraviaProductCard`'s badge can't render it directly (it passes params through to `ProductCard`), so use `GraviaTintBadge.labelStyle`/`.backgroundColor` there |
| Styled bottom sheet | `showGraviaSheet` / `showGraviaAddToCartSheet` (extension on `BaseScreenState`, `gravia_sheet.dart`) — never raw `showAppBottomSheet` styling |
| Chrome-free confirmation sheet | `showOrderPlacedSheet` → `OrderPlacedSheetContent` — bypasses `AppBottomSheet`; never force a title/close in just to reuse the atom |
| Bounded-picklist selection sheet | `RadioOptionsSheetContent<T>` — its `RadioOptionRow` is also composable inline for radios among other sheet fields (Orders filter) |
| Bounded-picklist trigger field | `GraviaDropdownField` — `trailingIcon` swaps the chevron (Orders filter's Date uses a calendar glyph) |
| Form text field | `GraviaFormField` |
| Profile avatar (any size) | `GraviaAvatarImage` |
| List thumbnail (cart, order line, search suggestion) | `GraviaListThumbnail` |
| Single-select option chip | `SelectorChip` |
| Product grid (2-column, loaded) | `GraviaProductGrid` — the one `ChunkedGrid` + `GraviaProductCard` recipe (lg spacing, top-aligned, '% OFF' label); favourite affordance via optional `isFavourite`/`onFavouriteToggle` params (Favourites passes always-true, Category Details omits both) |
| Product grid loading skeleton (2-column) | `GraviaProductGridSkeleton` (`padding` param) — never a re-typed `ChunkedGrid`-of-`ShimmerBox` |
| Hairline / tinted-fill / sheet-text colours | `AppColorsExtension.dockedHairline` / `.sheetHairline` / `.tintedPrimaryFill` / `.onSheetMuted` |
| Neutral icon-circle / tile fill | `cs.surfaceContainerLow` directly — no app-local swatch or getter |

**Cautionary tale.** Before `GraviaProductCard` existed, four screens
hand-styled `ProductCard` inline and the copies drifted (Cart's rail shipped
with a lock icon where the glass quick-add belongs). When a new surface repeats
an already-styled block a **second** time, extract the preset then — not after
the third copy.

**When the built-in widget has no override point for the spec at all,** stop
theming and build a dedicated `core` atom. Reference case: Material's `Switch`
grows its thumb radius (8→12) on selection with no public way to pin both
states to one size — `thumbIcon` forces *both* to the larger radius. `AppSwitch`
(`core/ui/atoms/switch.dart`) is a plain custom-painted pill+circle: thumb size
is one constant computed from `height`, never branched on `value`, so both
states match by construction. Gravia's Dark Mode row feeds it the kit's exact
track swatches (`ColorConst.gray100` off, `ColorConst.success500` on).

---

## 14. State design

| State | Treatment |
|---|---|
| First load | a `*SkeletonBody` mirroring the loaded layout's silhouette, **inside the same sheet + header** (`HomeSkeletonBody`, `CategoriesSkeletonBody`, `OrdersSkeletonBody`, `GraviaProductGridSkeleton`) — never a spinner |
| Warm revisit (nav tab) | cached data instantly + silent refresh; the skeleton only ever shows on a genuine cold start — see `docs/how-to/design-tab-flow.md` |
| Empty | `EmptyState` — icon + one-line title + one-line subtitle + next-step action |
| Error | `ErrorView` + retry, with retry inputs carried on the error state |
| Content swap | `AnimatedSwitcher`, 300ms (§7) |
