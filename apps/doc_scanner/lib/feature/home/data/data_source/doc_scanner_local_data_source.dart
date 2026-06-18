import '../models/scanned_receipt_model.dart';

abstract interface class DocScannerLocalDataSource {
  Future<List<ScannedReceiptModel>> loadAll();
  Future<void> save(ScannedReceiptModel receipt);
  Future<void> deleteById(String id);
}
