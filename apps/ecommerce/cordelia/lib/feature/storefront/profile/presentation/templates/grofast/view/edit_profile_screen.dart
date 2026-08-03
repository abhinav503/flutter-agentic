import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/enums/avatar_source.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_form_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';

import '../../../../domain/entities/profile_entity.dart';
import '../../../bloc/edit_profile_bloc.dart';
import '../../../edit_profile_form.dart';
import '../widgets/profile_form_widgets.dart';

/// `grofast` template's Edit Profile, reached from the Profile tab's "My
/// Profile" row. All form behaviour lives in [EditProfileForm]; this screen
/// renders only the pack's chrome.
///
/// The kit ships no Edit Profile frame, so the layout is composed from the
/// pack's own recipes — hero avatar, stacked labelled fields, a floating
/// gradient CTA over the bottom fade (spec sheet §11).
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
      GrofastValueConst.avatarPickerMobileOnlyMessage;

  @override
  Future<AvatarSource?> showAvatarSourceSheet() =>
      showGrofastSheet<AvatarSource>(
        title: GrofastValueConst.changePhotoTitle,
        child: const GrofastAvatarSourceSheetContent(),
      );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: handleEditProfileState,
        builder: (context, state) {
          final isSaving = switch (state) {
            EditProfileSaving() => true,
            _ => false,
          };

          return GrofastScreenBody(
            title: GrofastValueConst.editProfileTitle,
            onBack: () => context.pop(),
            gap: AppSpacing.xl4,
            floatingAction: GrofastPrimaryButton(
              label: GrofastValueConst.saveChangesLabel,
              state: isSaving ? AppButtonState.loading : AppButtonState.idle,
              onTap: isSaving ? null : submitProfile,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GrofastProfileAvatarPicker(
                    profile: widget.profile,
                    pickedAvatarBytes: pickedAvatarBytes,
                    onTap: pickAvatar,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl6),
                _field(
                  GrofastValueConst.fullNameLabel,
                  nameController,
                  field: ProfileField.name,
                  keyboardType: TextInputType.name,
                  hint: GrofastValueConst.fullNameHint,
                ),
                const SizedBox(height: AppSpacing.lg),
                _field(
                  GrofastValueConst.emailLabel,
                  emailController,
                  field: ProfileField.email,
                  keyboardType: TextInputType.emailAddress,
                  hint: GrofastValueConst.emailHint,
                  // Can't change here — Firebase's own re-verification flow
                  // (verifyBeforeUpdateEmail) is needed to change the sign-in
                  // email, out of scope for this form.
                  enabled: false,
                ),
                const SizedBox(height: AppSpacing.lg),
                _field(
                  GrofastValueConst.phoneNumberLabel,
                  phoneController,
                  field: ProfileField.phone,
                  keyboardType: TextInputType.phone,
                  hint: GrofastValueConst.phoneNumberHint,
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
    required ProfileField field,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
    bool enabled = true,
  }) => GrofastFormField(
    label: label,
    controller: controller,
    hint: hint,
    keyboardType: keyboardType,
    errorText: fieldErrors[field],
    onChanged: (_) => clearFieldError(field),
    enabled: enabled,
  );
}
