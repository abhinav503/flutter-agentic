import '../../../../core/usecase/usecase.dart';
import '../entities/ai_scan_model.dart';
import '../repository/receipt_scan_repository.dart';

class SaveApiKeyParams {
  final AiScanModel model;
  final String apiKey;
  const SaveApiKeyParams({required this.model, required this.apiKey});
}

class SaveApiKeyUseCase extends UseCase<void, SaveApiKeyParams> {
  final ReceiptScanRepository _repository;
  const SaveApiKeyUseCase(this._repository);

  @override
  Future<void> call(SaveApiKeyParams params) =>
      _repository.saveApiKey(model: params.model, apiKey: params.apiKey);
}
