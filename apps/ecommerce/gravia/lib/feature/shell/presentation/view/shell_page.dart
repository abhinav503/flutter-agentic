import 'package:core/core/base/base_page.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/theme_mode_scope.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/atoms/theme_mode_toggle.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';
import 'package:core/core/ui/blocks/docked_bar_overlap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/di/injection_container.dart';
import 'package:gravia/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:gravia/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:gravia/feature/cart/presentation/widgets/cart_status_bar.dart';
import 'package:gravia/feature/categories/presentation/bloc/categories_bloc.dart';
import 'package:gravia/feature/categories/presentation/view/categories_screen.dart';
import 'package:gravia/feature/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:gravia/feature/favourites/presentation/view/favourites_screen.dart';
import 'package:gravia/feature/home/presentation/bloc/home_bloc.dart';
import 'package:gravia/feature/home/presentation/view/home_screen.dart';
import 'package:gravia/feature/orders/presentation/bloc/orders_bloc.dart';
import 'package:gravia/feature/orders/presentation/view/orders_screen.dart';
import 'package:gravia/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:gravia/feature/profile/presentation/view/profile_screen.dart';
import 'package:gravia/widgets/gravia_sheet.dart';

class ShellPage extends BasePage {
  // Nav-tab indices — public so any route outside the shell can request a
  // tab by name instead of a hardcoded magic number. Order matches _tabs.
  static const homeTabIndex = 0;
  static const categoriesTabIndex = 1;
  static const favouriteTabIndex = 2;
  static const ordersTabIndex = 3;
  static const profileTabIndex = 4;

  /// Which tab to select. Read from the `/home` route's `extra` in
  /// `app.dart`, so any pushed screen can land on a specific tab with
  /// `context.go(AppRoutes.home, extra: ShellPage.ordersTabIndex)` — `go`
  /// (not `push`) so it also discards whatever was pushed on top of the
  /// shell, the same way "return to the tab bar" should. Tab choice is
  /// otherwise UI-local `setState` (see the tabbed-apps note in
  /// `docs/reference/architecture.md`); this is the one supported door in
  /// from outside, not a general shared-state mechanism.
  ///
  /// Because `ShellPage` stays mounted underneath any route pushed on top
  /// of it (that's what lets its BLoCs/cart badge survive Cart being
  /// pushed), `context.go('/home', ...)` back to an already-mounted shell
  /// updates this constructor arg on the *existing* State rather than
  /// creating a new one — `_ShellPageState.didUpdateWidget` is what
  /// actually reacts to that; a `late` field set once in `initState` would
  /// only catch the very first (cold-start) navigation to `/home`.
  final int initialTab;

  const ShellPage({super.key, this.initialTab = homeTabIndex});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends BasePageState<ShellPage> {
  late int _currentTab = widget.initialTab;
  bool _verifySheetOpen = false;

  @override
  void initState() {
    super.initState();
    // Shell is only reached once a session is confirmed (Splash routes
    // signed-out users to Login first), so this is the earliest safe place
    // to load the signed-in shopper's persisted cart — once per cold start
    // or fresh login, not on every tab switch (initState, not build).
    context.read<CartCubit>().hydrate();
    context.read<FavouritesCubit>().hydrate();
  }

  @override
  void didUpdateWidget(covariant ShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      setState(() => _currentTab = widget.initialTab);
    }
  }

  // A relaunch-while-unverified session lands here (Splash sends any signed-
  // in user straight to the shell, verified or not — see its own doc) rather
  // than back to Login, since the user genuinely does have a session; being
  // dropped on a "Welcome, log in" screen while already signed in would be
  // confusing. AuthBloc.started() (the same resume check Login/Signup use)
  // detects the still-pending case and re-opens the persistent verify sheet
  // on top of the shell instead. Nothing to do for every other outcome —
  // this is a resume check, not a live auth flow, so the listener only
  // reacts to awaitingVerification.
  @override
  Widget buildBlocProviders(Widget child) => BlocProvider(
    create: (_) => AuthBloc(
      signUpUseCase: sl(),
      signInUseCase: sl(),
      resendVerificationEmailUseCase: sl(),
      checkEmailVerifiedUseCase: sl(),
      forgotPasswordUseCase: sl(),
    )..add(const AuthEvent.started()),
    child: Builder(
      builder: (context) => BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAwaitingVerification) _openVerifySheet(state.email);
          if (state is AuthAuthenticated) _closeVerifySheet();
        },
        child: child,
      ),
    ),
  );

  Future<void> _openVerifySheet(String email) async {
    if (_verifySheetOpen) return;
    _verifySheetOpen = true;
    await showVerifyEmailSheet(
      context: context,
      email: email,
      onResend: () => context.read<AuthBloc>().add(
        const AuthEvent.resendVerificationRequested(),
      ),
    );
    _verifySheetOpen = false;
  }

  void _closeVerifySheet() {
    if (_verifySheetOpen && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      _verifySheetOpen = false;
    }
  }

  // Kit tab set: Home, Categories, Favourite, Orders (bag), Profile — the
  // cart is not a nav tab in this pack.
  static final _tabs = [
    BottomNavBarItem(
      iconBuilder: _navIcon(ImageConst.navHome),
      label: ValueConst.navHome,
    ),
    BottomNavBarItem(
      iconBuilder: _navIcon(ImageConst.navCategories),
      label: ValueConst.navCategories,
    ),
    BottomNavBarItem(
      iconBuilder: _navIcon(ImageConst.navFavourite),
      label: ValueConst.navFavourite,
    ),
    BottomNavBarItem(
      iconBuilder: _navIcon(ImageConst.navOrders),
      label: ValueConst.navOrders,
    ),
    BottomNavBarItem(
      iconBuilder: _navIcon(ImageConst.navProfile),
      label: ValueConst.navProfile,
    ),
  ];

  static Widget Function(Color, double) _navIcon(String asset) =>
      (color, size) =>
          AppSvgImage.asset(asset, color: color, width: size, height: size);

  // Explicit rather than relying on Scaffold's implicit default, which was
  // resolving to something other than the theme's actual surface colour —
  // it's the backdrop below each tab's coloured header canvas.
  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    // Every tab renders its own coloured hero header as part of the screen
    // body, per the pack's "coloured header canvas" composition — a generic
    // top bar on top of any of them would double up. Kept as a switch
    // (rather than always returning null) so a future tab without its own
    // header still gets one for free.
    if (_currentTab == ShellPage.homeTabIndex ||
        _currentTab == ShellPage.categoriesTabIndex ||
        _currentTab == ShellPage.favouriteTabIndex ||
        _currentTab == ShellPage.ordersTabIndex ||
        _currentTab == ShellPage.profileTabIndex) {
      return null;
    }

    final themeMode = ThemeModeScope.maybeOf(context);
    return AppTopBar.primary(
      title: ValueConst.appTitle,
      actions: [
        if (themeMode != null)
          ThemeModeToggle(mode: themeMode.value, onTap: themeMode.cycle),
      ],
      bottomBorderColor: Theme.of(context).extension<AppColorsExtension>()!.dockedHairline,
      bottomBorderWidth: 0.5,
    );
  }

  @override
  Widget? buildBottomNav(BuildContext context) => BottomNavBar(
    items: _tabs,
    currentIndex: _currentTab,
    onTap: (index) => setState(() => _currentTab = index),
    topBorderColor: Theme.of(context).extension<AppColorsExtension>()!.dockedHairline,
    topBorderWidth: 0.5,
    // Gray/500 in both modes per kit spec — same value doesn't come from
    // the (mode-differing) onSurfaceVariant role, so it's an explicit
    // override rather than a theme edit.
    inactiveIconColor: ColorConst.gray500,
  );

  @override
  Widget buildBody(BuildContext context) {
    final content = switch (_currentTab) {
      ShellPage.homeTabIndex => BlocProvider(
        create: (_) =>
            HomeBloc(getHomeUseCase: sl())..add(const HomeEvent.started()),
        child: const HomeScreen(),
      ),
      ShellPage.categoriesTabIndex => BlocProvider(
        create: (_) =>
            CategoriesBloc(getCategoriesUseCase: sl())
              ..add(const CategoriesEvent.started()),
        child: const CategoriesScreen(),
      ),
      ShellPage.favouriteTabIndex => const FavouritesScreen(),
      ShellPage.ordersTabIndex => BlocProvider(
        create: (_) =>
            OrdersBloc(getOrdersUseCase: sl())
              ..add(const OrdersEvent.started()),
        child: const OrdersScreen(),
      ),
      _ => BlocProvider(
        create: (_) =>
            ProfileBloc(getProfileUseCase: sl())
              ..add(const ProfileEvent.started()),
        child: const ProfileScreen(),
      ),
    };

    // Cart is not a nav tab (see _tabs above) — instead a persistent bar
    // docks above the bottom nav on Home/Categories whenever the shared cart
    // is non-empty. It lives in this shell's body (not a `SnackBar`), so it's
    // automatically hidden while Cart/Product Details/Search are pushed on
    // top and reappears on pop — no manual show/hide bookkeeping needed.
    if (_currentTab != ShellPage.homeTabIndex &&
        _currentTab != ShellPage.categoriesTabIndex) {
      return content;
    }

    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    // The bar always stays in the tree (empty cart → zero-height bar) so the
    // content subtree never moves to a different slot when the cart toggles
    // between empty and non-empty — a structural change there would remount
    // the tab's BlocProvider and re-fetch mid-session.
    return DockedBarOverlap(
      overlap: shapes.sheetRadius,
      bar: BlocBuilder<CartCubit, List<CartItemEntity>>(
        builder: (context, items) => items.isEmpty
            ? const SizedBox.shrink()
            : CartStatusBar(
                itemCount: items.itemCount,
                grandTotal: items.grandTotal,
                onTap: () => context.push(AppRoutes.cart),
                onClear: () => context.read<CartCubit>().clear(),
              ),
      ),
      child: content,
    );
  }
}
