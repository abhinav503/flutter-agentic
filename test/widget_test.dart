import 'package:flutter_agentic/app.dart';
import 'package:flutter_agentic/core/di/injection_container.dart';
import 'package:flutter_agentic/feature/jokes/domain/entities/joke_entity.dart';
import 'package:flutter_agentic/feature/jokes/domain/repository/jokes_repository.dart';
import 'package:flutter_agentic/feature/jokes/domain/usecase/get_random_joke_usecase.dart';
import 'package:flutter_agentic/feature/jokes/domain/usecase/search_jokes_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';

import 'helpers/fake_jokes_repository.dart';

void main() {
  setUpAll(() async {
    await GetIt.instance.reset();

    final fakeRepo = FakeJokesRepository()
      ..result = right(const JokeEntity(id: '1', content: 'Smoke-test joke'));

    sl.registerLazySingleton<JokesRepository>(() => fakeRepo);
    sl.registerLazySingleton(() => GetRandomJokeUseCase(sl()));
    sl.registerLazySingleton(() => SearchJokesUseCase(sl()));
  });

  testWidgets('app renders without crashing', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.text('For You'), findsAtLeastNWidgets(1));
  });
}
