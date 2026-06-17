/// All user-facing copy for the ai_chat app. No inline string literals in
/// widgets — add new strings here.
class ValueConst {
  const ValueConst._();

  static const appTitle = 'AI Chat';
  static const homeAppBarTitle = 'AI Chat';

  static const inputHint = 'Message AI Chat…';
  static const sendButton = 'Send';
  static const stopButton = 'Stop';
  static const retryButton = 'Retry';

  static const emptyTitle = 'Start a conversation';
  static const emptySubtitle =
      'Ask anything — replies stream in token by token from a local mock.';

  static const assistantError =
      'Something went wrong while responding. Tap retry to try again.';

  // Reply mode toggle
  static const modeTooltip = 'Reply mode';
  static const modeStreaming = 'Streaming';
  static const modeStreamingSubtitle = 'Token by token';
  static const modeOneShot = 'One-shot';
  static const modeOneShotSubtitle = 'Whole reply at once';

  // API key (BYOK)
  static const groqApiKeyStorageKey = 'groq_api_key';
  static const settingsTooltip = 'Groq API key';
  static const apiKeySheetTitle = 'Groq API key';
  static const apiKeyModelLabel = 'Model: Groq';
  static const apiKeyFieldLabel = 'API key';
  static const apiKeyHint = 'gsk_…';
  static const apiKeyHelp =
      'Paste your Groq API key to chat with a real model. Without a key the app '
      'replies from a local mock. The key is stored on this device only.';
  static const saveButton = 'Save';
  static const clearButton = 'Clear';
  static const apiKeySaved = 'API key saved — now using Groq';
  static const apiKeyCleared = 'API key cleared — using local mock';
}
