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
extension GraviaColorSchemeX on ColorScheme {
  /// Tinted-primary fill for selected/emphasis pill surfaces (product
  /// badges, selector chips). Light mode uses the kit's pre-baked pastel
  /// swatch (Primary/50); dark mode's spec calls this "Primary 20%" — the
  /// actual brand colour at 20% opacity over the dark surface, not a
  /// separate baked swatch — so it can't be expressed as a single static
  /// `Color` the way [ColorConst.primary50] is.
  Color get tintedPrimaryFill => brightness == Brightness.dark
      ? primary.withValues(alpha: 0.2)
      : ColorConst.primary50;

  /// Same light-baked-swatch / dark-20%-alpha split as [tintedPrimaryFill],
  /// for the Select Address screen's Delete pill: light mode uses the kit's
  /// pre-baked pastel swatch (Error/50); dark mode's spec calls this
  /// "Error/500 20%" — the actual error colour at 20% opacity, not a
  /// separate baked swatch.
  Color get tintedErrorFill => brightness == Brightness.dark
      ? ColorConst.error500.withValues(alpha: 0.2)
      : ColorConst.error50;

  /// Top hairline separating a docked bar (BottomNavBar, docked CTA bars,
  /// AppTopBar's bottom border) from scrollable content: Gray/500 in light;
  /// the kit's dark-mode spec calls for white rather than a darker gray, so
  /// the divider still reads against the dark surface.
  Color get dockedHairline =>
      brightness == Brightness.dark ? Colors.white : ColorConst.gray500;

  /// Hairline/handle shade for bottom sheets (divider + drag handle):
  /// Gray/200 light, the kit's dark neutral "Light/900" ([ColorConst.gray900])
  /// dark — neither `outlineVariant` nor `onSurfaceVariant` lands on the
  /// kit's exact shade in both modes.
  Color get sheetHairline =>
      brightness == Brightness.dark ? ColorConst.gray900 : ColorConst.gray200;
}
