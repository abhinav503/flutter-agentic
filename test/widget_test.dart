import 'package:flutter_agentic/app.dart';
import 'package:flutter_agentic/core/di/injection_container.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/repository/receipt_scan_repository.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/usecase/delete_receipt_usecase.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/usecase/edit_receipt_usecase.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/usecase/generate_pdf_usecase.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/usecase/get_api_keys_usecase.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/usecase/get_selected_model_usecase.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/usecase/load_receipts_usecase.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/usecase/resolve_image_usecase.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/usecase/save_api_key_usecase.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/usecase/save_receipt_usecase.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/usecase/scan_receipt_usecase.dart';
import 'package:flutter_agentic/feature/doc_scanner/domain/usecase/select_model_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'helpers/fake_receipt_scan_repository.dart';

void main() {
  setUpAll(() async {
    await GetIt.instance.reset();

    sl.registerLazySingleton<ReceiptScanRepository>(
      () => FakeReceiptScanRepository(),
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
  });

  testWidgets('app renders without crashing', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.text('Scan Receipts'), findsOneWidget);
  });
}
