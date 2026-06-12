import 'package:flutter/material.dart';
import 'package:flutter_agentic/feature/jokes/presentation/view/jokes_page.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_config.dart';
import 'feature/doc_scanner/presentation/view/doc_scanner_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, _) => const DocScannerPage(),
    ),
    GoRoute(
      path: '/scan',
      builder: (context, _) => const DocScannerPage(),
    ),
  ],
);

class App extends StatelessWidget {
  final AppThemeConfig themeConfig;

  const App({super.key, this.themeConfig = AppThemeConfig.defaults});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FlutterAgentic',
      routerConfig: _router,
      theme: AppTheme.fromConfig(themeConfig),
      darkTheme: AppTheme.fromConfig(themeConfig, dark: true),
      themeMode: ThemeMode.system,
    );
  }
}
