import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/scanned_receipt_entity.dart';
import '../repository/receipt_scan_repository.dart';

class SaveReceiptParams {
  final ScannedReceiptEntity receipt;
  const SaveReceiptParams({required this.receipt});
}

class SaveReceiptUseCase extends UseCase<Either<Failure, Unit>, SaveReceiptParams> {
  final ReceiptScanRepository _repository;
  const SaveReceiptUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(SaveReceiptParams params) =>
      _repository.saveReceipt(receipt: params.receipt);
}
