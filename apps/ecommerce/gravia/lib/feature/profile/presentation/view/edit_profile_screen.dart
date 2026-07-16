import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/image_picker/image_picker_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_avatar_image.dart';
import 'package:gravia/widgets/gravia_docked_bar.dart';
import 'package:gravia/widgets/gravia_form_field.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';
import 'package:gravia/widgets/gravia_primary_button.dart';
import 'package:gravia/widgets/gravia_sheet.dart';

import '../../domain/entities/profile_entity.dart';

enum _ProfileField { name, email, phone }

/// Edit Profile form, reached from ProfileHeroHeader's glass edit trigger.
/// Always in edit mode (a profile always exists — no "add" case, unlike
/// Address). Result pops back to the caller as a [ProfileEntity] —
/// ProfileScreen dispatches it into the shared ProfileBloc via
/// `ProfileEvent.saved`, the same "push, await the pop, react" shape as
/// AddressScreen's own edit flow. No BLoC of its own — every field here,
/// including the picked avatar preview, is screen-local UI state until
/// Update, the same carve-out AddressFormScreen uses.
class EditProfileScreen extends BaseScreen {
  final ProfileEntity profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends BaseScreenState<EditProfileScreen> {
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

  static const _avatarSize = 96.0;
  static const _cameraBadgeSize = 32.0;

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

    final source = await showGraviaSheet<_AvatarSource>(
      title: ValueConst.changePhotoTitle,
      child: const _AvatarSourceSheetContent(),
    );
    if (source == null) return;

    final files = source == _AvatarSource.camera
        ? await ImagePickerService.instance.fromCamera()
        : await ImagePickerService.instance.fromGallery();
    if (files.isEmpty || !mounted) return;

    final bytes = await files.first.readAsBytes();
    if (!mounted) return;
    setState(() => _pickedAvatarBytes = bytes);
  }

  void _submit() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    final errors = <_ProfileField, String>{
      if (name.isEmpty)
        _ProfileField.name: ValueConst.requiredFieldErrorMessage,
      if (email.isEmpty)
        _ProfileField.email: ValueConst.requiredFieldErrorMessage,
      if (phone.isEmpty)
        _ProfileField.phone: ValueConst.requiredFieldErrorMessage,
    };

    if (errors.isNotEmpty) {
      setState(() {
        _errors
          ..clear()
          ..addAll(errors);
      });
      return;
    }

    context.pop(
      ProfileEntity(
        name: name,
        email: email,
        phone: phone,
        avatarUrl: widget.profile.avatarUrl,
        avatarBytes: _pickedAvatarBytes ?? widget.profile.avatarBytes,
      ),
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
      child: Column(
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
                    Center(child: _avatarPicker(context)),
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
              onTap: _submit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPicker(BuildContext context) {
    final previewProfile = _pickedAvatarBytes == null
        ? widget.profile
        : ProfileEntity(
            name: widget.profile.name,
            email: widget.profile.email,
            phone: widget.profile.phone,
            avatarUrl: widget.profile.avatarUrl,
            avatarBytes: _pickedAvatarBytes,
          );

    return GestureDetector(
      onTap: _pickAvatar,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GraviaAvatarImage(profile: previewProfile, size: _avatarSize),
          Container(
            width: _cameraBadgeSize,
            height: _cameraBadgeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.45),
            ),
            alignment: Alignment.center,
            child: AppSvgImage.asset(
              ImageConst.camera,
              color: Colors.white,
              width: 18,
              height: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    required _ProfileField field,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return GraviaFormField(
      label: label,
      controller: controller,
      hint: hint,
      keyboardType: keyboardType,
      errorText: _errors[field],
      onChanged: (_) => _clearError(field),
    );
  }
}

enum _AvatarSource { camera, gallery }

/// Two-row action sheet — "Take Photo" / "Choose from Gallery" — opened from
/// the avatar's camera badge. An action list, not a selection list, so this
/// stays a small local widget rather than a `RadioOptionsSheetContent`
/// (which shows a currently-`selected` value; there isn't one here).
class _AvatarSourceSheetContent extends StatelessWidget {
  const _AvatarSourceSheetContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row(
            context,
            icon: AppSvgImage.asset(
              ImageConst.camera,
              color: Theme.of(context).colorScheme.onSurface,
              width: 20,
              height: 20,
            ),
            label: ValueConst.takePhotoLabel,
            source: _AvatarSource.camera,
          ),
          _row(
            context,
            icon: AppSvgImage.asset(
              ImageConst.folderGallery,
              color: Theme.of(context).colorScheme.onSurface,
              width: 20,
              height: 20,
            ),
            label: ValueConst.chooseFromGalleryLabel,
            source: _AvatarSource.gallery,
          ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required Widget icon,
    required String label,
    required _AvatarSource source,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.pop(source),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            icon,
            const SizedBox(width: AppSpacing.base),
            Text(label, style: tt.bodyLarge!.copyWith(color: cs.onSurface)),
          ],
        ),
      ),
    );
  }
}
