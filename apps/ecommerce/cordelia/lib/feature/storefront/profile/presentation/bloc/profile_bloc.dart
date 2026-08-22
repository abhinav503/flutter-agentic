import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' show User;
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

  StreamSubscription<User?>? _authChanges;

  /// Who the current state describes. Seeded at construction because the
  /// provider dispatches `started` itself, and `authStateChanges` replays
  /// the current user the moment it is listened to — without this the first
  /// emission would fetch the same profile a second time.
  String? _uid;

  ProfileBloc({required GetProfileUseCase getProfileUseCase})
    : _getProfile = getProfileUseCase,
      super(const ProfileState.loading()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileSaved>(_onSaved);

    // The profile *is* a function of who is signed in, so it follows that
    // rather than waiting to be told. A shopper who signs in from a gated
    // tab reaches Login through the shell's own page context, which sits
    // above this bloc's provider — so nothing on that path could reach in
    // and refresh it, and the Profile tab sat on its skeleton for the rest
    // of the visit.
    _uid = FirebaseAuthService.instance.currentUser?.uid;
    _authChanges = FirebaseAuthService.instance.authStateChanges.listen((user) {
      if (user?.uid == _uid) return;
      _uid = user?.uid;
      add(const ProfileEvent.started());
    });
  }

  @override
  Future<void> close() {
    _authChanges?.cancel();
    return super.close();
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    // A guest has no profile to fetch — asking would be a 401, and the
    // resulting error state reads to a header as "still loading". Settled
    // here rather than at the provider so every caller of `started` gets the
    // same answer, including one dispatched after a sign-out.
    if (!FirebaseAuthService.instance.isSignedIn) {
      emit(const ProfileState.signedOut());
      return;
    }
    _uid = FirebaseAuthService.instance.currentUser?.uid;
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
