import 'package:core/core/di/core_injection.dart';

import '../feature/home/data/data_source/doc_scanner_data_source_dispatcher.dart';
import '../feature/home/data/data_source/doc_scanner_local_data_source.dart';
import '../feature/home/data/data_source/doc_scanner_local_data_source_impl.dart';
import '../feature/home/data/data_source/doc_scanner_remote_data_source.dart';
import '../feature/home/data/repository_impl/receipt_scan_repository_impl.dart';
import '../feature/home/domain/repository/receipt_scan_repository.dart';
import '../feature/home/domain/usecase/delete_receipt_usecase.dart';
import '../feature/home/domain/usecase/generate_pdf_usecase.dart';
import '../feature/home/domain/usecase/get_api_keys_usecase.dart';
import '../feature/home/domain/usecase/get_selected_model_usecase.dart';
import '../feature/home/domain/usecase/load_receipts_usecase.dart';
import '../feature/home/domain/usecase/resolve_image_usecase.dart';
import '../feature/home/domain/usecase/save_api_key_usecase.dart';
import '../feature/home/domain/usecase/save_receipt_usecase.dart';
import '../feature/home/domain/usecase/scan_receipt_usecase.dart';
import '../feature/home/domain/usecase/edit_receipt_usecase.dart';
import '../feature/home/domain/usecase/select_model_usecase.dart';

// Re-export the shared service locator so consumers can import `sl` from the
// app's own DI entrypoint.
export 'package:core/core/di/core_injection.dart' show sl;

/// Wires the doc_scanner app: shared core services first, then doc_scanner.
Future<void> initDependencies() async {
  await initCoreDependencies();

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
}
