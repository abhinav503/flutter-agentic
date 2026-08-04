import 'package:flutter/material.dart';

/// Raw kit swatches that don't map to a `ColorScheme`/`AppColorsExtension`
/// role — the DailyMart pack's two pinned colours (see
/// docs/ai-rules/style-packs/dailymart.md §1).
///
/// Everything else comes from the theme: the mint canvas is
/// `cs.canvas` below, the discount pill is `cs.error`, the neutrals are the
/// scheme's own ramp.
abstract final class DailyMartColorConst {
  /// The rating star. Amber in both modes — a theme role would flip it and
  /// the star would stop reading as a rating. Matches the fill baked into
  /// `star.svg`, so tinting the glyph with this is a no-op by design: the
  /// swatch stays the single source of truth for the number beside it.
  static const ratingStar = Color(0xFFF1B826);

  /// 20% black wash between a promo card's photo and its white copy, so the
  /// headline stays legible over any image the store uploads.
  static const promoScrim = Color(0x33000000);

  /// The kit's "Color/orange" — the payment glyph on the Notification
  /// screen, and the pack's only warm accent. Pinned rather than mapped to
  /// `AppColorsExtension.warning`: the `dailyMart` preset declares no warning
  /// role, so that would resolve to a seed-derived tone, not this swatch.
  static const paymentIcon = Color(0xFFFF9C44);

  /// The static Reviews tab's amber (kit `warning/400`) — summary stars,
  /// star bars, and the review row's rating pill, with the kit's ink on the
  /// pill. Pinned for the same reason as [paymentIcon]: the preset declares
  /// no warning role, and review amber must stay amber in both modes, like
  /// [ratingStar].
  static const reviewAmber = Color(0xFFFACC15);
  static const onReviewAmber = Color(0xFF0D121C);
}

/// The pack's canvas role, which no `ColorScheme` member expresses on its
/// own — computed once here instead of re-deriving the same ternary at every
/// call site (same pattern as `GraviaColorSchemeX.tintedErrorFill`).
extension DailyMartColorSchemeX on ColorScheme {
  /// Home's full-bleed page background. Light mode is the kit's mint
  /// (`primaryContainer`, `#C6FFB9`); dark mode has no equivalent — a
  /// desaturated green wash reads as sickly — so it falls back to the plain
  /// surface and cards separate by shadow alone.
  Color get canvas =>
      brightness == Brightness.dark ? surface : primaryContainer;
}

/// The pack's three shadow recipes. Unlike packs that separate layers by
/// fill, DailyMart lifts white cards off a mint canvas with a real shadow —
/// so these are contract values, not per-widget guesses. A fourth shadow in
/// this template is drift.
abstract final class DailyMartElevation {
  /// Product cards, category tiles, the promo card's "Order Now" pill.
  static const card = [
    BoxShadow(color: Color(0x40000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  /// The bottom nav's upward lift over scrolling content.
  static const nav = [
    BoxShadow(color: Color(0x14000000), blurRadius: 30, offset: Offset(0, -20)),
  ];

  /// The floating Filter pill on Search results.
  static const floatingAction = [
    BoxShadow(color: Color(0x3D576F85), blurRadius: 12, offset: Offset(0, 12)),
  ];
}
