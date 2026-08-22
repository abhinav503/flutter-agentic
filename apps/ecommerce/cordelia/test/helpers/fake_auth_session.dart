import 'dart:async';

import 'package:core/core/auth/auth_session.dart';
import 'package:core/core/di/core_injection.dart';
import 'package:flutter_test/flutter_test.dart';

/// A session a test can drive.
///
/// Replaces the static `debugSignedIn` override that used to live on
/// `FirebaseAuthService`: that was global mutable state in production code,
/// and a test forgetting to reset it changed the next one. This is
/// registered into GetIt per test and goes away with it.
///
/// [signIn]/[signOut] drive [uidChanges], so a test can exercise what the
/// app does when the account changes underneath it — the path
/// `ProfileBloc` follows and which no test could reach before.
class FakeAuthSession implements AuthSession {
  FakeAuthSession({String? initialUid, this.currentEmail}) : _uid = initialUid;

  final _uids = StreamController<String?>.broadcast();
  final _expirations = StreamController<void>.broadcast();

  String? _uid;

  @override
  String? currentEmail;

  @override
  bool get isSignedIn => _uid != null;

  @override
  String? get currentUid => _uid;

  @override
  Stream<String?> get uidChanges => _uids.stream;

  @override
  Stream<void> get expirations => _expirations.stream;

  int endSessionCalls = 0;

  @override
  Future<void> endSession() async {
    endSessionCalls++;
    signOut();
    _expirations.add(null);
  }

  void signIn(String uid) {
    _uid = uid;
    _uids.add(uid);
  }

  void signOut() {
    _uid = null;
    _uids.add(null);
  }

  /// Call from `addTearDown` — a leaked broadcast controller keeps the test
  /// binding alive and turns an unrelated later failure into a mystery.
  void dispose() {
    _uids.close();
    _expirations.close();
  }
}

/// Registers a [FakeAuthSession] holding [uid] and returns it, replacing any
/// already registered. Call from `setUp`; the registration is torn down with
/// the test.
///
/// Most tests only care *that* somebody is signed in, which is what the two
/// wrappers below say at a glance. Take the return value when the test needs
/// to change the account mid-run.
FakeAuthSession registerFakeSession({String? uid, String? email}) {
  if (sl.isRegistered<AuthSession>()) sl.unregister<AuthSession>();
  final session = FakeAuthSession(initialUid: uid, currentEmail: email);
  sl.registerSingleton<AuthSession>(session);
  addTearDown(() {
    session.dispose();
    if (sl.isRegistered<AuthSession>()) sl.unregister<AuthSession>();
  });
  return session;
}

/// A session with an account behind it — the signed-in half of any screen
/// that gates on one.
FakeAuthSession signIntoFakeSession({String uid = 'test-uid'}) =>
    registerFakeSession(uid: uid, email: 'shopper@example.com');

/// A session with nobody behind it — a guest.
FakeAuthSession signOutFakeSession() => registerFakeSession();
