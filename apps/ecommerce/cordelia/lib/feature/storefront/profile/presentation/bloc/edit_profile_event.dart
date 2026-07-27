part of 'edit_profile_bloc.dart';

@freezed
sealed class EditProfileEvent with _$EditProfileEvent {
  const factory EditProfileEvent.submitted({
    required String name,
    required String mobile,
  }) = EditProfileSubmitted;
}
