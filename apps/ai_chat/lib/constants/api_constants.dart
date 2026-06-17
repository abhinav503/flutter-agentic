/// API endpoints + config for the ai_chat app.
///
/// The app replies from a **local mock by default** (no network, no key), so it
/// always clones-and-runs. Paste a Groq API key in-app (top-bar key action) to
/// switch to a real model — the key is stored on-device and the user can then
/// choose streaming (token-by-token) or one-shot replies.
class ApiConstants {
  const ApiConstants._();

  // Groq is OpenAI-compatible. One endpoint handles both modes — set
  // "stream": true for token-by-token SSE, or false for a single response.
  static const groqChatCompletionsUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const groqModel = 'llama-3.3-70b-versatile';
}
