import 'package:get_it/get_it.dart';

import '../services/shared_pref_service/shared_preference_service.dart';
import '../../feature/jokes/data/data_source/jokes_remote_data_source.dart';
import '../../feature/jokes/data/data_source/jokes_remote_data_source_impl.dart';
import '../../feature/jokes/data/repository_impl/jokes_repository_impl.dart';
import '../../feature/jokes/domain/repository/jokes_repository.dart';
import '../../feature/jokes/domain/usecase/get_random_joke_usecase.dart';
import '../../feature/jokes/domain/usecase/search_jokes_usecase.dart';
import '../../feature/doc_scanner/data/data_source/doc_scanner_data_source_dispatcher.dart';
import '../../feature/doc_scanner/data/data_source/doc_scanner_local_data_source.dart';
import '../../feature/doc_scanner/data/data_source/doc_scanner_local_data_source_impl.dart';
import '../../feature/doc_scanner/data/data_source/doc_scanner_remote_data_source.dart';
import '../../feature/doc_scanner/data/repository_impl/receipt_scan_repository_impl.dart';
import '../../feature/doc_scanner/domain/repository/receipt_scan_repository.dart';
import '../../feature/doc_scanner/domain/usecase/delete_receipt_usecase.dart';
import '../../feature/doc_scanner/domain/usecase/generate_pdf_usecase.dart';
import '../../feature/doc_scanner/domain/usecase/get_api_keys_usecase.dart';
import '../../feature/doc_scanner/domain/usecase/get_selected_model_usecase.dart';
import '../../feature/doc_scanner/domain/usecase/load_receipts_usecase.dart';
import '../../feature/doc_scanner/domain/usecase/resolve_image_usecase.dart';
import '../../feature/doc_scanner/domain/usecase/save_api_key_usecase.dart';
import '../../feature/doc_scanner/domain/usecase/save_receipt_usecase.dart';
import '../../feature/doc_scanner/domain/usecase/scan_receipt_usecase.dart';
import '../../feature/doc_scanner/domain/usecase/edit_receipt_usecase.dart';
import '../../feature/doc_scanner/domain/usecase/select_model_usecase.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Services ───────────────────────────────────────────────────────────────

  // Both are static singletons — no GetIt registration needed.
  await SharedPreferenceService.instance.init();

  // ── Jokes ──────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<JokesRemoteDataSource>(
    () => const JokesRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<JokesRepository>(
    () => JokesRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetRandomJokeUseCase(sl()));
  sl.registerLazySingleton(() => SearchJokesUseCase(sl()));

  // ── Doc Scanner ────────────────────────────────────────────────────────────

  sl.registerLazySingleton<DocScannerRemoteDataSource>(
    () => const DocScannerDataSourceDispatcher(),
  );

  sl.registerLazySingleton<DocScannerLocalDataSource>(
    () => const DocScannerLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<ReceiptScanRepository>(
    () => ReceiptScanRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => ResolveImageUseCase(sl()));
  sl.registerLazySingleton(() => ScanReceiptUseCase(sl()));
  sl.registerLazySingleton(() => GeneratePdfUseCase(sl()));
  sl.registerLazySingleton(() => LoadReceiptsUseCase(sl()));
  sl.registerLazySingleton(() => SaveReceiptUseCase(sl()));
  sl.registerLazySingleton(() => EditReceiptUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReceiptUseCase(sl()));
  sl.registerLazySingleton(() => GetSelectedModelUseCase(sl()));
  sl.registerLazySingleton(() => SelectModelUseCase(sl()));
  sl.registerLazySingleton(() => GetApiKeysUseCase(sl()));
  sl.registerLazySingleton(() => SaveApiKeyUseCase(sl()));

  // BLoCs are NOT registered here — instantiate them directly in each page's
  // BlocProvider so their lifetime is tied to the widget tree, not the app.
}
