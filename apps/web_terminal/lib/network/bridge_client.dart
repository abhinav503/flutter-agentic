import 'package:core/core/network/http_service.dart';

/// the dev fallback origin is supplied via [configure] at startup, so the class can
/// move to `core` later as a pure relocation if a second app needs it.
class BridgeClient {
  BridgeClient._();
  static final BridgeClient instance = BridgeClient._();

  late String _fallbackOrigin;

  /// Call once at startup
  void configure({required String fallbackOrigin}) =>
      _fallbackOrigin = fallbackOrigin;

  // Serving origin first, then the dev fallback. A set literal keeps insertion
  // order and dedupes when they coincide (page already served by the bridge).
  Iterable<String> get _origins => {
        if (Uri.base.scheme.startsWith('http')) Uri.base.origin,
        _fallbackOrigin,
      };

  /// Runs [request] against each candidate origin in order, returning the first
  /// success. Throws with the last error only if every origin fails.
  Future<T> send<T>(Future<T> Function(String origin) request) async {
    Object? lastError;
    for (final origin in _origins) {
      try {
        return await request(origin);
      } catch (e) {
        lastError = e;
      }
    }
    throw Exception('Could not reach the local bridge. $lastError');
  }

  /// GET [path] (joined onto the resolved origin) and return the JSON body.
  Future<Map<String, dynamic>> getJson(String path) => send(
        (origin) => HttpService.instance
            .get<Map<String, dynamic>>('$origin$path')
            .then((r) => r.data!),
      );

  /// POST [path] (joined onto the resolved origin) with an optional JSON [body]
  /// and return the JSON response.
  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) =>
      send(
        (origin) => HttpService.instance
            .post<Map<String, dynamic>>('$origin$path', data: body)
            .then((r) => r.data!),
      );
}
