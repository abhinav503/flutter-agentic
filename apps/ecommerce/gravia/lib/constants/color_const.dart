import 'package:flutter/material.dart';

/// Raw kit swatches that don't map to a `ColorScheme`/`AppColorsExtension`
/// role — used when a design spec calls out an exact shade (e.g. "Gray/500")
/// rather than a semantic role like `onSurfaceVariant`.
abstract final class ColorConst {
  static const gray100 = Color(0xFFEDEDED);
  static const gray200 = Color(0xFFDFDFDF);
  static const gray500 = Color(0xFFA1A1A1);
  static const gray900 = Color(0xFF3A3B3F);

  /// Same shade in both light and dark — unlike `onSurfaceVariant`, which
  /// resolves to Gray/700 in light but Gray/400 in dark.
  static const gray700 = Color(0xFF7B7B7B);
  static const primary50 = Color(0xFFECFDF6);

  /// Dark-mode counterpart to [gray200] for the same hairline/handle
  /// elements — the kit's dark-mode neutral scale ("Light/900"), not a
  /// `ColorScheme` role (neither `outlineVariant` nor `surfaceContainer`
  /// lands on this exact shade in dark mode).

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
  Color get tintedPrimaryFill =>
      brightness == Brightness.dark ? primary.withValues(alpha: 0.2) : ColorConst.primary50;
}
