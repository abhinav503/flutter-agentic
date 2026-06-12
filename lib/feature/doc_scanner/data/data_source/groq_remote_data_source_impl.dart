import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/value_const.dart';
import '../../../../core/network/http_service.dart';
import '../models/receipt_extraction_model.dart';
import 'doc_scanner_remote_data_source.dart';

class GroqRemoteDataSourceImpl implements DocScannerRemoteDataSource {
  const GroqRemoteDataSourceImpl();

  @override
  Future<ReceiptExtractionModel?> extractReceiptData({
    required String base64Image,
    required String mimeType,
    required String modelId,
    required String apiKey,
  }) async {
    final kb = (base64Image.length * 3 / 4 / 1024).round();
    debugPrint('[Groq] model=$modelId sending image ~${kb}KB');

    final response = await HttpService.instance.post<Map<String, dynamic>>(
      '${ApiConstants.groqBaseUrl}${ApiConstants.groqChatPath}',
      data: {
        'model': modelId,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image_url',
                'image_url': {'url': 'data:$mimeType;base64,$base64Image'},
              },
              {'type': 'text', 'text': ValueConst.docScannerReceiptPrompt},
            ],
          },
        ],
      },
      options: Options(
        headers: {'Authorization': 'Bearer $apiKey'},
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    debugPrint('[Groq] response received');
    final choices = response.data?['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      debugPrint('[Groq] unexpected response shape: ${response.data}');
      return null;
    }
    final message = (choices.first as Map?)?['message'];
    final content = (message as Map?)?['content'];
    if (content is! String) {
      debugPrint('[Groq] content is not a String: $content');
      return null;
    }
    return _parse(content);
  }

  static ReceiptExtractionModel? _parse(String raw) {
    try {
      final clean = raw
          .replaceAll(RegExp(r'```json\s*'), '')
          .replaceAll(RegExp(r'```\s*'), '')
          .trim();
      return ReceiptExtractionModel.fromJson(
        jsonDecode(clean) as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('[Groq] _parse error: $e\nRaw: $raw');
      return null;
    }
  }
}
