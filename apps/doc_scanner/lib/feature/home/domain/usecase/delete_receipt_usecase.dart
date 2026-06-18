import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import '../repository/receipt_scan_repository.dart';

class DeleteReceiptParams {
  final String id;
  const DeleteReceiptParams({required this.id});
}

class DeleteReceiptUseCase
    extends UseCase<Either<Failure, Unit>, DeleteReceiptParams> {
  final ReceiptScanRepository _repository;
  const DeleteReceiptUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteReceiptParams params) =>
      _repository.deleteReceipt(id: params.id);
}
