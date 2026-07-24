import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/theme/theme_mode_controller.dart';
import 'package:core/core/theme/theme_mode_scope.dart';

import 'constants/app_routes.dart';
import 'constants/value_const.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart'
    show kPendingEmailVerificationPrefKey;
import 'feature/auth/presentation/view/login_page.dart';
import 'feature/auth/presentation/view/signup_page.dart';
import 'feature/home/presentation/view/home_page.dart';
import 'feature/legal/presentation/view/legal_document_content.dart';
import 'feature/legal/presentation/view/legal_document_page.dart';
import 'feature/onboarding/presentation/view/onboarding_page.dart';
import 'feature/splash/presentation/view/splash_page.dart';
import 'feature/storefront/presentation/view/storefront_page.dart';
import 'services/firebase_auth_service.dart';
import 'services/user_profile_cache_service.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (context, _) => const SplashPage()),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, _) => const OnboardingPage(),
    ),
    GoRoute(path: AppRoutes.login, builder: (context, _) => const LoginPage()),
    GoRoute(
      path: AppRoutes.signup,
      // Fade, same reasoning as gravia's own Login/Signup — they share the
      // same primary canvas colour, so a horizontal push would visibly
      // overlap the headers' back buttons mid-flight.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: const SignupPage(),
      ),
    ),
    GoRoute(path: AppRoutes.home, builder: (context, _) => const HomePage()),
    GoRoute(
      path: AppRoutes.storefront,
      builder: (context, state) {
        final args = state.extra as ({String storeId, String storeName});
        return StorefrontPage(storeId: args.storeId, storeName: args.storeName);
      },
    ),
    GoRoute(
      path: AppRoutes.termsAndConditions,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: LegalDocumentPage(
          content: LegalDocumentContent.termsAndConditions(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: LegalDocumentPage(content: LegalDocumentContent.privacyPolicy()),
      ),
    ),
  ],
);

final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Wraps every routed page so a dead Firebase session — e.g. this device's
/// refresh token revoked by a password change/reset made elsewhere,
/// discovered the next time any feature's authenticated call reaches
/// `FirebaseAuthService.idToken()` — gets one consistent, app-wide reaction
/// instead of each screen independently rendering its own confusing
/// "something went wrong" with an endless, always-failing Retry. Ported
/// verbatim from gravia's `app.dart` — this stays app-wide (unlike the
/// verify-email sheet, which moved to `HomePage`, see its own doc) because a
/// dead session can be discovered from *any* authenticated call anywhere,
/// including a future storefront screen.
class _SessionExpiredGuard extends StatefulWidget {
  final Widget? child;

  const _SessionExpiredGuard({required this.child});

  @override
  State<_SessionExpiredGuard> createState() => _SessionExpiredGuardState();
}

class _SessionExpiredGuardState extends State<_SessionExpiredGuard> {
  @override
  void initState() {
    super.initState();
    FirebaseAuthService.instance.sessionExpired.addListener(_handleExpired);
  }

  @override
  void dispose() {
    FirebaseAuthService.instance.sessionExpired.removeListener(
      _handleExpired,
    );
    super.dispose();
  }

  Future<void> _handleExpired() async {
    await UserProfileCacheService.instance.clear();
    await SharedPreferenceService.instance.setBool(
      kPendingEmailVerificationPrefKey,
      false,
    );
    _scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text(ValueConst.sessionExpiredMessage)),
    );
    _router.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) =>
      widget.child ?? const SizedBox.shrink();
}

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
          scaffoldMessengerKey: _scaffoldMessengerKey,
          builder: (context, child) => _SessionExpiredGuard(child: child),
        ),
      ),
    );
  }
}
