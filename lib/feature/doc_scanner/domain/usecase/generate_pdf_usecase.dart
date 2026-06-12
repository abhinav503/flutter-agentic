import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/scanned_receipt_entity.dart';
import '../repository/receipt_scan_repository.dart';

class GeneratePdfParams {
  final List<ScannedReceiptEntity> receipts;
  const GeneratePdfParams({required this.receipts});
}

class GeneratePdfUseCase
    extends UseCase<Either<Failure, String>, GeneratePdfParams> {
  final ReceiptScanRepository _repository;
  const GeneratePdfUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(GeneratePdfParams params) =>
      _repository.generatePdf(receipts: params.receipts);
}
