import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/coupon_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/usecase/get_home_usecase.dart';
import 'package:cordelia/feature/storefront/home/presentation/bloc/home_bloc.dart';
import 'package:cordelia/feature/storefront/presentation/view/storefront_page.dart';
import 'package:cordelia/feature/storefront/shell/presentation/templates/gravia/view/shell_page.dart';
import 'package:cordelia/feature/storefront/template/store_currency.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';
import 'package:cordelia/l10n/active_locale_controller.dart';
import 'package:cordelia/l10n/active_locale_scope.dart';
import '../../../helpers/fake_auth_session.dart';
import 'package:cordelia/theme/active_theme_controller.dart';
import 'package:cordelia/theme/active_theme_scope.dart';
import 'package:core/core/di/core_injection.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_storefront_use_cases.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Entering a storefront must cost exactly one round of fetches.
///
/// `StorefrontPage` applies the store's template theme AND its language
/// *after* the first frame — the theme because the config is an async asset
/// load, the locale because notifying an ancestor mid-mount throws. Both
/// notify app-level ValueListenableBuilders that sit above `MaterialApp`, so
/// entering a store rebuilds the whole app twice before it settles.
///
/// A rebuild must not be a remount. The shell hydrates cart and favourites
/// from `initState` (once per store visit, deliberately not per tab switch),
/// so if any of those rebuilds replaced the shell's element the shopper would
/// silently pay for a second full round of network calls on every store they
/// open. This test counts the calls rather than trusting that.

class _DiscoveryStub extends StatelessWidget {
  const _DiscoveryStub();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('discovery')));
}

const _store = ActiveStoreEntity(
  storeId: 'test-store',
  storeName: 'Test Store',
  templateId: StorefrontTemplate.gravia,
  language: StoreLanguage.en,
  currency: StoreCurrency.inr,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeGetHomeUseCase getHome;
  late FakeGetCartUseCase getCart;
  late FakeGetFavouritesUseCase getFavourites;

  setUp(() async {
    SharedPreferences.setMockInitialValues(const {});
    await SharedPreferenceService.instance.init();
    getHome = FakeGetHomeUseCase();
    getCart = FakeGetCartUseCase();
    getFavourites = FakeGetFavouritesUseCase();
    if (sl.isRegistered<GetHomeUseCase>()) sl.unregister<GetHomeUseCase>();
    sl.registerLazySingleton<GetHomeUseCase>(() => getHome);
    // Warm-start cache: without this the second test in a run would seed from
    // the first's result and skip the fetch being counted.
    HomeBloc.resetCache();
    // The bag and the wishlist are the signed-in shopper's own, so the shell
    // only fetches them for one. There is no Firebase app in a test to say
    // so — hence the seam.
    signIntoFakeSession();
  });

  testWidgets(
    'entering a storefront fetches home, cart and favourites once each',
    (tester) async {
      final activeTheme = ActiveThemeController(AppThemeConfig.defaults);
      final activeLocale = ActiveLocaleController();
      final activeStore = ActiveStoreCubit();
      addTearDown(activeTheme.dispose);
      addTearDown(activeLocale.dispose);
      addTearDown(activeStore.close);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => CartCubit(
                getCartUseCase: getCart,
                saveCartUseCase: FakeSaveCartUseCase(),
              ),
            ),
            BlocProvider(
              create: (_) => CouponCubit(
                validateCouponUseCase: FakeValidateCouponUseCase(),
              ),
            ),
            BlocProvider(
              create: (_) => FavouritesCubit(
                getFavouritesUseCase: getFavourites,
                addFavouriteUseCase: FakeAddFavouriteUseCase(),
                removeFavouriteUseCase: FakeRemoveFavouriteUseCase(),
              ),
            ),
            BlocProvider.value(value: activeStore),
          ],
          // Mirrors _AppState: BOTH the theme and the locale sit in
          // ValueListenableBuilders above MaterialApp, and StorefrontPage
          // notifies both after mount.
          child: ValueListenableBuilder<AppThemeConfig>(
            valueListenable: activeTheme,
            builder: (context, config, _) => ValueListenableBuilder<Locale>(
              valueListenable: activeLocale,
              builder: (context, locale, _) => ActiveThemeScope(
                controller: activeTheme,
                child: ActiveLocaleScope(
                  controller: activeLocale,
                  child: MaterialApp(
                    theme: AppTheme.fromConfig(config),
                    locale: locale,
                    home: const _DiscoveryStub(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      tester
          .state<NavigatorState>(find.byType(Navigator))
          .push(
            MaterialPageRoute<void>(
              builder: (_) => const StorefrontPage(store: _store),
            ),
          );

      // Long enough for the route transition, the async template-theme asset
      // load, and the post-frame locale apply to all have landed.
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(ShellPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      expect(
        getCart.calls,
        1,
        reason: 'cart hydrated more than once per visit',
      );
      expect(
        getFavourites.calls,
        1,
        reason: 'favourites hydrated more than once per visit',
      );
      expect(getHome.calls, 1, reason: 'home loaded more than once per visit');

      // Popping the storefront tears the session down while the pop is still
      // animating, so this shell is still on screen when the app-level store
      // goes away. Reading that cubit in `buildBody` therefore went null
      // mid-transition: first it threw on every frame, then — once guarded —
      // it painted a blank screen over the outgoing storefront. The shell
      // captures its id at mount instead, which is what this asserts.
      final staleToken = activeStore.open(_store);
      activeStore.closeSession(staleToken);
      expect(activeStore.state, isNull);

      // Clearing the store rebuilds nothing by itself — every consumer uses
      // context.read, not watch — so the rebuild has to be forced or this
      // never exercises buildBody at all.
      // Re-selecting the current tab is enough: onTabSelected always calls
      // setState. Switching to another tab would drag in that tab's use
      // cases, which this harness deliberately doesn't register.
      // ignore: avoid_dynamic_calls
      (tester.state(find.byType(ShellPage)) as dynamic).onTabSelected(0);
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        find.byType(ShellPage),
        findsOneWidget,
        reason: 'the shell must keep rendering after losing the active store',
      );
    },
  );

  testWidgets('a guest fetches neither cart nor favourites, and is not left '
      'holding an unresolvable loading state', (tester) async {
    signOutFakeSession();

    final activeTheme = ActiveThemeController(AppThemeConfig.defaults);
    final activeLocale = ActiveLocaleController();
    final activeStore = ActiveStoreCubit();
    final favourites = FavouritesCubit(
      getFavouritesUseCase: getFavourites,
      addFavouriteUseCase: FakeAddFavouriteUseCase(),
      removeFavouriteUseCase: FakeRemoveFavouriteUseCase(),
    );
    addTearDown(activeTheme.dispose);
    addTearDown(activeLocale.dispose);
    addTearDown(activeStore.close);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CartCubit(
              getCartUseCase: getCart,
              saveCartUseCase: FakeSaveCartUseCase(),
            ),
          ),
          BlocProvider(
            create: (_) =>
                CouponCubit(validateCouponUseCase: FakeValidateCouponUseCase()),
          ),
          BlocProvider.value(value: favourites),
          BlocProvider.value(value: activeStore),
        ],
        child: ActiveThemeScope(
          controller: activeTheme,
          child: ActiveLocaleScope(
            controller: activeLocale,
            child: MaterialApp(
              theme: AppTheme.fromConfig(AppThemeConfig.defaults),
              home: const _DiscoveryStub(),
            ),
          ),
        ),
      ),
    );

    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(
          MaterialPageRoute<void>(
            builder: (_) => const StorefrontPage(store: _store),
          ),
        );
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));

    expect(getCart.calls, 0, reason: 'a guest has no server-side bag to read');
    expect(
      getFavourites.calls,
      0,
      reason: 'a guest has no server-side wishlist to read',
    );
    // `FavouritesCubit` opens in its loading state so the Wishlist tab shows
    // a skeleton rather than a premature "nothing here". No hydration runs
    // for a guest, so nothing would ever end it. Not reachable today — the
    // Wishlist tab is gated and `openableTab` keeps a guest off it even via
    // `initialTab` — this pins the state itself as honest, so reaching it
    // some other way can't produce a skeleton that never stops.
    expect(
      favourites.state.isLoading,
      isFalse,
      reason: 'a guest wishlist must settle, not shimmer for the whole visit',
    );
  });

  testWidgets('a guest aimed at a gated tab lands on Home instead', (
    tester,
  ) async {
    signOutFakeSession();

    final activeTheme = ActiveThemeController(AppThemeConfig.defaults);
    final activeLocale = ActiveLocaleController();
    final activeStore = ActiveStoreCubit();
    addTearDown(activeTheme.dispose);
    addTearDown(activeLocale.dispose);
    addTearDown(activeStore.close);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CartCubit(
              getCartUseCase: getCart,
              saveCartUseCase: FakeSaveCartUseCase(),
            ),
          ),
          BlocProvider(
            create: (_) =>
                CouponCubit(validateCouponUseCase: FakeValidateCouponUseCase()),
          ),
          BlocProvider(
            create: (_) => FavouritesCubit(
              getFavouritesUseCase: getFavourites,
              addFavouriteUseCase: FakeAddFavouriteUseCase(),
              removeFavouriteUseCase: FakeRemoveFavouriteUseCase(),
            ),
          ),
          BlocProvider.value(value: activeStore),
        ],
        child: ActiveThemeScope(
          controller: activeTheme,
          child: ActiveLocaleScope(
            controller: activeLocale,
            child: MaterialApp(
              theme: AppTheme.fromConfig(AppThemeConfig.defaults),
              home: const _DiscoveryStub(),
            ),
          ),
        ),
      ),
    );

    // `onTabSelected` gates a *tap*; `initialTab` arrives from a route and
    // used to skip that entirely, landing a guest on gravia's Wishlist tab —
    // whose skeleton has no fetch behind it, so it shimmered forever and
    // hung any `pumpAndSettle` on it.
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(
          MaterialPageRoute<void>(
            builder: (_) => const StorefrontPage(
              store: _store,
              initialTab: ShellPage.favouriteTabIndex,
            ),
          ),
        );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      // ignore: avoid_dynamic_calls
      (tester.state(find.byType(ShellPage)) as dynamic).currentTab,
      ShellPage.homeTabIndex,
      reason: 'a guest cannot be dropped onto a tab that needs an account',
    );
    expect(getHome.calls, 1, reason: 'the Home tab it fell back to loaded');
  });

  // Uses the Wishlist tab throughout: it renders `FavouritesCubit` directly,
  // so the jump can be exercised without registering Orders/Profile use cases
  // this harness deliberately leaves out. The mechanism under test is the
  // shell's, and is the same whichever tab is asked for.
  testWidgets('a repeat jump to the tab already requested still lands', (
    tester,
  ) async {
    signIntoFakeSession();

    final activeTheme = ActiveThemeController(AppThemeConfig.defaults);
    final activeLocale = ActiveLocaleController();
    final activeStore = ActiveStoreCubit();
    addTearDown(activeTheme.dispose);
    addTearDown(activeLocale.dispose);
    addTearDown(activeStore.close);

    // Rebuilt below with a fresh request each time, the way `go` does.
    Widget page(int tab) {
      final args = StorefrontRouteArgs(store: _store, initialTab: tab);
      return StorefrontPage(
        store: args.store,
        initialTab: args.initialTab,
        tabRequest: args.tabRequest,
      );
    }

    Widget host(Widget child) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CartCubit(
            getCartUseCase: getCart,
            saveCartUseCase: FakeSaveCartUseCase(),
          ),
        ),
        BlocProvider(
          create: (_) =>
              CouponCubit(validateCouponUseCase: FakeValidateCouponUseCase()),
        ),
        BlocProvider(
          create: (_) => FavouritesCubit(
            getFavouritesUseCase: getFavourites,
            addFavouriteUseCase: FakeAddFavouriteUseCase(),
            removeFavouriteUseCase: FakeRemoveFavouriteUseCase(),
          ),
        ),
        BlocProvider.value(value: activeStore),
      ],
      child: ActiveThemeScope(
        controller: activeTheme,
        child: ActiveLocaleScope(
          controller: activeLocale,
          child: MaterialApp(
            theme: AppTheme.fromConfig(AppThemeConfig.defaults),
            home: child,
          ),
        ),
      ),
    );

    // The jump lands once...
    await tester.pumpWidget(host(page(ShellPage.favouriteTabIndex)));
    await tester.pump(const Duration(seconds: 2));
    int tabOf() =>
        // ignore: avoid_dynamic_calls
        (tester.state(find.byType(ShellPage)) as dynamic).currentTab as int;
    expect(tabOf(), ShellPage.favouriteTabIndex);

    // ...the shopper moves away by hand...
    // ignore: avoid_dynamic_calls
    (tester.state(find.byType(ShellPage)) as dynamic).onTabSelected(
      ShellPage.homeTabIndex,
    );
    await tester.pump();
    expect(tabOf(), ShellPage.homeTabIndex);

    // ...an ordinary rebuild must NOT drag them back to the jumped tab.
    await tester.pumpWidget(
      host(
        StorefrontPage(
          store: _store,
          initialTab: ShellPage.favouriteTabIndex,
          tabRequest: 1,
        ),
      ),
    );
    await tester.pump();
    expect(
      tabOf(),
      ShellPage.homeTabIndex,
      reason: 'a rebuild carries the same request and must change nothing',
    );

    // ...but tapping "My Orders" a second time must land again. Keyed on the
    // tab alone this was indistinguishable from the rebuild above, so it was
    // ignored and the row went dead for the rest of the visit.
    await tester.pumpWidget(host(page(ShellPage.favouriteTabIndex)));
    await tester.pump();
    expect(
      tabOf(),
      ShellPage.favouriteTabIndex,
      reason: 'a second jump to the same tab is still a jump',
    );
  });
}
