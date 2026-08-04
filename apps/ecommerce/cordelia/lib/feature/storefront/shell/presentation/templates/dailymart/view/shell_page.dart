import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';

import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/templates/dailymart/view/cart_screen.dart';
import 'package:cordelia/feature/storefront/cart/presentation/templates/dailymart/widgets/cart_status_bar.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/templates/dailymart/view/favourites_screen.dart';
import 'package:cordelia/feature/storefront/home/presentation/bloc/home_bloc_provider.dart';
import 'package:cordelia/feature/storefront/home/presentation/templates/dailymart/view/home_screen.dart';
import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc_provider.dart';
import 'package:cordelia/feature/storefront/profile/presentation/templates/dailymart/view/profile_screen.dart';
import 'package:cordelia/feature/storefront/shell/presentation/storefront_shell.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';

/// `dailymart` template's nav shell. Four tabs — Home, Wishlist, Cart,
/// Profile — in the kit's own order; note the cart **is** a tab here, unlike
/// `gravia`, where it's a docked status bar above a five-tab set. Every tab
/// renders this pack's own screen.
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
      // The kit only ships home's *active* glyph: a filled green house with
      // a white smile cut into it. An `srcIn` tint repaints the smile too
      // and flattens it into a solid block, so active renders that export
      // untinted (its own brand green already matches `cs.primary`) and
      // inactive swaps to the stroke-only redraw, which takes the nav's grey
      // like every other tab. Same filled/outline pair as Wishlist below.
      iconBuilder: currentTab == ShellPage.homeTabIndex
          ? (color, size) => AppSvgImage.asset(
              DailyMartImageConst.navHome,
              width: size,
              height: size,
            )
          : svgNavIcon(DailyMartImageConst.navHomeOutline),
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
      iconBuilder: svgNavIcon(
        currentTab == ShellPage.cartTabIndex
            ? DailyMartImageConst.navCartSolid
            : DailyMartImageConst.navCart,
      ),
      label: DailyMartValueConst.navCart,
    ),
    BottomNavBarItem(
      iconBuilder: svgNavIcon(
        currentTab == ShellPage.profileTabIndex
            ? DailyMartImageConst.navProfileSolid
            : DailyMartImageConst.navProfile,
      ),
      label: DailyMartValueConst.navProfile,
    ),
  ];

  /// This pack has no app bar on any screen: every screen builds its own
  /// header row as the first item of its scroll view (spec sheet §8).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// Shared above the tabs because Home's header renders the shopper's name
  /// and avatar, and the Profile tab will read the same profile — one fetch,
  /// cache-first, instead of one per screen. (CheckoutBloc used to live here
  /// too; it moved to `checkout/…/dailymart/view/checkout_page.dart` when
  /// checkout became its own routed page.)
  @override
  Widget buildBlocProviders(Widget child) => profileBlocProvider(child: child);

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
      ShellPage.homeTabIndex => homeBlocProvider(
        storeId: storeId,
        child: const HomeScreen(),
      ),
      // The favourites live in the app-root FavouritesCubit, hydrated by
      // StorefrontShellState — nothing to provide per-tab.
      ShellPage.wishlistTabIndex => FavouritesScreen(onExplore: _goHome),
      // The cart's items live in the app-root CartCubit — nothing to provide
      // per-tab (checkout runs on its own routed page with its own bloc).
      // showBack: false — a tab root has nowhere to pop; onBack still serves
      // the empty state's Explore action and the order-placed continue.
      ShellPage.cartTabIndex => CartScreen(onBack: _goHome, showBack: false),
      // ProfileBloc is shell-level (see buildBlocProviders) — Home's header
      // reads the same profile, so there's nothing to provide per-tab.
      _ => const ProfileScreen(),
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
