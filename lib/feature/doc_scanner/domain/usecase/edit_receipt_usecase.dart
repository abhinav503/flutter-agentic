import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/extraction_status.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/scanned_receipt_entity.dart';
import '../repository/receipt_scan_repository.dart';

class EditReceiptParams {
  final ScannedReceiptEntity original;
  final String? restaurantName;
  final double? amount;
  final String? date;

  const EditReceiptParams({
    required this.original,
    required this.restaurantName,
    required this.amount,
    required this.date,
  });
}

/// Applies a user-initiated edit to a receipt.
///
/// Immutable fields (id, imagePath, currency) are preserved from [original].
/// Editable fields (restaurantName, amount, date) are replaced with the
/// supplied values. Status is forced to [ExtractionStatus.done] and any
/// prior errorMessage is cleared.
class EditReceiptUseCase
    extends UseCase<Either<Failure, ScannedReceiptEntity>, EditReceiptParams> {
  final ReceiptScanRepository _repository;
  const EditReceiptUseCase(this._repository);

  @override
  Future<Either<Failure, ScannedReceiptEntity>> call(
      EditReceiptParams params) async {
    final updated = ScannedReceiptEntity(
      id: params.original.id,
      imagePath: params.original.imagePath,
      currency: params.original.currency,
      restaurantName: params.restaurantName,
      amount: params.amount,
      date: params.date,
      status: ExtractionStatus.done,
    );
    final result = await _repository.saveReceipt(receipt: updated);
    return result.map((_) => updated);
  }
}
