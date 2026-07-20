import 'package:flutter_test/flutter_test.dart';

import 'package:gravia/feature/search/domain/usecase/search_catalog_usecase.dart';

import '../../../../helpers/fake_search_repository.dart';

void main() {
  late FakeSearchRepository repository;
  late SearchCatalogUseCase useCase;

  setUp(() {
    repository = FakeSearchRepository();
    useCase = SearchCatalogUseCase(repository);
  });

  test('passes the query through and returns the repository result', () async {
    final result = await useCase(const SearchCatalogParams(query: 'apple'));

    expect(repository.lastQuery, 'apple');
    expect(result, repository.searchResult);
  });
}
