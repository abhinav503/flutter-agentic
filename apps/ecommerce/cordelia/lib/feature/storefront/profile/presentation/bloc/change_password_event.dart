part of 'change_password_bloc.dart';

@freezed
sealed class ChangePasswordEvent with _$ChangePasswordEvent {
  const factory ChangePasswordEvent.submitted({
    required String currentPassword,
    required String newPassword,
  }) = ChangePasswordSubmitted;
}
