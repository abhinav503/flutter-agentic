part of 'chat_bloc.dart';

/// Chat is a single, continuously evolving state rather than mutually
/// exclusive phases — messages, the in-flight reply, and errors all coexist.
/// So this is one Freezed data class with `copyWith`, not a sealed union.
/// Per-message lifecycle lives on [ChatMessageEntity.status]; [isResponding]
/// is true while a reply is streaming (drives the Send/Stop toggle).
@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default(<ChatMessageEntity>[]) List<ChatMessageEntity> messages,
    @Default(false) bool isResponding,
    @Default(ChatMode.streaming) ChatMode mode,
    @Default('') String apiKey,
  }) = _ChatState;
  const ChatState._();

  /// True once a Groq key is saved — replies come from Groq, not the mock.
  bool get hasApiKey => apiKey.trim().isNotEmpty;
}
