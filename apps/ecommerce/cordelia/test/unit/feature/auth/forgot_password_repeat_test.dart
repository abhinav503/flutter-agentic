import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_auth_session.dart';
import 'package:fpdart/fpdart.dart';

import 'package:cordelia/feature/auth/domain/entities/user_entity.dart';
import 'package:cordelia/feature/auth/domain/repository/auth_repository.dart';
import 'package:cordelia/feature/auth/domain/usecase/check_email_verified_usecase.dart';
import 'package:cordelia/feature/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:cordelia/feature/auth/domain/usecase/resend_verification_email_usecase.dart';
import 'package:cordelia/feature/auth/domain/usecase/sign_in_usecase.dart';
import 'package:cordelia/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:cordelia/feature/auth/presentation/bloc/auth_bloc.dart';

/// "Forgot password" is a one-shot signal, not rendered state: the screen
/// answers it with a snackbar and nothing else changes. Bloc suppresses an
/// emit whose state equals the current one, and this handler deliberately
/// never passes through `loading` (it would flash the login button's
/// spinner), so before `attempt` existed a second tap on the same address
/// produced an identical state and was swallowed — the user saw nothing and
/// reasonably concluded the button was broken.
///
/// A second tap is the *expected* interaction here: you tap again precisely
/// because the first mail hasn't shown up.
class _FakeAuthRepository implements AuthRepository {
  int sendCount = 0;
  Either<Failure, void> result = right(null);

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    sendCount++;
    return result;
  }

  // Every other method is declared so the fake still satisfies the interface,
  // and throws so a future test that starts depending on one can't pass by
  // silently reading a stub value.
  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> signOut() => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteAccount() => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> resendVerificationEmail() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, UserEntity?>> checkEmailVerified() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String mobile,
    Uint8List? avatarBytes,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => throw UnimplementedError();
}

void main() {
  late _FakeAuthRepository repository;

  AuthBloc buildBloc() => AuthBloc(
    signUpUseCase: SignUpUseCase(repository),
    signInUseCase: SignInUseCase(repository),
    resendVerificationEmailUseCase: ResendVerificationEmailUseCase(repository),
    checkEmailVerifiedUseCase: CheckEmailVerifiedUseCase(repository),
    authSession: FakeAuthSession(),
    forgotPasswordUseCase: ForgotPasswordUseCase(repository),
  );

  setUp(() => repository = _FakeAuthRepository());

  const email = 'someone@example.com';
  const request = AuthEvent.forgotPasswordRequested(email: email);

  blocTest<AuthBloc, AuthState>(
    'two sends to the same address emit two distinct states',
    build: buildBloc,
    act: (bloc) => bloc
      ..add(request)
      ..add(request),
    expect: () => const [
      AuthState.passwordResetEmailSent(email: email, attempt: 1),
      AuthState.passwordResetEmailSent(email: email, attempt: 2),
    ],
    verify: (_) => expect(repository.sendCount, 2),
  );

  blocTest<AuthBloc, AuthState>(
    'two identical failures also both surface',
    build: buildBloc,
    setUp: () => repository.result = left(
      const Failure.unexpected(message: 'Incorrect email or password.'),
    ),
    act: (bloc) => bloc
      ..add(request)
      ..add(request),
    expect: () => const [
      AuthState.error(message: 'Incorrect email or password.', attempt: 1),
      AuthState.error(message: 'Incorrect email or password.', attempt: 2),
    ],
  );
}
