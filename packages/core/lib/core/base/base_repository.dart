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
      return left(_mapDioError(e));
    } catch (e) {
      return left(Failure.unexpected(message: e.toString()));
    }
  }

  /// Streaming counterpart to [handleRequest]. Wraps a source [Stream] of
  /// values (e.g. SSE token deltas) and yields each as `right(value)`, mapping
  /// any error into a typed [Failure] so no exception crosses the layer
  /// boundary. Completes naturally when the source completes.
  Stream<Either<Failure, T>> handleStream<T>(
    Stream<T> Function() source,
  ) async* {
    try {
      await for (final value in source()) {
        yield right(value);
      }
    } on DioException catch (e) {
      yield left(_mapDioError(e));
    } catch (e) {
      yield left(Failure.unexpected(message: e.toString()));
    }
  }

  Failure _mapDioError(DioException e) {
    if (_isNetworkError(e)) {
      return Failure.network(message: e.message ?? 'Network error');
    }
    return Failure.server(
      statusCode: e.response?.statusCode ?? 0,
      message: _serverMessage(e),
    );
  }

  bool _isNetworkError(DioException e) =>
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      // unknown wraps socket/SSL exceptions that produce no HTTP response
      (e.type == DioExceptionType.unknown && e.response == null);

  // Extracts a human-readable message from the response body when the API
  // returns a structured error (e.g. {"error": {"message": "..."}}), so the
  // caller sees the real reason instead of Dio's generic description.
  String _serverMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final error = data['error'];
      if (error is Map && error['message'] is String) {
        return error['message'] as String;
      }
      if (data['message'] is String) return data['message'] as String;
    }
    return e.message ?? e.error?.toString() ?? 'Server error';
  }
}
