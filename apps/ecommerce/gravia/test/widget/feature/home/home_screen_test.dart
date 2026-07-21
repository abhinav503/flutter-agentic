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
import 'package:gravia/feature/favourites/domain/usecase/add_favourite_usecase.dart';
import 'package:gravia/feature/favourites/domain/usecase/get_favourites_usecase.dart';
import 'package:gravia/feature/favourites/domain/usecase/remove_favourite_usecase.dart';
import 'package:gravia/feature/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:gravia/feature/home/domain/entities/category_entity.dart';
import 'package:gravia/feature/home/domain/entities/home_entity.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';
import 'package:gravia/feature/home/presentation/bloc/home_bloc.dart';
import 'package:gravia/feature/home/presentation/view/home_screen.dart';

import '../../../helpers/fake_favourites_repository.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

// HomePopularItemsSection reads FavouritesCubit unconditionally while
// building, so every state (loading/loaded/error) needs it provided — a
// real cubit over a manual fake repository, per this project's "no
// mockito/mocktail" testing convention (MockBloc is the sanctioned
// exception for the bloc under test itself, not its collaborators).
FavouritesCubit _buildFavouritesCubit() {
  final repository = FakeFavouritesRepository();
  return FavouritesCubit(
    getFavouritesUseCase: GetFavouritesUseCase(repository),
    addFavouriteUseCase: AddFavouriteUseCase(repository),
    removeFavouriteUseCase: RemoveFavouriteUseCase(repository),
  );
}

Widget _wrap(HomeBloc bloc, FavouritesCubit favouritesCubit) => MaterialApp(
  theme: AppTheme.fromConfig(AppThemeConfig.defaults),
  home: MultiBlocProvider(
    providers: [
      BlocProvider<HomeBloc>.value(value: bloc),
      BlocProvider<FavouritesCubit>.value(value: favouritesCubit),
    ],
    child: const Scaffold(body: HomeScreen()),
  ),
);

void main() {
  late _MockHomeBloc bloc;
  late FavouritesCubit favouritesCubit;

  setUp(() async {
    // HomeScreen reads the selected address from prefs in initState.
    SharedPreferences.setMockInitialValues(const {});
    await SharedPreferenceService.instance.init();
    bloc = _MockHomeBloc();
    favouritesCubit = _buildFavouritesCubit();
  });
  tearDown(() {
    bloc.close();
    favouritesCubit.close();
  });

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

    await tester.pumpWidget(_wrap(bloc, favouritesCubit));

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

    await tester.pumpWidget(_wrap(bloc, favouritesCubit));

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

    await tester.pumpWidget(_wrap(bloc, favouritesCubit));

    expect(find.text(ValueConst.homeLoadErrorMessage), findsOneWidget);
    expect(find.text(CoreConst.retryButton), findsOneWidget);
  });
}
