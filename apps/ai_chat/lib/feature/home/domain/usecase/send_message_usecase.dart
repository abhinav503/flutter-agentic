import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import 'package:ai_chat/enums/chat_mode.dart';
import '../repository/chat_repository.dart';

class SendMessageParams {
  final String prompt;
  final ChatMode mode;
  const SendMessageParams({required this.prompt, required this.mode});
}

/// Streams the assistant reply for a prompt. Uses [StreamUseCase] because the
/// result arrives as token deltas over time (one delta in one-shot mode, many
/// in streaming mode), not a single synchronous value.
class SendMessageUseCase
    extends StreamUseCase<Either<Failure, String>, SendMessageParams> {
  final ChatRepository _repository;
  const SendMessageUseCase(this._repository);

  @override
  Stream<Either<Failure, String>> call(SendMessageParams params) =>
      _repository.sendMessage(params.prompt, params.mode);
}
