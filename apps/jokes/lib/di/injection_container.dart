import 'package:core/core/di/core_injection.dart';

import '../feature/home/data/data_source/jokes_remote_data_source.dart';
import '../feature/home/data/data_source/jokes_remote_data_source_impl.dart';
import '../feature/home/data/repository_impl/jokes_repository_impl.dart';
import '../feature/home/domain/repository/jokes_repository.dart';
import '../feature/home/domain/usecase/get_random_joke_usecase.dart';
import '../feature/home/domain/usecase/search_jokes_usecase.dart';

// Re-export the shared service locator so consumers can import `sl` from the
// app's own DI entrypoint.
export 'package:core/core/di/core_injection.dart' show sl;

/// Wires the jokes app: shared core services first, then jokes features.
Future<void> initDependencies() async {
  await initCoreDependencies();

  sl.registerLazySingleton<JokesRemoteDataSource>(
    () => const JokesRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<JokesRepository>(
    () => JokesRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetRandomJokeUseCase(sl()));
  sl.registerLazySingleton(() => SearchJokesUseCase(sl()));
}
