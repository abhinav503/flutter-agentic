import 'package:flutter/material.dart';

import 'app_radius.dart';

double _lerp(double a, double b, double t) => a + (b - a) * t;

/// Brand shape (corner radii) knobs not covered by [ColorScheme].
///
/// Registered on [ThemeData] in [AppTheme] and read by atoms so their shape is
/// theme-driven per app:
/// ```dart
/// final shapes = Theme.of(context).extension<AppShapes>()!;
/// borderRadius: BorderRadius.circular(shapes.buttonRadius),
/// ```
/// The **same** values also drive [ThemeData]'s built-in component themes
/// (`elevatedButtonTheme`, `chipTheme`, `cardTheme`, …), so raw Material widgets
/// and our atoms share one source of truth and re-skin together per theme.
///
/// Values come from each app's `assets/theme/theme_config.json` `shape` block
/// (or a preset). Any omitted key falls back to [standard].
@immutable
class AppShapes extends ThemeExtension<AppShapes> {
  final double buttonRadius;
  final double chipRadius;
  final double cardRadius;
  final double inputRadius;
  final double sheetRadius;

  const AppShapes({
    required this.buttonRadius,
    required this.chipRadius,
    required this.cardRadius,
    required this.inputRadius,
    required this.sheetRadius,
  });

  /// Defaults matching the design-token scale — the look before any per-theme
  /// override, so apps that don't set a `shape` block stay pixel-identical.
  static const AppShapes standard = AppShapes(
    buttonRadius: AppRadius.mdValue, // 8
    chipRadius: AppRadius.fullValue, // 999 (pill)
    cardRadius: AppRadius.xlValue, // 16
    inputRadius: AppRadius.mdValue, // 8
    sheetRadius: 24,
  );

  @override
  AppShapes copyWith({
    double? buttonRadius,
    double? chipRadius,
    double? cardRadius,
    double? inputRadius,
    double? sheetRadius,
  }) =>
      AppShapes(
        buttonRadius: buttonRadius ?? this.buttonRadius,
        chipRadius: chipRadius ?? this.chipRadius,
        cardRadius: cardRadius ?? this.cardRadius,
        inputRadius: inputRadius ?? this.inputRadius,
        sheetRadius: sheetRadius ?? this.sheetRadius,
      );

  @override
  AppShapes lerp(AppShapes other, double t) => AppShapes(
        buttonRadius: _lerp(buttonRadius, other.buttonRadius, t),
        chipRadius: _lerp(chipRadius, other.chipRadius, t),
        cardRadius: _lerp(cardRadius, other.cardRadius, t),
        inputRadius: _lerp(inputRadius, other.inputRadius, t),
        sheetRadius: _lerp(sheetRadius, other.sheetRadius, t),
      );
}
