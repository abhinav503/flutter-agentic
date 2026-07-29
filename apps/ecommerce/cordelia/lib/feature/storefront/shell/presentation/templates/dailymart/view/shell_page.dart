import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/presentation/bloc/checkout_bloc.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/templates/dailymart/view/cart_screen.dart';
import 'package:cordelia/feature/storefront/cart/presentation/templates/dailymart/widgets/cart_status_bar.dart';
import 'package:cordelia/feature/storefront/home/presentation/bloc/home_bloc.dart';
import 'package:cordelia/feature/storefront/home/presentation/templates/dailymart/view/home_screen.dart';
import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc.dart';
import 'package:cordelia/feature/storefront/shell/presentation/storefront_shell.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';

/// `dailymart` template's nav shell. Four tabs — Home, Wishlist, Cart,
/// Profile — in the kit's own order; note the cart **is** a tab here, unlike
/// `gravia`, where it's a docked status bar above a five-tab set.
///
/// Only Home is ported so far; the other three render an [EmptyState] rather
/// than borrowing gravia's screens, which would mix two packs' visual
/// languages on one nav bar. Each lands with its own
/// `presentation/templates/dailymart/` screen.
class ShellPage extends StorefrontShellPage {
  // Nav-tab indices — public so a route outside the shell can request a tab
  // by name instead of a magic number. Order matches _tabs.
  static const homeTabIndex = 0;
  static const wishlistTabIndex = 1;
  static const cartTabIndex = 2;
  static const profileTabIndex = 3;

  const ShellPage({super.key, super.initialTab = homeTabIndex});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends BasePageState<ShellPage>
    with StorefrontShellState {
  /// Built per frame rather than held `static const`: the Home glyph needs
  /// to know whether its own tab is selected (see below), which a const list
  /// can't see.
  List<BottomNavBarItem> _tabs() => [
    BottomNavBarItem(
      iconBuilder: (color, size) => AppSvgImage.asset(
        DailyMartImageConst.navHome,
        // The kit only ships home's *active* glyph: a filled green house
        // with a white smile cut into it. An `srcIn` tint repaints the
        // smile too and flattens it into a solid block, so while active it
        // renders untinted (its own brand green already matches
        // `cs.primary`) and only the inactive state — which the kit never
        // draws — takes the nav's grey.
        color: currentTab == ShellPage.homeTabIndex ? null : color,
        width: size,
        height: size,
      ),
      label: DailyMartValueConst.navHome,
    ),
    BottomNavBarItem(
      iconBuilder: svgNavIcon(
        currentTab == ShellPage.wishlistTabIndex
            ? DailyMartImageConst.heartFilled
            : DailyMartImageConst.navWishlist,
      ),
      label: DailyMartValueConst.navWishlist,
    ),
    BottomNavBarItem(
      iconBuilder: svgNavIcon(DailyMartImageConst.navCart),
      label: DailyMartValueConst.navCart,
    ),
    BottomNavBarItem(
      iconBuilder: svgNavIcon(DailyMartImageConst.navProfile),
      label: DailyMartValueConst.navProfile,
    ),
  ];

  /// This pack has no app bar on any screen: every screen builds its own
  /// header row as the first item of its scroll view (spec sheet §8).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// Shared above the tabs because Home's header renders the shopper's name
  /// and avatar, and the Profile tab will read the same profile — one fetch,
  /// cache-first, instead of one per screen.
  ///
  /// CheckoutBloc sits here too, not inside the Cart tab's own subtree: the
  /// shell rebuilds each tab's providers fresh on every switch, so a bloc
  /// created per-tab would be disposed — success listener and all — if the
  /// shopper switched tabs while an order was mid-flight. It's lazy, so it
  /// only instantiates when the Cart tab first reads it.
  @override
  Widget buildBlocProviders(Widget child) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) =>
            ProfileBloc(getProfileUseCase: sl())
              ..add(const ProfileEvent.started()),
      ),
      BlocProvider(
        create: (context) => CheckoutBloc(
          createPaymentUseCase: sl(),
          processPaymentUseCase: sl(),
          createOrderUseCase: sl(),
          storeId: context.read<ActiveStoreCubit>().state!.storeId,
        ),
      ),
    ],
    child: child,
  );

  @override
  Widget? buildBottomNav(BuildContext context) => BottomNavBar(
    variant: BottomNavBarVariant.stacked,
    items: _tabs(),
    currentIndex: currentTab,
    onTap: onTabSelected,
    topBorderColor: context.appColors.dockedHairline,
    // The kit's bar lifts off the content with a soft upward shadow as well
    // as the hairline — both, not either.
    shadows: DailyMartElevation.nav,
  );

  @override
  Widget buildBody(BuildContext context) {
    // `!`: the shell only renders inside a mounted StorefrontPage, which
    // seeds the cubit before its first build.
    final storeId = context.read<ActiveStoreCubit>().state!.storeId;

    final content = switch (currentTab) {
      ShellPage.homeTabIndex => BlocProvider(
        create: (_) =>
            HomeBloc(getHomeUseCase: sl(), storeId: storeId)
              ..add(HomeEvent.started(storeId: storeId)),
        child: const HomeScreen(),
      ),
      ShellPage.wishlistTabIndex => _NotPortedYet(
        icon: Icons.favorite_border_rounded,
        tab: DailyMartValueConst.navWishlist,
        onBackToHome: _goHome,
      ),
      // The cart's items live in the app-root CartCubit and checkout in the
      // shell-level CheckoutBloc (see buildBlocProviders) — nothing to
      // provide per-tab.
      // showBack: false — a tab root has nowhere to pop; onBack still serves
      // the empty state's Explore action and the order-placed continue.
      ShellPage.cartTabIndex => CartScreen(onBack: _goHome, showBack: false),
      _ => _NotPortedYet(
        icon: Icons.person_outline_rounded,
        tab: DailyMartValueConst.navProfile,
        onBackToHome: _goHome,
      ),
    };

    if (currentTab != ShellPage.homeTabIndex) return content;

    // Same idea as gravia's shell-level CartStatusBar: the pill lives in the
    // shell body, so pushed routes cover it and it reappears on pop with no
    // show/hide bookkeeping. The tab content keeps its slot (index 0) while
    // the overlay children toggle, so flipping the cart between empty and
    // non-empty never remounts Home's BlocProvider mid-session. Tapping it
    // switches to the Cart tab — dailymart's cart is a tab, not a route.
    return Stack(
      children: [
        Positioned.fill(child: content),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BlocBuilder<CartCubit, List<CartItemEntity>>(
            builder: (context, items) => items.isEmpty
                ? const SizedBox.shrink()
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Home scrolls on the mint canvas, not surface — the
                      // fade must dissolve into the colour actually behind it.
                      DailyMartBottomFade(
                        color: Theme.of(context).colorScheme.canvas,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: DailyMartCartStatusBar(
                          itemCount: items.itemCount,
                          grandTotal: items.grandTotal,
                          onTap: () => setState(
                            () => currentTab = ShellPage.cartTabIndex,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  void _goHome() => setState(() => currentTab = ShellPage.homeTabIndex);
}

/// Placeholder for a tab whose `dailymart` screen hasn't been built. A
/// designed empty state with a way out, not a blank tab — a dead end here
/// reads as a broken app rather than an unfinished one.
class _NotPortedYet extends StatelessWidget {
  final IconData icon;
  final String tab;
  final VoidCallback onBackToHome;

  const _NotPortedYet({
    required this.icon,
    required this.tab,
    required this.onBackToHome,
  });

  @override
  Widget build(BuildContext context) => EmptyState(
    iconData: icon,
    title: DailyMartValueConst.comingSoonTitle,
    subtitle: DailyMartValueConst.comingSoonSubtitle(tab),
    actions: [
      AppButton(
        label: DailyMartValueConst.comingSoonAction,
        variant: AppButtonVariant.secondary,
        onTap: onBackToHome,
      ),
    ],
  );
}
