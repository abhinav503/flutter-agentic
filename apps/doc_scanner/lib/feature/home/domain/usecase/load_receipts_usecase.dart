import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import '../entities/scanned_receipt_entity.dart';
import '../repository/receipt_scan_repository.dart';

class LoadReceiptsUseCase
    extends UseCase<Either<Failure, List<ScannedReceiptEntity>>, NoParams> {
  final ReceiptScanRepository _repository;
  const LoadReceiptsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ScannedReceiptEntity>>> call(NoParams _) =>
      _repository.loadReceipts();
}
