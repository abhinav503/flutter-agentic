part of 'edit_profile_bloc.dart';

@freezed
sealed class EditProfileState with _$EditProfileState {
  const factory EditProfileState.initial() = EditProfileInitial;
  const factory EditProfileState.saving() = EditProfileSaving;
  const factory EditProfileState.success({required UserEntity user}) =
      EditProfileSuccess;
  const factory EditProfileState.error({required String message}) =
      EditProfileError;
}
