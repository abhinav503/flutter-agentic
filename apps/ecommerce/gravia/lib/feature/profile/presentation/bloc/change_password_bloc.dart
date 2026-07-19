import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:gravia/constants/value_const.dart';

// Cross-feature dependency: reauth + password update both live on
// feature/auth's FirebaseAuthService/AuthRepository — same reasoning as
// EditProfileBloc reusing UpdateProfileUseCase, not a forked copy here.
import 'package:gravia/feature/auth/domain/usecase/change_password_usecase.dart';

part 'change_password_bloc.freezed.dart';
part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase _changePassword;

  ChangePasswordBloc({required ChangePasswordUseCase changePasswordUseCase})
    : _changePassword = changePasswordUseCase,
      super(const ChangePasswordState.initial()) {
    on<ChangePasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    if (kIsWeb) {
      emit(
        const ChangePasswordState.error(
          message: ValueConst.authWebUnsupportedMessage,
        ),
      );
      return;
    }
    emit(const ChangePasswordState.saving());
    final result = await _changePassword(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) => emit(ChangePasswordState.error(message: failure.message)),
      (_) => emit(const ChangePasswordState.success()),
    );
  }
}
