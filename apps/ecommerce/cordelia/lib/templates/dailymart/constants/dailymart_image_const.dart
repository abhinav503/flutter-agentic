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
/// Material Symbol (see docs/ai-rules/style-packs/dailymart.md §5): Home
/// header's location pin and its chevron (a different glyph from the
/// address row's [location]), the avatar's person placeholder, the cart
/// row's trash, the coupon row's discount badge, and Profile's My Orders /
/// Dark Mode / Terms rows, which the kit's own list never draws.
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

  /// Profile's bordered menu rows — the kit's `vuesax/linear/*` 20px family.
  ///
  /// [menuUser] is **not** [navProfile]: the kit draws the nav tab's person
  /// with a shoulder arc and this one with a rounded-rectangle body, so the
  /// two are separate exports rather than one glyph at two sizes.
  static const menuUser = '$_icons/user-linear.svg';
  static const menuLock = '$_icons/lock.svg';
  static const menuShieldCheck = '$_icons/shield-check.svg';

  /// The Logout row's glyph. The kit's own frame mirrors this export
  /// horizontally so the arrow exits the door rightwards — see
  /// `DailyMartMenuTile`'s call site, which reproduces that flip.
  static const menuLogout = '$_icons/logout.svg';

  /// A menu row's trailing chevron (18) — the kit's `arrow-right`, also
  /// rotated 90° for a select field's down-chevron.
  static const chevronRight = '$_icons/arrow-right.svg';

  /// Edit Profile's avatar badge — a white pencil on the green disc, which
  /// is drawn in Flutter (the export is the bare glyph).
  static const pencil = '$_icons/pencil.svg';

  /// Select Address's row pin. Ships 14 × 20, not square — give it a square
  /// box and let `BoxFit.contain` letterbox it rather than stretching.
  static const location = '$_icons/location.svg';

  /// The selected address's tick. Ships 11.3 × 8.4 (bare glyph, no disc):
  /// the green circle behind it is drawn in Flutter, same convention as
  /// [plus] / [minus].
  static const check = '$_icons/check.svg';

  /// [heart]'s exact path with a fill added (hand-derived, not a kit
  /// export) — keeps the outline's stroke so the two states share one
  /// silhouette and toggling doesn't jump.
  static const heartFilled = '$_icons/heart_filled.svg';
}
