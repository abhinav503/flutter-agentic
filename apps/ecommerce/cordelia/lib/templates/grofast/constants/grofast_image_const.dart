/// Icon assets the `grofast` template's storefront screens use.
///
/// Pack-scoped under `assets/icons/templates/grofast/`, not the app-wide
/// `assets/icons/` — the same way `assets/theme/templates/` scopes each
/// template's theme config, so this pack, `gravia` and `dailymart` can ship
/// different `heart.svg`s without colliding. Genuinely app-level artwork
/// (Cordelia's brand marks, the auth-provider logos) stays in [ImageConst].
///
/// Every glyph here is solid-filled and rendered through `AppSvgImage.asset`
/// with an explicit `color`, so one export serves both the active and the
/// inactive state of a control (spec sheet §5).
///
/// Not exported from the kit, so those call sites render a Material Symbol
/// instead: the location pin and its chevron in Home's header, the avatar's
/// person placeholder, the chevron ending a menu row, the edit pencil, the
/// star, the lock on Change Password, and the shield on the legal screens.
///
/// Two files in the folder are deliberately **not** named below:
/// `scan.svg` (the kit's Scan tab and 3D-scan button — cordelia has no
/// barcode feature, so the control would be dead) and `list_view_menu.svg`
/// (the other half of the kit's grid/list toggle, which this pack doesn't
/// build). Both deviations are recorded in the spec sheet §11; the files stay
/// in place for the day either decision changes.
abstract final class GrofastImageConst {
  static const _icons = 'assets/icons/templates/grofast';

  /// The pack's back control glyph. Sits inside a 60 × 40 rounded rectangle,
  /// not a disc — see `GrofastBackButton`.
  static const backArrow = '$_icons/back_arrow.svg';

  static const bell = '$_icons/bell.svg';
  static const check = '$_icons/check.svg';
  static const delete = '$_icons/delete.svg';
  static const filter = '$_icons/filter.svg';
  static const gear = '$_icons/gear.svg';
  static const gift = '$_icons/gift.svg';
  static const heart = '$_icons/heart.svg';
  static const logout = '$_icons/logout.svg';
  static const search = '$_icons/search_outline.svg';

  /// The **+** / **−** glyphs. No disc or gradient is baked in: the
  /// container (the card's corner button, the stepper's circle) is drawn in
  /// Flutter so it restyles with the theme, and the glyph takes an `srcIn`
  /// tint.
  static const plus = '$_icons/plus.svg';
  static const minus = '$_icons/minus.svg';

  /// The four-square glyph the kit puts beside "All Categories". It doubles
  /// as the Categories tab's nav icon — the kit's own nav has no categories
  /// slot (see the §11 deviation on the discarded Scan tab).
  static const grid = '$_icons/grid_view_menu.svg';

  // --------------------------------------------------------- nav bar glyphs

  static const navHome = '$_icons/home_filled.svg';
  static const navBag = '$_icons/filled_cart.svg';
  static const navAccount = '$_icons/filled_user.svg';
}
