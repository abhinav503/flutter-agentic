import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_form_field.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:cordelia/utils/localized_validations.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/docked_bar.dart';

import '../../../bloc/change_password_bloc.dart';
import '../../../change_password_form.dart';

/// Change Password form, reached from ProfileScreen's "Change Password"
/// menu tile. Reauthenticates with the current password, then sets the new
/// one — see `FirebaseAuthService.reauthenticate`/`updatePassword`. On
/// success, shows a confirmation snackbar and pops back to Profile. All form
/// behaviour lives in [ChangePasswordForm]; this screen renders only the
/// pack's chrome.
class ChangePasswordScreen extends BaseScreen {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends BaseScreenState<ChangePasswordScreen>
    with TextfieldValidations, LocalizedValidations, ChangePasswordForm {
  @override
  String get passwordUpdatedMessage => GraviaValueConst.passwordUpdatedMessage;

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: handleChangePasswordState,
      builder: (context, state) {
        final isSaving = switch (state) {
          ChangePasswordSaving() => true,
          _ => false,
        };
        return Column(
          children: [
            Expanded(
              child: CollapsingHeaderSheet(
                initialHeaderHeight: GraviaDimenConst.headerHeightCompact,
                header: GraviaHeroHeader(
                  title: GraviaValueConst.changePasswordTitle,
                  onBack: () => context.pop(),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GraviaFormField(
                        label: GraviaValueConst.currentPasswordLabel,
                        controller: currentPasswordController,
                        hint: GraviaValueConst.currentPasswordHint,
                        obscureText: true,
                        errorText: fieldErrors[ChangePasswordField.current],
                        onChanged: (_) =>
                            clearFieldError(ChangePasswordField.current),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      GraviaFormField(
                        label: GraviaValueConst.newPasswordLabel,
                        controller: newPasswordController,
                        hint: GraviaValueConst.newPasswordHint,
                        obscureText: true,
                        errorText: fieldErrors[ChangePasswordField.newPassword],
                        onChanged: (_) =>
                            clearFieldError(ChangePasswordField.newPassword),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      GraviaFormField(
                        label: GraviaValueConst.confirmNewPasswordLabel,
                        controller: confirmPasswordController,
                        hint: GraviaValueConst.confirmNewPasswordHint,
                        obscureText: true,
                        errorText: fieldErrors[ChangePasswordField.confirm],
                        onChanged: (_) =>
                            clearFieldError(ChangePasswordField.confirm),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            DockedBar(
              child: GraviaPrimaryButton(
                label: GraviaValueConst.updatePasswordButtonLabel,
                state: isSaving ? AppButtonState.loading : AppButtonState.idle,
                onTap: isSaving ? null : submitPassword,
              ),
            ),
          ],
        );
      },
    );
  }
}
