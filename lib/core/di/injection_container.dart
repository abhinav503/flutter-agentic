import 'package:get_it/get_it.dart';

import '../constants/api_constants.dart';
import '../network/api_client.dart';
import '../../feature/jokes/data/data_source/jokes_remote_data_source.dart';
import '../../feature/jokes/data/data_source/jokes_remote_data_source_impl.dart';
import '../../feature/jokes/data/repository_impl/jokes_repository_impl.dart';
import '../../feature/jokes/domain/repository/jokes_repository.dart';
import '../../feature/jokes/domain/usecase/get_random_joke_usecase.dart';
import '../../feature/jokes/domain/usecase/search_jokes_usecase.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Network
  sl.registerLazySingleton(
    () => createDioClient(baseUrl: ApiConstants.jokesBaseUrl),
  );

  // Data sources
  sl.registerLazySingleton<JokesRemoteDataSource>(
    () => JokesRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<JokesRepository>(
    () => JokesRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRandomJokeUseCase(sl()));
  sl.registerLazySingleton(() => SearchJokesUseCase(sl()));

  // BLoCs are NOT registered here — instantiate them directly in each page's
  // BlocProvider so their lifetime is tied to the widget tree, not the app.
}
