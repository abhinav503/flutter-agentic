import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ai_scan_model.dart';
import '../entities/scanned_receipt_entity.dart';
import '../repository/receipt_scan_repository.dart';

class ScanReceiptParams {
  final ScannedReceiptEntity receipt;
  final AiScanModel model;
  final String apiKey;
  const ScanReceiptParams({
    required this.receipt,
    required this.model,
    required this.apiKey,
  });
}

class ScanReceiptUseCase
    extends UseCase<Either<Failure, ScannedReceiptEntity>, ScanReceiptParams> {
  final ReceiptScanRepository _repository;
  const ScanReceiptUseCase(this._repository);

  @override
  Future<Either<Failure, ScannedReceiptEntity>> call(
    ScanReceiptParams params,
  ) =>
      _repository.scanReceipt(
        receipt: params.receipt,
        model: params.model,
        apiKey: params.apiKey,
      );
}
