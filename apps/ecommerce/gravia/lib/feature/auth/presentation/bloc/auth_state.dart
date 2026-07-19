part of 'auth_bloc.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.awaitingVerification({required String email}) =
      AuthAwaitingVerification;
  const factory AuthState.authenticated({required UserEntity user}) =
      AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  // Carries just `message` (shown via a BlocListener snackbar), not full
  // retry-context — Login/Signup are forms with screen-local
  // TextEditingControllers, so the user retries by editing and tapping the
  // button again (a brand-new event with live field values), not via an
  // ErrorView-style auto-retry the BLoC would need to re-dispatch itself.
  const factory AuthState.error({required String message}) = AuthError;
}
