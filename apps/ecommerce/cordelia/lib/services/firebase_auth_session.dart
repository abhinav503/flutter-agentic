import 'dart:async';

import 'package:core/core/auth/auth_session.dart';

import 'firebase_auth_service.dart';

/// The Firebase-backed [AuthSession] — the one place in the app that knows
/// the session comes from Firebase.
///
/// A thin adapter over [FirebaseAuthService] rather than a replacement for
/// it: that class stays as the SDK wrapper the `data` layer uses for
/// `idToken()` and the auth operations. This exposes only what the app's
/// screens and BLoCs are allowed to ask about a session, in terms that name
/// no provider.
class FirebaseAuthSession implements AuthSession {
  FirebaseAuthSession();

  final _service = FirebaseAuthService.instance;

  @override
  bool get isSignedIn => _service.isSignedIn;

  @override
  String? get currentUid => _service.currentUser?.uid;

  @override
  String? get currentEmail => _service.currentUser?.email;

  @override
  Stream<String?> get uidChanges =>
      _service.authStateChanges.map((user) => user?.uid);

  /// Bridges the service's `ValueNotifier` counter to the stream the port
  /// promises. Broadcast because the guard listening to it is rebuilt
  /// whenever the app is, and a single-subscription stream would throw the
  /// second time.
  @override
  Stream<void> get expirations {
    final notifier = _service.sessionExpired;
    late final StreamController<void> controller;
    void emit() => controller.add(null);
    controller = StreamController<void>.broadcast(
      onListen: () => notifier.addListener(emit),
      onCancel: () => notifier.removeListener(emit),
    );
    return controller.stream;
  }

  @override
  Future<void> endSession() => _service.endSession();
}
