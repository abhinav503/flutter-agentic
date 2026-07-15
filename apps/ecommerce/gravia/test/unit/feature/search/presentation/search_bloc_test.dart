import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';
import 'package:gravia/feature/search/domain/entities/search_entity.dart';
import 'package:gravia/feature/search/domain/usecase/get_search_usecase.dart';
import 'package:gravia/feature/search/presentation/bloc/search_bloc.dart';

import '../../../../helpers/fake_search_repository.dart';

void main() {
  late FakeSearchRepository repository;

  const product = ProductEntity(
    id: '2',
    name: 'Green Grapes',
    imageUrl: 'https://example.com/grapes.png',
    price: 4.00,
    originalPrice: 5.00,
    discountPercentage: 20,
    unitValue: 500,
    unitType: ProductUnitType.grams,
    prepTime: '10 Min',
    isFavourite: false,
  );
  const recentApple = ProductEntity(
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
  const recentCabbage = ProductEntity(
    id: '4',
    name: 'Cabbage',
    imageUrl: 'https://example.com/cabbage.png',
    price: 2.40,
    originalPrice: 3.00,
    discountPercentage: 20,
    unitValue: 500,
    unitType: ProductUnitType.grams,
    prepTime: '10 Min',
    isFavourite: false,
  );
  const search = SearchEntity(
    recentSearches: [recentApple, recentCabbage],
    popularProducts: [product],
  );

  setUp(() {
    repository = FakeSearchRepository()..result = right(search);
  });

  blocTest<SearchBloc, SearchState>(
    'emits [loading, loaded] when started succeeds',
    build: () => SearchBloc(getSearchUseCase: GetSearchUseCase(repository)),
    act: (bloc) => bloc.add(const SearchEvent.started()),
    expect: () => [
      const SearchState.loaded(search: search),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [loading, error] when started fails',
    setUp: () => repository.result =
        left(const Failure.unexpected(message: 'boom')),
    build: () => SearchBloc(getSearchUseCase: GetSearchUseCase(repository)),
    act: (bloc) => bloc.add(const SearchEvent.started()),
    expect: () => [
      const SearchState.error(message: 'boom'),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'recentSearchRemoved drops only the matching product',
    build: () => SearchBloc(getSearchUseCase: GetSearchUseCase(repository)),
    act: (bloc) async {
      bloc.add(const SearchEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SearchEvent.recentSearchRemoved(productId: '1'));
    },
    verify: (bloc) {
      final state = bloc.state as SearchLoaded;
      expect(state.search.recentSearches, [recentCabbage]);
    },
  );
}
