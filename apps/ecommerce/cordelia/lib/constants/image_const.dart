/// App-level assets only — Cordelia's own brand marks, the auth providers'
/// logos, and the back arrow every screen shares regardless of storefront.
///
/// A storefront template's artwork does NOT belong here: it lives in that
/// template's own const class against `assets/icons/templates/<id>/` (see
/// [GraviaImageConst]), so two packs can ship different `search.svg`s.
abstract final class ImageConst {
  static const cordeliaBrandIcon = 'assets/icons/cordelia-icon.svg';
  static const arrowLeft = 'assets/icons/arrow-left.svg';
  static const googleIcon = 'assets/icons/google_icon.svg';
  static const appleIcon = 'assets/icons/apple_icon.svg';
  static const cordeliaWordmarkIcon = 'assets/icons/cordelia-wordmark.svg';

  /// The shopper's fallback avatar photo — the shopper is the same person in
  /// every storefront, so the default portrait is app-level, not per-pack.
  static const profileDefault = 'assets/images/profile_default.png';
}
