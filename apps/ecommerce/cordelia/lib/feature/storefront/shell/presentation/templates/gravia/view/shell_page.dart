import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/templates/gravia/widgets/cart_status_bar.dart';
import 'package:cordelia/feature/storefront/categories/presentation/bloc/categories_bloc_provider.dart';
import 'package:cordelia/feature/storefront/categories/presentation/templates/gravia/view/categories_screen.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/templates/gravia/view/favourites_screen.dart';
import 'package:cordelia/feature/storefront/home/presentation/bloc/home_bloc_provider.dart';
import 'package:cordelia/feature/storefront/home/presentation/templates/gravia/view/home_screen.dart';
import 'package:cordelia/feature/storefront/orders/presentation/bloc/orders_bloc_provider.dart';
import 'package:cordelia/feature/storefront/orders/presentation/templates/gravia/view/orders_screen.dart';
import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc_provider.dart';
import 'package:cordelia/feature/storefront/profile/presentation/templates/gravia/view/profile_screen.dart';
import 'package:cordelia/feature/storefront/shell/presentation/storefront_shell.dart';
import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';
import 'package:core/core/base/base_page.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/theme_mode_scope.dart';
import 'package:core/core/ui/atoms/theme_mode_toggle.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';
import 'package:core/core/ui/blocks/docked_bar_overlap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ShellPage extends StorefrontShellPage {
  // Nav-tab indices — public so any route outside the shell can request a
  // tab by name instead of a hardcoded magic number. Order matches _tabs.
  static const homeTabIndex = 0;
  static const categoriesTabIndex = 1;
  static const favouriteTabIndex = 2;
  static const ordersTabIndex = 3;
  static const profileTabIndex = 4;

  const ShellPage({super.key, super.initialTab = homeTabIndex});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends BasePageState<ShellPage>
    with StorefrontShellState {
  // Kit tab set: Home, Categories, Favourite, Orders (bag), Profile — the
  // cart is not a nav tab in this pack. A getter, not `static final`: the
  // labels come from L10n and a class-lifetime cache would pin whichever
  // language happened to be active at first build.
  List<BottomNavBarItem> get _tabs => [
    BottomNavBarItem(
      iconBuilder: svgNavIcon(GraviaImageConst.navHome),
      label: GraviaValueConst.navHome,
    ),
    BottomNavBarItem(
      iconBuilder: svgNavIcon(GraviaImageConst.navCategories),
      label: GraviaValueConst.navCategories,
    ),
    BottomNavBarItem(
      iconBuilder: svgNavIcon(GraviaImageConst.navFavourite),
      label: GraviaValueConst.navFavourite,
    ),
    BottomNavBarItem(
      iconBuilder: svgNavIcon(GraviaImageConst.navOrders),
      label: GraviaValueConst.navOrders,
    ),
    BottomNavBarItem(
      iconBuilder: svgNavIcon(GraviaImageConst.navProfile),
      label: GraviaValueConst.navProfile,
    ),
  ];

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    // Every tab renders its own coloured hero header as part of the screen
    // body, per the pack's "coloured header canvas" composition — a generic
    // top bar on top of any of them would double up. Kept as a switch
    // (rather than always returning null) so a future tab without its own
    // header still gets one for free.
    if (currentTab == ShellPage.homeTabIndex ||
        currentTab == ShellPage.categoriesTabIndex ||
        currentTab == ShellPage.favouriteTabIndex ||
        currentTab == ShellPage.ordersTabIndex ||
        currentTab == ShellPage.profileTabIndex) {
      return null;
    }

    final themeMode = ThemeModeScope.maybeOf(context);
    return AppTopBar.primary(
      title: ValueConst.appTitle,
      actions: [
        if (themeMode != null)
          ThemeModeToggle(mode: themeMode.value, onTap: themeMode.cycle),
      ],
      bottomBorderColor: context.appColors.dockedHairline,
      bottomBorderWidth: GraviaDimenConst.hairlineWidth,
    );
  }

  /// Shell-level, not per-tab: the Profile tab is rebuilt fresh on every tab
  /// switch, so constructing the bloc down in [buildBody] replayed the whole
  /// profile skeleton each visit. Matches dailymart/grofast.
  @override
  Widget buildBlocProviders(Widget child) => profileBlocProvider(child: child);

  @override
  Widget? buildBottomNav(BuildContext context) => BottomNavBar(
    items: _tabs,
    currentIndex: currentTab,
    onTap: onTabSelected,
    topBorderColor: context.appColors.dockedHairline,
    topBorderWidth: GraviaDimenConst.hairlineWidth,
    // Gray/500 in both modes per kit spec — same value doesn't come from
    // the (mode-differing) onSurfaceVariant role, so it's an explicit
    // override rather than a theme edit.
    inactiveIconColor: GraviaColorConst.gray500,
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
      ShellPage.categoriesTabIndex => categoriesBlocProvider(
        storeId: storeId,
        child: const CategoriesScreen(),
      ),
      ShellPage.favouriteTabIndex => const FavouritesScreen(),
      ShellPage.ordersTabIndex => ordersBlocProvider(
        storeId: storeId,
        child: const OrdersScreen(),
      ),
      _ => const ProfileScreen(),
    };

    // Cart is not a nav tab (see _tabs above) — instead a persistent bar
    // docks above the bottom nav on Home/Categories whenever the shared cart
    // is non-empty. It lives in this shell's body (not a `SnackBar`), so it's
    // automatically hidden while Cart/Product Details/Search are pushed on
    // top and reappears on pop — no manual show/hide bookkeeping needed.
    if (currentTab != ShellPage.homeTabIndex &&
        currentTab != ShellPage.categoriesTabIndex) {
      return content;
    }

    final shapes = context.appShapes;

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
                onTap: () => context.push(AppRoutes.cart, extra: storeId),
                onClear: () => showGraviaConfirmSheet(
                  context: context,
                  title: GraviaValueConst.clearCartTitle,
                  message: GraviaValueConst.clearCartConfirmMessage,
                  confirmLabel: GraviaValueConst.clearCartConfirmLabel,
                  onConfirm: () => context.read<CartCubit>().clear(),
                ),
              ),
      ),
      child: content,
    );
  }
}
