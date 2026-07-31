part of 'edit_profile_bloc.dart';

@freezed
sealed class EditProfileState with _$EditProfileState {
  const factory EditProfileState.initial() = EditProfileInitial;
  const factory EditProfileState.saving() = EditProfileSaving;
  const factory EditProfileState.success({required UserEntity user}) =
      EditProfileSuccess;
  const factory EditProfileState.error({
    required String message,

    /// Retry context — the submitted values, so a retry can re-dispatch
    /// without reading the screen's controllers.
    required String name,
    required String mobile,
    Uint8List? avatarBytes,
  }) = EditProfileError;
}
