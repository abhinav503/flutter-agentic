import 'package:flutter/material.dart';

/// Raw GROFAST swatches and paint recipes that no `ColorScheme` /
/// `AppColorsExtension` role can express (see
/// docs/ai-rules/style-packs/grofast.md §1).
///
/// Everything a role *can* express comes from the theme: the ink is
/// `cs.onSurface` (a dark green, not a neutral), cards are
/// `cs.surfaceContainerLow`, hearts and discounts are `cs.error`, prices are
/// `cs.primary`.
abstract final class GrofastColorConst {
  /// The kit's one gradient, and the pack's single most repeated visual: every
  /// affirmative control is painted with it — the wide CTA, the product card's
  /// corner add button, Home's scan button, the nav's raised disc, the success
  /// sheet's check.
  ///
  /// A `ColorScheme` role holds one colour, so the pair lives here. Never
  /// paint an affirmative control with flat `cs.primary` — a solid green
  /// button is instantly out of place in this pack.
  static const gradientStart = Color(0xFF26AD71);
  static const gradientEnd = Color(0xFF32CB4B);

  /// Figma draws the gradient at 41° on a near-square button and 10° on a
  /// wide one — the same normalized diagonal, re-expressed per box. Flutter's
  /// alignment-space gradients work in that same normalized box, so one
  /// bottom-left → top-right recipe reproduces every instance.
  static const brandGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [gradientStart, gradientEnd],
    stops: [0.063, 0.967],
  );

  /// The pastel wash behind a category tile's artwork. The kit hand-assigns a
  /// different tint per category (mint / cream / sand / blush / butter /
  /// peach / sky); the storefront's categories come from the admin backend
  /// with no tint field, so the pack cycles this ramp by index instead —
  /// recorded as a deviation in the spec sheet.
  ///
  /// Light mode only: these washes are barely-there tints of white and turn
  /// to mud on a dark canvas, so `ColorScheme.categoryTint` falls back to the
  /// scheme's own raised neutral there.
  static const categoryTints = [
    Color(0xFFEBF4F1), // mint
    Color(0xFFF5F4E8), // cream
    Color(0xFFF6EDE4), // sand
    Color(0xFFFBECEC), // blush
    Color(0xFFF7F4E3), // butter
    Color(0xFFF8EFE4), // peach
    Color(0xFFE9F1F7), // sky
  ];

  /// Black wash between a promo banner's photo and the white copy over it, so
  /// the headline stays legible against any image the store uploads. The kit
  /// draws its banners with the copy on flat artwork; a real uploaded photo
  /// needs the scrim.
  static const promoScrim = Color(0x40000000);
}

/// Roles the pack needs that no `ColorScheme` member expresses on its own —
/// computed once here rather than re-deriving the same `brightness` ternary at
/// every call site (same pattern as `DailyMartColorSchemeX.canvas`).
extension GrofastColorSchemeX on ColorScheme {
  /// The tint behind one category tile's artwork. See
  /// [GrofastColorConst.categoryTints] for why this is index-driven.
  Color categoryTint(int index) => brightness == Brightness.dark
      ? surfaceContainerLow
      : GrofastColorConst.categoryTints[index %
            GrofastColorConst.categoryTints.length];

  /// The kit's search field: its ink at 6%, not a grey from the neutral ramp
  /// — so the field carries a green cast that a `surfaceContainer*` role
  /// can't reproduce. Same recipe in both modes; on dark the ink is the light
  /// text colour, which lifts the field off the canvas exactly as intended.
  Color get fieldFill => onSurface.withValues(alpha: 0.06);
}

/// The kit's one elevation recipe — a four-layer green-tinted shadow
/// (`#369246` at 6/9/12/18% alpha), used wherever something floats free of
/// the page: the nav's raised disc, the floating filter pill, the success
/// sheet's icon. Cards do **not** use it; they separate by fill alone.
///
/// A second shadow recipe in this pack is drift.
abstract final class GrofastElevation {
  static const raised = [
    BoxShadow(
      color: Color(0x0F369246),
      blurRadius: 3.76,
      offset: Offset(0, 1.58),
    ),
    BoxShadow(
      color: Color(0x17369246),
      blurRadius: 10.56,
      offset: Offset(0, 7.2),
    ),
    BoxShadow(
      color: Color(0x1F369246),
      blurRadius: 28.34,
      offset: Offset(0, 18.23),
    ),
    BoxShadow(color: Color(0x2E369246), blurRadius: 65, offset: Offset(0, 36)),
  ];
}
