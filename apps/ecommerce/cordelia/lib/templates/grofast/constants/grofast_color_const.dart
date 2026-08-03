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

  /// The rating star on Product Details' badge — the kit's one amber, and the
  /// only warm accent in a pack that is otherwise green. Not a scheme role:
  /// `AppColorsExtension.warning` is a semantic state colour, and a star is
  /// not a warning.
  static const ratingStar = Color(0xFFF0C334);

  /// The kit's Dark-Grey — the header row's centred title, a *neutral*
  /// deliberately distinct from both the green ink (`onSurface`) and the
  /// muted grey (`onSurfaceVariant`). Light mode only; see
  /// [GrofastColorSchemeX.headerInk] for the dark-mode fallback.
  static const darkGrey = Color(0xFF4B4B4B);

  /// The kit's Medium-Green — the *active* ink and border of the big list
  /// chips (`Button-Text/Big-Active`, the All / On Delivery / Delivered row).
  /// Deliberately not `cs.primary`: the kit inks these chips a step darker
  /// than the price green so the row doesn't compete with the totals below.
  static const chipActiveInk = Color(0xFF2AAF7F);

  /// The promo banner's copy ink — the kit's Dark-Green, held constant across
  /// light **and** dark mode rather than read from `cs.onSurface` (which
  /// inverts on dark): the copy sits on the *store's* picked banner colour,
  /// not on the theme's canvas, and that colour doesn't change with the mode.
  static const promoInk = Color(0xFF194B38);
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

  /// The header row's centred title — the kit's Dark-Grey, which would sink
  /// into the dark canvas, so dark mode falls back to the muted role.
  Color get headerInk => brightness == Brightness.dark
      ? onSurfaceVariant
      : GrofastColorConst.darkGrey;
}

/// The kit's one elevation recipe — a four-layer green-tinted shadow
/// (`#369246` at 6/9/12/18% alpha), used wherever something floats free of
/// the page: the nav's raised disc, the floating filter pill, the success
/// sheet's icon. Cards do **not** use it; they separate by fill alone.
///
/// The nav bar takes [navBar] instead — same green ink, but a wash rather
/// than a lift. A third shadow recipe in this pack is drift.
abstract final class GrofastElevation {
  /// The bar's separation from the page. Bar and canvas are both `cs.surface`,
  /// so with no shadow the silhouette only reads where content happens to sit
  /// behind the dome — and a Material `elevation` this wide is invisible at
  /// the alpha `Canvas.drawShadow` derives for it.
  ///
  /// Two layers for what the kit draws as one 318-tall gradient above the bar
  /// (measured: ~10% of the ink at the bar's edge, gone ~230 above it): the
  /// tight layer defines the dome's outline, the wide one is that wash, cut
  /// to a blur that is affordable to redraw every frame of a tab change.
  static const navBar = [
    BoxShadow(
      color: Color(0x1F369246),
      blurRadius: 18,
      offset: Offset(0, -2),
    ),
    BoxShadow(
      color: Color(0x1A369246),
      blurRadius: 55,
      offset: Offset(0, -16),
    ),
  ];

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
