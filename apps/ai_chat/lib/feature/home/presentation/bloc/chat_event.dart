part of 'chat_bloc.dart';

@freezed
sealed class ChatEvent with _$ChatEvent {
  /// Loads any persisted Groq API key on startup.
  const factory ChatEvent.started() = ChatStarted;

  /// User submitted a prompt.
  const factory ChatEvent.sendPressed({required String prompt}) =
      ChatSendPressed;

  /// User tapped Stop while a reply was streaming.
  const factory ChatEvent.stopPressed() = ChatStopPressed;

  /// User tapped Retry after a failed reply — re-streams the last prompt.
  const factory ChatEvent.retryPressed() = ChatRetryPressed;

  /// User switched between streaming and one-shot reply modes.
  const factory ChatEvent.modeChanged({required ChatMode mode}) =
      ChatModeChanged;

  /// User saved (or cleared) the Groq API key in settings.
  const factory ChatEvent.apiKeySaved({required String apiKey}) =
      ChatApiKeySaved;
}
