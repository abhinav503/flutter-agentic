import '../models/receipt_extraction_model.dart';

abstract interface class DocScannerRemoteDataSource {
  Future<ReceiptExtractionModel?> extractReceiptData({
    required String base64Image,
    required String mimeType,
    required String modelId,
    required String apiKey,
  });
}
