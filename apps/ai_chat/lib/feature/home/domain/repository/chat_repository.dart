import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import 'package:ai_chat/enums/chat_mode.dart';

/// Chat + Groq API-key management.
abstract interface class ChatRepository {
  /// Streams an assistant reply for [prompt] as a sequence of token deltas.
  ///
  /// Routes to the real Groq backend when a key is saved, otherwise to the
  /// local mock. Each `right(delta)` is text to append to the current assistant
  /// message; in [ChatMode.oneShot] a single delta carries the whole reply.
  /// Stream completion means the reply finished; `left(Failure)` means it
  /// failed. No exceptions cross this boundary — errors are values.
  Stream<Either<Failure, String>> sendMessage(String prompt, ChatMode mode);

  /// The saved Groq API key, or empty string when none is set.
  Future<String> getApiKey();

  /// Saves the Groq API key (or clears it when [apiKey] is blank).
  Future<void> saveApiKey(String apiKey);
}
