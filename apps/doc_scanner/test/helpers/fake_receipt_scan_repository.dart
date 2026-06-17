import 'package:fpdart/fpdart.dart';
import 'package:core/core/error/failure.dart';
import 'package:doc_scanner/feature/home/domain/entities/ai_scan_model.dart';
import 'package:doc_scanner/feature/home/domain/entities/scanned_receipt_entity.dart';
import 'package:doc_scanner/feature/home/domain/repository/receipt_scan_repository.dart';

class FakeReceiptScanRepository implements ReceiptScanRepository {
  @override
  Future<Either<Failure, ({String id, String imagePath})>> resolveImage({
    required String tempPath,
  }) async =>
      right((id: 'fake-id', imagePath: tempPath));

  @override
  Future<Either<Failure, ScannedReceiptEntity>> scanReceipt({
    required ScannedReceiptEntity receipt,
    required AiScanModel model,
    required String apiKey,
  }) async =>
      right(receipt);

  @override
  Future<Either<Failure, String>> generatePdf({
    required List<ScannedReceiptEntity> receipts,
  }) async =>
      right('/tmp/fake.pdf');

  @override
  Future<Either<Failure, List<ScannedReceiptEntity>>> loadReceipts() async =>
      right([]);

  @override
  Future<Either<Failure, Unit>> saveReceipt({
    required ScannedReceiptEntity receipt,
  }) async =>
      right(unit);

  @override
  Future<Either<Failure, Unit>> deleteReceipt({
    required String imagePath,
  }) async =>
      right(unit);

  @override
  Future<AiScanModel> getSelectedModel() async => AiScanModel.groqLlama4Scout;

  @override
  Future<void> selectModel({required AiScanModel model}) async {}

  @override
  Future<Map<String, String>> getApiKeys() async => {};

  @override
  Future<void> saveApiKey({
    required AiScanModel model,
    required String apiKey,
  }) async {}
}
