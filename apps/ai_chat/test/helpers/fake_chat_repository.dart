import 'package:ai_chat/enums/chat_mode.dart';
import 'package:ai_chat/feature/home/domain/repository/chat_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Manual fake (no mockito/mocktail). Configure [deltas] for the reply tokens
/// and [failure] to emit an error; [storedKey] backs the API-key methods.
/// Records the [lastMode] sendMessage was called with.
class FakeChatRepository implements ChatRepository {
  List<String> deltas = const [];
  Failure? failure;
  String storedKey = '';
  ChatMode? lastMode;

  @override
  Stream<Either<Failure, String>> sendMessage(String prompt, ChatMode mode) async* {
    lastMode = mode;
    for (final d in deltas) {
      yield right(d);
    }
    if (failure != null) yield left(failure!);
  }

  @override
  Future<String> getApiKey() async => storedKey;

  @override
  Future<void> saveApiKey(String apiKey) async => storedKey = apiKey.trim();
}
