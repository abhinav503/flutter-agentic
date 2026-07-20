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
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';

import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_docked_bar.dart';
import 'package:gravia/widgets/gravia_form_field.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';
import 'package:gravia/widgets/gravia_primary_button.dart';
import 'package:gravia/widgets/gravia_sheet.dart';

import '../../domain/entities/profile_entity.dart';
import '../bloc/edit_profile_bloc.dart';
import '../widgets/avatar_source_sheet_content.dart';
import '../widgets/profile_avatar_picker.dart';

enum _ProfileField { name, email, phone }

/// Edit Profile form, reached from ProfileHeroHeader's glass edit trigger.
/// Always in edit mode (a profile always exists — no "add" case, unlike
/// Address). On a successful save, pops back to the caller as a
/// [ProfileEntity] — ProfileScreen dispatches it into the shared ProfileBloc
/// via `ProfileEvent.saved`, the same "push, await the pop, react" shape as
/// AddressScreen's own edit flow. Typed field values and the picked avatar
/// preview stay screen-local UI state (same carve-out AddressFormScreen
/// uses); only the actual Update submit goes through `EditProfileBloc`,
/// which owns the real network call (Firebase Auth + Firestore).
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
  /// over the existing `avatarUrl` (see `GraviaAvatarImage`).
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
  // opening a browser file dialog that goes nowhere (same guard doc_scanner
  // uses around its own ImagePickerService calls).
  Future<void> _pickAvatar() async {
    if (kIsWeb) {
      showSnackBar(ValueConst.avatarPickerMobileOnlyMessage);
      return;
    }

    final source = await showGraviaSheet<AvatarSource>(
      title: ValueConst.changePhotoTitle,
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
  Widget body(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
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
          return Column(
            children: [
              Expanded(
                child: CollapsingHeaderSheet(
                  initialHeaderHeight: 110,
                  header: GraviaHeroHeader(
                    title: ValueConst.editProfileTitle,
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
                            pickedAvatarBytes: _pickedAvatarBytes,
                            onTap: _pickAvatar,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl2),
                        _field(
                          ValueConst.nameLabel,
                          _nameController,
                          field: _ProfileField.name,
                          keyboardType: TextInputType.name,
                          hint: ValueConst.nameHint,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _field(
                          ValueConst.emailAddressLabel,
                          _emailController,
                          field: _ProfileField.email,
                          keyboardType: TextInputType.emailAddress,
                          hint: ValueConst.emailAddressHint,
                          // Can't change here — Firebase's own re-verification
                          // flow (verifyBeforeUpdateEmail) is needed to change
                          // the sign-in email, out of scope for this form.
                          enabled: false,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _field(
                          ValueConst.mobileNumberLabel,
                          _phoneController,
                          field: _ProfileField.phone,
                          keyboardType: TextInputType.phone,
                          hint: ValueConst.phoneNumberHint,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GraviaDockedBar(
                child: GraviaPrimaryButton(
                  label: ValueConst.updateProfileButtonLabel,
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
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    required _ProfileField field,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
    bool enabled = true,
  }) {
    return GraviaFormField(
      label: label,
      controller: controller,
      hint: hint,
      keyboardType: keyboardType,
      errorText: _errors[field],
      onChanged: (_) => _clearError(field),
      enabled: enabled,
    );
  }
}
