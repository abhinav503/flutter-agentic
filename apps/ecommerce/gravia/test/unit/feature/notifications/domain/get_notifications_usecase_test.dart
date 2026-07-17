import 'package:flutter_test/flutter_test.dart';

import 'package:core/core/usecase/usecase.dart';
import 'package:gravia/feature/notifications/domain/usecase/get_notifications_usecase.dart';

import '../../../../helpers/fake_notifications_repository.dart';

void main() {
  late FakeNotificationsRepository repository;
  late GetNotificationsUseCase useCase;

  setUp(() {
    repository = FakeNotificationsRepository();
    useCase = GetNotificationsUseCase(repository);
  });

  test('returns the repository result unchanged', () async {
    final result = await useCase(const NoParams());

    expect(result, repository.result);
  });
}
