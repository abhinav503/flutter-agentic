/// Icon assets the `dailymart` template's storefront screens use.
///
/// Pack-scoped under `assets/icons/templates/dailymart/`, not the app-wide
/// `assets/icons/` — the same way `assets/theme/templates/` scopes each
/// template's theme config, so this pack and `gravia` can ship different
/// `search.svg`s without colliding. Genuinely app-level artwork (Cordelia's
/// brand marks, the auth-provider logos, the shared back arrow) stays in
/// [ImageConst].
///
/// Not yet exported from the kit, so those call sites still render a
/// Material Symbol (see docs/ai-rules/style-packs/dailymart.md §5): the
/// location pin, the chevron, the avatar's person placeholder, the cart
/// row's trash, and the coupon row's discount badge.
abstract final class DailyMartImageConst {
  static const _icons = 'assets/icons/templates/dailymart';

  static const notification = '$_icons/bell-notifications.svg';
  static const search = '$_icons/search-normal.svg';
  static const scanner = '$_icons/scaner.svg';

  /// The recent-search rows' smaller, thinner search glyph — the kit draws
  /// it distinct from the search bar's [search], not a scaled-down copy.
  static const searchSmall = '$_icons/search-small.svg';

  /// The **+** add control's and stepper **−**'s bare glyphs — unlike
  /// [navHome], no disc is baked in: the container (the stepper's
  /// `AppRadius.sm` square, the add button's circle, both `cs.primary`) is
  /// drawn in Flutter so it restyles with the theme, and the glyph takes an
  /// `srcIn` `cs.onPrimary` tint.
  static const plus = '$_icons/plus.svg';
  static const minus = '$_icons/minus.svg';

  /// The Reviews tab's thumbs-up. The kit has no thumbs-down export — the
  /// call site renders this rotated 180° instead, exactly as the kit's own
  /// frame does.
  static const like = '$_icons/like.svg';

  /// The product card's rating star. Ships 14 × 13, not square — render it
  /// inside a square box and let `BoxFit.contain` letterbox it rather than
  /// stretching it to fit.
  static const star = '$_icons/star.svg';


  static const delete = '$_icons/delete.svg';

  /// The Notification screen's row glyphs. Unlike everything else in this
  /// pack these two are **solid**, not outline — the kit draws its
  /// `Icon / solid / …` family here and nowhere else, so the §5 outline rule
  /// still describes the rest of the app.
  ///
  /// The kit exports these three of the kinds [NotificationKind] carries;
  /// the order and security glyphs fall back to a filled Material Symbol at
  /// the call site (see `NotificationRow`).
  static const discountSolid = '$_icons/discount-solid.svg';
  static const cardSolid = '$_icons/card-solid.svg';
  static const profileSolid = '$_icons/profile-solid.svg';

  /// The **active** home tab — a filled house with a white smile cut into
  /// it, drawn in the brand green. Unlike every other icon here it must NOT
  /// be recoloured while active: an `srcIn` filter repaints the smile too
  /// and flattens the glyph into a solid block. See `ShellPage._tabs`.
  static const navHome = '$_icons/home.svg';
  static const navWishlist = '$_icons/heart.svg';
  static const navCart = '$_icons/cart.svg';
  static const navProfile = '$_icons/user.svg';

  /// Same outline heart as the Wishlist tab, at the card's smaller size.
  static const heart = navWishlist;

  /// [heart]'s exact path with a fill added (hand-derived, not a kit
  /// export) — keeps the outline's stroke so the two states share one
  /// silhouette and toggling doesn't jump.
  static const heartFilled = '$_icons/heart_filled.svg';
}
