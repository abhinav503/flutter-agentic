import 'dart:convert';

import 'package:core/core/network/http_service.dart';

import 'package:ai_chat/constants/api_constants.dart';
import 'package:ai_chat/enums/chat_mode.dart';
import 'chat_remote_data_source.dart';

/// Real data source talking to Groq's OpenAI-compatible chat-completions
/// endpoint. One endpoint serves both modes — `"stream": true` returns an SSE
/// stream of token deltas, `false` returns a single JSON response.
///
/// `const` no-arg per template convention; reaches the network via
/// `HttpService.instance` and reads config from [ApiConstants].
class GroqChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const GroqChatRemoteDataSourceImpl();

  Map<String, String> _headers(String apiKey) => {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

  Map<String, dynamic> _body(String prompt, {required bool stream}) => {
        'model': ApiConstants.groqModel,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'stream': stream,
      };

  @override
  Stream<String> sendMessage({
    required String prompt,
    required ChatMode mode,
    required String apiKey,
  }) =>
      mode == ChatMode.streaming
          ? _streaming(prompt, apiKey)
          : _oneShot(prompt, apiKey);

  // streaming: parse SSE `data:` frames, yielding each choices[0].delta.content
  Stream<String> _streaming(String prompt, String apiKey) async* {
    final response = await HttpService.instance.postStream(
      ApiConstants.groqChatCompletionsUrl,
      data: _body(prompt, stream: true),
      headers: _headers(apiKey),
    );

    var buffer = '';
    await for (final chunk in response.data!.stream) {
      buffer += utf8.decode(chunk, allowMalformed: true);
      int newline;
      while ((newline = buffer.indexOf('\n')) != -1) {
        final line = buffer.substring(0, newline).trim();
        buffer = buffer.substring(newline + 1);
        if (line.isEmpty || !line.startsWith('data:')) continue;
        final data = line.substring('data:'.length).trim();
        if (data == '[DONE]') return;
        final delta = _extractDelta(data);
        if (delta != null && delta.isNotEmpty) yield delta;
      }
    }
  }

  // one-shot: a single non-streamed response → yield the whole message once.
  Stream<String> _oneShot(String prompt, String apiKey) async* {
    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.groqChatCompletionsUrl,
      data: _body(prompt, stream: false),
      headers: _headers(apiKey),
    );
    final choices = response.data?['choices'] as List?;
    final content = (choices != null && choices.isNotEmpty)
        ? ((choices.first as Map)['message']?['content'] as String?)
        : null;
    if (content != null && content.isNotEmpty) yield content;
  }

  // Pulls choices[0].delta.content out of one SSE data frame; null for
  // keep-alives or frames without a content delta.
  String? _extractDelta(String data) {
    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      final choices = json['choices'] as List?;
      if (choices == null || choices.isEmpty) return null;
      final delta = (choices.first as Map)['delta'] as Map?;
      return delta?['content'] as String?;
    } catch (_) {
      return null; // ignore malformed / non-JSON lines
    }
  }
}
