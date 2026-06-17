import 'package:core/core/di/core_injection.dart';

import '../feature/home/data/data_source/chat_data_source_dispatcher.dart';
import '../feature/home/data/data_source/chat_remote_data_source.dart';
import '../feature/home/data/repository_impl/chat_repository_impl.dart';
import '../feature/home/domain/repository/chat_repository.dart';
import '../feature/home/domain/usecase/get_api_key_usecase.dart';
import '../feature/home/domain/usecase/save_api_key_usecase.dart';
import '../feature/home/domain/usecase/send_message_usecase.dart';

// Re-export the shared service locator so consumers can import `sl` from the
// app's own DI entrypoint.
export 'package:core/core/di/core_injection.dart' show sl;

/// Wires the ai_chat app: shared core services first, then chat features.
Future<void> initDependencies() async {
  await initCoreDependencies();

  // Data source — the dispatcher routes to the real Groq source when a key is
  // saved, otherwise the local mock, so the app always clones-and-runs
  // (see docs/how-to/stream-usecase.md).
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => const ChatDataSourceDispatcher(),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetApiKeyUseCase(sl()));
  sl.registerLazySingleton(() => SaveApiKeyUseCase(sl()));
}
