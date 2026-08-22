part of 'profile_bloc.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.loading() = ProfileLoading;

  /// No account, so there is no profile to fetch and never will be until
  /// one is created. Distinct from [ProfileLoading] because a guest is a
  /// settled answer, not a pending one — a header that shimmers forever is
  /// what conflating them looks like.
  const factory ProfileState.signedOut() = ProfileSignedOut;
  const factory ProfileState.loaded({required ProfileEntity profile}) =
      ProfileLoaded;
  const factory ProfileState.error({required String message}) = ProfileError;
}
