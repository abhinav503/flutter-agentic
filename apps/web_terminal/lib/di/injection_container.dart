import 'package:core/core/di/core_injection.dart';

import '../feature/apps/data/data_source/apps_remote_data_source.dart';
import '../feature/apps/data/data_source/apps_remote_data_source_impl.dart';
import '../feature/apps/data/repository_impl/apps_repository_impl.dart';
import '../feature/apps/domain/repository/apps_repository.dart';
import '../feature/apps/domain/usecase/list_apps_usecase.dart';
import '../feature/apps/domain/usecase/run_app_usecase.dart';
import '../feature/apps/domain/usecase/stop_app_usecase.dart';
import '../feature/home/data/data_source/terminal_remote_data_source.dart';
import '../feature/home/data/data_source/terminal_remote_data_source_impl.dart';
import '../feature/home/data/repository_impl/terminal_repository_impl.dart';
import '../feature/home/domain/repository/terminal_repository.dart';
import '../feature/home/domain/usecase/connect_terminal_usecase.dart';
import '../feature/home/domain/usecase/disconnect_terminal_usecase.dart';
import '../feature/home/domain/usecase/resize_terminal_usecase.dart';
import '../feature/home/domain/usecase/send_input_usecase.dart';

// Re-export the shared service locator so consumers import `sl` from here.
export 'package:core/core/di/core_injection.dart' show sl;

Future<void> initDependencies() async {
  await initCoreDependencies();

  // Stateful (owns the live WebSocket), so a plain singleton rather than the
  // `const` no-arg source the request/response apps use.
  sl.registerLazySingleton<TerminalRemoteDataSource>(
    () => TerminalRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<TerminalRepository>(
    () => TerminalRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => ConnectTerminalUseCase(sl()));
  sl.registerLazySingleton(() => SendInputUseCase(sl()));
  sl.registerLazySingleton(() => ResizeTerminalUseCase(sl()));
  sl.registerLazySingleton(() => DisconnectTerminalUseCase(sl()));

  // Apps feature — preview targets under apps/.
  sl.registerLazySingleton<AppsRemoteDataSource>(
    () => const AppsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AppsRepository>(() => AppsRepositoryImpl(sl()));
  sl.registerLazySingleton(() => ListAppsUseCase(sl()));
  sl.registerLazySingleton(() => RunAppUseCase(sl()));
  sl.registerLazySingleton(() => StopAppUseCase(sl()));
}
