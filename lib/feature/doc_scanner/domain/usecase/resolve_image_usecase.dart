import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/receipt_scan_repository.dart';

class ResolveImageParams {
  final String tempPath;
  const ResolveImageParams({required this.tempPath});
}

class ResolveImageUseCase
    extends UseCase<Either<Failure, ({String id, String imagePath})>, ResolveImageParams> {
  final ReceiptScanRepository _repository;
  const ResolveImageUseCase(this._repository);

  @override
  Future<Either<Failure, ({String id, String imagePath})>> call(
          ResolveImageParams params) =>
      _repository.resolveImage(tempPath: params.tempPath);
}
