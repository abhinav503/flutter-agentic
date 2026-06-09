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
/// ```
///
/// To customise per-theme, override the values in [AppTheme._build()].
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warningContainer;
  final Color onWarningContainer;

  const AppColorsExtension({
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warningContainer,
    required this.onWarningContainer,
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
  );

  @override
  AppColorsExtension copyWith({
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warningContainer,
    Color? onWarningContainer,
  }) =>
      AppColorsExtension(
        successContainer:   successContainer   ?? this.successContainer,
        onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
        warningContainer:   warningContainer   ?? this.warningContainer,
        onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      );

  @override
  AppColorsExtension lerp(AppColorsExtension other, double t) =>
      AppColorsExtension(
        successContainer:   Color.lerp(successContainer,   other.successContainer,   t)!,
        onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
        warningContainer:   Color.lerp(warningContainer,   other.warningContainer,   t)!,
        onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      );
}
