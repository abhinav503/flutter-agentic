abstract final class ApiConstants {
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com';
  static const String geminiGeneratePath = '/v1beta/models/gemini-2.5-flash:generateContent';

  static const String groqBaseUrl = 'https://api.groq.com';
  static const String groqChatPath = '/openai/v1/chat/completions';

  static const String claudeBaseUrl = 'https://api.anthropic.com';
  static const String claudeMessagesPath = '/v1/messages';
  static const String claudeApiVersion = '2023-06-01';
}
