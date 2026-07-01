import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/theme/theme_mode_controller.dart';
import 'package:core/core/theme/theme_mode_scope.dart';

import 'constants/value_const.dart';
import 'feature/home/presentation/view/home_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, _) => const HomePage(),
    ),
  ],
);

class App extends StatefulWidget {
  final AppThemeConfig themeConfig;

  const App({super.key, this.themeConfig = AppThemeConfig.defaults});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // Owns the app-wide, persisted theme mode; the AppBar toggle reaches it via
  // ThemeModeScope and advances it with cycle().
  final ThemeModeController _themeMode = ThemeModeController()..load();

  @override
  void dispose() {
    _themeMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeMode,
      builder: (context, mode, _) => ThemeModeScope(
        controller: _themeMode,
        child: MaterialApp.router(
          title: ValueConst.appTitle,
          routerConfig: _router,
          theme: AppTheme.fromConfig(widget.themeConfig),
          darkTheme: AppTheme.fromConfig(widget.themeConfig, dark: true),
          themeMode: mode,
        ),
      ),
    );
  }
}
