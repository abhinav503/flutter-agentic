import 'package:flutter_test/flutter_test.dart';

import 'package:core/core/usecase/usecase.dart';
import 'package:gravia/feature/home/domain/usecase/get_home_usecase.dart';

import '../../../../helpers/fake_home_repository.dart';

void main() {
  late FakeHomeRepository repository;
  late GetHomeUseCase useCase;

  setUp(() {
    repository = FakeHomeRepository();
    useCase = GetHomeUseCase(repository);
  });

  test('returns the repository result unchanged', () async {
    final result = await useCase(const NoParams());

    expect(result, repository.result);
  });
}
