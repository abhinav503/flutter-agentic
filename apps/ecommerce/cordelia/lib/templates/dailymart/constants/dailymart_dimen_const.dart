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

  /// Product Details' single image well — taller than the card's
  /// [productImageHeight] because it is the screen's hero surface.
  static const double detailImageHeight = 226;

  /// The bordered rating pill beside the product name on Product Details,
  /// and the yellow rating pill on a review row — same 32px pill.
  static const double ratingPillHeight = 32;

  /// The cart row's square photo thumbnail.
  static const double cartThumbSize = 90;

  /// The sheet chrome's drag handle (64 × 5 in the kit — wider and thicker
  /// than core's default so it reads on the 24px-radius sheet).
  static const double sheetHandleWidth = 64;
  static const double sheetHandleHeight = 5;

  /// The sheet chrome's pinned header: the handle band (6 + 5 + 6) + the
  /// 48px close-disc row with breathing room, no divider — re-derive if the
  /// disc or handle sizes change.
  static const double sheetHeaderHeight = 84;

  /// The `surface → transparent` fade under a floating control
  /// (`DailyMartBottomFade`); the taller value clears Product Details' two
  /// stacked rows (status pill + action row).
  static const double bottomFadeHeight = 120;
  static const double detailBottomFadeHeight = 160;

  /// Bottom spacer under any scroll view that floats a control over
  /// [bottomFadeHeight] — Home's cart pill, Edit Profile's Save Changes,
  /// Select Address's Add New Address — so the last row clears it.
  static const double floatingActionScrollInset = 100;

  /// The floating Filter pill on Search results — 52px tall at radius 40,
  /// the pack's one recorded off-token radius (spec sheet §2).
  static const double filterPillHeight = 52;
  static const double filterPillRadius = 40;

  /// Profile's bordered menu rows. Shorter than [controlHeight] because a
  /// row is a full-width strip, not a tappable disc — the kit sizes the two
  /// independently.
  static const double menuRowHeight = 52;

  /// Profile's identity avatar, beside the name/email block.
  static const double profileAvatarSize = 64;

  /// Edit Profile's hero avatar and the green pencil badge overlapping its
  /// bottom-right corner.
  static const double editAvatarSize = 140;
  static const double editAvatarBadgeSize = 38;

  /// Edit Profile's form fields — taller than [controlHeight] so a typed
  /// value has the same breathing room as the [ctaHeight] button below them.
  static const double formFieldHeight = 56;

  /// Select Address's per-row radio disc (a filled tick when selected, a
  /// bare ring when not).
  static const double addressCheckSize = 20;

  /// The legal document's right-edge scroll rail — the kit draws the
  /// scrollbar as part of the page rather than as an overlay.
  static const double scrollRailWidth = 4;
}
