import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/services/network/session_expiry_interceptor.dart';

const _apiBase = 'https://example.test/api';

DioException _error({required String url, int? status}) => DioException(
  requestOptions: RequestOptions(path: url),
  response: status == null
      ? null
      : Response<dynamic>(
          requestOptions: RequestOptions(path: url),
          statusCode: status,
        ),
);

/// Records whether the session was ended, without needing Firebase — the
/// interceptor takes the callback precisely so this is testable.
class _EndSessionSpy {
  int calls = 0;
  Future<void> call() async => calls++;
}

void main() {
  late _EndSessionSpy spy;
  late SessionExpiryInterceptor interceptor;

  setUp(() {
    spy = _EndSessionSpy();
    interceptor = SessionExpiryInterceptor(
      onUnauthorized: spy.call,
      apiBaseUrl: _apiBase,
    );
  });

  // The interceptor must never swallow the error: every existing failure path
  // (BaseRepository's mapping, the screens' error views) is downstream of it.
  void expectPropagates(DioException err) {
    var passedOn = false;
    interceptor.onError(err, _CapturingHandler(onNext: () => passedOn = true));
    expect(passedOn, isTrue);
  }

  test('a 401 from our API ends the session', () {
    final err = _error(url: '$_apiBase/stores/s1/orders', status: 401);
    expectPropagates(err);
    expect(spy.calls, 1);
  });

  test('a 401 from another host does not', () {
    // An image CDN or a map tile answering 401 says nothing about whether
    // this shopper is still signed in to us.
    expectPropagates(_error(url: 'https://cdn.example.com/x.png', status: 401));
    expect(spy.calls, 0);
  });

  test('a 403 leaves the session alone', () {
    // "You may not do this" is a real answer to a real question, not a dead
    // session — signing out on it would log people out of their own mistakes.
    expectPropagates(_error(url: '$_apiBase/stores/s1', status: 403));
    expect(spy.calls, 0);
  });

  test('a transport failure with no response leaves the session alone', () {
    // Offline is the case that must never sign anyone out: it is transient,
    // and the shopper would come back to a login screen for a lost signal.
    expectPropagates(_error(url: '$_apiBase/stores'));
    expect(spy.calls, 0);
  });

  test('a burst of 401s is still one end-session call', () {
    // Screens fire several requests at once, so one dead token produces
    // several 401s. Re-entrancy is guarded in FirebaseAuthService.endSession;
    // here we only assert the interceptor calls it per error and never
    // suppresses one, which is what makes that guard the single owner.
    for (var i = 0; i < 3; i++) {
      expectPropagates(_error(url: '$_apiBase/users', status: 401));
    }
    expect(spy.calls, 3);
  });
}

/// Records which of the three outcomes the interceptor chose.
///
/// Extends rather than implements: `ErrorInterceptorHandler`'s base class
/// carries private completer members that cannot be satisfied from outside
/// Dio. Overriding without `super` keeps that completer untouched, which is
/// what we want — nothing here awaits the chain.
class _CapturingHandler extends ErrorInterceptorHandler {
  final void Function() onNext;

  _CapturingHandler({required this.onNext});

  @override
  void next(DioException err) => onNext();

  @override
  void reject(DioException error) =>
      fail('the interceptor must not reject; it only observes');

  @override
  void resolve(Response<dynamic> response) =>
      fail('the interceptor must not resolve; it only observes');
}
