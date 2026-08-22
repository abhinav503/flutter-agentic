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

import '../../../helpers/fake_auth_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stand-in for Discovery: just a page beneath the pushed StorefrontPage so
/// popping the storefront rebuilds a still-mounted ancestor — the exact
/// shape of the dispose-time regression this file guards against.
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

  setUp(() async {
    SharedPreferences.setMockInitialValues(const {});
    await SharedPreferenceService.instance.init();
    if (!sl.isRegistered<GetHomeUseCase>()) {
      sl.registerLazySingleton<GetHomeUseCase>(() => FakeGetHomeUseCase());
    }
    HomeBloc.resetCache();
    // This one walks the storefront as a guest; the session has to be
    // registered either way now, which is the point — a screen that gates on
    // an account no longer silently reads "signed out" from an absent
    // Firebase app.
    signOutFakeSession();
  });

  testWidgets(
    'popping Storefront back to Discovery resets the active theme and store '
    'on the next frame without crashing the locked unmount pass',
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
                getCartUseCase: FakeGetCartUseCase(),
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
                getFavouritesUseCase: FakeGetFavouritesUseCase(),
                addFavouriteUseCase: FakeAddFavouriteUseCase(),
                removeFavouriteUseCase: FakeRemoveFavouriteUseCase(),
              ),
            ),
            BlocProvider.value(value: activeStore),
          ],
          // Mirrors _AppState: an ancestor ValueListenableBuilder rebuilds
          // MaterialApp whenever the active theme changes — the listener the
          // dispose-time reset notifies.
          child: ValueListenableBuilder<AppThemeConfig>(
            valueListenable: activeTheme,
            builder: (context, config, _) => ActiveThemeScope(
              controller: activeTheme,
              child: ActiveLocaleScope(
                controller: activeLocale,
                child: MaterialApp(
                  theme: AppTheme.fromConfig(config),
                  home: const _DiscoveryStub(),
                ),
              ),
            ),
          ),
        ),
      );

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => const StorefrontPage(store: _store),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(ShellPage), findsOneWidget);
      expect(activeStore.state, same(_store));

      navigator.pop();
      await tester.pump();
      // The regression threw here: resetToAppDefault()/clear() notifying a
      // still-mounted ancestor synchronously from dispose() while the tree
      // was locked (`setState() or markNeedsBuild() called when widget tree
      // was locked`). The fix defers both to a post-frame callback.
      expect(tester.takeException(), isNull);

      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
      expect(find.byType(StorefrontPage), findsNothing);
      expect(find.text('discovery'), findsOneWidget);
      expect(activeTheme.value, same(AppThemeConfig.defaults));
      expect(activeStore.state, isNull);
    },
  );
}
