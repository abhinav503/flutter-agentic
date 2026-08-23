# Style pack spec sheet — TEMPLATE

Copy this file to `docs/ai-rules/style-packs/<pack>.md` and fill every section
when adding a new style pack (procedure: `docs/ai-rules/design.md` §4).

**What this file is for.** A pack is reproducible only if the *invariants* are
written down as values, not inferred from screenshots. Sections §1–§9 are the
**contracts** — short tables an implementer can read once and then generate a
screen that already looks like the pack, before ever seeing a reference image.
§10–§13 are the **compositions** — the pack's signature screen shapes and the
app-level wrapper layer that keeps them from drifting.

Rules for filling it:

- **Every row is a declared value, not a description.** "buttons are rounded" is
  not a spec; `button → 999 (pill)` is.
- **Record cross-mode behaviour explicitly.** For each contract, say what stays
  identical between light and dark. A value that *doesn't* flip is a design
  decision and the single most common thing a duplicate gets wrong.
- **A number that appears in three places is a constant.** If the same value
  shows up on buttons, icon discs, and form fields, it goes in the app's
  `DimenConst` (or the preset) once, and this sheet names that constant.
- **Contracts are values; compositions are prose.** Don't push a number into
  §10 where nobody will find it, and don't write a paragraph into a §1–§9 table.
- Leave a row as `— (not used by this pack)` rather than deleting it; an empty
  slot tells the next reader the axis was considered.

---

## 0. Identity

| Field | Value |
|---|---|
| Preset key (`activeTheme`) | |
| Source | kit / Figma file / original — plus licence note if third-party |
| Categories | ecommerce, health, finance, … |
| Mood | 2–4 adjectives |
| Exemplar app | `apps/…` — the app that proves the pack end-to-end |
| Font family | |
| Preset location | `packages/core/lib/core/theme/app_theme_presets.dart` → `'<pack>'` |
| App constants | `apps/<app>/lib/constants/` — `color_const.dart`, `text_style_const.dart`, `dimen_const.dart` |

**Sourcing note.** Where the values came from, and any place the source lies
(kits routinely ship stale defaults on their "foundation" pages that no real
screen uses). Always sample 1–2 *real screens* before writing a value here.

---

## 1. Colour contract

The full role map lives in the preset — **don't restate hexes in app code**.
This section records the *decisions* the hex list can't express.

**Character.** One paragraph: what primary is used *for* (brand canvas vs.
accent), what carries the surfaces, how dark mode differs in kind (not just in
value) from light.

**Cross-mode invariants** — roles deliberately identical in light and dark:

| Role | Value | Why it doesn't flip |
|---|---|---|
| | | |

**Fixed swatches** — colours pinned to one value in both modes, living in the
app's `color_const.dart` named by ramp stop (never inline hex, never a
`ColorScheme` role):

| Constant | Value | Used by |
|---|---|---|

**Extension roles** (`AppColorsExtension`, set per-preset — read via
`Theme.of(context).extension<AppColorsExtension>()!`, never re-derived from a
`brightness` ternary at the call site):

| Role | Light | Dark | Used by |
|---|---|---|---|
| `dockedHairline` | | | docked bar + bottom nav top border, in-content dividers |
| `sheetHairline` | | | sheet divider + drag handle |
| `tintedPrimaryFill` | | | selected/emphasis pill fill |
| `onSheetMuted` | | | chrome-free sheet subtitle |

**Unused ramp policy.** M3's `ColorScheme` exposes ~4–6 slots per family; a kit
ships 50–950. State which stops the preset promotes and where an in-between
shade goes when a screen needs one (generic semantic → `AppColorsExtension` in
core; pack-specific exact swatch → the app's `color_const.dart`).

---

## 2. Shape contract

| Role | Radius | Source |
|---|---|---|
| Button | | preset `shape.button` |
| Chip | | preset `shape.chip` |
| Card / product image | | preset `shape.card` |
| Input (shared default) | | preset `shape.input` |
| Bottom sheet | | preset `shape.sheet` |
| Sheet-over-header (the content sheet's top corners) | | |
| List thumbnail | | `AppRadius.*` |
| Icon circle / avatar | | full circle |

**Documented deviations** — a role whose spec differs from the shared token on
some screens. Record it here so nobody "fixes" it back:

| Where | Deviates to | Why |
|---|---|---|

---

## 3. Dimension contract

| Constant | Value | Applies to |
|---|---|---|
| `DimenConst.controlHeight` | | every fixed-height interactive control — list them |
| Icon-circle diameter (header glass control) | | |
| Icon-circle diameter (list/menu row) | | |
| Icon glyph size (in a circle) | | |
| Icon glyph size (inline / trailing) | | |
| List thumbnail | | |
| Avatar — header / picker | | |
| Screen gutter | `AppSpacing.lg` | |
| Between sections | `AppSpacing.xl4`+ | |
| Inside a card | `AppSpacing.base` | |
| Minimum touch target | ≥ 44 | |

> One height shared by buttons, icon discs, form fields, and tab bars is the
> single highest-signal number in a pack — it's what makes unrelated controls
> read as one system. Name it once; never re-declare it per widget.

---

## 4. Type contract

| Field | Value |
|---|---|
| Family | |
| Letter-spacing | |
| Weights in use | (and which are *banned* — e.g. no light weights) |
| Scale source | the kit's token groups, e.g. Display 2xl…xs + Text xl…xs |

`core`'s 13-role M3 scale (`AppTheme._textTheme`) is shared by every preset —
**never edit it for one pack**. Extend the app's `text_style_const.dart` on
demand instead: one `copyWith`-based static per token+weight an actual screen
uses, named after the source token (`textLgBold`, `textSmRegular`), based off
the nearest M3 role so family and default colour still come from the theme.
Blocks that need it take an optional style-override param (`titleStyle`,
`labelStyle`) — core stays generic, the app supplies the metrics.

| Token | M3 role it wraps | Used for |
|---|---|---|

---

## 5. Iconography contract

The most-repeated visual in an app, and the one most often left unspecified.

| Field | Value |
|---|---|
| Style | line / filled / duotone |
| Stroke width | e.g. 1.5 — thin strokes and thick strokes are different design languages; mixing them is instantly visible |
| Corner/terminal | round / square caps |
| Source | kit SVGs in `assets/icons/`, rendered via `AppSvgImage.asset` with `color` passed in |
| Material fallback | when a kit SVG doesn't exist yet — and which widget takes `asset` *or* `icon`, never both |
| Colour policy | which icons take a theme role vs. a fixed swatch that stays put across modes |
| Sizes | see §3 |

---

## 6. Surface & contrast ladder

Which background each class of widget sits on, from back to front. This is what
makes a screen read as layered instead of flat, and it's pure token selection —
no new colours.

| Layer | Token | Carries |
|---|---|---|
| Brand canvas | `cs.primary` | |
| Content sheet | `cs.surface` | |
| Raised neutral (icon circles, tiles) | `cs.surfaceContainerLow` | |
| Tinted info (badges, steppers) | `cs.primaryContainer` / `tintedPrimaryFill` | |
| Hairline | `AppColorsExtension.dockedHairline` | |
| Glass | blurred tint of the surface behind it | |

**One divider colour per app**, computed once and reused for every hairline
(docked bar, bottom nav, in-content `Divider`). A screen with its own one-off
shade is a smell.

---

## 7. Motion contract

Durations are a system, not per-widget guesses. Declare the tiers; every
animation in the app picks one.

| Tier | Duration | Curve | Used for |
|---|---|---|---|
| Micro (state flip) | | | button/chip/checkbox/switch press + selection |
| Component | | | nav pill, page indicator, segmented-tab slide |
| Content swap | | | `AnimatedSwitcher` between loading / loaded / error |
| Route | | | page transitions |
| Shared element | | | `Hero` flights |
| Ambient / looping | | | shimmer, pulsing dots, mount-in celebrations |

Rules: motion is subtle — no bounces; two things that read as one transition
share one duration (e.g. a fading control and the bar it sits in); a mount-in
animation must not relayout (scale/fade, not size).

---

## 8. Screen skeleton

The layout **every** screen in this pack starts from — the reason its screens
feel like one app. Describe it as a stack, then list the deviations.

```
<paste the pack's canonical page structure>
```

| Region | Widget | Notes |
|---|---|---|
| Chrome | | `AppBar` or a pack header treatment? |
| Scroll behaviour | | does the header pin, collapse, or scroll away? |
| Body | | |
| Persistent action | | docked bar or inline? |
| Global nav | | |

**Screens that deviate** and why (auth, splash, onboarding usually do).

---

## 9. Overlay policy

One decision, applied app-wide: which overlay type carries which job. Mixing
sheets and dialogs for the same class of interaction is a top-level smell.

| Interaction | Overlay | Entry point |
|---|---|---|
| Bounded picklist (sort, status, city) | | |
| Confirm / destructive | | |
| Terminal confirmation (nothing to cancel) | | |
| Contextual action list | | |
| Transient feedback | snackbar | `showSnackBar` from `BaseScreenState` |

State explicitly whether `AppDialog` / `showDialog` / `PopupMenuButton` /
`AppDropdownMenu` are used **at all** in this pack.

---

## 10. Signature compositions

The look, in order of importance. One bullet per composition: what it is, the
rules that make it right, and the block/preset that renders it. This is the
section a reader skims to answer "what does a screen in this pack look like?"

---

## 11. Recipes

Non-obvious multi-step techniques this pack depends on (shared-element
flights, custom scroll coordination, platform quirks), each with a reference
implementation path. Only add one when getting it wrong degrades silently.

---

## 12. Blocks used

Which of `core/ui/blocks/` this pack composes from (index: `design.md` §2), and
any block it contributed. A pack in the same category reuses the category
subfolder unchanged; a new category gets a new sibling subfolder.

---

## 13. Wrapper roster

The app-level `lib/widgets/` layer: thin presets that bake this pack's fixed
override recipe into one place. **Fill every role** — they recur in any app
regardless of vertical; only the domain card is category-specific. When a
role's spec needs an override the core widget doesn't expose, add the param to
the core widget (defaulting to prior behaviour) **before** wrapping — never
fork the atom, never hand-repeat params at call sites. Extract the preset on
the **second** screen that repeats a styled composition, not the third.

| Wrapper role | Wraps | This pack's instance |
|---|---|---|
| Full-width primary CTA (docked-bar confirm) | `AppButton` | |
| Destructive / tinted inline pill | `AppButton` | |
| Two half-width actions side by side | two buttons | |
| Form text field | `AppTextField` | |
| Bounded-picklist trigger field | field-styled box | |
| Styled bottom-sheet chrome | `AppBottomSheet` | |
| Chrome-free confirmation sheet | `showModalBottomSheet` | |
| Bounded-picklist selection sheet | sheet body | |
| Back + centered-title / page-title header | core `HeroHeader` | |
| Glass / icon header control | `AppIconButton` | |
| Single-select option chip | `AppChip` | |
| Thumbnail / avatar / info badge | `AppNetworkImage` / `AppBadge` | |
| Quantity or numeric stepper | `QuantityStepper` | |
| Loading skeleton body | `ShimmerBox` + a grid/rail | |
| **Domain card** (category-specific) | a `blocks/<category>/` block | |

---

## 14. State design

| State | Treatment |
|---|---|
| First load | skeleton mirroring the loaded silhouette — never a spinner |
| Warm revisit (nav tab) | cached data instantly, silent refresh — no re-shimmer |
| Empty | `EmptyState`: icon + one-line title + one-line subtitle + next-step action |
| Error | `ErrorView` + retry, with the retry inputs carried on the error state |
| Inline pending | `LoadingDots` |

---

## 15. Content states the kit doesn't draw

> A UI kit is a catalogue of happy paths: everything is in stock, someone is
> signed in, and the basket has a total. **None of the states below will have
> a frame in your kit.** Compose each from the recipes this pack already owns
> — never skip one. Two of them are store-policy failures rather than gaps.
> Delete this blockquote once the section is filled.

### 15.1 Stock and availability

`ProductEntityStockX` (`isOutOfStock`, `isLowStock`, `purchaseLimit`) answers
the questions; the pack decides how each reads.

| Surface | This pack's treatment |
|---|---|
| Product card, sold out | *(mark + photo at `kSoldOutImageOpacity`; add control disabled)* |
| Product card, low stock | *("Only N left", `cs.error`)* |
| Quantity control | Capped at `purchaseLimit` |
| Cart row | Subtitle replaced by `CartItemAvailabilityX.availabilityLabel` |

### 15.2 Delivery fee

*(Which line, in which totals panel. Must appear in **all three** places a
total does: cart, checkout, track order — the fee is computed server-side in
one file so the payment intent and the order transaction can't disagree, and a
panel that omits it shows a total the shopper is not charged.)*

### 15.3 Help & Support

*(Which screen shell + row widget. One row per `SupportChannel` the store
publishes, platform fallback underneath. Two entry points: the Profile row and
a row in the body of Track Order.)*

### 15.4 Reporting a review, blocking its author

*(The pack's sheet chrome over `ReportReviewForm` + `ReviewReportReason`,
reached from the overflow control on someone else's review. One sheet does
both. Required by App Store Review Guideline 1.2 for any app carrying UGC.)*

### 15.5 Signed out

*(How `ProfileSignedOut()` renders, and the signed-out form of any header that
greets the shopper by name. The branch must exist or a guest's Profile
shimmers forever.)*

Every write-shaped tap (bag, wishlist, order, profile, review) goes through
`context.requireSignIn()`, which **pushes** Login so backing out returns the
shopper to where they were. Browsing needs no account and must render fully
without one.
