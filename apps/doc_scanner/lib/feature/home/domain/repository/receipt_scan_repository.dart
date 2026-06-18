import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import '../entities/ai_scan_model.dart';
import '../entities/scanned_receipt_entity.dart';

abstract interface class ReceiptScanRepository {
  /// Copies a temp image to a permanent content-addressed path and returns a
  /// stable id (MD5 hash) + permanent path. Safe to call multiple times with
  /// the same source — returns the same result without re-copying.
  Future<Either<Failure, ({String id, String imagePath})>> resolveImage({
    required String tempPath,
  });

  /// Scans a receipt image using [model] and the user-supplied [apiKey].
  /// Checks local cache first — skips the API call entirely if extraction
  /// data already exists for this image.
  Future<Either<Failure, ScannedReceiptEntity>> scanReceipt({
    required ScannedReceiptEntity receipt,
    required AiScanModel model,
    required String apiKey,
  });

  /// Generates a PDF from the provided receipts and returns the file path.
  Future<Either<Failure, String>> generatePdf({
    required List<ScannedReceiptEntity> receipts,
  });

  /// Loads all previously saved receipts from local storage.
  Future<Either<Failure, List<ScannedReceiptEntity>>> loadReceipts();

  /// Saves (or updates) a receipt record in local storage — any status.
  Future<Either<Failure, Unit>> saveReceipt({
    required ScannedReceiptEntity receipt,
  });

  /// Deletes the saved receipt with the given id.
  Future<Either<Failure, Unit>> deleteReceipt({required String id});

  /// Returns the persisted model selection, falling back to the default.
  Future<AiScanModel> getSelectedModel();

  /// Persists the selected model.
  Future<void> selectModel({required AiScanModel model});

  /// Returns all saved API keys keyed by model id.
  Future<Map<String, String>> getApiKeys();

  /// Saves or removes an API key for [model] — removes when [apiKey] is blank.
  Future<void> saveApiKey({required AiScanModel model, required String apiKey});
}
