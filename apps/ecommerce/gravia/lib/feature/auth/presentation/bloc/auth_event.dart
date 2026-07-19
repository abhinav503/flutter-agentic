part of 'auth_bloc.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  /// Dispatched once on `AuthBloc` creation — resumes a stuck verification
  /// sheet across app relaunches (see [kPendingEmailVerificationPrefKey]).
  const factory AuthEvent.started() = AuthStarted;

  const factory AuthEvent.signUpRequested({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) = AuthSignUpRequested;

  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = AuthLoginRequested;

  const factory AuthEvent.resendVerificationRequested() =
      AuthResendVerificationRequested;

  const factory AuthEvent.forgotPasswordRequested({required String email}) =
      AuthForgotPasswordRequested;

  /// Internal — fired every 3s by the awaiting-verification poll timer.
  const factory AuthEvent.verificationTicked() = AuthVerificationTicked;
}
