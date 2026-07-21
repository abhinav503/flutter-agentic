import 'package:flutter/material.dart';

/// Custom semantic colour roles not covered by Material Design 3's [ColorScheme].
///
/// Registered on [ThemeData] in [AppTheme] and accessed anywhere via:
/// ```dart
/// final ext = Theme.of(context).extension<AppColorsExtension>()!;
/// ext.successContainer   // background for success badges / banners
/// ext.onSuccessContainer // foreground text / icons on successContainer
/// ext.warningContainer
/// ext.onWarningContainer
/// ext.onOverlay           // icon/text on a colour/photo/glass overlay surface
/// ext.tintedPrimaryFill   // selected/emphasis pill fill (badges, selector chips)
/// ext.dockedHairline      // top hairline of docked bars (bottom nav, CTA bars)
/// ext.sheetHairline       // bottom-sheet divider + drag-handle shade
/// ```
///
/// `tintedPrimaryFill`/`dockedHairline`/`sheetHairline` are theme data, not
/// derivable ternaries: a style pack's kit typically specs exact swatches for
/// them (see the `gravia` preset), so they're overridable per theme via the
/// same config keys as `ColorScheme` roles ([AppTheme.fromConfig] resolves
/// them, falling back to scheme-derived defaults when a preset doesn't set
/// them). The constants below only cover direct construction outside
/// [AppTheme].
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warningContainer;
  final Color onWarningContainer;

  /// Foreground for icons/text sitting on a colour, photo, or glass overlay
  /// surface (e.g. a hero header icon, a search bar's icon over its glass
  /// tint) — fixed across light/dark, unlike M3's `on*` roles (`onPrimary`
  /// etc.), which intentionally invert per-theme for contrast against their
  /// paired surface. Those overlay surfaces don't invert the same way (the
  /// header stays a green photo/gradient look regardless of app theme), so
  /// pairing them with a theme-flipping role turns the icon dark in dark
  /// mode instead of staying legible.
  final Color onOverlay;

  /// Tinted-primary fill for selected/emphasis pill surfaces (product
  /// badges, selector chips). Kits typically bake a pastel swatch in light
  /// mode and spec "primary at N% opacity" in dark mode, so neither
  /// `primaryContainer` nor a single static colour lands on both.
  final Color tintedPrimaryFill;

  /// Top hairline separating a docked bar (bottom nav, docked CTA bars, a
  /// top bar's bottom border) from scrollable content.
  final Color dockedHairline;

  /// Hairline/handle shade for bottom sheets (divider + drag handle) —
  /// packs spec this independently of [dockedHairline].
  final Color sheetHairline;

  const AppColorsExtension({
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warningContainer,
    required this.onWarningContainer,
    this.onOverlay = Colors.white,
    this.tintedPrimaryFill = const Color(0x1A6750A4),
    this.dockedHairline = const Color(0x1F000000),
    this.sheetHairline = const Color(0x1F000000),
  });

  /// Default light-mode values.
  static const AppColorsExtension light = AppColorsExtension(
    successContainer:   Color(0xFFD4EDDA),
    onSuccessContainer: Color(0xFF155724),
    warningContainer:   Color(0xFFFFF3CD),
    onWarningContainer: Color(0xFF856404),
  );

  /// Default dark-mode values.
  static const AppColorsExtension dark = AppColorsExtension(
    successContainer:   Color(0xFF1B4332),
    onSuccessContainer: Color(0xFF8DD5B2),
    warningContainer:   Color(0xFF3D2C00),
    onWarningContainer: Color(0xFFFFD60A),
    tintedPrimaryFill:  Color(0x336750A4),
    dockedHairline:     Color(0x33FFFFFF),
    sheetHairline:      Color(0x33FFFFFF),
  );

  @override
  AppColorsExtension copyWith({
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? onOverlay,
    Color? tintedPrimaryFill,
    Color? dockedHairline,
    Color? sheetHairline,
  }) =>
      AppColorsExtension(
        successContainer:   successContainer   ?? this.successContainer,
        onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
        warningContainer:   warningContainer   ?? this.warningContainer,
        onWarningContainer: onWarningContainer ?? this.onWarningContainer,
        onOverlay:          onOverlay          ?? this.onOverlay,
        tintedPrimaryFill:  tintedPrimaryFill  ?? this.tintedPrimaryFill,
        dockedHairline:     dockedHairline     ?? this.dockedHairline,
        sheetHairline:      sheetHairline      ?? this.sheetHairline,
      );

  @override
  AppColorsExtension lerp(AppColorsExtension other, double t) =>
      AppColorsExtension(
        successContainer:   Color.lerp(successContainer,   other.successContainer,   t)!,
        onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
        warningContainer:   Color.lerp(warningContainer,   other.warningContainer,   t)!,
        onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
        onOverlay:          Color.lerp(onOverlay,          other.onOverlay,          t)!,
        tintedPrimaryFill:  Color.lerp(tintedPrimaryFill,  other.tintedPrimaryFill,  t)!,
        dockedHairline:     Color.lerp(dockedHairline,     other.dockedHairline,     t)!,
        sheetHairline:      Color.lerp(sheetHairline,      other.sheetHairline,      t)!,
      );
}
