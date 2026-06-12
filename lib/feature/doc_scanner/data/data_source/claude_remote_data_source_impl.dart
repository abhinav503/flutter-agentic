import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/value_const.dart';
import '../../../../core/network/http_service.dart';
import '../models/receipt_extraction_model.dart';
import 'doc_scanner_remote_data_source.dart';

class ClaudeRemoteDataSourceImpl implements DocScannerRemoteDataSource {
  const ClaudeRemoteDataSourceImpl();

  @override
  Future<ReceiptExtractionModel?> extractReceiptData({
    required String base64Image,
    required String mimeType,
    required String modelId,
    required String apiKey,
  }) async {
    final kb = (base64Image.length * 3 / 4 / 1024).round();
    debugPrint('[Claude] model=$modelId sending image ~${kb}KB');

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      '${ApiConstants.claudeBaseUrl}${ApiConstants.claudeMessagesPath}',
      data: {
        'model': modelId,
        'max_tokens': 256,
        'system': ValueConst.docScannerSystemPromptClaude,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image',
                'source': {
                  'type': 'base64',
                  'media_type': mimeType,
                  'data': base64Image,
                },
              },
              {'type': 'text', 'text': ValueConst.docScannerReceiptPrompt},
            ],
          },
          // Prefill forces Claude to begin its response as JSON.
          // The opening '{' is not included in the response text, so we prepend it below.
          {'role': 'assistant', 'content': '{'},
        ],
      },
      options: Options(
        headers: {
          'x-api-key': apiKey,
          'anthropic-version': ApiConstants.claudeApiVersion,
        },
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    debugPrint('[Claude] response received');
    final content = response.data?['content'] as List?;
    if (content == null || content.isEmpty) {
      debugPrint('[Claude] unexpected response shape: ${response.data}');
      return null;
    }

    for (final block in content) {
      final text = (block as Map?)?['text'];
      if (text is String) return _parse('{$text');
    }
    debugPrint('[Claude] no text block found in: $content');
    return null;
  }

  static ReceiptExtractionModel? _parse(String raw) {
    try {
      return ReceiptExtractionModel.fromJson(
        jsonDecode(raw.trim()) as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('[Claude] _parse error: $e\nRaw: $raw');
      return null;
    }
  }
}
