import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/enums/recent_search_type.dart';
import 'package:gravia/feature/home/domain/entities/category_entity.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';
import 'package:gravia/feature/search/domain/entities/recent_search_entity.dart';
import 'package:gravia/feature/search/domain/entities/search_entity.dart';
import 'package:gravia/feature/search/domain/entities/search_results_entity.dart';
import 'package:gravia/feature/search/domain/usecase/add_recent_search_usecase.dart';
import 'package:gravia/feature/search/domain/usecase/get_search_usecase.dart';
import 'package:gravia/feature/search/domain/usecase/remove_recent_search_usecase.dart';
import 'package:gravia/feature/search/domain/usecase/search_catalog_usecase.dart';
import 'package:gravia/feature/search/presentation/bloc/search_bloc.dart';

import '../../../../helpers/fake_search_repository.dart';

void main() {
  late FakeSearchRepository repository;

  ProductEntity product(String id, String name) => ProductEntity(
    id: id,
    name: name,
    imageUrl: 'https://example.com/$id.png',
    price: 4.00,
    originalPrice: 5.00,
    discountPercentage: 20,
    unitValue: 500,
    unitType: ProductUnitType.grams,
    prepTime: '10 Min',
    isFavourite: false,
  );
  CategoryEntity category(String id, String name) => CategoryEntity(
    id: id,
    name: name,
    imageUrl: 'https://example.com/$id.png',
  );

  const recentApple = RecentSearchEntity(
    id: '1',
    name: 'Washington Red Apple',
    type: RecentSearchType.product,
  );
  const recentCabbage = RecentSearchEntity(
    id: '4',
    name: 'Cabbage',
    type: RecentSearchType.product,
  );
  final search = SearchEntity(
    recentSearches: const [recentApple, recentCabbage],
    popularProducts: [product('2', 'Green Grapes')],
  );

  // Longer than the bloc's 300ms debounce, so queryChanged tests can wait
  // it out deterministically.
  const debounceWait = Duration(milliseconds: 400);

  SearchBloc buildBloc() => SearchBloc(
    getSearchUseCase: GetSearchUseCase(repository),
    searchCatalogUseCase: SearchCatalogUseCase(repository),
    addRecentSearchUseCase: AddRecentSearchUseCase(repository),
    removeRecentSearchUseCase: RemoveRecentSearchUseCase(repository),
  );

  setUp(() {
    SearchBloc.resetCache();
    repository = FakeSearchRepository()..result = right(search);
  });

  blocTest<SearchBloc, SearchState>(
    'emits [loading, loaded] when started succeeds',
    build: buildBloc,
    act: (bloc) => bloc.add(const SearchEvent.started()),
    expect: () => [SearchState.loaded(search: search)],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [loading, error] when started fails',
    setUp: () =>
        repository.result = left(const Failure.unexpected(message: 'boom')),
    build: buildBloc,
    act: (bloc) => bloc.add(const SearchEvent.started()),
    expect: () => [const SearchState.error(message: 'boom')],
  );

  test('a second bloc warm-starts loaded from the cache', () async {
    final first = buildBloc()..add(const SearchEvent.started());
    await Future<void>.delayed(Duration.zero);
    await first.close();

    final second = buildBloc();
    expect(second.state, SearchState.loaded(search: search));
    await second.close();
  });

  blocTest<SearchBloc, SearchState>(
    'queryChanged searches after the debounce and caps suggestions at 5',
    setUp: () => repository.searchResult = right(
      SearchResultsEntity(
        products: [for (var i = 0; i < 8; i++) product('p$i', 'Product $i')],
        categories: [
          for (var i = 0; i < 3; i++) category('c$i', 'Category $i'),
        ],
      ),
    ),
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const SearchEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SearchEvent.queryChanged(query: 'app'));
    },
    wait: debounceWait,
    verify: (bloc) {
      final state = bloc.state as SearchLoaded;
      expect(repository.lastQuery, 'app');
      expect(state.searching, isFalse);
      // 2 reserved category slots + 3 products = the 5-suggestion cap.
      expect(state.results!.categories.length, 2);
      expect(state.results!.products.length, 3);
    },
  );

  blocTest<SearchBloc, SearchState>(
    'queryChanged with a failure keeps the query as retry context',
    setUp: () => repository.searchResult = left(
      const Failure.unexpected(message: 'boom'),
    ),
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const SearchEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SearchEvent.queryChanged(query: 'app'));
    },
    wait: debounceWait,
    verify: (bloc) {
      final state = bloc.state as SearchLoaded;
      expect(state.resultsError, 'boom');
      expect(state.query, 'app');
    },
  );

  blocTest<SearchBloc, SearchState>(
    'resultSelected moves the item to the top and records it',
    setUp: () =>
        repository.recentsResult = right(const [recentCabbage, recentApple]),
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const SearchEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SearchEvent.resultSelected(item: recentCabbage));
    },
    verify: (bloc) {
      final state = bloc.state as SearchLoaded;
      expect(repository.lastAdded, recentCabbage);
      expect(state.search.recentSearches, [recentCabbage, recentApple]);
    },
  );

  blocTest<SearchBloc, SearchState>(
    'recentSearchRemoved drops only the matching item',
    setUp: () => repository.recentsResult = right(const [recentCabbage]),
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const SearchEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SearchEvent.recentSearchRemoved(item: recentApple));
    },
    verify: (bloc) {
      final state = bloc.state as SearchLoaded;
      expect(
        repository.lastRemoved,
        (id: recentApple.id, type: recentApple.type),
      );
      expect(state.search.recentSearches, [recentCabbage]);
    },
  );
}
