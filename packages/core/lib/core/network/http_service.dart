import 'package:dio/dio.dart';

import 'interceptors/logging_interceptor.dart';

class HttpService {
  HttpService._();

  static final HttpService instance = HttpService._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.add(LoggingInterceptor());

  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(url, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
  }) =>
      _dio.post<T>(
        url,
        data: data,
        queryParameters: queryParameters,
        options: headers != null
            ? (options ?? Options()).copyWith(headers: headers)
            : options,
      );

  /// Streaming POST for server-sent events (SSE) and other chunked responses.
  ///
  /// Returns the raw byte stream of the response body
  /// (`response.data!.stream`), which the caller decodes and parses (e.g. SSE
  /// `data:` frames). Used for token-by-token LLM streaming. The receive
  /// timeout is relaxed so a long-running stream isn't aborted between tokens.
  Future<Response<ResponseBody>> postStream(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) =>
      _dio.post<ResponseBody>(
        url,
        data: data,
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(minutes: 5),
          headers: headers,
        ),
      );
}
