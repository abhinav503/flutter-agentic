import '../../../../core/usecase/usecase.dart';
import '../entities/ai_scan_model.dart';
import '../repository/receipt_scan_repository.dart';

class GetSelectedModelUseCase extends UseCase<AiScanModel, NoParams> {
  final ReceiptScanRepository _repository;
  const GetSelectedModelUseCase(this._repository);

  @override
  Future<AiScanModel> call(NoParams params) => _repository.getSelectedModel();
}
