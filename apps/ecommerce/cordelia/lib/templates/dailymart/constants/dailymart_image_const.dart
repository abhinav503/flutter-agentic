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
/// location pin, the chevron, the product card's **+**, the rating star, and
/// a filled heart for the favourited state.
abstract final class DailyMartImageConst {
  static const _icons = 'assets/icons/templates/dailymart';

  static const notification = '$_icons/bell-notifications.svg';
  static const search = '$_icons/search-normal.svg';
  static const scanner = '$_icons/scaner.svg';

  /// The **active** home tab — a filled house with a white smile cut into
  /// it, drawn in the brand green. Unlike every other icon here it must NOT
  /// be recoloured while active: an `srcIn` filter repaints the smile too
  /// and flattens the glyph into a solid block. See `ShellPage._tabs`.
  static const navHome = '$_icons/home.svg';
  static const navWishlist = '$_icons/heart.svg';
  static const navCart = '$_icons/cart.svg';
  static const navProfile = '$_icons/user.svg';

  /// Same outline heart as the Wishlist tab, at the card's smaller size. The
  /// kit's filled counterpart isn't exported, so the favourited state is
  /// marked by tint (`cs.error`) rather than by fill.
  static const heart = navWishlist;
}
