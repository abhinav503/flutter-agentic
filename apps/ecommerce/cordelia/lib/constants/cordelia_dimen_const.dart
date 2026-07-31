/// Dimensions for the app's own chrome (auth, discovery) — shared with the
/// `gravia` pack, whose kit they were sampled from (`GraviaDimenConst`
/// re-exposes [controlHeight]).
abstract final class CordeliaDimenConst {
  /// The fixed height for pill buttons, glass icon discs, and form fields —
  /// one shared source instead of several independently-named constants that
  /// happen to agree on the same number.
  static const double controlHeight = 45;

  // ── CollapsingHeaderSheet `initialHeaderHeight` for the auth screens —
  // named here so a screen's loading/error/loaded arms can't drift apart.
  /// Login: glass back disc + title + subtitle block.
  static const double authHeaderHeightLogin = 210;

  /// Signup: glass back disc + title row (no subtitle).
  static const double authHeaderHeightSignup = 170;
}
