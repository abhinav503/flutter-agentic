import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/auth/domain/entities/user_entity.dart';
import 'package:cordelia/feature/auth/domain/usecase/update_profile_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'edit_profile_bloc.freezed.dart';
part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UpdateProfileUseCase _updateProfile;

  EditProfileBloc({required UpdateProfileUseCase updateProfileUseCase})
    : _updateProfile = updateProfileUseCase,
      super(const EditProfileState.initial()) {
    on<EditProfileSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    // Same short-circuit as ChangePasswordBloc/AuthBloc: Firebase never
    // initialises on web, so the token-backed profile write can't run.
    if (kIsWeb) {
      emit(
        EditProfileState.error(
          message: ValueConst.authWebUnsupportedMessage,
          name: event.name,
          mobile: event.mobile,
          avatarBytes: event.avatarBytes,
        ),
      );
      return;
    }
    emit(const EditProfileState.saving());
    final result = await _updateProfile(
      UpdateProfileParams(
        name: event.name,
        mobile: event.mobile,
        avatarBytes: event.avatarBytes,
      ),
    );
    result.fold(
      (failure) => emit(
        EditProfileState.error(
          message: failure.message,
          name: event.name,
          mobile: event.mobile,
          avatarBytes: event.avatarBytes,
        ),
      ),
      (user) => emit(EditProfileState.success(user: user)),
    );
  }
}
