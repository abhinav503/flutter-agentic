import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:cordelia/feature/storefront/profile/domain/entities/profile_entity.dart';
import 'package:cordelia/feature/storefront/profile/domain/usecase/get_profile_usecase.dart';
import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc.dart';
import '../../../../helpers/fake_auth_session.dart';

/// A guest who signs in from the gated Profile tab reaches Login through the
/// **shell page's** context, which sits above `buildBlocProviders` — so the
/// gate could never reach in and refresh this bloc, and the tab sat on its
/// skeleton for the rest of the visit (`ProfileSignedOut` renders one).
///
/// The bloc follows the account itself now, so there is nothing to reach in
/// and tell. These pin the two halves of that: a guest settles rather than
/// shimmers, and `started` fetches once an account exists.
class _FakeGetProfileUseCase implements GetProfileUseCase {
  int calls = 0;

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) async {
    calls++;
    return right(
      const ProfileEntity(
        name: 'Sam',
        email: 'sam@example.com',
        phone: '',
        avatarUrl: '',
      ),
    );
  }
}

void main() {
  late _FakeGetProfileUseCase getProfile;

  setUp(() => getProfile = _FakeGetProfileUseCase());

  ProfileBloc blocFor(FakeAuthSession session) {
    final bloc = ProfileBloc(
      getProfileUseCase: getProfile,
      authSession: session,
    );
    addTearDown(bloc.close);
    return bloc;
  }

  test('a guest settles on signedOut instead of an endless skeleton', () async {
    final bloc = blocFor(signOutFakeSession())
      ..add(const ProfileEvent.started());

    await expectLater(bloc.stream.first, completion(isA<ProfileSignedOut>()));
    expect(getProfile.calls, 0, reason: 'a guest has no profile to fetch');
  });

  test('with an account, started loads the profile', () async {
    final bloc = blocFor(signIntoFakeSession())
      ..add(const ProfileEvent.started());

    await expectLater(bloc.stream.first, completion(isA<ProfileLoaded>()));
    expect(getProfile.calls, 1);
  });

  test('an account appearing loads the profile without being told', () async {
    final session = signOutFakeSession();
    final bloc = blocFor(session)..add(const ProfileEvent.started());
    await bloc.stream.first;

    // What the gated Profile tab does: Login resolves somewhere the bloc
    // cannot be reached from, and it has to catch up on its own. Before the
    // session was a port this could not be written at all — there was no way
    // to make an account appear mid-test.
    session.signIn('u1');

    await expectLater(
      bloc.stream.firstWhere((s) => s is ProfileLoaded),
      completes,
    );
    expect(getProfile.calls, 1);
  });

  test('the account going away settles it back to signedOut', () async {
    final session = signIntoFakeSession();
    final bloc = blocFor(session)..add(const ProfileEvent.started());
    await bloc.stream.firstWhere((s) => s is ProfileLoaded);

    session.signOut();

    await expectLater(
      bloc.stream.firstWhere((s) => s is ProfileSignedOut),
      completes,
    );
  });
}
