import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/usecase/usecase.dart';

import 'package:cordelia/services/firebase_auth_service.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/usecase/get_profile_usecase.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfile;

  ProfileBloc({required GetProfileUseCase getProfileUseCase})
    : _getProfile = getProfileUseCase,
      super(const ProfileState.loading()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileSaved>(_onSaved);
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    // A guest has no profile to fetch — asking would be a 401, and the
    // resulting error state reads to a header as "still loading". Settled
    // here rather than at the provider so every caller of `started` gets the
    // same answer, including one dispatched after a sign-out.
    if (FirebaseAuthService.instance.currentUser == null) {
      emit(const ProfileState.signedOut());
      return;
    }
    final result = await _getProfile(const NoParams());
    result.fold(
      (failure) => emit(ProfileState.error(message: failure.message)),
      (profile) => emit(ProfileState.loaded(profile: profile)),
    );
  }

  void _onSaved(ProfileSaved event, Emitter<ProfileState> emit) {
    emit(ProfileState.loaded(profile: event.profile));
  }
}
