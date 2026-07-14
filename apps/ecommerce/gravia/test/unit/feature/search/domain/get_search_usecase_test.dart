import 'package:flutter_test/flutter_test.dart';

import 'package:core/core/usecase/usecase.dart';
import 'package:gravia/feature/search/domain/usecase/get_search_usecase.dart';

import '../../../../helpers/fake_search_repository.dart';

void main() {
  late FakeSearchRepository repository;
  late GetSearchUseCase useCase;

  setUp(() {
    repository = FakeSearchRepository();
    useCase = GetSearchUseCase(repository);
  });

  test('returns the repository result unchanged', () async {
    final result = await useCase(const NoParams());

    expect(result, repository.result);
  });
}
