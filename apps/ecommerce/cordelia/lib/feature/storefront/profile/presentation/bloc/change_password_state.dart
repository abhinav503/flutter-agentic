part of 'change_password_bloc.dart';

@freezed
sealed class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState.initial() = ChangePasswordInitial;
  const factory ChangePasswordState.saving() = ChangePasswordSaving;
  const factory ChangePasswordState.success() = ChangePasswordSuccess;
  const factory ChangePasswordState.error({required String message}) =
      ChangePasswordError;
}
