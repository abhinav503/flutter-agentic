import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/receipt_scan_repository.dart';

class DeleteReceiptParams {
  final String imagePath;
  const DeleteReceiptParams({required this.imagePath});
}

class DeleteReceiptUseCase
    extends UseCase<Either<Failure, Unit>, DeleteReceiptParams> {
  final ReceiptScanRepository _repository;
  const DeleteReceiptUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteReceiptParams params) =>
      _repository.deleteReceipt(imagePath: params.imagePath);
}
