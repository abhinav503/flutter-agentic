part of 'profile_bloc.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.loading() = ProfileLoading;
  const factory ProfileState.loaded({required ProfileEntity profile}) = ProfileLoaded;
  const factory ProfileState.error({required String message}) = ProfileError;
}
