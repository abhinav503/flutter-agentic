import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(options);
      return;
    }
    final bodySize = options.data != null
        ? '${_roughSize(options.data)} bytes'
        : 'no body';
    debugPrint('[REQ] ${options.method} ${options.uri} — $bodySize');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[RES] ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final status = err.response?.statusCode;
      final url = err.requestOptions.uri;
      debugPrint('[ERR] $status $url');
      debugPrint('[ERR] type: ${err.type.name}');
      if (err.error != null) {
        debugPrint('[ERR] cause: ${err.error}');
      }
      if (err.response?.data != null) {
        final body = err.response!.data.toString();
        debugPrint('[ERR] body: ${body.length > 400 ? '${body.substring(0, 400)}…' : body}');
      }
    }
    handler.next(err);
  }

  int _roughSize(dynamic data) {
    try {
      return data.toString().length;
    } catch (_) {
      return 0;
    }
  }
}
