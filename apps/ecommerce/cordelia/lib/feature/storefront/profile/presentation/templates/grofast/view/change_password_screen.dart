import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_form_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';

import '../../../bloc/change_password_bloc.dart';
import '../../../change_password_form.dart';

/// `grofast` template's Change Password form, reached from the Profile tab's
/// own row. All form behaviour lives in [ChangePasswordForm]; this screen
/// renders only the pack's chrome.
///
/// The kit has no Change Password frame, so this is assembled from the pack's
/// own contract rather than ported: the Edit Profile silhouette (header row →
/// stacked labelled fields → CTA floating over the bottom fade) with three
/// obscured fields in place of the avatar and personal-data stack
/// (spec sheet §11).
class ChangePasswordScreen extends BaseScreen {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends BaseScreenState<ChangePasswordScreen>
    with TextfieldValidations, ChangePasswordForm {
  @override
  String get passwordUpdatedMessage => GrofastValueConst.passwordUpdatedMessage;

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: handleChangePasswordState,
        builder: (context, state) {
          final isSaving = switch (state) {
            ChangePasswordSaving() => true,
            _ => false,
          };

          return GrofastScreenBody(
            title: GrofastValueConst.changePasswordTitle,
            onBack: () => context.pop(),
            gap: AppSpacing.xl4,
            floatingAction: GrofastPrimaryButton(
              label: GrofastValueConst.updatePasswordButtonLabel,
              state: isSaving ? AppButtonState.loading : AppButtonState.idle,
              onTap: isSaving ? null : submitPassword,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(
                  GrofastValueConst.currentPasswordLabel,
                  currentPasswordController,
                  field: ChangePasswordField.current,
                  hint: GrofastValueConst.currentPasswordHint,
                ),
                const SizedBox(height: AppSpacing.lg),
                _field(
                  GrofastValueConst.newPasswordLabel,
                  newPasswordController,
                  field: ChangePasswordField.newPassword,
                  hint: GrofastValueConst.newPasswordHint,
                ),
                const SizedBox(height: AppSpacing.lg),
                _field(
                  GrofastValueConst.confirmNewPasswordLabel,
                  confirmPasswordController,
                  field: ChangePasswordField.confirm,
                  hint: GrofastValueConst.confirmNewPasswordHint,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    required ChangePasswordField field,
    String? hint,
  }) => GrofastFormField(
    label: label,
    controller: controller,
    hint: hint,
    obscureText: true,
    errorText: fieldErrors[field],
    onChanged: (_) => clearFieldError(field),
  );
}
