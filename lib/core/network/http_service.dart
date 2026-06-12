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
    Options? options,
  }) =>
      _dio.post<T>(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
}
