import 'package:core/core/base/base_page.dart';
import 'package:core/core/ui/blocks/bottom_nav_bar.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:flutter/material.dart';

import 'package:gravia/constants/value_const.dart';
import 'home_screen.dart';

class HomePage extends BasePage {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  int _currentTab = 0;

  static const _tabs = [
    BottomNavBarItem(icon: Icons.home_rounded, label: ValueConst.navHome),
    BottomNavBarItem(
      icon: Icons.grid_view_rounded,
      label: ValueConst.navCategories,
    ),
    BottomNavBarItem(
      icon: Icons.shopping_cart_rounded,
      label: ValueConst.navCart,
    ),
    BottomNavBarItem(icon: Icons.person_rounded, label: ValueConst.navProfile),
  ];

  @override
  Widget? buildBottomNav(BuildContext context) => BottomNavBar(
        items: _tabs,
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
      );

  @override
  Widget buildBody(BuildContext context) => switch (_currentTab) {
        0 => const HomeScreen(),
        1 => const EmptyState(
            iconData: Icons.grid_view_rounded,
            title: ValueConst.categoriesComingTitle,
            subtitle: ValueConst.categoriesComingSubtitle,
          ),
        2 => const EmptyState(
            iconData: Icons.shopping_cart_outlined,
            title: ValueConst.cartEmptyTitle,
            subtitle: ValueConst.cartEmptySubtitle,
          ),
        _ => const EmptyState(
            iconData: Icons.person_outline_rounded,
            title: ValueConst.profileComingTitle,
            subtitle: ValueConst.profileComingSubtitle,
          ),
      };
}
