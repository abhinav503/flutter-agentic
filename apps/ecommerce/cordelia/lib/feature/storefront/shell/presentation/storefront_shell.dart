import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/coupon_cubit.dart';
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
  late int currentTab;

  /// The store this shell renders. Captured **once**, not read from the
  /// app-level [ActiveStoreCubit] on every build — a shell belongs to one
  /// store for its whole life, and that cubit does not.
  ///
  /// Two things cleared it out from under a still-mounted shell:
  ///   * Popping back to discovery tears the session down while the pop
  ///     animation is still running, so a build-time read went null and
  ///     painted a blank frame over the outgoing storefront.
  ///   * Hot reload recreates `App`'s state, and with it the cubit, while
  ///     this State survives — a build-time read threw on every frame after.
  /// A field set at mount is immune to both.
  late final String storeId;

  @override
  void initState() {
    super.initState();
    currentTab = openableTab(widget.initialTab);
    storeId = context.read<ActiveStoreCubit>().state!.storeId;
    // A coupon is priced against one store's cart — entering a storefront
    // (fresh shell per visit) always starts without one, so the previous
    // store's discount can't leak into this one's totals.
    context.read<CouponCubit>().reset();
    // Both are the signed-in shopper's own, keyed on the verified token's
    // uid, so a guest has nothing to load — and asking would be a 401 per
    // store visit. `SignInGateX.requireSignIn` hydrates them at the moment
    // an account appears, which is the only other way into this state.
    if (context.isSignedIn) {
      context.read<CartCubit>().hydrate(storeId);
      context.read<FavouritesCubit>().hydrate(storeId);
      return;
    }
    // Nothing is hydrating, so nothing will clear `FavouritesCubit`'s
    // opening `isLoading: true` — it exists so a shopper landing on the
    // Wishlist tab sees a skeleton rather than a premature "nothing here",
    // and a skeleton with no fetch behind it shimmers for the whole visit.
    // [openableTab] keeps a guest off that tab; this makes the state honest
    // even if something reaches it another way.
    context.read<CartCubit>().reset();
    context.read<FavouritesCubit>().reset();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      setState(() => currentTab = openableTab(widget.initialTab));
    }
  }

  /// [tab], or Home when a guest is being aimed at a tab that needs an
  /// account.
  ///
  /// [onTabSelected] puts Login in front of a *tap*, but `initialTab`
  /// arrives from a route — a tab jump ("Track Your Order"), a deep link, a
  /// notification — and lands on the tab directly, gate and all skipped.
  /// Every caller today aims at a tab the sender was already signed in for,
  /// so this closes the shape of the hole rather than a live bug: one
  /// future caller is all it would take, and what a guest would get is a
  /// screen with nothing on it (Orders/Profile paint their signed-out state
  /// as a skeleton, and the Wishlist's never stops).
  ///
  /// Home rather than Login, because nobody asked for a login here — the
  /// shopper asked for this store.
  @protected
  int openableTab(int tab) =>
      signedInOnlyTabs.contains(tab) && !context.isSignedIn ? 0 : tab;

  /// The open store's id, or null in the window where the app-level store
  /// was lost — a hot reload in debug (see `StorefrontPage.reassemble`), or
  /// a teardown race in the worst case. Every template's `buildBody` renders
  /// a neutral surface for that frame instead of crashing: a storefront with
  /// no store has nothing to show, and a `!` here took the whole screen down
  /// on every subsequent frame.
  String? get activeStoreId => context.read<ActiveStoreCubit>().state?.storeId;

  /// Tabs that need an account, by this template's own indices. Home and
  /// browse-style tabs stay open to a guest; a bag, a wishlist, an order
  /// history and a profile are all somebody's, so they gate.
  Set<int> get signedInOnlyTabs => const {};

  /// `BottomNavBar.onTap`. Gated tabs put Login in front of the switch, and
  /// a shopper who backs out of it stays on the tab they were reading —
  /// switching first and showing an empty "sign in" panel would strand them
  /// somewhere they never chose to go.
  Future<void> onTabSelected(int index) async {
    if (signedInOnlyTabs.contains(index) && !await context.requireSignIn()) {
      return;
    }
    if (mounted) setState(() => currentTab = index);
  }

  /// Explicit rather than Scaffold's implicit default — each tab paints its
  /// own canvas, and this is the colour behind them (and behind an
  /// overscroll).
  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
}
