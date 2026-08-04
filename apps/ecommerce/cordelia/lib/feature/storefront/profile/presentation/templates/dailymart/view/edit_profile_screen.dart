import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/enums/avatar_source.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_form_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_screen_body.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';

import '../../../../domain/entities/profile_entity.dart';
import '../../../bloc/edit_profile_bloc.dart';
import '../../../edit_profile_form.dart';
import '../widgets/avatar_source_sheet_content.dart';
import '../widgets/profile_avatar_picker.dart';

/// `dailymart` template's Edit Profile form (kit frame `43 Personal Data`),
/// reached from the Profile tab's own "Edit Profile" row rather than from an
/// avatar affordance — this pack's Profile has no header canvas to hang one
/// on. All form behaviour lives in [EditProfileForm]; this screen renders
/// only the pack's chrome.
///
/// The kit's Date of Birth and Gender fields are not reproduced —
/// [ProfileEntity] carries neither, and inventing storage for two fields the
/// backend never returns would put dead controls on a live form.
class EditProfileScreen extends BaseScreen {
  final ProfileEntity profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends BaseScreenState<EditProfileScreen>
    with TextfieldValidations, EditProfileForm {
  @override
  ProfileEntity get profile => widget.profile;

  @override
  String get avatarPickerMobileOnlyMessage =>
      DailyMartValueConst.avatarPickerMobileOnlyMessage;

  @override
  Future<AvatarSource?> showAvatarSourceSheet() => showDailyMartSheet(
    title: DailyMartValueConst.changePhotoTitle,
    child: const AvatarSourceSheetContent(),
  );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: BlocConsumer<EditProfileBloc, EditProfileState>(
          listener: handleEditProfileState,
          builder: (context, state) {
            final isSaving = switch (state) {
              EditProfileSaving() => true,
              _ => false,
            };

            return DailyMartScreenBody(
              title: DailyMartValueConst.editProfileTitle,
              onBack: () => context.pop(),
              gap: AppSpacing.xl4,
              floatingAction: DailyMartPrimaryButton(
                label: DailyMartValueConst.saveChangesLabel,
                state: isSaving ? AppButtonState.loading : AppButtonState.idle,
                onTap: isSaving ? null : submitProfile,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ProfileAvatarPicker(
                      profile: widget.profile,
                      pickedAvatarBytes: pickedAvatarBytes,
                      onTap: pickAvatar,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl2),
                  _field(
                    DailyMartValueConst.fullNameLabel,
                    nameController,
                    field: ProfileField.name,
                    keyboardType: TextInputType.name,
                    hint: DailyMartValueConst.fullNameHint,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    DailyMartValueConst.emailLabel,
                    emailController,
                    field: ProfileField.email,
                    keyboardType: TextInputType.emailAddress,
                    hint: DailyMartValueConst.emailHint,
                    // Can't change here — Firebase's own re-verification
                    // flow (verifyBeforeUpdateEmail) is needed to change
                    // the sign-in email, out of scope for this form.
                    enabled: false,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    DailyMartValueConst.phoneNumberLabel,
                    phoneController,
                    field: ProfileField.phone,
                    keyboardType: TextInputType.phone,
                    hint: DailyMartValueConst.phoneNumberHint,
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
    required ProfileField field,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
    bool enabled = true,
  }) => DailyMartFormField(
    label: label,
    controller: controller,
    hint: hint,
    keyboardType: keyboardType,
    errorText: fieldErrors[field],
    onChanged: (_) => clearFieldError(field),
    enabled: enabled,
  );
}
