import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';

/// Mixin that wraps repository calls with consistent Dio error mapping.
///
/// Converts [DioException] variants into typed [Failure] values so every
/// repository implementation stays free of duplicated try/catch boilerplate.
mixin BaseRepository {
  Future<Either<Failure, T>> handleRequest<T>(
    Future<Either<Failure, T>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        return left(Failure.network(message: e.message ?? 'Network error'));
      }
      return left(Failure.server(
        statusCode: e.response?.statusCode ?? 0,
        message: e.message ?? 'Server error',
      ));
    } catch (e) {
      return left(Failure.unexpected(message: e.toString()));
    }
  }

  bool _isNetworkError(DioException e) =>
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout;
}
