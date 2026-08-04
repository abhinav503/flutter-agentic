import 'package:cordelia/enums/avatar_source.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_form_field.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/docked_bar.dart';

import '../../../../domain/entities/profile_entity.dart';
import '../../../bloc/edit_profile_bloc.dart';
import '../../../edit_profile_form.dart';
import '../widgets/avatar_source_sheet_content.dart';
import '../widgets/profile_avatar_picker.dart';

/// Edit Profile form, reached from ProfileHeroHeader's glass edit trigger.
/// Always in edit mode (a profile always exists — no "add" case, unlike
/// Address). On a successful save, pops back to the caller as a
/// [ProfileEntity] — ProfileScreen dispatches it into the shared ProfileBloc
/// via `ProfileEvent.saved`, the same "push, await the pop, react" shape as
/// AddressScreen's own edit flow. All form behaviour lives in
/// [EditProfileForm]; this screen renders only the pack's chrome.
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
      GraviaValueConst.avatarPickerMobileOnlyMessage;

  @override
  Future<AvatarSource?> showAvatarSourceSheet() => showGraviaSheet(
    title: GraviaValueConst.changePhotoTitle,
    child: const AvatarSourceSheetContent(),
  );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: handleEditProfileState,
      builder: (context, state) {
        final isSaving = switch (state) {
          EditProfileSaving() => true,
          _ => false,
        };
        return Column(
          children: [
            Expanded(
              child: CollapsingHeaderSheet(
                initialHeaderHeight: GraviaDimenConst.headerHeightCompact,
                header: GraviaHeroHeader(
                  title: GraviaValueConst.editProfileTitle,
                  onBack: () => context.pop(),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
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
                        GraviaValueConst.nameLabel,
                        nameController,
                        field: ProfileField.name,
                        keyboardType: TextInputType.name,
                        hint: GraviaValueConst.nameHint,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _field(
                        GraviaValueConst.emailAddressLabel,
                        emailController,
                        field: ProfileField.email,
                        keyboardType: TextInputType.emailAddress,
                        hint: GraviaValueConst.emailAddressHint,
                        // Can't change here — Firebase's own re-verification
                        // flow (verifyBeforeUpdateEmail) is needed to change
                        // the sign-in email, out of scope for this form.
                        enabled: false,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _field(
                        GraviaValueConst.mobileNumberLabel,
                        phoneController,
                        field: ProfileField.phone,
                        keyboardType: TextInputType.phone,
                        hint: GraviaValueConst.phoneNumberHint,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            DockedBar(
              child: GraviaPrimaryButton(
                label: GraviaValueConst.updateProfileButtonLabel,
                state: isSaving ? AppButtonState.loading : AppButtonState.idle,
                onTap: isSaving ? null : submitProfile,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    required ProfileField field,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
    bool enabled = true,
  }) {
    return GraviaFormField(
      label: label,
      controller: controller,
      hint: hint,
      keyboardType: keyboardType,
      errorText: fieldErrors[field],
      onChanged: (_) => clearFieldError(field),
      enabled: enabled,
    );
  }
}
