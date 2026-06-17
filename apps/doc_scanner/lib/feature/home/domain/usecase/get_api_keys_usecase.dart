import 'package:core/core/usecase/usecase.dart';
import '../repository/receipt_scan_repository.dart';

class GetApiKeysUseCase extends UseCase<Map<String, String>, NoParams> {
  final ReceiptScanRepository _repository;
  const GetApiKeysUseCase(this._repository);

  @override
  Future<Map<String, String>> call(NoParams params) =>
      _repository.getApiKeys();
}
