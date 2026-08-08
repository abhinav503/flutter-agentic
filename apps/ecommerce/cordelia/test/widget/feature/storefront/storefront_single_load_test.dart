import 'package:cordelia/feature/storefront/active_store/domain/entities/active_store_entity.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/applied_coupon_entity.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/domain/usecase/get_cart_usecase.dart';
import 'package:cordelia/feature/storefront/cart/domain/usecase/save_cart_usecase.dart';
import 'package:cordelia/feature/storefront/cart/domain/usecase/validate_coupon_usecase.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/coupon_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/domain/usecase/add_favourite_usecase.dart';
import 'package:cordelia/feature/storefront/favourites/domain/usecase/get_favourites_usecase.dart';
import 'package:cordelia/feature/storefront/favourites/domain/usecase/remove_favourite_usecase.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/home_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/usecase/get_home_usecase.dart';
import 'package:cordelia/feature/storefront/home/presentation/bloc/home_bloc.dart';
import 'package:cordelia/feature/storefront/presentation/view/storefront_page.dart';
import 'package:cordelia/feature/storefront/shell/presentation/templates/gravia/view/shell_page.dart';
import 'package:cordelia/feature/storefront/template/store_currency.dart';
import 'package:cordelia/feature/storefront/template/store_language.dart';
import 'package:cordelia/feature/storefront/template/storefront_template.dart';
import 'package:cordelia/l10n/active_locale_controller.dart';
import 'package:cordelia/l10n/active_locale_scope.dart';
import 'package:cordelia/theme/active_theme_controller.dart';
import 'package:cordelia/theme/active_theme_scope.dart';
import 'package:core/core/di/core_injection.dart';
import 'package:core/core/error/failure.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
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
class _CountingGetHomeUseCase implements GetHomeUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, HomeEntity>> call(GetHomeParams params) async {
    calls++;
    return right(const HomeEntity(categories: [], popularProducts: [], banners: []));
  }
}

class _CountingGetCartUseCase implements GetCartUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(
    GetCartParams params,
  ) async {
    calls++;
    return right(const []);
  }
}

class _CountingGetFavouritesUseCase implements GetFavouritesUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetFavouritesParams params,
  ) async {
    calls++;
    return right(const []);
  }
}

class _FakeSaveCartUseCase implements SaveCartUseCase {
  @override
  Future<Either<Failure, List<CartItemEntity>>> call(
    SaveCartParams params,
  ) async => right(params.items);
}

class _FakeValidateCouponUseCase implements ValidateCouponUseCase {
  @override
  Future<Either<Failure, AppliedCouponEntity>> call(
    ValidateCouponParams params,
  ) async => right(const AppliedCouponEntity(code: '', discount: 0));
}

class _FakeAddFavouriteUseCase implements AddFavouriteUseCase {
  @override
  Future<Either<Failure, void>> call(AddFavouriteParams params) async =>
      right(null);
}

class _FakeRemoveFavouriteUseCase implements RemoveFavouriteUseCase {
  @override
  Future<Either<Failure, void>> call(RemoveFavouriteParams params) async =>
      right(null);
}

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

  late _CountingGetHomeUseCase getHome;
  late _CountingGetCartUseCase getCart;
  late _CountingGetFavouritesUseCase getFavourites;

  setUp(() async {
    SharedPreferences.setMockInitialValues(const {});
    await SharedPreferenceService.instance.init();
    getHome = _CountingGetHomeUseCase();
    getCart = _CountingGetCartUseCase();
    getFavourites = _CountingGetFavouritesUseCase();
    if (sl.isRegistered<GetHomeUseCase>()) sl.unregister<GetHomeUseCase>();
    sl.registerLazySingleton<GetHomeUseCase>(() => getHome);
    // Warm-start cache: without this the second test in a run would seed from
    // the first's result and skip the fetch being counted.
    HomeBloc.resetCache();
  });

  testWidgets('entering a storefront fetches home, cart and favourites once each', (
    tester,
  ) async {
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
              saveCartUseCase: _FakeSaveCartUseCase(),
            ),
          ),
          BlocProvider(
            create: (_) =>
                CouponCubit(validateCouponUseCase: _FakeValidateCouponUseCase()),
          ),
          BlocProvider(
            create: (_) => FavouritesCubit(
              getFavouritesUseCase: getFavourites,
              addFavouriteUseCase: _FakeAddFavouriteUseCase(),
              removeFavouriteUseCase: _FakeRemoveFavouriteUseCase(),
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

    tester.state<NavigatorState>(find.byType(Navigator)).push(
      MaterialPageRoute<void>(builder: (_) => const StorefrontPage(store: _store)),
    );

    // Long enough for the route transition, the async template-theme asset
    // load, and the post-frame locale apply to all have landed.
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(ShellPage), findsOneWidget);
    expect(tester.takeException(), isNull);

    expect(getCart.calls, 1, reason: 'cart hydrated more than once per visit');
    expect(
      getFavourites.calls,
      1,
      reason: 'favourites hydrated more than once per visit',
    );
    expect(getHome.calls, 1, reason: 'home loaded more than once per visit');
  });
}
