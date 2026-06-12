import '../../../../core/usecase/usecase.dart';
import '../entities/ai_scan_model.dart';
import '../repository/receipt_scan_repository.dart';

class SelectModelParams {
  final AiScanModel model;
  const SelectModelParams({required this.model});
}

class SelectModelUseCase extends UseCase<void, SelectModelParams> {
  final ReceiptScanRepository _repository;
  const SelectModelUseCase(this._repository);

  @override
  Future<void> call(SelectModelParams params) =>
      _repository.selectModel(model: params.model);
}
