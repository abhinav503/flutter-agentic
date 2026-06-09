import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/master_bloc.dart';

/// Abstract base for all full-featured pages.
///
/// Trigger the body-scoped loading overlay from any descendant:
/// ```dart
/// context.read<MasterBloc>().add(ShowLoader());
/// context.read<MasterBloc>().add(HideLoader());
/// ```
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

  /// Override to replace the default spinner shown by [MasterBloc].
  Widget buildLoader(BuildContext context) => const CircularProgressIndicator();

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
  Widget buildBlocProviders(Widget child) => child;

  @override
  Widget build(BuildContext context) {
    return buildBlocProviders(
      BlocProvider(
        create: (_) => MasterBloc(),
        child: Builder(
          builder: (ctx) => Scaffold(
            appBar: buildAppBar(ctx),
            body: _BodyWithLoader(
              body: buildBody(ctx),
              loader: buildLoader(ctx),
            ),
            floatingActionButton: buildFab(ctx),
            bottomNavigationBar: buildBottomNav(ctx),
            backgroundColor: backgroundColor(ctx),
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          ),
        ),
      ),
    );
  }
}

/// Scopes the [MasterBloc] loading overlay to the Scaffold body only,
/// so the AppBar and BottomNavigationBar remain visible and interactive.
class _BodyWithLoader extends StatelessWidget {
  final Widget body;
  final Widget loader;

  const _BodyWithLoader({required this.body, required this.loader});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        body,
        BlocBuilder<MasterBloc, MasterState>(
          builder: (ctx, state) {
            if (state is! MasterLoading) return const SizedBox.shrink();
            final scrim =
                Theme.of(ctx).colorScheme.scrim.withValues(alpha: 0.33);
            return ColoredBox(
              color: scrim,
              child: Center(child: loader),
            );
          },
        ),
      ],
    );
  }
}
