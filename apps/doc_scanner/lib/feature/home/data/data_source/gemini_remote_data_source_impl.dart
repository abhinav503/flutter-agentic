import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:doc_scanner/constants/api_constants.dart';
import 'package:doc_scanner/constants/value_const.dart';
import 'package:core/core/network/http_service.dart';
import '../models/receipt_extraction_model.dart';
import 'doc_scanner_remote_data_source.dart';

class GeminiRemoteDataSourceImpl implements DocScannerRemoteDataSource {
  const GeminiRemoteDataSourceImpl();

  @override
  Future<ReceiptExtractionModel?> extractReceiptData({
    required String base64Image,
    required String mimeType,
    required String modelId,
    required String apiKey,
  }) async {
    final kb = (base64Image.length * 3 / 4 / 1024).round();
    debugPrint('[Gemini] sending image ~${kb}KB mime=$mimeType');

    final body = {
      'contents': [
        {
          'parts': [
            {
              'inline_data': {'mime_type': mimeType, 'data': base64Image},
            },
            {'text': ValueConst.docScannerReceiptPromptGemini},
          ],
        },
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
        'responseSchema': {
          'type': 'object',
          'properties': {
            'restaurant_name': {'type': 'string', 'nullable': true},
            'date': {
              'type': 'string',
              'description': 'YYYY-MM-DD format',
              'nullable': true,
            },
            'total_amount': {'type': 'number', 'nullable': true},
            'currency': {'type': 'string', 'nullable': true},
          },
        },
      },
    };

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      '${ApiConstants.geminiBaseUrl}${ApiConstants.geminiGeneratePath}',
      data: body,
      options: Options(
        headers: {'X-goog-api-key': apiKey},
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
    debugPrint('[Gemini] response received');

    final candidates = response.data?['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      debugPrint('[Gemini] unexpected response shape: ${response.data}');
      return null;
    }

    final content = (candidates.first as Map?)?['content'];
    final parts = (content as Map?)?['parts'] as List?;
    if (parts == null) {
      debugPrint('[Gemini] no parts in response: $content');
      return null;
    }

    for (final part in parts) {
      final text = (part as Map?)?['text'];
      if (text is String) return _parse(text);
    }
    debugPrint('[Gemini] no text part found in: $parts');
    return null;
  }

  static ReceiptExtractionModel? _parse(String raw) {
    try {
      return ReceiptExtractionModel.fromJson(
        jsonDecode(raw.trim()) as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('[Gemini] _parse error: $e\nRaw: $raw');
      return null;
    }
  }
}
