import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/templates/grofast/view/cart_screen.dart';
import 'package:cordelia/feature/storefront/categories/presentation/bloc/categories_bloc_provider.dart';
import 'package:cordelia/feature/storefront/categories/presentation/templates/grofast/view/categories_screen.dart';
import 'package:cordelia/feature/storefront/home/presentation/bloc/home_bloc_provider.dart';
import 'package:cordelia/feature/storefront/home/presentation/templates/grofast/view/home_screen.dart';
import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc_provider.dart';
import 'package:cordelia/feature/storefront/profile/presentation/templates/grofast/view/profile_screen.dart';
import 'package:cordelia/feature/storefront/shell/presentation/storefront_shell.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_nav_bar.dart';

/// `grofast` template's nav shell. Four tabs — Home, Categories, Bag, Account
/// — in the kit's own four-slot bar, rendered by [GrofastNavBar]: a white bar
/// whose top edge lifts into a dome around the active tab, with that tab's
/// gradient disc sitting in the dome.
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
  ///
  /// Not a `static const` list: the Bag's dot is the bag's own unread mark,
  /// so it has to follow the cart rather than be lit permanently.
  static List<GrofastNavItem> _tabs({required bool bagHasItems}) => [
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
      showDot: bagHasItems,
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

  /// The nav's dome is a bulge in the bar's top edge, and a white bulge on a
  /// white canvas is invisible — it only reads with the tab's own content
  /// passing behind it. Each tab pays [GrofastDimenConst.navScrollInset] for
  /// that, which is derived from the height this hands it.
  @override
  bool get extendBody => true;

  /// Shared above the tabs because Home's greeting and avatar read the same
  /// profile the Account tab does — one fetch, cache-first, instead of one
  /// per screen.
  @override
  Widget buildBlocProviders(Widget child) => profileBlocProvider(child: child);

  @override
  Widget? buildBottomNav(BuildContext context) => GrofastNavBar(
    items: _tabs(bagHasItems: context.watch<CartCubit>().state.isNotEmpty),
    currentIndex: currentTab,
    onTap: onTabSelected,
  );

  @override
  Widget buildBody(BuildContext context) {
    // `storeId` comes from StorefrontShellState — captured at mount, so it
    // survives the teardown that runs while this shell is still animating
    // out.

    return switch (currentTab) {
      ShellPage.homeTabIndex => homeBlocProvider(
        storeId: storeId,
        child: HomeScreen(onSeeAllCategories: _goCategories),
      ),
      ShellPage.categoriesTabIndex => categoriesBlocProvider(
        storeId: storeId,
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
