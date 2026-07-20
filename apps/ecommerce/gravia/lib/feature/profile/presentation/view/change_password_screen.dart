import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';

import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_docked_bar.dart';
import 'package:gravia/widgets/gravia_form_field.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';
import 'package:gravia/widgets/gravia_primary_button.dart';

import '../bloc/change_password_bloc.dart';

enum _ChangePasswordField { current, newPassword, confirm }

/// Change Password form, reached from ProfileScreen's "Change Password"
/// menu tile. Reauthenticates with the current password, then sets the new
/// one — see `FirebaseAuthService.reauthenticate`/`updatePassword`. On
/// success, shows a confirmation snackbar and pops back to Profile.
class ChangePasswordScreen extends BaseScreen {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends BaseScreenState<ChangePasswordScreen>
    with TextfieldValidations {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final Map<_ChangePasswordField, String> _errors = {};

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearError(_ChangePasswordField field) {
    if (_errors.containsKey(field)) setState(() => _errors.remove(field));
  }

  bool _validate() {
    final errors = <_ChangePasswordField, String>{
      _ChangePasswordField.current: ?validatePassword(
        _currentPasswordController.text,
      ),
      _ChangePasswordField.newPassword: ?validatePassword(
        _newPasswordController.text,
      ),
      _ChangePasswordField.confirm: ?validateConfirmPassword(
        _confirmPasswordController.text,
        _newPasswordController.text,
      ),
    };
    if (errors.isNotEmpty) {
      setState(() {
        _errors
          ..clear()
          ..addAll(errors);
      });
    }
    return errors.isEmpty;
  }

  void _submit() {
    if (!_validate()) return;
    context.read<ChangePasswordBloc>().add(
      ChangePasswordEvent.submitted(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) => switch (state) {
        ChangePasswordSuccess() => _handleSuccess(),
        ChangePasswordError(:final message) => showSnackBar(message),
        _ => null,
      },
      builder: (context, state) {
        final isSaving = state is ChangePasswordSaving;
        return Column(
          children: [
            Expanded(
              child: CollapsingHeaderSheet(
                initialHeaderHeight: 110,
                header: GraviaHeroHeader(
                  title: ValueConst.changePasswordTitle,
                  onBack: () => context.pop(),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GraviaFormField(
                        label: ValueConst.currentPasswordLabel,
                        controller: _currentPasswordController,
                        hint: ValueConst.currentPasswordHint,
                        obscureText: true,
                        errorText: _errors[_ChangePasswordField.current],
                        onChanged: (_) =>
                            _clearError(_ChangePasswordField.current),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      GraviaFormField(
                        label: ValueConst.newPasswordLabel,
                        controller: _newPasswordController,
                        hint: ValueConst.newPasswordHint,
                        obscureText: true,
                        errorText: _errors[_ChangePasswordField.newPassword],
                        onChanged: (_) =>
                            _clearError(_ChangePasswordField.newPassword),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      GraviaFormField(
                        label: ValueConst.confirmNewPasswordLabel,
                        controller: _confirmPasswordController,
                        hint: ValueConst.confirmNewPasswordHint,
                        obscureText: true,
                        errorText: _errors[_ChangePasswordField.confirm],
                        onChanged: (_) =>
                            _clearError(_ChangePasswordField.confirm),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GraviaDockedBar(
              child: GraviaPrimaryButton(
                label: ValueConst.updatePasswordButtonLabel,
                state: isSaving ? AppButtonState.loading : AppButtonState.idle,
                onTap: isSaving ? null : _submit,
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleSuccess() {
    showSnackBar(ValueConst.passwordUpdatedMessage);
    context.pop();
  }
}
