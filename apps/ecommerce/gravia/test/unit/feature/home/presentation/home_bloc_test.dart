import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/feature/home/domain/entities/category_entity.dart';
import 'package:gravia/feature/home/domain/entities/home_entity.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';
import 'package:gravia/feature/home/domain/usecase/get_home_usecase.dart';
import 'package:gravia/feature/home/presentation/bloc/home_bloc.dart';

import '../../../../helpers/fake_home_repository.dart';

void main() {
  late FakeHomeRepository repository;

  const product = ProductEntity(
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
  );
  const home = HomeEntity(
    categories: [
      CategoryEntity(
        id: '1',
        name: 'Fresh',
        imageUrl: 'https://example.com/fresh.png',
      ),
    ],
    popularProducts: [product],
  );

  setUp(() {
    // `HomeBloc._cachedHome` is a static field (survives the bloc instance
    // being recreated on a real Home-tab revisit) — reset it so warm-start
    // caching from one test doesn't leak into the next.
    HomeBloc.resetCache();
    repository = FakeHomeRepository()..result = right(home);
  });

  blocTest<HomeBloc, HomeState>(
    'emits [loading, loaded] when started succeeds',
    build: () => HomeBloc(getHomeUseCase: GetHomeUseCase(repository)),
    act: (bloc) => bloc.add(const HomeEvent.started()),
    expect: () => [const HomeState.loaded(home: home)],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [loading, error] when started fails',
    setUp: () =>
        repository.result = left(const Failure.unexpected(message: 'boom')),
    build: () => HomeBloc(getHomeUseCase: GetHomeUseCase(repository)),
    act: (bloc) => bloc.add(const HomeEvent.started()),
    expect: () => [const HomeState.error(message: 'boom')],
  );

  blocTest<HomeBloc, HomeState>(
    'favouriteToggled flips isFavourite for the matching product only',
    build: () => HomeBloc(getHomeUseCase: GetHomeUseCase(repository)),
    act: (bloc) async {
      bloc.add(const HomeEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const HomeEvent.favouriteToggled(productId: '1'));
    },
    // ProductEntity has no value equality (plain domain entity, per
    // convention), so assert on the resulting field rather than object
    // equality against a freshly-built copyWith instance.
    verify: (bloc) {
      final state = bloc.state as HomeLoaded;
      expect(state.home.popularProducts.single.isFavourite, isTrue);
    },
  );

  group('warm start (cached data from a prior successful load)', () {
    setUp(() async {
      // Prime HomeBloc's static cache the same way a real first Home-tab
      // load would — build a bloc, let it fetch and cache, then discard it.
      final primer = HomeBloc(getHomeUseCase: GetHomeUseCase(repository));
      primer.add(const HomeEvent.started());
      await primer.stream.first;
      await primer.close();
    });

    test(
      'seeds the loaded state immediately, before any event is processed',
      () {
        final bloc = HomeBloc(getHomeUseCase: GetHomeUseCase(repository));
        expect(bloc.state, const HomeState.loaded(home: home));
        bloc.close();
      },
    );

    blocTest<HomeBloc, HomeState>(
      'never re-emits loading — silently refreshes in the background',
      build: () => HomeBloc(getHomeUseCase: GetHomeUseCase(repository)),
      act: (bloc) => bloc.add(const HomeEvent.started()),
      // Refetch resolves to the same fake data, so the only emission is the
      // fresh loaded state — critically, HomeLoading is never emitted.
      expect: () => [const HomeState.loaded(home: home)],
    );

    blocTest<HomeBloc, HomeState>(
      'keeps the cached content and sets refreshFailed when the background '
      'refetch fails',
      build: () {
        repository.result = left(const Failure.unexpected(message: 'boom'));
        return HomeBloc(getHomeUseCase: GetHomeUseCase(repository));
      },
      act: (bloc) => bloc.add(const HomeEvent.started()),
      expect: () => [const HomeState.loaded(home: home, refreshFailed: true)],
    );
  });
}
