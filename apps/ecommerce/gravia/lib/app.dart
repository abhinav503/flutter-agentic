import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:core/core/theme/theme_mode_controller.dart';
import 'package:core/core/theme/theme_mode_scope.dart';

import 'constants/app_routes.dart';
import 'constants/value_const.dart';
import 'di/injection_container.dart';
import 'feature/address/domain/entities/address_entity.dart';
import 'feature/address/presentation/view/address_form_page.dart';
import 'feature/address/presentation/view/address_page.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart'
    show kPendingEmailVerificationPrefKey;
import 'feature/auth/presentation/view/login_page.dart';
import 'feature/auth/presentation/view/signup_page.dart';
import 'feature/cart/presentation/cubit/cart_cubit.dart';
import 'feature/cart/presentation/view/cart_page.dart';
import 'feature/category_details/presentation/view/category_details_page.dart';
import 'feature/legal/presentation/view/legal_document_content.dart';
import 'feature/legal/presentation/view/legal_document_page.dart';
import 'feature/notifications/presentation/view/notifications_page.dart';
import 'feature/onboarding/presentation/view/onboarding_page.dart';
import 'feature/product_details/presentation/view/product_details_page.dart';
import 'feature/profile/domain/entities/profile_entity.dart';
import 'feature/profile/presentation/view/change_password_page.dart';
import 'feature/profile/presentation/view/edit_profile_page.dart';
import 'feature/search/presentation/view/search_page.dart';
import 'feature/shell/presentation/view/shell_page.dart';
import 'feature/splash/presentation/view/splash_page.dart';
import 'services/firebase_auth_service.dart';
import 'services/user_profile_cache_service.dart';

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
    GoRoute(path: AppRoutes.login, builder: (context, _) => const LoginPage()),
    GoRoute(
      path: AppRoutes.signup,
      // Fade, same reasoning as Product Details/Cart — Login and Signup
      // share the same primary canvas colour, so a horizontal push would
      // visibly overlap the headers' back buttons mid-flight.
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
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) =>
          ShellPage(initialTab: state.extra as int? ?? 0),
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
      path: AppRoutes.addressForm,
      // Fade, same reasoning as Select Address — they share the same
      // primary canvas colour and back-button position.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: AddressFormPage(address: state.extra as AddressEntity?),
      ),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      // Fade, same reasoning as Select Address/Address form.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: EditProfilePage(profile: state.extra as ProfileEntity),
      ),
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      // Fade, same reasoning as Edit Profile/Select Address.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: const ChangePasswordPage(),
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
    GoRoute(
      path: AppRoutes.cart,
      // Fade, same reasoning as the Select Address route — Home/Categories
      // and Cart share the same primary canvas colour, so a horizontal push
      // would visibly overlap the headers' back buttons mid-flight.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: const CartPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      // Fade, same reasoning as Cart/Select Address — this screen's coloured
      // header canvas shares the back-button position every other "coloured
      // header canvas" screen uses.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: const NotificationsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.termsAndConditions,
      // Fade, same reasoning as the other coloured-header-canvas routes.
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
      // Fade, same reasoning as the other coloured-header-canvas routes.
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
/// "something went wrong" with an endless, always-failing Retry (see
/// `FirebaseAuthService.idToken`/`sessionExpired`).
///
/// Lives at `MaterialApp.router`'s `builder`, above the Navigator, so it can
/// unconditionally `_router.go()` regardless of which page is currently
/// showing, and uses `_scaffoldMessengerKey` (not `context`) for the
/// snackbar since this level has no `Scaffold` of its own.
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
    // CartCubit lives here, above the router, rather than in ShellPage's
    // buildBlocProviders — Product Details, Search, and Cart itself are
    // separate GoRouter pages (siblings of ShellPage in the root Navigator),
    // so a shell-scoped provider wouldn't reach them.
    return BlocProvider(
      create: (_) => CartCubit(getCartUseCase: sl(), saveCartUseCase: sl()),
      child: ValueListenableBuilder<ThemeMode>(
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
      ),
    );
  }
}
