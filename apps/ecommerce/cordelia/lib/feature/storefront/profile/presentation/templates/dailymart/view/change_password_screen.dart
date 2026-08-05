import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:cordelia/utils/localized_validations.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_form_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_screen_body.dart';

import '../../../bloc/change_password_bloc.dart';
import '../../../change_password_form.dart';

/// `dailymart` template's Change Password form, reached from the Profile
/// tab's "Change Password" row. All form behaviour lives in
/// [ChangePasswordForm]; this screen renders only the pack's chrome.
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
    with TextfieldValidations, LocalizedValidations, ChangePasswordForm {
  @override
  String get passwordUpdatedMessage =>
      DailyMartValueConst.passwordUpdatedMessage;

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
          listener: handleChangePasswordState,
          builder: (context, state) {
            final isSaving = switch (state) {
              ChangePasswordSaving() => true,
              _ => false,
            };

            return DailyMartScreenBody(
              title: DailyMartValueConst.changePasswordTitle,
              onBack: () => context.pop(),
              gap: AppSpacing.xl4,
              floatingAction: DailyMartPrimaryButton(
                label: DailyMartValueConst.updatePasswordButtonLabel,
                state: isSaving ? AppButtonState.loading : AppButtonState.idle,
                onTap: isSaving ? null : submitPassword,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _field(
                    DailyMartValueConst.currentPasswordLabel,
                    currentPasswordController,
                    field: ChangePasswordField.current,
                    hint: DailyMartValueConst.currentPasswordHint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    DailyMartValueConst.newPasswordLabel,
                    newPasswordController,
                    field: ChangePasswordField.newPassword,
                    hint: DailyMartValueConst.newPasswordHint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    DailyMartValueConst.confirmNewPasswordLabel,
                    confirmPasswordController,
                    field: ChangePasswordField.confirm,
                    hint: DailyMartValueConst.confirmNewPasswordHint,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    required ChangePasswordField field,
    String? hint,
  }) => DailyMartFormField(
    label: label,
    controller: controller,
    hint: hint,
    obscureText: true,
    errorText: fieldErrors[field],
    onChanged: (_) => clearFieldError(field),
  );
}
