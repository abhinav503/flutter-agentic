import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/di/injection_container.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/templates/grofast/view/cart_screen.dart';
import 'package:cordelia/feature/storefront/categories/presentation/bloc/categories_bloc.dart';
import 'package:cordelia/feature/storefront/categories/presentation/templates/grofast/view/categories_screen.dart';
import 'package:cordelia/feature/storefront/home/presentation/bloc/home_bloc.dart';
import 'package:cordelia/feature/storefront/home/presentation/templates/grofast/view/home_screen.dart';
import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc.dart';
import 'package:cordelia/feature/storefront/profile/presentation/templates/grofast/view/profile_screen.dart';
import 'package:cordelia/feature/storefront/shell/presentation/storefront_shell.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_nav_bar.dart';

/// `grofast` template's nav shell. Four tabs — Home, Categories, Bag, Account
/// — in the kit's own four-slot bar, rendered by [GrofastNavBar]: a white bar
/// with a circular notch cut out of its top edge and the active tab's
/// gradient disc dropped into it.
///
/// The kit's second slot is a barcode **Scan** tab. This storefront has no
/// barcode feature, so shipping it would be a dead control; Categories takes
/// the slot instead, which the kit's own Home links to with a "see all"
/// (spec sheet §11). Wishlist and My Orders are reached from Profile, exactly
/// as the kit's Profile does.
class ShellPage extends StorefrontShellPage {
  // Nav-tab indices — public so a route outside the shell can request a tab
  // by name instead of a magic number. Order matches _tabs.
  static const homeTabIndex = 0;
  static const categoriesTabIndex = 1;
  static const bagTabIndex = 2;
  static const accountTabIndex = 3;

  const ShellPage({super.key, super.initialTab = homeTabIndex});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends BasePageState<ShellPage>
    with StorefrontShellState {
  /// The kit's nav glyphs are all solid fills — one export per slot serves
  /// both states, tinted by the bar (spec sheet §5).
  static const _tabs = [
    GrofastNavItem(
      asset: GrofastImageConst.navHome,
      label: GrofastValueConst.navHome,
    ),
    GrofastNavItem(
      asset: GrofastImageConst.grid,
      label: GrofastValueConst.navCategories,
    ),
    GrofastNavItem(
      asset: GrofastImageConst.navBag,
      label: GrofastValueConst.navBag,
      showDot: true,
    ),
    GrofastNavItem(
      asset: GrofastImageConst.navAccount,
      label: GrofastValueConst.navAccount,
    ),
  ];

  /// This pack has no app bar on any screen: every screen builds its own
  /// header row as the first item of its scroll view (spec sheet §8).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// Shared above the tabs because Home's greeting and avatar read the same
  /// profile the Account tab does — one fetch, cache-first, instead of one
  /// per screen.
  @override
  Widget buildBlocProviders(Widget child) => BlocProvider(
    create: (_) =>
        ProfileBloc(getProfileUseCase: sl())..add(const ProfileEvent.started()),
    child: child,
  );

  @override
  Widget? buildBottomNav(BuildContext context) => GrofastNavBar(
    items: _tabs,
    currentIndex: currentTab,
    onTap: onTabSelected,
  );

  @override
  Widget buildBody(BuildContext context) {
    // `!`: the shell only renders inside a mounted StorefrontPage, which
    // seeds the cubit before its first build.
    final storeId = context.read<ActiveStoreCubit>().state!.storeId;

    return switch (currentTab) {
      ShellPage.homeTabIndex => BlocProvider(
        create: (_) =>
            HomeBloc(getHomeUseCase: sl(), storeId: storeId)
              ..add(HomeEvent.started(storeId: storeId)),
        child: HomeScreen(onSeeAllCategories: _goCategories),
      ),
      ShellPage.categoriesTabIndex => BlocProvider(
        create: (_) =>
            CategoriesBloc(getCategoriesUseCase: sl(), storeId: storeId)
              ..add(const CategoriesEvent.started()),
        child: const CategoriesScreen(),
      ),
      // The bag's items live in the app-root CartCubit — nothing to provide
      // per-tab (checkout runs on its own routed page with its own bloc).
      // showBack: false — a tab root has nowhere to pop; onBack still serves
      // the empty state's way out.
      ShellPage.bagTabIndex => CartScreen(onBack: _goHome, showBack: false),
      // ProfileBloc is shell-level (see buildBlocProviders).
      _ => const ProfileScreen(),
    };
  }

  void _goHome() => setState(() => currentTab = ShellPage.homeTabIndex);

  void _goCategories() =>
      setState(() => currentTab = ShellPage.categoriesTabIndex);
}
