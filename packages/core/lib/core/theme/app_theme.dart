import 'package:flutter/material.dart';

import 'app_colors_extension.dart';
import 'app_radius.dart';
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

    cs = _applyOverrides(cs, dark ? config.darkOverrides : config.lightOverrides);

    return _build(cs, fontFamily: config.fontFamily);
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

    return fontFamily != null ? scale.apply(fontFamily: fontFamily) : scale;
  }

  static ThemeData _build(ColorScheme cs, {String? fontFamily}) {
    final isDark = cs.brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,

      // ── Custom semantic colours ───────────────────────────────────────────
      // success/warning roles not covered by M3 ColorScheme — access via
      // Theme.of(context).extension<AppColorsExtension>()!
      extensions: [isDark ? AppColorsExtension.dark : AppColorsExtension.light],

      // ── Text theme ────────────────────────────────────────────────────────
      // Explicit M3 type scale — change sizes/weights here, not in widgets.
      // Font family is stamped across all styles via TextTheme.apply().
      textTheme: _textTheme(fontFamily),

      // ── Input fields ──────────────────────────────────────────────────────
      // M3 default uses an underline border. This switches every TextFormField
      // to an outlined rounded style so plain fields match AppTextField.
      // hintStyle/labelStyle inherit the textTheme font via the theme cascade.
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.mdValue),
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.mdValue),
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.mdValue),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.mdValue),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.mdValue),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.mdValue),
          borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
        ),
        hintStyle: TextStyle(color: cs.onSurfaceVariant),
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
        errorStyle: TextStyle(color: cs.error, fontSize: 12),
      ),
    );
  }
}
