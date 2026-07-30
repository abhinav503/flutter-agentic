import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/mixins/textfield_validations.dart';
import 'package:core/core/services/image_picker/image_picker_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_form_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';

import '../../../../domain/entities/profile_entity.dart';
import '../../../bloc/edit_profile_bloc.dart';
import '../widgets/avatar_source_sheet_content.dart';
import '../widgets/profile_avatar_picker.dart';

enum _ProfileField { name, email, phone }

/// `dailymart` template's Edit Profile form (kit frame `43 Personal Data`),
/// reached from the Profile tab's own "Edit Profile" row rather than from an
/// avatar affordance — this pack's Profile has no header canvas to hang one
/// on.
///
/// Always in edit mode (a profile always exists — no "add" case, unlike
/// Address). On a successful save it pops back to the caller as a
/// [ProfileEntity], which `ProfileScreen` dispatches into the shell's
/// `ProfileBloc`. Typed values and the picked avatar stay screen-local UI
/// state; only the Save Changes submit goes through [EditProfileBloc].
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
    with TextfieldValidations {
  late final _nameController = TextEditingController(text: widget.profile.name);
  late final _emailController = TextEditingController(
    text: widget.profile.email,
  );
  late final _phoneController = TextEditingController(
    text: widget.profile.phone,
  );

  /// A photo picked this session, previewed immediately and carried into the
  /// popped result — null until the user picks one, in which case it wins
  /// over the existing `avatarUrl` (see `CordeliaAvatarImage`).
  Uint8List? _pickedAvatarBytes;

  final Map<_ProfileField, String> _errors = {};

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _clearError(_ProfileField field) {
    if (_errors.containsKey(field)) setState(() => _errors.remove(field));
  }

  // Camera/gallery capture is mobile-only; on the web preview there's no
  // capture pipeline, so surface a snackbar and skip the picker instead of
  // opening a browser file dialog that goes nowhere.
  Future<void> _pickAvatar() async {
    if (kIsWeb) {
      showSnackBar(DailyMartValueConst.avatarPickerMobileOnlyMessage);
      return;
    }

    final source = await showDailyMartSheet<AvatarSource>(
      title: DailyMartValueConst.changePhotoTitle,
      child: const AvatarSourceSheetContent(),
    );
    if (source == null) return;

    final files = source == AvatarSource.camera
        ? await ImagePickerService.instance.fromCamera()
        : await ImagePickerService.instance.fromGallery();
    if (files.isEmpty || !mounted) return;

    final bytes = await files.first.readAsBytes();
    if (!mounted) return;
    setState(() => _pickedAvatarBytes = bytes);
  }

  void _submit() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    final errors = <_ProfileField, String>{
      _ProfileField.name: ?validateName(name),
      _ProfileField.phone: ?validateMobile(phone),
    };

    if (errors.isNotEmpty) {
      setState(() {
        _errors
          ..clear()
          ..addAll(errors);
      });
      return;
    }

    context.read<EditProfileBloc>().add(
      EditProfileEvent.submitted(name: name, mobile: phone),
    );
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
        child: BlocConsumer<EditProfileBloc, EditProfileState>(
          listener: (context, state) => switch (state) {
            EditProfileSuccess(:final user) => context.pop(
              ProfileEntity(
                name: user.name,
                email: user.email,
                phone: user.mobile,
                avatarUrl: widget.profile.avatarUrl,
                avatarBytes: _pickedAvatarBytes ?? widget.profile.avatarBytes,
              ),
            ),
            EditProfileError(:final message) => showSnackBar(message),
            _ => null,
          },
          builder: (context, state) {
            final isSaving = state is EditProfileSaving;

            return Stack(
              // The scroll view shrink-wraps its content; without expanding,
              // a short form ends the stack early and the positioned fade +
              // CTA pin to the content's bottom edge, not the device's.
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
                        title: DailyMartValueConst.editProfileTitle,
                        onBack: () => context.pop(),
                      ),
                      const SizedBox(height: AppSpacing.xl4),
                      Center(
                        child: ProfileAvatarPicker(
                          profile: widget.profile,
                          pickedAvatarBytes: _pickedAvatarBytes,
                          onTap: _pickAvatar,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl2),
                      _field(
                        DailyMartValueConst.fullNameLabel,
                        _nameController,
                        field: _ProfileField.name,
                        keyboardType: TextInputType.name,
                        hint: DailyMartValueConst.fullNameHint,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _field(
                        DailyMartValueConst.emailLabel,
                        _emailController,
                        field: _ProfileField.email,
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
                        _phoneController,
                        field: _ProfileField.phone,
                        keyboardType: TextInputType.phone,
                        hint: DailyMartValueConst.phoneNumberHint,
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
                    label: DailyMartValueConst.saveChangesLabel,
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
    required _ProfileField field,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
    bool enabled = true,
  }) => DailyMartFormField(
    label: label,
    controller: controller,
    hint: hint,
    keyboardType: keyboardType,
    errorText: _errors[field],
    onChanged: (_) => _clearError(field),
    enabled: enabled,
  );
}
