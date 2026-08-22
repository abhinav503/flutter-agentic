import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:cordelia/feature/storefront/profile/domain/entities/profile_entity.dart';
import 'package:cordelia/feature/storefront/profile/domain/usecase/get_profile_usecase.dart';
import 'package:cordelia/feature/storefront/profile/presentation/bloc/profile_bloc.dart';
import 'package:cordelia/services/firebase_auth_service.dart';

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
  tearDown(() => FirebaseAuthService.debugSignedIn = null);

  test('a guest settles on signedOut instead of an endless skeleton', () async {
    FirebaseAuthService.debugSignedIn = false;
    final bloc = ProfileBloc(getProfileUseCase: getProfile)
      ..add(const ProfileEvent.started());
    addTearDown(bloc.close);

    await expectLater(bloc.stream.first, completion(isA<ProfileSignedOut>()));
    expect(getProfile.calls, 0, reason: 'a guest has no profile to fetch');
  });

  test('with an account, started loads the profile', () async {
    FirebaseAuthService.debugSignedIn = true;
    final bloc = ProfileBloc(getProfileUseCase: getProfile)
      ..add(const ProfileEvent.started());
    addTearDown(bloc.close);

    await expectLater(bloc.stream.first, completion(isA<ProfileLoaded>()));
    expect(getProfile.calls, 1);
  });

  test('signing in after a guest start loads it, with no second fetch for the '
      'same account', () async {
    FirebaseAuthService.debugSignedIn = false;
    final bloc = ProfileBloc(getProfileUseCase: getProfile)
      ..add(const ProfileEvent.started());
    addTearDown(bloc.close);
    await bloc.stream.first;

    // What the gated Profile tab does: Login resolves, then whatever is
    // showing the profile has to catch up. Nothing tells this bloc — it is
    // the account changing that does.
    FirebaseAuthService.debugSignedIn = true;
    bloc.add(const ProfileEvent.started());

    await expectLater(
      bloc.stream.firstWhere((s) => s is ProfileLoaded),
      completes,
    );
    expect(getProfile.calls, 1);
  });
}
