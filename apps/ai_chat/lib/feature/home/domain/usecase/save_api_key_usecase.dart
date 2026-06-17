import 'package:core/core/usecase/usecase.dart';

import '../repository/chat_repository.dart';

class SaveApiKeyParams {
  final String apiKey;
  const SaveApiKeyParams({required this.apiKey});
}

class SaveApiKeyUseCase extends UseCase<void, SaveApiKeyParams> {
  final ChatRepository _repository;
  const SaveApiKeyUseCase(this._repository);

  @override
  Future<void> call(SaveApiKeyParams params) =>
      _repository.saveApiKey(params.apiKey);
}
