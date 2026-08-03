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

  /// Home's promo carousel. Neighbours peek by design, so the width is a
  /// fraction of the viewport rather than a hard number — 291/375 in the kit.
  static const double promoViewportFraction = 0.776;
  static const double promoCardHeight = 150;

  // -------------------------------------------------------------------- nav

  /// The bottom bar, its notch, and the raised disc that sits in it. The
  /// notch is a circle centred **on** the bar's top edge, and the disc is
  /// concentric with it — the 9px difference in radius is the white ring
  /// around the disc.
  static const double navBarHeight = 90;
  static const double navNotchDiameter = 82;
  static const double navDiscSize = 64;
  static const double navGlyphSize = 25;

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
  /// because it carries a button inside itself.
  static const double couponRowHeight = 70;

  /// The `- n +` stepper's round buttons, on a cart row and on Product
  /// Details. Below the touch floor for the same reason as the card heart.
  static const double stepperButtonSize = 28;

  /// Filter/status chips (sheet options, order status, notification kinds).
  static const double chipHeight = 28;

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
  static const double detailImageHeight = 380;

  /// The floating favourite disc that overlaps the hero dome's bottom edge.
  static const double detailFavouriteSize = 56;

  /// Track Order's timeline: the step disc and the connector between two.
  static const double timelineDiscSize = 24;
  static const double timelineLineWidth = 2;

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

  /// Bottom clearance for a scroll view inside the shell, so the last row
  /// clears the nav bar and the raised disc that rises out of it.
  static double navScrollInset(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom + navBarHeight + AppSpacing.lg;
}
