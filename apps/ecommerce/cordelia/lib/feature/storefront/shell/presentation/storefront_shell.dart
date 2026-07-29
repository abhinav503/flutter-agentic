import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';

/// A `BottomNavBarItem.iconBuilder` for a kit SVG glyph — every template's
/// shell was re-typing this identical closure.
Widget Function(Color, double) svgNavIcon(String asset) =>
    (color, size) =>
        AppSvgImage.asset(asset, color: color, width: size, height: size);

/// Base for every template's nav shell — carries the [initialTab] routing
/// param so the shared State machinery below can react to it.
abstract class StorefrontShellPage extends BasePage {
  /// Which tab to select. Threaded from the storefront route's
  /// `StorefrontRouteArgs.initialTab`, so any pushed screen can land on a
  /// specific tab with `context.go(AppRoutes.storefront,
  /// extra: StorefrontRouteArgs(store: …, initialTab: …))` — `go` (not
  /// `push`) so it also discards whatever was pushed on top of the shell,
  /// the same way "return to the tab bar" should. Tab choice is otherwise
  /// UI-local `setState` (see the tabbed-apps note in
  /// `docs/reference/architecture.md`); this is the one supported door in
  /// from outside, not a general shared-state mechanism.
  ///
  /// Because `StorefrontPage`/the shell stay mounted underneath any route
  /// pushed on top (that's what lets the shell's BLoCs/cart badge survive
  /// Cart being pushed), that `go` back to an already-mounted storefront
  /// updates this constructor arg on the *existing* State rather than
  /// creating a new one — [StorefrontShellState.didUpdateWidget] is what
  /// actually reacts to that; a `late` field set once in `initState` would
  /// only catch the very first (cold-start) navigation to the storefront.
  final int initialTab;

  const StorefrontShellPage({super.key, required this.initialTab});
}

/// The State machinery every template's shell repeats identically — tab
/// selection reacting to [StorefrontShellPage.initialTab], the once-per-
/// store-visit cart/favourites hydration, and the surface backdrop. Each
/// template keeps only its own tab roster, chrome, and body switch.
mixin StorefrontShellState<T extends StorefrontShellPage> on BasePageState<T> {
  late int currentTab = widget.initialTab;

  @override
  void initState() {
    super.initState();
    // The shell is only reached once a session is confirmed (Splash routes
    // signed-out users to Login first), so this is the earliest safe place
    // to load the signed-in shopper's persisted cart and favourites — once
    // per store visit (a fresh shell per StorefrontPage mount), not on
    // every tab switch.
    final storeId = context.read<ActiveStoreCubit>().state!.storeId;
    context.read<CartCubit>().hydrate(storeId);
    context.read<FavouritesCubit>().hydrate(storeId);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      setState(() => currentTab = widget.initialTab);
    }
  }

  /// `BottomNavBar.onTap`.
  void onTabSelected(int index) => setState(() => currentTab = index);

  /// Explicit rather than Scaffold's implicit default — each tab paints its
  /// own canvas, and this is the colour behind them (and behind an
  /// overscroll).
  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
}
