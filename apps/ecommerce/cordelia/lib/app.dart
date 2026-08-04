import 'package:cordelia/feature/home/presentation/view/discovery_page.dart';
import 'package:cordelia/feature/storefront/address/domain/entities/address_entity.dart';
import 'package:cordelia/feature/storefront/address/presentation/templates/dailymart/view/address_form_page.dart'
    as dailymart_address_form;
import 'package:cordelia/feature/storefront/address/presentation/templates/grofast/view/address_form_page.dart'
    as grofast_address_form;
import 'package:cordelia/feature/storefront/address/presentation/templates/gravia/view/address_form_page.dart'
    as gravia_address_form;
// Every template names its Select Address entry `AddressPage` (the class
// name belongs to the role, not the pack), so both need a prefix to be
// dispatched from one StorefrontTemplateSwitch — same as Notifications below.
import 'package:cordelia/feature/storefront/address/presentation/templates/dailymart/view/address_page.dart'
    as dailymart_address;
import 'package:cordelia/feature/storefront/address/presentation/templates/grofast/view/address_page.dart'
    as grofast_address;
import 'package:cordelia/feature/storefront/address/presentation/templates/gravia/view/address_page.dart'
    as gravia_address;
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/coupon_cubit.dart';
// Cart/Search/Product Details follow the Notifications pattern below: every
// template names the entry class the same, so each needs a prefix to be
// dispatched from one StorefrontTemplateSwitch.
import 'package:cordelia/feature/storefront/cart/presentation/templates/dailymart/view/cart_page.dart'
    as dailymart_cart;
import 'package:cordelia/feature/storefront/cart/presentation/templates/grofast/view/cart_page.dart'
    as grofast_cart;
import 'package:cordelia/feature/storefront/cart/presentation/templates/gravia/view/cart_page.dart'
    as gravia_cart;
import 'package:cordelia/feature/storefront/category_details/presentation/templates/dailymart/view/category_details_page.dart'
    as dailymart_category_details;
import 'package:cordelia/feature/storefront/category_details/presentation/templates/grofast/view/category_details_page.dart'
    as grofast_category_details;
import 'package:cordelia/feature/storefront/category_details/presentation/templates/gravia/view/category_details_page.dart'
    as gravia_category_details;
import 'package:cordelia/feature/storefront/checkout/presentation/templates/dailymart/view/checkout_page.dart'
    as dailymart_checkout;
import 'package:cordelia/feature/storefront/checkout/presentation/templates/grofast/view/checkout_page.dart'
    as grofast_checkout;
import 'package:cordelia/feature/storefront/orders/domain/entities/order_entity.dart';
import 'package:cordelia/feature/storefront/orders/presentation/templates/dailymart/view/orders_page.dart'
    as dailymart_orders;
import 'package:cordelia/feature/storefront/orders/presentation/templates/grofast/view/orders_page.dart'
    as grofast_orders;
import 'package:cordelia/feature/storefront/orders/presentation/templates/dailymart/view/track_order_page.dart'
    as dailymart_track_order;
import 'package:cordelia/feature/storefront/orders/presentation/templates/gravia/view/orders_page.dart'
    as gravia_orders;
import 'package:cordelia/feature/storefront/orders/presentation/templates/gravia/view/track_order_page.dart'
    as gravia_track_order;
import 'package:cordelia/feature/storefront/orders/presentation/templates/grofast/view/track_order_page.dart'
    as grofast_track_order;
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/templates/grofast/view/favourites_page.dart'
    as grofast_favourites;
// Every template names its Notifications entry `NotificationsPage` (the class
// name belongs to the role, not the pack), so both need a prefix to be
// dispatched from one StorefrontTemplateSwitch.
import 'package:cordelia/feature/storefront/notifications/presentation/templates/dailymart/view/notifications_page.dart'
    as dailymart_notifications;
import 'package:cordelia/feature/storefront/notifications/presentation/templates/grofast/view/notifications_page.dart'
    as grofast_notifications;
import 'package:cordelia/feature/storefront/notifications/presentation/templates/gravia/view/notifications_page.dart'
    as gravia_notifications;
import 'package:cordelia/feature/storefront/product_details/presentation/templates/dailymart/view/product_details_page.dart'
    as dailymart_product_details;
import 'package:cordelia/feature/storefront/product_details/presentation/templates/grofast/view/product_details_page.dart'
    as grofast_product_details;
import 'package:cordelia/feature/storefront/product_details/presentation/templates/gravia/view/product_details_page.dart'
    as gravia_product_details;
import 'package:cordelia/feature/storefront/profile/domain/entities/profile_entity.dart';
import 'package:cordelia/feature/storefront/profile/presentation/templates/dailymart/view/change_password_page.dart'
    as dailymart_change_password;
import 'package:cordelia/feature/storefront/profile/presentation/templates/grofast/view/change_password_page.dart'
    as grofast_change_password;
import 'package:cordelia/feature/storefront/profile/presentation/templates/gravia/view/change_password_page.dart'
    as gravia_change_password;
import 'package:cordelia/feature/storefront/profile/presentation/templates/dailymart/view/edit_profile_page.dart'
    as dailymart_edit_profile;
import 'package:cordelia/feature/storefront/profile/presentation/templates/grofast/view/edit_profile_page.dart'
    as grofast_edit_profile;
import 'package:cordelia/feature/storefront/profile/presentation/templates/gravia/view/edit_profile_page.dart'
    as gravia_edit_profile;
import 'package:cordelia/feature/storefront/search/presentation/templates/dailymart/view/search_page.dart'
    as dailymart_search;
import 'package:cordelia/feature/storefront/search/presentation/templates/grofast/view/search_page.dart'
    as grofast_search;
import 'package:cordelia/feature/storefront/search/presentation/templates/gravia/view/search_page.dart'
    as gravia_search;
import 'package:cordelia/feature/storefront/template/storefront_template_switch.dart';
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
import 'feature/auth/presentation/bloc/auth_bloc.dart'
    show kPendingEmailVerificationPrefKey;
import 'feature/auth/presentation/view/login_page.dart';
import 'feature/auth/presentation/view/signup_page.dart';
import 'feature/legal/presentation/view/legal_document_content.dart';
// Same per-template prefixing as Notifications/Cart above — the legal
// document screen is app-level copy rendered in the active store's pack.
import 'feature/legal/presentation/templates/dailymart/view/legal_document_page.dart'
    as dailymart_legal;
import 'feature/legal/presentation/templates/grofast/view/legal_document_page.dart'
    as grofast_legal;
import 'feature/legal/presentation/templates/gravia/view/legal_document_page.dart'
    as gravia_legal;
import 'feature/onboarding/presentation/view/onboarding_page.dart';
import 'feature/splash/presentation/view/splash_page.dart';
import 'feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'feature/storefront/presentation/view/storefront_page.dart';
import 'services/firebase_auth_service.dart';
import 'services/user_profile_cache_service.dart';
import 'theme/active_theme_controller.dart';
import 'theme/active_theme_scope.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, _) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.discovery,
      builder: (context, _) => const DiscoveryPage(),
      routes: [
        // Nested (not top-level) so `context.go(AppRoutes.storefront, …)` —
        // the tab-jump mechanism Cart/Profile/Home use — rebuilds the stack
        // as [Discovery, Storefront] instead of leaving Storefront with
        // nothing beneath it to pop back to.
        GoRoute(
          path: AppRoutes.storefrontSubPath,
          builder: (context, state) {
            final args = state.extra as StorefrontRouteArgs;
            return StorefrontPage(
              store: args.store,
              initialTab: args.initialTab,
            );
          },
        ),
      ],
    ),
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
        // Also reachable from Signup, i.e. outside any storefront — the
        // switch's documented `null` fallback lands on gravia there, the
        // same default an unknown `template_id` takes.
        child: StorefrontTemplateSwitch(
          gravia: (_) => gravia_legal.LegalDocumentPage(
            content: LegalDocumentContent.termsAndConditions(),
          ),
          dailymart: (_) => dailymart_legal.LegalDocumentPage(
            content: LegalDocumentContent.termsAndConditions(),
          ),
          grofast: (_) => grofast_legal.LegalDocumentPage(
            content: LegalDocumentContent.termsAndConditions(),
          ),
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
        child: StorefrontTemplateSwitch(
          gravia: (_) => gravia_legal.LegalDocumentPage(
            content: LegalDocumentContent.privacyPolicy(),
          ),
          dailymart: (_) => dailymart_legal.LegalDocumentPage(
            content: LegalDocumentContent.privacyPolicy(),
          ),
          grofast: (_) => grofast_legal.LegalDocumentPage(
            content: LegalDocumentContent.privacyPolicy(),
          ),
        ),
      ),
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
        child: StorefrontTemplateSwitch(
          gravia: (_) =>
              gravia_search.SearchPage(storeId: state.extra as String),
          dailymart: (_) =>
              dailymart_search.SearchPage(storeId: state.extra as String),
          grofast: (_) =>
              grofast_search.SearchPage(storeId: state.extra as String),
        ),
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
        child: StorefrontTemplateSwitch(
          gravia: (_) => gravia_product_details.ProductDetailsPage(
            storeId: state.extra as String,
            productId: state.pathParameters['id']!,
          ),
          dailymart: (_) => dailymart_product_details.ProductDetailsPage(
            storeId: state.extra as String,
            productId: state.pathParameters['id']!,
          ),
          grofast: (_) => grofast_product_details.ProductDetailsPage(
            storeId: state.extra as String,
            productId: state.pathParameters['id']!,
          ),
        ),
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
        child: StorefrontTemplateSwitch(
          gravia: (_) => const gravia_address.AddressPage(),
          dailymart: (_) => const dailymart_address.AddressPage(),
          grofast: (_) => const grofast_address.AddressPage(),
        ),
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
        child: StorefrontTemplateSwitch(
          gravia: (_) => gravia_address_form.AddressFormPage(
            address: state.extra as AddressEntity?,
          ),
          dailymart: (_) => dailymart_address_form.AddressFormPage(
            address: state.extra as AddressEntity?,
          ),
          grofast: (_) => grofast_address_form.AddressFormPage(
            address: state.extra as AddressEntity?,
          ),
        ),
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
        child: StorefrontTemplateSwitch(
          gravia: (_) => gravia_edit_profile.EditProfilePage(
            profile: state.extra as ProfileEntity,
          ),
          dailymart: (_) => dailymart_edit_profile.EditProfilePage(
            profile: state.extra as ProfileEntity,
          ),
          grofast: (_) => grofast_edit_profile.EditProfilePage(
            profile: state.extra as ProfileEntity,
          ),
        ),
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
        child: StorefrontTemplateSwitch(
          gravia: (_) => const gravia_change_password.ChangePasswordPage(),
          dailymart: (_) =>
              const dailymart_change_password.ChangePasswordPage(),
          grofast: (_) => const grofast_change_password.ChangePasswordPage(),
        ),
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
        child: StorefrontTemplateSwitch(
          gravia: (_) => gravia_category_details.CategoryDetailsPage(
            storeId: state.extra as String,
            categoryId: state.pathParameters['id']!,
            categoryName: state.uri.queryParameters['name'] ?? '',
          ),
          dailymart: (_) => dailymart_category_details.CategoryDetailsPage(
            storeId: state.extra as String,
            categoryId: state.pathParameters['id']!,
            categoryName: state.uri.queryParameters['name'] ?? '',
          ),
          grofast: (_) => grofast_category_details.CategoryDetailsPage(
            storeId: state.extra as String,
            categoryId: state.pathParameters['id']!,
            categoryName: state.uri.queryParameters['name'] ?? '',
          ),
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
        child: StorefrontTemplateSwitch(
          gravia: (_) => gravia_cart.CartPage(storeId: state.extra as String),
          // No storeId: this template's Cart places no order, so it needs
          // nothing store-scoped — Checkout resolves the store itself.
          dailymart: (_) => const dailymart_cart.CartPage(),
          // Same as dailymart: this template's Bag places no order, so it
          // needs nothing store-scoped — Checkout resolves the store itself.
          grofast: (_) => const grofast_cart.CartPage(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.checkout,
      // Fade, same reasoning as the Cart route it's pushed from — both sit
      // on the same surface canvas.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        // `gravia`'s Cart still runs the flow inline and never pushes here,
        // so its branch is unreachable — it maps to `dailymart`'s page rather
        // than existing as a fourth checkout screen nobody opens.
        child: StorefrontTemplateSwitch(
          gravia: (_) => dailymart_checkout.CheckoutPage(
            address: state.extra as AddressEntity,
          ),
          dailymart: (_) => dailymart_checkout.CheckoutPage(
            address: state.extra as AddressEntity,
          ),
          grofast: (_) => grofast_checkout.CheckoutPage(
            address: state.extra as AddressEntity,
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      // Fade, same reasoning as Cart/Select Address — this screen shares the
      // back-button position with the screen it is pushed from, so a
      // horizontal push would visibly slide one over the other.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: StorefrontTemplateSwitch(
          gravia: (_) => const gravia_notifications.NotificationsPage(),
          dailymart: (_) => const dailymart_notifications.NotificationsPage(),
          grofast: (_) => const grofast_notifications.NotificationsPage(),
        ),
      ),
    ),
    // `grofast` only: that template opens its wishlist from Profile rather
    // than from a nav tab, so it needs a route where the other two don't —
    // their branches map to grofast's page, which they never reach.
    GoRoute(
      path: AppRoutes.wishlist,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: StorefrontTemplateSwitch(
          gravia: (_) => const grofast_favourites.FavouritesPage(),
          dailymart: (_) => const grofast_favourites.FavouritesPage(),
          grofast: (_) => const grofast_favourites.FavouritesPage(),
        ),
      ),
    ),
    // My Orders and Track Order: gravia reaches the same list through a shell
    // tab and has no Track Order screen at all, so its branch maps to
    // `dailymart`'s page (unreachable) rather than existing separately — same
    // shape as the checkout route above.
    GoRoute(
      path: AppRoutes.orders,
      // Fade, same reasoning as Select Address — pushed from a screen that
      // puts its back disc in the same place.
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: StorefrontTemplateSwitch(
          gravia: (_) => const gravia_orders.OrdersPage(),
          dailymart: (_) => const dailymart_orders.OrdersPage(),
          grofast: (_) => const grofast_orders.OrdersPage(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.trackOrder,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            ),
        child: StorefrontTemplateSwitch(
          gravia: (_) => gravia_track_order.TrackOrderPage(
            order: state.extra as OrderEntity,
          ),
          dailymart: (_) => dailymart_track_order.TrackOrderPage(
            order: state.extra as OrderEntity,
          ),
          grofast: (_) => grofast_track_order.TrackOrderPage(
            order: state.extra as OrderEntity,
          ),
        ),
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
    FirebaseAuthService.instance.sessionExpired.removeListener(_handleExpired);
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
  Widget build(BuildContext context) => widget.child ?? const SizedBox.shrink();
}

class App extends StatefulWidget {
  final AppThemeConfig themeConfig;

  const App({super.key, this.themeConfig = AppThemeConfig.defaults});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ThemeModeController _themeMode = ThemeModeController()..load();
  late final ActiveThemeController _activeTheme = ActiveThemeController(
    widget.themeConfig,
  );

  // Shared across the whole app (Home, Product Details, Search, Cart/
  // Favourite tab) — see CartCubit/FavouritesCubit's own class docs for why:
  // Product Details/Cart/Search are separate GoRouter pages, not descendants
  // of one shell, so these must live above the router, not inside any page.
  late final CartCubit _cartCubit = CartCubit(
    getCartUseCase: sl(),
    saveCartUseCase: sl(),
  );
  // Beside CartCubit for the same reason: the promo row (Cart) and the flow
  // that consumes the code (Checkout) are separate GoRouter pages.
  late final CouponCubit _couponCubit = CouponCubit(
    validateCouponUseCase: sl(),
  );
  late final FavouritesCubit _favouritesCubit = FavouritesCubit(
    getFavouritesUseCase: sl(),
    addFavouriteUseCase: sl(),
    removeFavouriteUseCase: sl(),
  );

  // App-level for the same reason as the cubits above — Cart/Product
  // Details/Search are separate GoRouter pages, not descendants of the
  // storefront subtree, yet still need the active store's identity.
  // StorefrontPage seeds/clears it per store visit.
  final ActiveStoreCubit _activeStoreCubit = ActiveStoreCubit();

  @override
  void dispose() {
    _themeMode.dispose();
    _activeTheme.dispose();
    _cartCubit.close();
    _couponCubit.close();
    _favouritesCubit.close();
    _activeStoreCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cartCubit),
        BlocProvider.value(value: _couponCubit),
        BlocProvider.value(value: _favouritesCubit),
        BlocProvider.value(value: _activeStoreCubit),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: _themeMode,
        builder: (context, mode, _) => ValueListenableBuilder<AppThemeConfig>(
          valueListenable: _activeTheme,
          builder: (context, themeConfig, _) => ThemeModeScope(
            controller: _themeMode,
            child: ActiveThemeScope(
              controller: _activeTheme,
              child: MaterialApp.router(
                title: ValueConst.appTitle,
                routerConfig: _router,
                theme: AppTheme.fromConfig(themeConfig),
                darkTheme: AppTheme.fromConfig(themeConfig, dark: true),
                themeMode: mode,
                scaffoldMessengerKey: _scaffoldMessengerKey,
                builder: (context, child) => _SessionExpiredGuard(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
