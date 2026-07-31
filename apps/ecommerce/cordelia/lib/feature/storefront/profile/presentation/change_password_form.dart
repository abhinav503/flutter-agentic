import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';

import 'bloc/change_password_bloc.dart';

/// Which form field an error message belongs to.
enum ChangePasswordField { current, newPassword, confirm }

/// Everything Change Password does that isn't pack chrome — the three
/// controllers, per-field validation, the submit, and the success-pop/
/// error-snackbar listener. Both templates' Change Password screens mix
/// this in and render only their own layout (same shape as
/// [EditProfileForm]).
mixin ChangePasswordForm<T extends BaseScreen>
    on BaseScreenState<T>, TextfieldValidations {
  /// The pack's copy for the success snackbar.
  String get passwordUpdatedMessage;

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final Map<ChangePasswordField, String> fieldErrors = {};

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void clearFieldError(ChangePasswordField field) {
    if (fieldErrors.containsKey(field)) {
      setState(() => fieldErrors.remove(field));
    }
  }

  bool _validate() {
    final errors = <ChangePasswordField, String>{
      ChangePasswordField.current: ?validatePassword(
        currentPasswordController.text,
      ),
      ChangePasswordField.newPassword: ?validatePassword(
        newPasswordController.text,
      ),
      ChangePasswordField.confirm: ?validateConfirmPassword(
        confirmPasswordController.text,
        newPasswordController.text,
      ),
    };
    if (errors.isNotEmpty) {
      setState(() {
        fieldErrors
          ..clear()
          ..addAll(errors);
      });
    }
    return errors.isEmpty;
  }

  void submitPassword() {
    if (!_validate()) return;
    context.read<ChangePasswordBloc>().add(
      ChangePasswordEvent.submitted(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      ),
    );
  }

  /// The `BlocConsumer` listener body: success toasts and pops back to
  /// Profile, an error toasts in place.
  void handleChangePasswordState(
    BuildContext context,
    ChangePasswordState state,
  ) => switch (state) {
    ChangePasswordSuccess() => _handleSuccess(context),
    ChangePasswordError(:final message) => showSnackBar(message),
    _ => null,
  };

  void _handleSuccess(BuildContext context) {
    showSnackBar(passwordUpdatedMessage);
    context.pop();
  }
}
