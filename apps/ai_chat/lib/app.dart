import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';

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

class App extends StatelessWidget {
  final AppThemeConfig themeConfig;

  const App({super.key, this.themeConfig = AppThemeConfig.defaults});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: ValueConst.appTitle,
      routerConfig: _router,
      theme: AppTheme.fromConfig(themeConfig),
      darkTheme: AppTheme.fromConfig(themeConfig, dark: true),
      themeMode: ThemeMode.system,
    );
  }
}
