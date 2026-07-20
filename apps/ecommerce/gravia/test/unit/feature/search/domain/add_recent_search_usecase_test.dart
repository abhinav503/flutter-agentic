import 'package:flutter_test/flutter_test.dart';

import 'package:gravia/enums/recent_search_type.dart';
import 'package:gravia/feature/search/domain/entities/recent_search_entity.dart';
import 'package:gravia/feature/search/domain/usecase/add_recent_search_usecase.dart';

import '../../../../helpers/fake_search_repository.dart';

void main() {
  late FakeSearchRepository repository;
  late AddRecentSearchUseCase useCase;

  const item = RecentSearchEntity(
    id: '7',
    name: 'Bananas',
    type: RecentSearchType.product,
  );

  setUp(() {
    repository = FakeSearchRepository();
    useCase = AddRecentSearchUseCase(repository);
  });

  test('passes the item through and returns the repository result', () async {
    final result = await useCase(item);

    expect(repository.lastAdded, item);
    expect(result, repository.recentsResult);
  });
}
