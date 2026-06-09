import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({super.key});
}

abstract class BasePageState<T extends BasePage> extends State<T> {
  // ── Required ──────────────────────────────────────────────────────────────
  Widget buildBody(BuildContext context);

  // ── Optional overrides ────────────────────────────────────────────────────
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  Widget? buildFab(BuildContext context) => null;
  Color? backgroundColor(BuildContext context) => null;
  bool get resizeToAvoidBottomInset => true;

  // ── Bottom navigation ─────────────────────────────────────────────────────
  /// Set to true to enable the default [BottomNavigationBar].
  bool get showBottomNav => false;

  /// Items for the default bottom nav. Required when [showBottomNav] is true.
  List<BottomNavigationBarItem> get bottomNavItems => const [];

  /// Currently selected tab index.
  int get selectedNavIndex => 0;

  /// Called when a tab is tapped. Call [setState] here to update [selectedNavIndex].
  void onNavItemTapped(int index) {}

  /// Override for full control of the bottom navigation bar.
  /// By default, builds from [showBottomNav], [bottomNavItems], [selectedNavIndex],
  /// and [onNavItemTapped].
  Widget? buildBottomNav(BuildContext context) {
    if (!showBottomNav || bottomNavItems.isEmpty) return null;
    return BottomNavigationBar(
      currentIndex: selectedNavIndex,
      onTap: onNavItemTapped,
      items: bottomNavItems,
    );
  }

  /// Override to wrap feature BLoCs above the Scaffold.
  /// The [Builder] below ensures the context passed to all build methods
  /// is inside these providers, enabling direct [context.read<T>()] calls.
  Widget buildBlocProviders(Widget child) => child;

  @override
  Widget build(BuildContext context) {
    return buildBlocProviders(
      Builder(
        builder: (ctx) => Scaffold(
          appBar: buildAppBar(ctx),
          body: buildBody(ctx),
          floatingActionButton: buildFab(ctx),
          bottomNavigationBar: buildBottomNav(ctx),
          backgroundColor: backgroundColor(ctx),
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        ),
      ),
    );
  }
}
