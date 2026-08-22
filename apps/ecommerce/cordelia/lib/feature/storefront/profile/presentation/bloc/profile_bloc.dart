import 'dart:async';
import 'package:cordelia/utils/failure_message.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/auth/auth_session.dart';
import 'package:core/core/usecase/usecase.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/usecase/get_profile_usecase.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfile;
  final AuthSession _session;

  StreamSubscription<String?>? _uidChanges;

  /// Who the current state describes. Seeded at construction because the
  /// provider dispatches `started` itself, and `authStateChanges` replays
  /// the current user the moment it is listened to — without this the first
  /// emission would fetch the same profile a second time.
  String? _uid;

  ProfileBloc({
    required GetProfileUseCase getProfileUseCase,
    required AuthSession authSession,
  }) : _getProfile = getProfileUseCase,
       _session = authSession,
       super(const ProfileState.loading()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileSaved>(_onSaved);

    // The profile *is* a function of who is signed in, so it follows that
    // rather than waiting to be told. A shopper who signs in from a gated
    // tab reaches Login through the shell's own page context, which sits
    // above this bloc's provider — so nothing on that path could reach in
    // and refresh it, and the Profile tab sat on its skeleton for the rest
    // of the visit.
    _uid = _session.currentUid;
    _uidChanges = _session.uidChanges.listen((uid) {
      if (uid == _uid) return;
      _uid = uid;
      add(const ProfileEvent.started());
    });
  }

  @override
  Future<void> close() {
    _uidChanges?.cancel();
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
    if (!_session.isSignedIn) {
      emit(const ProfileState.signedOut());
      return;
    }
    _uid = _session.currentUid;
    final result = await _getProfile(const NoParams());
    result.fold(
      (failure) => emit(ProfileState.error(message: failure.shopperMessage)),
      (profile) => emit(ProfileState.loaded(profile: profile)),
    );
  }

  void _onSaved(ProfileSaved event, Emitter<ProfileState> emit) {
    emit(ProfileState.loaded(profile: event.profile));
  }
}
