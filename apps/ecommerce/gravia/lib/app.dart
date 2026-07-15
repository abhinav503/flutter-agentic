import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/theme/theme_mode_controller.dart';
import 'package:core/core/theme/theme_mode_scope.dart';

import 'constants/app_routes.dart';
import 'constants/value_const.dart';
import 'feature/address/presentation/view/address_page.dart';
import 'feature/category_details/presentation/view/category_details_page.dart';
import 'feature/onboarding/presentation/view/onboarding_page.dart';
import 'feature/product_details/presentation/view/product_details_page.dart';
import 'feature/search/presentation/view/search_page.dart';
import 'feature/shell/presentation/view/shell_page.dart';
import 'feature/splash/presentation/view/splash_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, _) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, _) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, _) => const ShellPage(),
    ),
    GoRoute(
      path: AppRoutes.search,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: const SearchPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.productDetails,
      // Fade, not the default slide — every "coloured header canvas" screen
      // (design.md) places its back button in roughly the same spot, so a
      // horizontal push visibly overlaps the outgoing and incoming back
      // buttons mid-flight. Same fix as the Search route.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: ProductDetailsPage(productId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: AppRoutes.selectAddress,
      // Fade, same reasoning as the Search route — Home and this screen
      // share the same primary canvas colour, so a horizontal push would
      // visibly overlap the two headers' back/location controls mid-flight.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: const AddressPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.categoryDetails,
      // Fade, same reasoning as the Product Details route above.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: CategoryDetailsPage(
          categoryId: state.pathParameters['id']!,
          categoryName: state.uri.queryParameters['name'] ?? '',
        ),
      ),
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
