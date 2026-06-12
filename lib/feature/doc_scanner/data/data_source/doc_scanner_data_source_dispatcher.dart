import '../../../../core/constants/value_const.dart';
import '../../../../core/services/shared_pref_service/shared_preference_service.dart';
import '../../domain/entities/ai_scan_model.dart';
import 'claude_remote_data_source_impl.dart';
import '../models/receipt_extraction_model.dart';
import 'doc_scanner_remote_data_source.dart';
import 'gemini_remote_data_source_impl.dart';
import 'groq_remote_data_source_impl.dart';

class DocScannerDataSourceDispatcher implements DocScannerRemoteDataSource {
  const DocScannerDataSourceDispatcher();

  DocScannerRemoteDataSource get _current {
    final saved = SharedPreferenceService.instance
        .getString(ValueConst.docScannerSelectedModelKey);
    final model = AiScanModel.all.firstWhere(
      (m) => m.id == saved,
      orElse: () => AiScanModel.defaultModel,
    );
    return switch (model.provider) {
      AiModelProvider.gemini => const GeminiRemoteDataSourceImpl(),
      AiModelProvider.claude => const ClaudeRemoteDataSourceImpl(),
      AiModelProvider.groq => const GroqRemoteDataSourceImpl(),
    };
  }

  @override
  Future<ReceiptExtractionModel?> extractReceiptData({
    required String base64Image,
    required String mimeType,
    required String modelId,
    required String apiKey,
  }) =>
      _current.extractReceiptData(
        base64Image: base64Image,
        mimeType: mimeType,
        modelId: modelId,
        apiKey: apiKey,
      );
}
