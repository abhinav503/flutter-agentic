import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core/core/constants/core_const.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_theme.dart';
import 'package:core/core/theme/app_theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/feature/home/domain/entities/category_entity.dart';
import 'package:gravia/feature/home/domain/entities/home_entity.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';
import 'package:gravia/feature/home/presentation/bloc/home_bloc.dart';
import 'package:gravia/feature/home/presentation/view/home_screen.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

Widget _wrap(HomeBloc bloc) => MaterialApp(
  theme: AppTheme.fromConfig(AppThemeConfig.defaults),
  home: BlocProvider<HomeBloc>.value(
    value: bloc,
    child: const Scaffold(body: HomeScreen()),
  ),
);

void main() {
  late _MockHomeBloc bloc;

  setUp(() async {
    // HomeScreen reads the selected address from prefs in initState.
    SharedPreferences.setMockInitialValues(const {});
    await SharedPreferenceService.instance.init();
    bloc = _MockHomeBloc();
  });
  tearDown(() => bloc.close());

  const home = HomeEntity(
    categories: [
      CategoryEntity(
        id: '1',
        name: 'Fresh',
        imageUrl: 'https://example.com/fresh.png',
      ),
    ],
    popularProducts: [
      ProductEntity(
        id: '1',
        name: 'Washington Red Apple',
        imageUrl: 'https://example.com/apple.png',
        price: 6.30,
        originalPrice: 8.00,
        discountPercentage: 20,
        unitValue: 300,
        unitType: ProductUnitType.grams,
        prepTime: '10 Min',
        isFavourite: false,
      ),
    ],
  );

  testWidgets('shows a loading indicator while loading', (tester) async {
    whenListen(
      bloc,
      const Stream<HomeState>.empty(),
      initialState: const HomeState.loading(),
    );

    await tester.pumpWidget(_wrap(bloc));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders categories and popular items once loaded', (
    tester,
  ) async {
    whenListen(
      bloc,
      const Stream<HomeState>.empty(),
      initialState: const HomeState.loaded(home: home),
    );

    await tester.pumpWidget(_wrap(bloc));

    expect(find.text(ValueConst.allCategoriesTitle), findsOneWidget);
    expect(find.text('Fresh'), findsOneWidget);
    expect(find.text(ValueConst.popularItemsTitle), findsOneWidget);
    expect(find.text('Washington Red Apple'), findsOneWidget);
  });

  testWidgets('shows a retry action on error', (tester) async {
    whenListen(
      bloc,
      const Stream<HomeState>.empty(),
      initialState: const HomeState.error(message: 'boom'),
    );

    await tester.pumpWidget(_wrap(bloc));

    expect(find.text(ValueConst.homeLoadErrorMessage), findsOneWidget);
    expect(find.text(CoreConst.retryButton), findsOneWidget);
  });
}
