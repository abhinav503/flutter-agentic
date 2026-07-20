import 'package:flutter_test/flutter_test.dart';

import 'package:gravia/enums/recent_search_type.dart';
import 'package:gravia/feature/search/domain/usecase/remove_recent_search_usecase.dart';

import '../../../../helpers/fake_search_repository.dart';

void main() {
  late FakeSearchRepository repository;
  late RemoveRecentSearchUseCase useCase;

  setUp(() {
    repository = FakeSearchRepository();
    useCase = RemoveRecentSearchUseCase(repository);
  });

  test('passes id and type through and returns the repository result', () async {
    final result = await useCase(
      const RemoveRecentSearchParams(id: '7', type: RecentSearchType.category),
    );

    expect(repository.lastRemoved, (id: '7', type: RecentSearchType.category));
    expect(result, repository.recentsResult);
  });
}
