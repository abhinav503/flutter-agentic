import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/usecase/usecase.dart';

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
  }

  Future<void> _onStarted(ProfileStarted event, Emitter<ProfileState> emit) async {
    final result = await _getProfile(const NoParams());
    result.fold(
      (failure) => emit(ProfileState.error(message: failure.message)),
      (profile) => emit(ProfileState.loaded(profile: profile)),
    );
  }
}
