import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_config.dart';
import 'feature/jokes/presentation/view/jokes_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, _) => const JokesPage(),
    ),
  ],
);

class App extends StatelessWidget {
  final AppThemeConfig themeConfig;

  const App({super.key, this.themeConfig = AppThemeConfig.defaults});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cordelia Base',
      routerConfig: _router,
      theme: AppTheme.fromConfig(themeConfig),
      darkTheme: AppTheme.fromConfig(themeConfig, dark: true),
      themeMode: ThemeMode.system,
    );
  }
}
