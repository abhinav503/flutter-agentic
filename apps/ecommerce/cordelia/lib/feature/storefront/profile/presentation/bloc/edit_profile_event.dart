part of 'edit_profile_bloc.dart';

@freezed
sealed class EditProfileEvent with _$EditProfileEvent {
  const factory EditProfileEvent.submitted({
    required String name,
    required String mobile,

    /// Set only when the shopper picked a new photo this session — the
    /// upload and the `avatar_url` write are both skipped when null, so
    /// saving a name change never re-uploads the existing avatar.
    Uint8List? avatarBytes,
  }) = EditProfileSubmitted;
}
