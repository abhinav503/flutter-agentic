import 'package:core/core/base/base_page.dart';
import 'package:core/core/theme/theme_mode_scope.dart';
import 'package:core/core/ui/atoms/theme_mode_toggle.dart';
import 'package:core/core/ui/atoms/top_bar.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gravia/constants/value_const.dart';
import 'package:gravia/di/injection_container.dart';
import 'package:gravia/feature/home/presentation/bloc/home_bloc.dart';
import 'package:gravia/feature/home/presentation/view/home_screen.dart';

class ShellPage extends BasePage {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends BasePageState<ShellPage> {
  int _currentTab = 0;

  // Kit tab set: Home, Categories, Favourite, Orders (bag), Profile — the
  // cart is not a nav tab in this pack.
  static const _tabs = [
    BottomNavBarItem(icon: Icons.home_outlined, label: ValueConst.navHome),
    BottomNavBarItem(
      icon: Icons.grid_view_rounded,
      label: ValueConst.navCategories,
    ),
    BottomNavBarItem(
      icon: Icons.favorite_outline,
      label: ValueConst.navFavourite,
    ),
    BottomNavBarItem(
      icon: Icons.shopping_bag_outlined,
      label: ValueConst.navOrders,
    ),
    BottomNavBarItem(icon: Icons.person_outline, label: ValueConst.navProfile),
  ];

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    // The Home tab renders its own coloured hero header (location, search)
    // as part of the screen body, per the pack's "coloured header canvas"
    // composition — a generic top bar on top of it would double up.
    if (_currentTab == 0) return null;

    final themeMode = ThemeModeScope.maybeOf(context);
    return AppTopBar.primary(
      title: ValueConst.appTitle,
      actions: [
        if (themeMode != null)
          ThemeModeToggle(mode: themeMode.value, onTap: themeMode.cycle),
      ],
    );
  }

  @override
  Widget? buildBottomNav(BuildContext context) => BottomNavBar(
        items: _tabs,
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
      );

  @override
  Widget buildBody(BuildContext context) => switch (_currentTab) {
        0 => BlocProvider(
            create: (_) => HomeBloc(getHomeUseCase: sl())
              ..add(const HomeEvent.started()),
            child: const HomeScreen(),
          ),
        1 => const EmptyState(
            iconData: Icons.grid_view_rounded,
            title: ValueConst.categoriesComingTitle,
            subtitle: ValueConst.categoriesComingSubtitle,
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
        _ => const EmptyState(
            iconData: Icons.person_outline,
            title: ValueConst.profileComingTitle,
            subtitle: ValueConst.profileComingSubtitle,
          ),
      };
}
