import 'package:ai_chat/enums/chat_mode.dart';

/// Transport-level source of assistant reply tokens.
///
/// Returns a [Stream] of raw text deltas. In [ChatMode.streaming] it yields
/// many deltas as they arrive; in [ChatMode.oneShot] it yields a single delta
/// with the full reply. [apiKey] is the Groq key (empty for the mock). The
/// dispatcher routes to the mock or Groq impl based on whether a key is set.
abstract interface class ChatRemoteDataSource {
  Stream<String> sendMessage({
    required String prompt,
    required ChatMode mode,
    required String apiKey,
  });
}
