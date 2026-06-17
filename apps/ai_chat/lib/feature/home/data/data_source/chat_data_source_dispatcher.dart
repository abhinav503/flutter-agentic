import 'package:ai_chat/enums/chat_mode.dart';
import 'chat_remote_data_source.dart';
import 'chat_remote_data_source_impl.dart';
import 'groq_chat_remote_data_source_impl.dart';

/// Routes a send to the real Groq source when an [apiKey] is set, otherwise to
/// the local mock — so the app works with zero setup and upgrades to a real
/// model the moment a key is saved. `const` no-arg per template convention.
class ChatDataSourceDispatcher implements ChatRemoteDataSource {
  const ChatDataSourceDispatcher();

  static const _groq = GroqChatRemoteDataSourceImpl();
  static const _mock = MockChatRemoteDataSourceImpl();

  @override
  Stream<String> sendMessage({
    required String prompt,
    required ChatMode mode,
    required String apiKey,
  }) {
    final source = apiKey.trim().isNotEmpty ? _groq : _mock;
    return source.sendMessage(prompt: prompt, mode: mode, apiKey: apiKey);
  }
}
