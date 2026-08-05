import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/auth/domain/usecase/change_password_usecase.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
        ChangePasswordState.error(
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
