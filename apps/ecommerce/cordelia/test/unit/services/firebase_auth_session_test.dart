import 'package:core/core/auth/auth_session.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_auth_session.dart';

/// The contract every [AuthSession] implementation owes its callers.
///
/// Run against [FakeAuthSession] rather than the Firebase adapter, which
/// needs an initialised app: the value here is pinning what the *interface*
/// promises, so a second implementation has something to be checked against.
/// The pieces the adapter adds on top — mapping Firebase's `User?` stream to
/// uids, bridging the expiry notifier to a stream — are thin enough to read.
void main() {
  test('a session with no account reports itself signed out', () {
    final session = signOutFakeSession();

    expect(session.isSignedIn, isFalse);
    expect(session.currentUid, isNull);
  });

  test('signing in reports the uid and announces the change', () async {
    final session = signOutFakeSession();
    final seen = <String?>[];
    session.uidChanges.listen(seen.add);

    session.signIn('u1');
    await Future<void>.delayed(Duration.zero);

    expect(session.isSignedIn, isTrue);
    expect(session.currentUid, 'u1');
    expect(seen, ['u1']);
  });

  test('signing out announces null, not just a flag flip', () async {
    final session = signIntoFakeSession(uid: 'u1');
    final seen = <String?>[];
    session.uidChanges.listen(seen.add);

    session.signOut();
    await Future<void>.delayed(Duration.zero);

    expect(session.isSignedIn, isFalse);
    expect(seen, [null]);
  });

  test('an expiry ends the session and announces it separately', () async {
    final session = signIntoFakeSession(uid: 'u1');
    var expirations = 0;
    session.expirations.listen((_) => expirations++);

    await session.endSession();
    await Future<void>.delayed(Duration.zero);

    expect(session.isSignedIn, isFalse);
    expect(
      expirations,
      1,
      reason: 'expiry is the navigation signal, and it fires once',
    );
  });
}
