import 'package:flutter/material.dart';

/// Raw kit swatches that don't map to a `ColorScheme`/`AppColorsExtension`
/// role — used when a design spec calls out an exact shade (e.g. "Gray/500")
/// rather than a semantic role like `onSurfaceVariant`.
abstract final class ColorConst {
  static const gray50 = Color(0xFFF7F7F7);
  static const gray100 = Color(0xFFEDEDED);
  static const gray200 = Color(0xFFDFDFDF);
  static const gray500 = Color(0xFFA1A1A1);
  static const gray900 = Color(0xFF3A3B3F);

  /// Dark-mode counterpart to [gray50] — category tile circle background.
  static const gray950 = Color(0xFF242528);

  /// Same shade in both light and dark — unlike `onSurfaceVariant`, which
  /// resolves to Gray/700 in light but Gray/400 in dark.
  static const gray700 = Color(0xFF7B7B7B);
  static const primary50 = Color(0xFFECFDF6);

  /// Success/500 — the Dark Mode switch's active-track colour (not the
  /// same green as [primary]; the kit calls out this specific swatch).
  static const success500 = Color(0xFF22C55E);

  /// Error/50 and Error/500 — the Select Address screen's Delete pill spec
  /// (not the theme's `errorContainer`/`onErrorContainer` roles, which are a
  /// different, darker-tinted pair on this preset).
  static const error50 = Color(0xFFFEF2F2);
  static const error500 = Color(0xFFEF4444);
}

/// [ColorScheme] role that isn't itself a `ColorScheme`/`AppColorsExtension`
/// member — computed once here instead of re-deriving the same ternary at
/// every call site.
///
/// `tintedPrimaryFill`/`dockedHairline`/`sheetHairline` used to live here as
/// derived ternaries but are now real theme data on core's
/// `AppColorsExtension` (set from this app's `gravia` preset in
/// `app_theme_presets.dart`) — read them via
/// `Theme.of(context).extension<AppColorsExtension>()!.dockedHairline` etc.,
/// not from `ColorScheme`. `tintedErrorFill` stays here: it's a single-caller
/// (Select Address's Delete pill), error-specific value, not a cross-cutting
/// role other packs would need.
extension GraviaColorSchemeX on ColorScheme {
  /// Same light-baked-swatch / dark-20%-alpha split as
  /// `AppColorsExtension.tintedPrimaryFill`, for the Select Address screen's
  /// Delete pill: light mode uses the kit's pre-baked pastel swatch
  /// (Error/50); dark mode's spec calls this "Error/500 20%" — the actual
  /// error colour at 20% opacity, not a separate baked swatch.
  Color get tintedErrorFill => brightness == Brightness.dark
      ? ColorConst.error500.withValues(alpha: 0.2)
      : ColorConst.error50;

  /// Neutral icon-circle / tile fill — Gray/50 light, Gray/950 dark. The
  /// kit's default "raised neutral surface" behind a glyph or thumbnail:
  /// `ProfileMenuTile`'s icon circle (via `AppMenuTile.iconCircleColor`),
  /// `CartStatusBar`'s cart icon circle, and `HomeCategorySection`/
  /// `CategoryGroupSection`'s `CategoryTile` background all render this —
  /// four copies of the same ternary had already drifted into their own
  /// comments cross-referencing each other before this existed.
  Color get iconCircleFill =>
      brightness == Brightness.dark ? ColorConst.gray950 : ColorConst.gray50;
}
