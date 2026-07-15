import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/theme/app_theme_presets.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

/// One [WidgetbookTheme] per preset × brightness, built the same way an app's
/// `theme_config.json` would (`activeTheme` → [AppThemeConfig.fromJson] →
/// [AppTheme.fromConfig]) — so this is exactly what shipping apps render.
List<WidgetbookTheme<ThemeData>> designGalleryPresetThemes() {
  return [
    for (final presetName in kThemePresets.keys) ...[
      WidgetbookTheme(
        name: '$presetName · Light',
        data: AppTheme.fromConfig(
          AppThemeConfig.fromJson({'activeTheme': presetName}),
        ),
      ),
      WidgetbookTheme(
        name: '$presetName · Dark',
        data: AppTheme.fromConfig(
          AppThemeConfig.fromJson({'activeTheme': presetName}),
          dark: true,
        ),
      ),
    ],
  ];
}
