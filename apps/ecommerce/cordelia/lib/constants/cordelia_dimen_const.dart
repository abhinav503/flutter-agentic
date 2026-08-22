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
  /// Login: brand lockup + title + subtitle block.
  static const double authHeaderHeightLogin = 270;

  /// Signup: glass back disc + brand mark row, then title + subtitle. The
  /// mark shares the back disc's row, so adding it cost no height.
  static const double authHeaderHeightSignup = 170;

  /// Discovery: brand row + greeting block + the search field sitting on the
  /// canvas. Taller than either auth header because of that third row.
  static const double discoveryHeaderHeight = 260;

  /// The brand mark's disc in a coloured header — the mark is a green
  /// gradient, so on the (now also green) primary canvas it only reads
  /// against a light disc of its own.
  static const double brandMarkDisc = 40;

  /// The mark inside [brandMarkDisc], inset so it doesn't touch the edge.
  static const double brandMarkGlyph = 24;

  /// A recents-rail store logo. Large enough to recognise a brand at a
  /// glance, small enough that six fit within two swipes.
  static const double recentStoreLogo = 60;

  /// Width of a recents-rail item — the logo plus room for a two-line name
  /// under it, fixed so names of different lengths don't stagger the rail.
  static const double recentStoreTile = 72;

  /// A store card's logo on the discovery list.
  static const double storeCardLogo = 56;

  // ── Discovery's Live | All segmented control, sized to match the admin
  // console's tab bar so the two surfaces read as one product.
  /// Track height. Compact — it sits on a section header row, not on its own.
  static const double segmentedHeight = 36;

  /// Inset between the track's edge and the raised pill inside it.
  static const double segmentedTrackInset = 3;

  /// The track's corner radius. Softened-square rather than a full pill —
  /// the fully-rounded version read as two chips rather than one control.
  static const double segmentedRadius = 10;

  /// The selected pill's radius. Derived, not a second literal: a rounded
  /// shape nested inside another only looks concentric when the inner radius
  /// is the outer one minus the gap between them.
  static const double segmentedPillRadius =
      segmentedRadius - segmentedTrackInset;

  /// Horizontal padding inside each segment.
  static const double segmentedSegmentInset = 14;

  /// The lift under the *selected* segment. Deliberately not an `AppShadows`
  /// tier — the nearest, `card`, is blur 12 at y 4, and a segment rises a
  /// hair off its track rather than floating over it. Kept with the rest of
  /// this control's spec so the whole thing reads in one place.
  static const double segmentedPillShadowBlur = 3;
  static const double segmentedPillShadowY = 1;
  static const double segmentedPillShadowOpacity = 0.08;

  /// Discovery's search field. Taller than [controlHeight] on purpose — it is
  /// the header's one interactive target, sits alone on the canvas, and at
  /// the form-field height read as a cramped strip against the greeting
  /// block above it.
  static const double discoverySearchHeight = 52;
}
