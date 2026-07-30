import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_form_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';

import '../../../bloc/change_password_bloc.dart';

enum _ChangePasswordField { current, newPassword, confirm }

/// `dailymart` template's Change Password form, reached from the Profile
/// tab's "Change Password" row. Reauthenticates with the current password,
/// then sets the new one — see
/// `FirebaseAuthService.reauthenticate`/`updatePassword`. On success it
/// shows a confirmation snackbar and pops back to Profile.
///
/// The kit has no Change Password frame — its Profile list stops at a
/// Security row with nothing behind it — so this is assembled from the
/// pack's own contract rather than ported: the Edit Profile silhouette
/// (header row → bordered fields → CTA floating over the bottom fade) with
/// three obscured fields in place of the avatar + personal-data stack.
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

  void _handleSuccess() {
    showSnackBar(DailyMartValueConst.passwordUpdatedMessage);
    context.pop();
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) => switch (state) {
            ChangePasswordSuccess() => _handleSuccess(),
            ChangePasswordError(:final message) => showSnackBar(message),
            _ => null,
          },
          builder: (context, state) {
            final isSaving = state is ChangePasswordSaving;

            return Stack(
              // The scroll view shrink-wraps its content; without expanding,
              // this short form ends the stack early and the positioned fade
              // + CTA pin to the content's bottom edge, not the device's.
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.base,
                    AppSpacing.lg,
                    // Clears the floating CTA docked over the fade.
                    DailyMartDimenConst.floatingActionScrollInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DailyMartHeaderRow(
                        title: DailyMartValueConst.changePasswordTitle,
                        onBack: () => context.pop(),
                      ),
                      const SizedBox(height: AppSpacing.xl4),
                      _field(
                        DailyMartValueConst.currentPasswordLabel,
                        _currentPasswordController,
                        field: _ChangePasswordField.current,
                        hint: DailyMartValueConst.currentPasswordHint,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _field(
                        DailyMartValueConst.newPasswordLabel,
                        _newPasswordController,
                        field: _ChangePasswordField.newPassword,
                        hint: DailyMartValueConst.newPasswordHint,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _field(
                        DailyMartValueConst.confirmNewPasswordLabel,
                        _confirmPasswordController,
                        field: _ChangePasswordField.confirm,
                        hint: DailyMartValueConst.confirmNewPasswordHint,
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: DailyMartBottomFade(),
                ),
                Positioned(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
                  child: DailyMartPrimaryButton(
                    label: DailyMartValueConst.updatePasswordButtonLabel,
                    state: isSaving
                        ? AppButtonState.loading
                        : AppButtonState.idle,
                    onTap: isSaving ? null : _submit,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    required _ChangePasswordField field,
    String? hint,
  }) => DailyMartFormField(
    label: label,
    controller: controller,
    hint: hint,
    obscureText: true,
    errorText: _errors[field],
    onChanged: (_) => _clearError(field),
  );
}
