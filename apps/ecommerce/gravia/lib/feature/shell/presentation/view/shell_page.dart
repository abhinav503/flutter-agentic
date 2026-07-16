import 'package:core/core/base/base_page.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/theme_mode_scope.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/atoms/theme_mode_toggle.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';
import 'package:core/core/ui/blocks/docked_bar_overlap.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/di/injection_container.dart';
import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:gravia/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:gravia/feature/cart/presentation/widgets/cart_status_bar.dart';
import 'package:gravia/feature/categories/presentation/bloc/categories_bloc.dart';
import 'package:gravia/feature/categories/presentation/view/categories_screen.dart';
import 'package:gravia/feature/home/presentation/bloc/home_bloc.dart';
import 'package:gravia/feature/home/presentation/view/home_screen.dart';
import 'package:gravia/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:gravia/feature/profile/presentation/view/profile_screen.dart';

class ShellPage extends BasePage {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends BasePageState<ShellPage> {
  int _currentTab = 0;

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
  // it's the backdrop of the tabs that don't paint their own canvas
  // (the EmptyState ones).
  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    // Home, Categories, and Profile render their own coloured hero header as
    // part of the screen body, per the pack's "coloured header canvas"
    // composition — a generic top bar on top of any of them would double up.
    if (_currentTab == 0 || _currentTab == 1 || _currentTab == 4) return null;

    final themeMode = ThemeModeScope.maybeOf(context);
    return AppTopBar.primary(
      title: ValueConst.appTitle,
      actions: [
        if (themeMode != null)
          ThemeModeToggle(mode: themeMode.value, onTap: themeMode.cycle),
      ],
      bottomBorderColor: Theme.of(context).colorScheme.dockedHairline,
      bottomBorderWidth: 0.5,
    );
  }

  @override
  Widget? buildBottomNav(BuildContext context) => BottomNavBar(
    items: _tabs,
    currentIndex: _currentTab,
    onTap: (index) => setState(() => _currentTab = index),
    topBorderColor: Theme.of(context).colorScheme.dockedHairline,
    topBorderWidth: 0.5,
    // Gray/500 in both modes per kit spec — same value doesn't come from
    // the (mode-differing) onSurfaceVariant role, so it's an explicit
    // override rather than a theme edit.
    inactiveIconColor: ColorConst.gray500,
  );

  @override
  Widget buildBody(BuildContext context) {
    final content = switch (_currentTab) {
      0 => BlocProvider(
        create: (_) =>
            HomeBloc(getHomeUseCase: sl())..add(const HomeEvent.started()),
        child: const HomeScreen(),
      ),
      1 => BlocProvider(
        create: (_) =>
            CategoriesBloc(getCategoriesUseCase: sl())
              ..add(const CategoriesEvent.started()),
        child: const CategoriesScreen(),
      ),
      2 => const EmptyState(
        iconData: Icons.favorite_outline,
        title: ValueConst.favouriteEmptyTitle,
        subtitle: ValueConst.favouriteEmptySubtitle,
      ),
      3 => const EmptyState(
        iconData: Icons.shopping_bag_outlined,
        title: ValueConst.ordersEmptyTitle,
        subtitle: ValueConst.ordersEmptySubtitle,
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
    if (_currentTab != 0 && _currentTab != 1) return content;

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
