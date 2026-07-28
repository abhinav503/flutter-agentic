import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/presentation/bloc/home_bloc.dart';
import 'package:cordelia/feature/storefront/home/presentation/templates/dailymart/view/home_screen.dart';
import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

/// `dailymart` template's nav shell. Four tabs — Home, Wishlist, Cart,
/// Profile — in the kit's own order; note the cart **is** a tab here, unlike
/// `gravia`, where it's a docked status bar above a five-tab set.
///
/// Only Home is ported so far; the other three render an [EmptyState] rather
/// than borrowing gravia's screens, which would mix two packs' visual
/// languages on one nav bar. Each lands with its own
/// `presentation/templates/dailymart/` screen.
class ShellPage extends BasePage {
  // Nav-tab indices — public so a route outside the shell can request a tab
  // by name instead of a magic number. Order matches _tabs.
  static const homeTabIndex = 0;
  static const wishlistTabIndex = 1;
  static const cartTabIndex = 2;
  static const profileTabIndex = 3;

  /// Which tab to select, threaded from `StorefrontRouteArgs.initialTab`.
  /// See gravia's `ShellPage.initialTab` for why `didUpdateWidget` (not
  /// `initState`) is what reacts to it.
  final int initialTab;

  const ShellPage({super.key, this.initialTab = homeTabIndex});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends BasePageState<ShellPage> {
  late int _currentTab = widget.initialTab;

  @override
  void initState() {
    super.initState();
    // Earliest safe point to load the signed-in shopper's persisted cart and
    // favourites — once per store visit (a fresh ShellPage per StorefrontPage
    // mount), not on every tab switch.
    final storeId = context.read<ActiveStoreCubit>().state!.storeId;
    context.read<CartCubit>().hydrate(storeId);
    context.read<FavouritesCubit>().hydrate(storeId);
  }

  @override
  void didUpdateWidget(covariant ShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      setState(() => _currentTab = widget.initialTab);
    }
  }

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
        color: _currentTab == ShellPage.homeTabIndex ? null : color,
        width: size,
        height: size,
      ),
      label: DailyMartValueConst.navHome,
    ),
    BottomNavBarItem(
      iconBuilder: _navIcon(DailyMartImageConst.navWishlist),
      label: DailyMartValueConst.navWishlist,
    ),
    BottomNavBarItem(
      iconBuilder: _navIcon(DailyMartImageConst.navCart),
      label: DailyMartValueConst.navCart,
    ),
    BottomNavBarItem(
      iconBuilder: _navIcon(DailyMartImageConst.navProfile),
      label: DailyMartValueConst.navProfile,
    ),
  ];

  static Widget Function(Color, double) _navIcon(String asset) =>
      (color, size) =>
          AppSvgImage.asset(asset, color: color, width: size, height: size);

  /// Explicit rather than Scaffold's implicit default — each tab paints its
  /// own canvas, and this is the colour behind them (and behind an
  /// overscroll).
  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  /// This pack has no app bar on any screen: every screen builds its own
  /// header row as the first item of its scroll view (spec sheet §8).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// Shared above the tabs because Home's header renders the shopper's name
  /// and avatar, and the Profile tab will read the same profile — one fetch,
  /// cache-first, instead of one per screen.
  @override
  Widget buildBlocProviders(Widget child) => BlocProvider(
    create: (_) =>
        ProfileBloc(getProfileUseCase: sl())..add(const ProfileEvent.started()),
    child: child,
  );

  @override
  Widget? buildBottomNav(BuildContext context) => BottomNavBar(
    variant: BottomNavBarVariant.stacked,
    items: _tabs(),
    currentIndex: _currentTab,
    onTap: (index) => setState(() => _currentTab = index),
    topBorderColor: Theme.of(
      context,
    ).extension<AppColorsExtension>()!.dockedHairline,
    // The kit's bar lifts off the content with a soft upward shadow as well
    // as the hairline — both, not either.
    shadows: DailyMartElevation.nav,
  );

  @override
  Widget buildBody(BuildContext context) {
    // `!`: the shell only renders inside a mounted StorefrontPage, which
    // seeds the cubit before its first build.
    final storeId = context.read<ActiveStoreCubit>().state!.storeId;

    return switch (_currentTab) {
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
      ShellPage.cartTabIndex => _NotPortedYet(
        icon: Icons.shopping_bag_outlined,
        tab: DailyMartValueConst.navCart,
        onBackToHome: _goHome,
      ),
      _ => _NotPortedYet(
        icon: Icons.person_outline_rounded,
        tab: DailyMartValueConst.navProfile,
        onBackToHome: _goHome,
      ),
    };
  }

  void _goHome() => setState(() => _currentTab = ShellPage.homeTabIndex);
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
