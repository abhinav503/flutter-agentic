import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors_extension.dart';
import 'app_shapes_extension.dart';
import 'app_spacing.dart';
import 'app_theme_config.dart';

/// Central theme builder.
///
/// Colours and font family come from [AppThemeConfig], which is loaded from
/// `assets/theme/theme_config.json` at startup. Edit that file to rebrand the
/// entire app without touching Dart code.
///
/// Usage in [MaterialApp]:
/// ```dart
/// MaterialApp.router(
///   theme:     AppTheme.fromConfig(config),
///   darkTheme: AppTheme.fromConfig(config, dark: true),
///   themeMode: ThemeMode.system,
/// )
/// ```
class AppTheme {
  AppTheme._();

  static ThemeData fromConfig(AppThemeConfig config, {bool dark = false}) {
    var cs = dark
        ? ColorScheme.fromSeed(
            seedColor: config.darkSeed,
            brightness: Brightness.dark,
          )
        : ColorScheme.fromSeed(seedColor: config.lightSeed);

    final overrides = dark ? config.darkOverrides : config.lightOverrides;
    cs = _applyOverrides(cs, overrides);

    return _build(
      cs,
      fontFamily: config.fontFamily,
      shapes: config.shapes,
      density: config.density,
      colorOverrides: overrides,
    );
  }

  /// Convenience constructor — useful in tests or when skipping JSON loading.
  static ThemeData light({
    Color seed = const Color(0xFF6750A4),
    String? fontFamily,
  }) =>
      _build(ColorScheme.fromSeed(seedColor: seed), fontFamily: fontFamily);

  static ThemeData dark({
    Color seed = const Color(0xFF6750A4),
    String? fontFamily,
  }) =>
      _build(
        ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        fontFamily: fontFamily,
      );

  /// Resolves a config's font family into the type scale.
  ///
  /// Defaults to google_fonts, which fetches/caches font files at runtime so
  /// presets need no per-app bundling. flutter_test blocks HTTP and fails the
  /// test on the resulting async error, so tests that build a preset with a
  /// fontFamily replace this:
  /// `AppTheme.fontResolver = (family, scale) => scale.apply(fontFamily: family);`
  @visibleForTesting
  static TextTheme Function(String fontFamily, TextTheme scale) fontResolver =
      _googleFontsTextTheme;

  static TextTheme _googleFontsTextTheme(String fontFamily, TextTheme scale) {
    // A family google_fonts doesn't know (a custom bundled font) falls back
    // to a plain reference, resolved against the app's `fonts:` assets.
    try {
      return GoogleFonts.getTextTheme(fontFamily, scale);
    } on Exception {
      return scale.apply(fontFamily: fontFamily);
    }
  }

  // ── Internals ──────────────────────────────────────────────────────────────

  /// Applies per-role overrides on top of a seed-generated [ColorScheme].
  /// Only keys present in [overrides] are applied; absent keys keep the
  /// seed-generated value (copyWith treats null as "keep existing").
  static ColorScheme _applyOverrides(
    ColorScheme cs,
    Map<String, Color> overrides,
  ) {
    if (overrides.isEmpty) return cs;
    return cs.copyWith(
      // Primary
      primary: overrides['primary'],
      onPrimary: overrides['onPrimary'],
      primaryContainer: overrides['primaryContainer'],
      onPrimaryContainer: overrides['onPrimaryContainer'],
      primaryFixed: overrides['primaryFixed'],
      primaryFixedDim: overrides['primaryFixedDim'],
      onPrimaryFixed: overrides['onPrimaryFixed'],
      onPrimaryFixedVariant: overrides['onPrimaryFixedVariant'],
      // Secondary
      secondary: overrides['secondary'],
      onSecondary: overrides['onSecondary'],
      secondaryContainer: overrides['secondaryContainer'],
      onSecondaryContainer: overrides['onSecondaryContainer'],
      secondaryFixed: overrides['secondaryFixed'],
      secondaryFixedDim: overrides['secondaryFixedDim'],
      onSecondaryFixed: overrides['onSecondaryFixed'],
      onSecondaryFixedVariant: overrides['onSecondaryFixedVariant'],
      // Tertiary
      tertiary: overrides['tertiary'],
      onTertiary: overrides['onTertiary'],
      tertiaryContainer: overrides['tertiaryContainer'],
      onTertiaryContainer: overrides['onTertiaryContainer'],
      tertiaryFixed: overrides['tertiaryFixed'],
      tertiaryFixedDim: overrides['tertiaryFixedDim'],
      onTertiaryFixed: overrides['onTertiaryFixed'],
      onTertiaryFixedVariant: overrides['onTertiaryFixedVariant'],
      // Error
      error: overrides['error'],
      onError: overrides['onError'],
      errorContainer: overrides['errorContainer'],
      onErrorContainer: overrides['onErrorContainer'],
      // Surface
      surface: overrides['surface'],
      onSurface: overrides['onSurface'],
      surfaceDim: overrides['surfaceDim'],
      surfaceBright: overrides['surfaceBright'],
      surfaceContainerLowest: overrides['surfaceContainerLowest'],
      surfaceContainerLow: overrides['surfaceContainerLow'],
      surfaceContainer: overrides['surfaceContainer'],
      surfaceContainerHigh: overrides['surfaceContainerHigh'],
      surfaceContainerHighest: overrides['surfaceContainerHighest'],
      onSurfaceVariant: overrides['onSurfaceVariant'],
      surfaceTint: overrides['surfaceTint'],
      // Utility
      outline: overrides['outline'],
      outlineVariant: overrides['outlineVariant'],
      shadow: overrides['shadow'],
      scrim: overrides['scrim'],
      inverseSurface: overrides['inverseSurface'],
      onInverseSurface: overrides['onInverseSurface'],
      inversePrimary: overrides['inversePrimary'],
    );
  }

  /// Full M3 type scale with explicit sizes, weights, and line heights.
  ///
  /// Values match the Material Design 3 type scale spec. Change any value here
  /// to adjust the scale globally — no need to touch individual widgets.
  /// [TextTheme.apply] stamps the active font family across every style.
  static TextTheme _textTheme(String? fontFamily) {
    const TextTheme scale = TextTheme(
      // ── Display ────────────────────────────────────────────────────────────
      displayLarge:  TextStyle(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25, height: 1.12),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, letterSpacing:  0,    height: 1.16),
      displaySmall:  TextStyle(fontSize: 36, fontWeight: FontWeight.w400, letterSpacing:  0,    height: 1.22),
      // ── Headline ───────────────────────────────────────────────────────────
      headlineLarge:  TextStyle(fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.25),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.29),
      headlineSmall:  TextStyle(fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.33),
      // ── Title ──────────────────────────────────────────────────────────────
      titleLarge:  TextStyle(fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0,    height: 1.27),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15, height: 1.50),
      titleSmall:  TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1,  height: 1.43),
      // ── Body ───────────────────────────────────────────────────────────────
      bodyLarge:   TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5,  height: 1.50),
      bodyMedium:  TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, height: 1.43),
      bodySmall:   TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4,  height: 1.33),
      // ── Label ──────────────────────────────────────────────────────────────
      labelLarge:  TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1,  height: 1.43),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5,  height: 1.33),
      labelSmall:  TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5,  height: 1.45),
    );

    return fontFamily != null ? fontResolver(fontFamily, scale) : scale;
  }

  static ThemeData _build(
    ColorScheme cs, {
    String? fontFamily,
    AppShapes shapes = AppShapes.standard,
    double density = 0,
    Map<String, Color> colorOverrides = const {},
  }) {
    final isDark = cs.brightness == Brightness.dark;

    // AppColorsExtension roles that are theme data (a kit specs exact
    // swatches — see the gravia preset) but have sensible scheme-derived
    // defaults for presets that don't set them. Keys share the namespace of
    // the ColorScheme role overrides; unknown keys are ignored by
    // _applyOverrides, so both readers can consume the same map.
    final colors = (isDark ? AppColorsExtension.dark : AppColorsExtension.light)
        .copyWith(
      tintedPrimaryFill: colorOverrides['tintedPrimaryFill'] ??
          cs.primary.withValues(alpha: isDark ? 0.20 : 0.10),
      dockedHairline: colorOverrides['dockedHairline'] ?? cs.outlineVariant,
      sheetHairline: colorOverrides['sheetHairline'] ?? cs.outlineVariant,
      onSheetMuted: colorOverrides['onSheetMuted'] ?? cs.onSurfaceVariant,
    );

    // Every brand shape is derived from the config's radii, so raw Material
    // widgets (ElevatedButton, Chip, Card…) and our atoms — which read the same
    // AppShapes extension — stay identical and re-skin together per theme.
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(shapes.buttonRadius),
    );
    final chipShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(shapes.chipRadius),
    );
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(shapes.cardRadius),
    );
    final inputRadius = BorderRadius.circular(shapes.inputRadius);

    OutlineInputBorder inputBorder(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      visualDensity: VisualDensity(horizontal: density, vertical: density),

      // ── Custom theme extensions ───────────────────────────────────────────
      // success/warning colours via AppColorsExtension; brand radii via
      // AppShapes — atoms read both from Theme.of(context).extension<…>().
      extensions: [
        colors,
        shapes,
      ],

      // ── Text theme ────────────────────────────────────────────────────────
      // Explicit M3 type scale — change sizes/weights here, not in widgets.
      // Font family is stamped across all styles via TextTheme.apply().
      textTheme: _textTheme(fontFamily),

      // ── Component themes (make RAW Material widgets on-brand) ──────────────
      // Colours already come from the ColorScheme automatically; these add the
      // brand shape so a plain ElevatedButton looks exactly like an AppButton.
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ElevatedButton.styleFrom(shape: buttonShape)),
      filledButtonTheme:
          FilledButtonThemeData(style: FilledButton.styleFrom(shape: buttonShape)),
      outlinedButtonTheme:
          OutlinedButtonThemeData(style: OutlinedButton.styleFrom(shape: buttonShape)),
      textButtonTheme:
          TextButtonThemeData(style: TextButton.styleFrom(shape: buttonShape)),
      chipTheme: ChipThemeData(shape: chipShape),
      cardTheme: CardThemeData(clipBehavior: Clip.antiAlias, shape: cardShape),
      dialogTheme: DialogThemeData(shape: cardShape),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(shapes.sheetRadius)),
        ),
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(shape: buttonShape),

      // ── Input fields ──────────────────────────────────────────────────────
      // M3 default uses an underline border. This switches every TextFormField
      // to an outlined rounded style (radius from shapes.inputRadius) so plain
      // fields match AppTextField. hint/label inherit the textTheme font.
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        border: inputBorder(cs.outline),
        enabledBorder: inputBorder(cs.outline),
        focusedBorder: inputBorder(cs.primary, width: 2),
        errorBorder: inputBorder(cs.error),
        focusedErrorBorder: inputBorder(cs.error, width: 2),
        disabledBorder: inputBorder(cs.onSurface.withValues(alpha: 0.12)),
        hintStyle: TextStyle(color: cs.onSurfaceVariant),
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
        errorStyle: TextStyle(color: cs.error, fontSize: 12),
      ),
    );
  }
}
