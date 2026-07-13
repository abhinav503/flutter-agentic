import 'package:core/core/di/core_injection.dart';

import '../feature/home/data/data_source/home_remote_data_source.dart';
import '../feature/home/data/data_source/home_remote_data_source_impl.dart';
import '../feature/home/data/repository_impl/home_repository_impl.dart';
import '../feature/home/domain/repository/home_repository.dart';
import '../feature/home/domain/usecase/get_home_usecase.dart';

// Re-export the shared service locator so consumers can import `sl` from the
// app's own DI entrypoint.
export 'package:core/core/di/core_injection.dart' show sl;

/// Wires the Gravia app: shared core services first, then this app's
/// features (data sources → repositories → use cases) as they land.
Future<void> initDependencies() async {
  await initCoreDependencies();

  // ── Home (storefront) ──────────────────────────────────────────────────
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => const HomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetHomeUseCase(sl()));
}
