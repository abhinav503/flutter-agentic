import 'package:flutter/material.dart';

import '../../constants/core_const.dart';

/// AppBar action that cycles the app's theme mode: System → Light → Dark.
///
/// Presentational only — the caller supplies the current [mode] and an [onTap]
/// that advances it (e.g. `ThemeModeController.cycle`). Icon colour comes from
/// the ambient [IconTheme]/[ColorScheme]; no hard-coded colours.
class ThemeModeToggle extends StatelessWidget {
  final ThemeMode mode;
  final VoidCallback onTap;

  const ThemeModeToggle({super.key, required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String tooltip) = switch (mode) {
      ThemeMode.system => (
          Icons.brightness_auto_outlined,
          CoreConst.themeModeSystemTooltip,
        ),
      ThemeMode.light => (
          Icons.light_mode_outlined,
          CoreConst.themeModeLightTooltip,
        ),
      ThemeMode.dark => (
          Icons.dark_mode_outlined,
          CoreConst.themeModeDarkTooltip,
        ),
    };

    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      tooltip: tooltip,
    );
  }
}
