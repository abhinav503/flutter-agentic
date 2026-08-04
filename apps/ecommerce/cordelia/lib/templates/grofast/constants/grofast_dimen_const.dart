import 'dart:math' as math;

import 'package:core/core/theme/app_spacing.dart';
import 'package:flutter/widgets.dart';

/// The GROFAST pack's fixed sizes (spec sheet §3), measured off the kit's
/// 375-wide frames. [controlHeight] is the one to reach for; every other
/// value here is a declared exception, so a new height that happens to match
/// one of them is drift, not a decision.
abstract final class GrofastDimenConst {
  /// Search bars, the scan button, every wide CTA, form fields.
  static const double controlHeight = 50;

  /// The kit's screen gutter — wider than most packs, and the main reason its
  /// screens feel unhurried. Applies to every screen's content, including the
  /// grids (a 375-wide frame leaves 315 for content).
  static const double screenGutter = 30;

  /// The back control is a wide rounded rectangle, not a disc — the pack's
  /// one deviation from the usual circular back button.
  static const double backButtonWidth = 60;
  static const double backButtonHeight = 40;

  /// Home's header band: avatar, the location pill, the bell.
  static const double headerControlHeight = 40;

  /// The trailing icon disc inside a header row (bell, bag) and the sheet's
  /// close control.
  static const double headerIconSize = 25;

  /// The kit's **second** corner radius, for the surfaces that hold an image
  /// rather than a whole card: a category tile's tinted well and a cart /
  /// checkout / order line-item row. Everything card-sized — product card,
  /// promo banner, menu tile, promo-code row — stays on the theme's
  /// `cardRadius` (28), which is where a radius should come from; this is the
  /// declared exception, not a second default.
  static const double tileRadius = 23;

  // ---------------------------------------------------------------- product

  /// The product card's two heights. The grid is staggered by giving the
  /// *first* card the short height and every other card the tall one, which
  /// offsets the right column by exactly their difference for the rest of the
  /// scroll — see `GrofastProductGrid`.
  static const double productCardHeight = 245;
  static const double productCardShortHeight = 215;

  /// Everything the card stacks below its image well: the 8px gap, the name
  /// (16), the 8px gap, and the price row (22) with the card's own bottom
  /// padding. The image well is `cardHeight - productCardChromeHeight`, so a
  /// short card's well shrinks and its chrome stays put.
  static const double productCardChromeHeight = 71;

  /// Breathing room around the photo inside the image well.
  ///
  /// The kit's well is edge-to-edge and needs no padding, because its artwork
  /// is a cut-out on transparency that carries ~20 of margin in the file
  /// itself. A store uploads a rectangular photograph, which `contain` then
  /// runs to the card's own edges — so the margin the kit bakes into its
  /// assets is added here instead, at the same measured value.
  static const double productImageInset = 20;

  /// The card's corner add-to-bag button, welded into the bottom-right: it
  /// shares the card's 28 radius on that corner and rounds its top-left by
  /// [productAddButtonNotchRadius].
  static const double productAddButtonWidth = 53;
  static const double productAddButtonHeight = 41;
  static const double productAddButtonNotchRadius = 15;

  /// The favourite heart floating on a card's top-right — a white disc with a
  /// tinted inner disc. Below the 44px touch floor on purpose: the card is
  /// the large target, the heart is a secondary action on top of it.
  static const double productHeartSize = 25;
  static const double productHeartInset = 17;

  /// The saved heart's outer ring. Measured off the kit rather than chosen:
  /// its ring lays down ~15% of the ink a solid hairline would, which is why
  /// it reads as a halo. At full strength it becomes a second outline and the
  /// control starts competing with the price.
  static const double favouriteRingOpacity = 0.15;

  /// Gaps between grid cells. Horizontal and vertical differ by a pixel in
  /// the kit; both are kept because the grid's stagger makes the vertical one
  /// visible against the offset column.
  static const double gridColumnGap = 17;
  static const double gridRowGap = 18;

  // --------------------------------------------------------------- category

  /// Home's category rail entry — a tinted square with the label beneath.
  static const double categoryRailTileSize = 70;
  static const double categoryRailEntryHeight = 89;

  /// The All Categories grid cell is a square; the grid derives its side from
  /// the viewport, so only the aspect ratio is fixed here.
  static const double categoryGridAspectRatio = 1;

  /// Artwork inside a category tile, as a fraction of the tile — the kit sets
  /// its emoji at 45pt in a 149 tile and 32pt in a 70 one, i.e. the same ~30%.
  static const double categoryArtworkFraction = 0.42;

  // ------------------------------------------------------------------ promo

  /// Home's promo carousel. Neighbours peek by design, so the card width is a
  /// fraction of the screen rather than a hard number — 291/375 in the kit,
  /// with an 18 gap to the next card.
  static const double promoCardWidthFraction = 0.776;
  static const double promoCardGap = 18;
  static const double promoCardHeight = 150;

  /// The carousel's `PageController.viewportFraction`.
  ///
  /// Derived, not a constant, and this is the whole reason the first card
  /// used to sit inset well past the gutter: a page is `card + gap`, but it
  /// is measured against a viewport already narrowed by the leading
  /// [screenGutter] — one absolute inset among proportional widths, so the
  /// ratio moves with the screen. Clamped because a narrow web window can
  /// make the page wider than the viewport, which `PageController` asserts
  /// on.
  static double promoPageFraction(double screenWidth) =>
      ((screenWidth * promoCardWidthFraction + promoCardGap) /
              (screenWidth - screenGutter))
          .clamp(0.1, 1);

  /// The banner splits into a copy column and an artwork column. Flex weights
  /// rather than widths, so the split holds at every card width the carousel
  /// hands out.
  static const int promoCopyFlex = 43;
  static const int promoImageFlex = 57;

  // -------------------------------------------------------------------- nav

  /// The bottom bar, the dome that rises out of it, and the raised disc that
  /// sits in the dome. The dome is a circle centred **on** the bar's top edge
  /// — the bar's white *bulges up* around the active tab, it is not a hole
  /// cut through it — and the disc is concentric with it, so the 9px
  /// difference in radius reads as a white ring around the disc.
  static const double navBarHeight = 90;
  static const double navBumpDiameter = 82;
  static const double navDiscSize = 64;
  static const double navGlyphSize = 25;

  /// The dome's shoulders, measured off the kit's own vector. The bar's flat
  /// top edge starts lifting [navBumpShoulderSpan] out from the dome's centre
  /// and meets the circle at [navBumpTangentDegrees] off its peak; the curve
  /// between the two is tangent to both, which is what stops the shoulder
  /// reading as a cusp. A plain rectangle-∪-circle leaves two corners there.
  static const double navBumpShoulderSpan = 60.5;
  static const double navBumpTangentDegrees = 59;

  /// Width of the box the active tab's label is centred in. The label is the
  /// one nav element whose width is its own, so it needs a slot to centre in
  /// rather than an alignment (only ever one is on screen, so a slot wider
  /// than the gap between tabs is harmless).
  static const double navLabelSlotWidth = 120;

  /// Distance from the bar's top edge to an inactive glyph's top, and to the
  /// active tab's label.
  static const double navGlyphTop = 24;
  static const double navLabelTop = 41;

  /// Symmetric inset from each screen edge to the outermost tab's centre; the
  /// remaining slots divide what's left evenly.
  static const double navSlotEdgeInset = 65;

  // ------------------------------------------------------------------ sheet

  /// The pack's signature: a sheet's top edge is an upward arc, not a pair of
  /// rounded corners. [sheetDomeRise] is how far the centre climbs above the
  /// edges (measured 22.4 on a 375-wide frame; the arc scales with width).
  static const double sheetDomeRise = 22;

  /// The drag handle floats on the scrim *above* the dome, rather than inside
  /// the sheet — so it is white, not a hairline colour.
  static const double sheetHandleWidth = 74;
  static const double sheetHandleHeight = 4;
  static const double sheetHandleGap = 16;

  /// From the dome's peak to the sheet's first line of content. Larger than a
  /// normal sheet's padding because the arc eats the corners.
  static const double sheetContentTop = 46;

  // ------------------------------------------------------------------- rows

  /// The cart / checkout / order line-item row and its photo well.
  static const double lineItemRowHeight = 100;
  static const double lineItemThumbSize = 76;

  /// The promo-code row on Cart and Checkout — taller than a form field
  /// because it carries a button inside itself. Its dashed outline is the
  /// pack's ink at 20% (`#194B3833` in the kit), a swatch no neutral outline
  /// role reproduces here.
  static const double couponRowHeight = 70;
  static const double couponBorderOpacity = 0.2;

  /// The Apply pill's corner. The pack's buttons are pills; this one isn't —
  /// it sits *inside* a rounded row and a full pill would echo the row's own
  /// curve at half the size.
  static const double applyPillRadius = 15;

  /// The `- n +` stepper's buttons, on a cart row and on Product Details.
  /// Rounded squares, not discs — the pack's one square control at this size.
  /// Below the touch floor for the same reason as the card heart.
  static const double stepperButtonSize = 28;
  static const double stepperButtonRadius = 8;

  /// The favourite heart on a Bag row — the same control the product card
  /// floats, at the smaller size the kit's wide card uses.
  static const double lineItemHeartSize = 20;

  /// Filter/status chips (sheet options, order status, notification kinds).
  static const double chipHeight = 28;

  /// The kit's `Button-Text/Big` list chip (the Notification / My Orders
  /// filter row): a **35**-tall pill at [tileRadius] with 22 of side
  /// padding, visibly larger than the sheet's [chipHeight] pills. The height
  /// is pinned rather than derived from vertical padding — the kit's 10 + a
  /// 12px line lands on 35, but Flutter's role line-height would drift it.
  static const double bigChipHeight = 35;
  static const double bigChipHorizontalPad = 22;

  /// The glyph or artwork leading a static `GrofastBadge`.
  static const double badgeLeadingSize = 16;

  /// My Orders' card — the kit's 100-tall notification card at [tileRadius],
  /// whose image well is the square the card's height makes.
  static const double orderCardHeight = 100;

  /// The Bag's "Apply" pill — the pack's one non-gradient button, sized to
  /// sit inside the [couponRowHeight] row rather than to match
  /// [controlHeight].
  static const double applyPillHeight = 40;

  /// Profile's menu rows and its three quick-action tiles.
  static const double menuRowHeight = 60;
  static const double quickTileHeight = 78;

  /// Profile's identity avatar, and Edit Profile's larger hero avatar with
  /// the badge overlapping its bottom-right corner.
  static const double profileAvatarSize = 100;
  static const double editAvatarSize = 120;
  static const double editAvatarBadgeSize = 36;

  /// Product Details' hero well — the tallest surface in the pack, and the
  /// only one whose *bottom* edge is a dome.
  ///
  /// A fraction of the screen, not a fixed height: the kit gives it 465 of an
  /// 812-tall frame, and a hero that owns 57% of a phone can't be pinned to a
  /// number without swallowing a short screen or stranding a tall one.
  static const double detailImageHeightFraction = 465 / 812;

  static double detailImageHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height * detailImageHeightFraction;

  /// The favourite disc on the hero. The kit floats it **inside** the well,
  /// clear of the dome's arc — not straddling the edge — so
  /// [detailFavouriteBottomInset] is measured up from the well's flat bottom.
  static const double detailFavouriteSize = 50;
  static const double detailFavouriteBottomInset = 39;

  /// Product Details' docked row (kit `27:316` + `101:1254`), the pack's one
  /// control that deliberately ignores the device inset: the gradient panel
  /// is welded into the bottom-right corner with a single 28 radius on its
  /// top-left, and only the stepper beside it keeps the safe area.
  static const double detailDockPanelWidthFraction = 196 / 375;
  static const double detailDockPanelRadius = 28;

  /// Product Details prints the price at 28/24 against a card's 18/14 — the
  /// largest the pack ever draws it.
  static const double detailPriceScale = 28 / 18;

  /// A Total row's price (kit `Item/Menu/Total-Title`, 22/18).
  static const double totalPriceScale = 22 / 18;

  /// The stepper on Product Details is the kit's larger "add-medium" pair —
  /// [stepperButtonSize] is the compact one a Bag row carries.
  static const double detailStepperButtonSize = 40;
  static const double detailStepperButtonRadius = 15;

  /// The whole stepper's footprint — two keys either side of the count. Only
  /// the skeleton needs it; the live stepper sizes itself from its children.
  static const double detailStepperWidth =
      detailStepperButtonSize * 2 + AppSpacing.xl6;

  /// Where the stepper's bottom edge lands: on the home indicator's top edge,
  /// as the kit draws it. Falls back to the pack's usual breathing room on a
  /// device that reports no inset, where resting on the frame would read as a
  /// mistake rather than as a deliberate weld.
  static double detailStepperBottomInset(BuildContext context) =>
      math.max(MediaQuery.paddingOf(context).bottom, AppSpacing.lg);

  /// The band hugs its row: the kit's 92 measures a panel that overshoots the
  /// stepper by 18, and that overshoot is dead white space on the stepper's
  /// side of the screen — so the dock is exactly the row plus the inset it
  /// rests on.
  static double detailDockHeight(BuildContext context) =>
      detailStepperBottomInset(context) + detailStepperButtonSize;

  /// Bottom clearance for Product Details' scroll view, whose dock is taller
  /// than the pack's ordinary floating CTA and, unlike it, opaque.
  static double detailScrollInset(BuildContext context) =>
      detailDockHeight(context) + AppSpacing.xl2;

  /// An address card (kit `Item/Location`): a 100-tall tinted card at
  /// [tileRadius] whose map thumbnail is a square inset 6 from the card's
  /// edges (so its side is derived, `height − 2 × inset`), rounded a step
  /// softer than the card exactly as the product image wells are.
  static const double addressTileHeight = 100;
  static const double addressThumbInset = 6;
  static const double addressThumbRadius = 18;

  /// Track Order's Order Detail fields (kit `Track/Status` / `Track/Date`):
  /// two side-by-side 33-tall tinted fields at the pack's one odd radius, 13.
  static const double trackFieldHeight = 33;
  static const double trackFieldRadius = 13;

  /// A form/field label's inset from its field's left edge — the kit starts
  /// "Status" 9 in from the field below it, and every labelled field in the
  /// pack (forms, pickers, the Order Detail pair) shares it.
  static const double fieldLabelInset = 9;

  /// The newest tracking event's tinted card (kit `Track/New`).
  static const double trackEventCardHeight = 70;

  /// Track Order's timeline: the past-event bullet and the connector line.
  static const double timelineDiscSize = 8;
  static const double timelineLineWidth = 1;

  /// How far the past rows indent, chosen so the bullet's centre lands on
  /// the event card's leading glyph centre: the card pads 20 and its glyph
  /// is 20 wide (centre at 30), and the 8-wide bullet needs its left edge 4
  /// short of that.
  static const double timelinePastIndent =
      AppSpacing.xl2 + AppSpacing.xl2 / 2 - timelineDiscSize / 2;

  /// The `surface → transparent` fade under a floating control.
  static const double bottomFadeHeight = 120;

  /// Bottom clearance for any scroll view that floats a control over
  /// [bottomFadeHeight], so the last row clears it.
  ///
  /// Derived, not a constant: the floating CTA sits at
  /// `paddingOf(context).bottom + lg` above the device edge, so a static
  /// clearance runs short by exactly the home-indicator inset on notched
  /// devices.
  static double floatingActionScrollInset(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom +
      AppSpacing.lg +
      controlHeight +
      AppSpacing.xl2;

  /// Bottom clearance for a scroll view inside the shell.
  ///
  /// The shell's `Scaffold` runs `extendBody`, so the body already reaches
  /// under the whole nav widget and `paddingOf(context).bottom` reports its
  /// full height (dome + bar + device inset). Content clears the **bar**, not
  /// the dome: letting the last rows scroll under the raised dome is what
  /// makes the dome read as a shape at all — with nothing behind it, white on
  /// white, there is no silhouette to see.
  static double navScrollInset(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom -
      navBumpDiameter / 2 +
      AppSpacing.lg;
}
