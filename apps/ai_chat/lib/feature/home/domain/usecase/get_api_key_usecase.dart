import 'package:core/core/usecase/usecase.dart';

import '../repository/chat_repository.dart';

class GetApiKeyUseCase extends UseCase<String, NoParams> {
  final ChatRepository _repository;
  const GetApiKeyUseCase(this._repository);

  @override
  Future<String> call(NoParams params) => _repository.getApiKey();
}
