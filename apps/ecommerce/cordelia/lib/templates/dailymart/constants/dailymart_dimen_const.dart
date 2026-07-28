/// The DailyMart pack's fixed sizes (spec sheet §3). `controlHeight` is the
/// one to reach for; the other two are the pack's only declared exceptions,
/// so a fourth height sharing their value is drift, not a decision.
abstract final class DailyMartDimenConst {
  /// Back discs, sheet-close discs, the Filter sheet's select fields, and
  /// the Search screens' search bar.
  static const double controlHeight = 48;

  /// Home's header row only — avatar, bell disc and search bar share this
  /// taller size so the row reads as one band.
  static const double headerControlHeight = 52;

  /// Sheet CTAs (Reset / Apply).
  static const double ctaHeight = 56;

  /// Circular overlays that sit *inside* a product card (favourite heart,
  /// add button) — below the 44px touch floor on purpose: the card itself
  /// is the large target, these are secondary actions on top of it.
  static const double cardActionSize = 28;

  /// The product card's image well.
  static const double productImageHeight = 150;

  /// Everything `DailyMartProductCard` stacks *below* that image well: the
  /// 10px gap, the name + price block beside the add button (45.4), the 4px
  /// gap, the rating row (18.6), and the card's own 8px vertical padding.
  ///
  /// Skeletons size against `productImageHeight + productCardChromeHeight`
  /// rather than guessing, so the grid doesn't reflow when real cards land.
  /// Changing the card's stack below the image means re-deriving this.
  static const double productCardChromeHeight = 86;

  /// Category tile — a rounded photo tile, not a circle.
  static const double categoryTileWidth = 78;
  static const double categoryTileHeight = 92;
  static const double categoryImageHeight = 63;

  /// Promo carousel card. The neighbours peek by design, so this is a
  /// fraction of the viewport rather than a hard width — 286/375 in the kit.
  static const double promoViewportFraction = 0.79;
  static const double promoCardHeight = 156;
}
