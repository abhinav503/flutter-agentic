import 'package:dio/dio.dart';
import 'interceptors/logging_interceptor.dart';

Dio createDioClient({required String baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(LoggingInterceptor());
  return dio;
}
